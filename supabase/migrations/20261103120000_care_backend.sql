-- Stage 2 backend: the shared event log, members, device bindings and
-- invitation codes (docs/backend.md, docs/roles.md).
--
-- Clients get no table access at all. Tables live in the `private`
-- schema, which the API does not expose; clients call the functions in
-- `public`, which check the calling device (auth.uid(), one anonymous
-- user per device) and mirror SimulatedServer.

create schema private;
revoke all on schema private from public, anon, authenticated;

-- Tables -------------------------------------------------------------------

create table private.circles (
  id uuid primary key default gen_random_uuid(),
  recipient_name text not null,
  -- Dates in events are wall-clock times in this zone (CareEventCodec).
  time_zone text not null default 'America/Argentina/Buenos_Aires',
  next_seq bigint not null default 1,
  last_received_at timestamptz,
  created_at timestamptz not null default now()
);

create table private.members (
  circle_id uuid not null references private.circles on delete cascade,
  member_id text not null,
  name text not null,
  role text not null check (role in ('admin', 'caregiver', 'helper', 'viewer')),
  removed boolean not null default false,
  primary key (circle_id, member_id)
);

-- Which member each device is. One row per device: joining another
-- circle replaces it; leaving or removal ends it, never deletes it, so
-- late facts from that device can still be checked and flagged.
create table private.device_bindings (
  uid uuid primary key references auth.users on delete cascade,
  circle_id uuid not null,
  member_id text not null,
  ended_at timestamptz,
  foreign key (circle_id, member_id)
    references private.members on delete cascade
);

-- Codes are secrets: only their hashes are stored, and never in the log.
create table private.invite_codes (
  code_hash text primary key,
  circle_id uuid not null,
  member_id text not null,
  expires_at timestamptz not null,
  used boolean not null default false,
  foreign key (circle_id, member_id)
    references private.members on delete cascade
);

create table private.events (
  circle_id uuid not null references private.circles on delete cascade,
  id text not null,
  seq bigint not null,
  received_at timestamptz not null,
  author text not null,
  type text not null,
  audience text not null check (audience in ('care', 'team')),
  from_former_member boolean not null default false,
  -- The event as CareEventCodec encodes it, with the server's fields set.
  payload jsonb not null,
  primary key (circle_id, id),
  unique (circle_id, seq)
);

-- Six-character codes can be guessed: devices that fail too often wait.
create table private.join_attempts (
  uid uuid primary key references auth.users on delete cascade,
  failed_count int not null default 0,
  locked_until timestamptz
);

alter table private.circles enable row level security;
alter table private.members enable row level security;
alter table private.device_bindings enable row level security;
alter table private.invite_codes enable row level security;
alter table private.events enable row level security;
alter table private.join_attempts enable row level security;

-- Rules (lib/features/care/domain/permissions.dart) --------------------------

-- `can`: the permission matrix. Keep in step with the Dart copy; the
-- pgTAP suite checks every cell.
create function private.can(p_role text, p_action text)
returns boolean
language sql immutable
set search_path = ''
as $$
  select case
    when p_action in ('record_care', 'remove_own_record', 'leave_note')
      then p_role in ('admin', 'caregiver', 'helper')
    when p_action in (
      'review_conflict', 'manage_medications', 'manage_tasks',
      'manage_appointments', 'manage_reasons', 'edit_emergency_card'
    ) then p_role in ('admin', 'caregiver')
    when p_action in ('remove_any_record', 'manage_members', 'reset_demo')
      then p_role = 'admin'
    when p_action = 'leave_circle' then true
    else false
  end
$$;

-- `actionOf`: what an event stands for; null for events only the server
-- writes (and types this server does not know).
create function private.action_of(
  p_type text,
  p_author text,
  p_target_author text,
  p_has_conflict_key boolean
)
returns text
language sql immutable
set search_path = ''
as $$
  select case
    when p_type in ('dose_given', 'dose_skipped', 'task_done', 'task_skipped')
      then 'record_care'
    when p_type = 'dose_undone' and p_has_conflict_key then 'review_conflict'
    when p_type = 'dose_undone' and p_target_author = p_author
      then 'remove_own_record'
    when p_type = 'dose_undone' then 'remove_any_record'
    when p_type = 'conflict_acknowledged' then 'review_conflict'
    when p_type in (
      'medication_created', 'medication_updated', 'schedule_changed',
      'medication_archived', 'stock_counted', 'stock_refilled'
    ) then 'manage_medications'
    when p_type in ('task_created', 'task_updated', 'task_archived')
      then 'manage_tasks'
    when p_type in (
      'appointment_created', 'appointment_updated', 'appointment_cancelled',
      'visit_note_added', 'document_linked', 'document_removed'
    ) then 'manage_appointments'
    when p_type = 'recipient_profile_updated' then 'edit_emergency_card'
    when p_type = 'care_note_added' then 'leave_note'
    when p_type in (
      'skip_reason_added', 'skip_reason_hidden', 'skip_reason_shown'
    ) then 'manage_reasons'
    when p_type in (
      'member_invited', 'invitation_revoked', 'role_changed', 'member_removed'
    ) then 'manage_members'
    when p_type = 'member_left' then 'leave_circle'
  end
$$;

-- `isFact`: records about the person cared for, accepted (flagged) even
-- from a device whose member has left.
create function private.is_fact(p_action text)
returns boolean
language sql immutable
set search_path = ''
as $$
  select p_action in ('record_care', 'remove_own_record')
$$;

-- `audienceOf`
create function private.audience_of(p_type text)
returns text
language sql immutable
set search_path = ''
as $$
  select case
    when p_type in (
      'appointment_created', 'appointment_updated', 'appointment_cancelled',
      'visit_note_added', 'document_linked', 'document_removed'
    ) then 'team'
    else 'care'
  end
$$;

-- `audiencesFor`: helpers read only `care`.
create function private.reads(p_role text, p_audience text)
returns boolean
language sql immutable
set search_path = ''
as $$
  select p_audience = 'care' or p_role <> 'helper'
$$;

-- Whether [p_event] would take away the circle's last admin.
create function private.leaves_no_admin(p_circle uuid, p_event jsonb)
returns boolean
language sql stable
set search_path = ''
as $$
  select exists (
      select 1
      from private.members m
      where m.circle_id = p_circle
        and m.member_id = p_event ->> 'member_id'
        and m.role = 'admin'
        and (
          p_event ->> 'type' in ('member_removed', 'invitation_revoked')
          or (p_event ->> 'type' = 'role_changed'
            and p_event ->> 'role' <> 'admin')
        )
    )
    and (
      select count(*)
      from private.members m
      where m.circle_id = p_circle and m.role = 'admin' and not m.removed
    ) <= 1
$$;

-- Helpers ------------------------------------------------------------------

-- A time in CareEventCodec's format: wall clock in the circle's zone.
create function private.wall_clock(p_at timestamptz, p_time_zone text)
returns text
language sql stable
set search_path = ''
as $$
  select to_char(p_at at time zone p_time_zone, 'YYYY-MM-DD"T"HH24:MI:SS.US')
$$;

-- The device's binding while it belongs to a current member, else null.
create function private.active_binding(p_uid uuid)
returns private.device_bindings
language sql stable
set search_path = ''
as $$
  select b.*
  from private.device_bindings b
  join private.members m
    on m.circle_id = b.circle_id and m.member_id = b.member_id
  where b.uid = p_uid and b.ended_at is null and not m.removed
$$;

-- Applies a stored member event to the member tables, in the same
-- transaction, so log and state never disagree.
create function private.apply_member_event(p_circle uuid, p_event jsonb)
returns void
language plpgsql
set search_path = ''
as $$
begin
  case p_event ->> 'type'
    when 'member_invited' then
      insert into private.members (circle_id, member_id, name, role)
      values (
        p_circle,
        p_event ->> 'member_id',
        p_event ->> 'name',
        p_event ->> 'role'
      )
      on conflict do nothing;
    when 'role_changed' then
      update private.members
      set role = p_event ->> 'role'
      where circle_id = p_circle and member_id = p_event ->> 'member_id';
    when 'member_removed', 'invitation_revoked' then
      update private.members
      set removed = true
      where circle_id = p_circle and member_id = p_event ->> 'member_id';
      update private.device_bindings
      set ended_at = coalesce(ended_at, now())
      where circle_id = p_circle and member_id = p_event ->> 'member_id';
    else
      null;
  end case;
end
$$;

-- Stores [p_event] as the circle's next event and returns it as stored.
-- Locks the circle's row until commit (docs/backend.md, "Ordering"), so
-- seq order is commit order and received_at keeps increasing.
create function private.append_event(
  p_circle uuid,
  p_event jsonb,
  p_from_former_member boolean default false
)
returns jsonb
language plpgsql
set search_path = ''
as $$
declare
  v_circle private.circles;
  v_received timestamptz;
  v_stored jsonb;
begin
  select * into strict v_circle
  from private.circles
  where id = p_circle
  for update;

  v_received := greatest(
    clock_timestamp(),
    v_circle.last_received_at + interval '1 microsecond'
  );
  -- Only the server sets these; whatever the client sent is replaced.
  v_stored := (p_event - 'from_former_member' - 'server_seq')
    || jsonb_build_object(
      'received_at', private.wall_clock(v_received, v_circle.time_zone),
      'server_seq', v_circle.next_seq
    )
    || case
      when p_from_former_member then '{"from_former_member": true}'::jsonb
      else '{}'::jsonb
    end;

  insert into private.events (
    circle_id, id, seq, received_at, author, type, audience,
    from_former_member, payload
  )
  values (
    p_circle,
    p_event ->> 'id',
    v_circle.next_seq,
    v_received,
    p_event ->> 'caregiver_id',
    p_event ->> 'type',
    private.audience_of(p_event ->> 'type'),
    p_from_former_member,
    v_stored
  );
  update private.circles
  set next_seq = next_seq + 1, last_received_at = v_received
  where id = p_circle;
  perform private.apply_member_event(p_circle, v_stored);
  return v_stored;
end
$$;

-- An event the server writes itself (author `system`).
create function private.system_event(
  p_circle uuid,
  p_id text,
  p_type text,
  p_fields jsonb
)
returns jsonb
language sql
set search_path = ''
as $$
  select private.append_event(
    p_circle,
    jsonb_build_object(
      'v', 1,
      'id', p_id,
      'caregiver_id', 'system',
      'occurred_at', private.wall_clock(now(), c.time_zone),
      'type', p_type
    ) || p_fields
  )
  from private.circles c
  where c.id = p_circle
$$;

-- Tells the circle's devices that new events are there; they read them
-- with events_after. Delivered after commit.
create function private.ring(p_circle uuid)
returns void
language sql
set search_path = ''
as $$
  select realtime.send(
    '{}'::jsonb, 'appended', 'circle:' || p_circle::text, true
  )
$$;

-- API ----------------------------------------------------------------------

-- SyncGateway.push: checks and stores [p_events] in order, each against
-- the state the ones before it left (docs/roles.md, "Checking each
-- event"). Returns {stored: [event], rejected: [{id, reason}]}; an event
-- already stored comes back as stored, unchanged.
create function public.push_events(p_events jsonb)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_binding private.device_bindings;
  v_member private.members;
  v_event jsonb;
  v_existing jsonb;
  v_target_author text;
  v_action text;
  v_reason text;
  v_former boolean;
  v_appended int := 0;
  v_stored jsonb := '[]';
  v_rejected jsonb := '[]';
begin
  if jsonb_typeof(p_events) is distinct from 'array' then
    raise exception 'invalid_request';
  end if;
  select * into v_binding from private.device_bindings where uid = v_uid;
  if not found then
    return jsonb_build_object(
      'stored', '[]'::jsonb,
      'rejected', coalesce(
        (select jsonb_agg(jsonb_build_object(
            'id', e ->> 'id', 'reason', 'not_member'))
          from jsonb_array_elements(p_events) e),
        '[]'::jsonb
      )
    );
  end if;
  perform 1 from private.circles where id = v_binding.circle_id for update;

  for v_event in
    select e from jsonb_array_elements(p_events) with ordinality as t(e, n)
    order by n
  loop
    select payload into v_existing
    from private.events
    where circle_id = v_binding.circle_id and id = v_event ->> 'id';
    if found then
      v_stored := v_stored || jsonb_build_array(v_existing);
      continue;
    end if;

    -- An earlier event of this push may have ended the binding.
    select * into v_binding from private.device_bindings where uid = v_uid;
    v_reason := null;
    v_former := false;
    v_target_author := null;
    if v_event ->> 'type' = 'dose_undone' then
      select author into v_target_author
      from private.events
      where circle_id = v_binding.circle_id
        and id = v_event ->> 'target_event_id';
    end if;
    v_action := private.action_of(
      v_event ->> 'type',
      v_event ->> 'caregiver_id',
      v_target_author,
      v_event ? 'conflict_key'
    );

    if v_event ->> 'caregiver_id' is distinct from v_binding.member_id then
      v_reason := 'wrong_author';
    elsif v_action is null or v_event ->> 'v' is distinct from '1' then
      v_reason := 'not_allowed';
    else
      select * into v_member
      from private.members
      where circle_id = v_binding.circle_id
        and member_id = v_binding.member_id;
      if not found or v_member.removed or v_binding.ended_at is not null then
        if private.is_fact(v_action) then
          v_former := true;
        else
          v_reason := 'not_member';
        end if;
      elsif not private.can(v_member.role, v_action) then
        v_reason := 'not_allowed';
      elsif private.leaves_no_admin(v_binding.circle_id, v_event) then
        v_reason := 'last_admin';
      end if;
    end if;

    if v_reason is null then
      begin
        v_stored := v_stored || jsonb_build_array(
          private.append_event(v_binding.circle_id, v_event, v_former)
        );
        v_appended := v_appended + 1;
        -- A device leaving unbinds only itself.
        if v_event ->> 'type' = 'member_left' then
          update private.device_bindings
          set ended_at = coalesce(ended_at, now())
          where uid = v_uid;
        end if;
      exception
        -- A malformed event (no id, an unknown role) is refused alone.
        when not_null_violation or check_violation
          or foreign_key_violation then
          v_reason := 'not_allowed';
      end;
    end if;
    if v_reason is not null then
      v_rejected := v_rejected || jsonb_build_array(
        jsonb_build_object('id', v_event ->> 'id', 'reason', v_reason)
      );
    end if;
  end loop;

  if v_appended > 0 then
    perform private.ring(v_binding.circle_id);
  end if;
  return jsonb_build_object('stored', v_stored, 'rejected', v_rejected);
end
$$;

-- SyncGateway.watch reads through this: the events after [p_cursor] the
-- device's role may read, by seq, and the cursor to resume from, which
-- covers unreadable events too. Raises `not_member` for a device that
-- does not belong to a current member: under RLS a select would just
-- return nothing, and the device would never learn it was removed.
create function public.events_after(p_cursor text, p_limit int default 500)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_binding private.device_bindings := private.active_binding(auth.uid());
  v_role text;
  v_result jsonb;
begin
  if v_binding.uid is null then
    raise exception 'not_member';
  end if;
  select role into v_role
  from private.members
  where circle_id = v_binding.circle_id and member_id = v_binding.member_id;

  -- One statement, one snapshot: the cursor never runs ahead of the page.
  with page as (
    select e.seq, e.payload
    from private.events e
    where e.circle_id = v_binding.circle_id
      and e.seq > coalesce(p_cursor::bigint, 0)
      and private.reads(v_role, e.audience)
    order by e.seq
    limit p_limit
  )
  select jsonb_build_object(
    'events', coalesce(jsonb_agg(page.payload order by page.seq), '[]'),
    'cursor', (
      case
        when count(*) = p_limit then max(page.seq)
        else (
          select c.next_seq - 1 from private.circles c
          where c.id = v_binding.circle_id
        )
      end
    )::text
  )
  into v_result
  from page;
  return v_result;
end
$$;

-- MembershipGateway.createCircle: a circle for [p_recipient_name] with
-- this device joined as its first admin; returns the admin's member id.
-- [p_member_id] picks that id, as clients pick invited members' ids;
-- the server makes one up when it is null.
create function public.create_circle(
  p_creator_name text,
  p_recipient_name text,
  p_member_id text default null
)
returns text
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_circle uuid;
  v_member text := coalesce(p_member_id, 'member-' || gen_random_uuid()::text);
begin
  if v_uid is null then
    raise exception 'not_member';
  end if;
  if (private.active_binding(v_uid)).uid is not null then
    raise exception 'forbidden';
  end if;
  insert into private.circles (recipient_name)
  values (p_recipient_name)
  returning id into v_circle;

  perform private.system_event(
    v_circle, 'system-1-circle', 'circle_created',
    jsonb_build_object('recipient_name', p_recipient_name)
  );
  perform private.system_event(
    v_circle, 'system-2-invited', 'member_invited',
    jsonb_build_object(
      'member_id', v_member, 'name', p_creator_name,
      'role', 'admin', 'color_index', 0
    )
  );
  insert into private.device_bindings (uid, circle_id, member_id)
  values (v_uid, v_circle, v_member)
  on conflict (uid) do update
  set circle_id = excluded.circle_id,
    member_id = excluded.member_id,
    ended_at = null;
  perform private.system_event(
    v_circle, 'system-3-joined', 'member_joined',
    jsonb_build_object('member_id', v_member)
  );
  return v_member;
end
$$;

-- MembershipGateway.issueCode: a new one-time code for [p_member_id],
-- valid for 48 hours; any unused one for that member stops working.
-- Returns {code, expires_at}. Admins only.
create function public.issue_code(p_member_id text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_binding private.device_bindings := private.active_binding(auth.uid());
  v_alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_code text;
  v_bytes bytea;
  v_expires timestamptz := now() + interval '48 hours';
begin
  if v_binding.uid is null then
    raise exception 'not_member';
  end if;
  perform 1 from private.circles where id = v_binding.circle_id for update;
  if not private.can(
    (select role from private.members
      where circle_id = v_binding.circle_id
        and member_id = v_binding.member_id),
    'manage_members'
  ) then
    raise exception 'forbidden';
  end if;
  if not exists (
    select 1 from private.members
    where circle_id = v_binding.circle_id
      and member_id = p_member_id
      and not removed
  ) then
    raise exception 'not_found';
  end if;

  update private.invite_codes
  set used = true
  where circle_id = v_binding.circle_id
    and member_id = p_member_id
    and not used;
  loop
    v_bytes := extensions.gen_random_bytes(6);
    v_code := '';
    for i in 0..5 loop
      v_code := v_code || substr(
        v_alphabet, get_byte(v_bytes, i) % length(v_alphabet) + 1, 1
      );
    end loop;
    insert into private.invite_codes (
      code_hash, circle_id, member_id, expires_at
    )
    values (
      encode(sha256(convert_to(v_code, 'UTF8')), 'hex'),
      v_binding.circle_id, p_member_id, v_expires
    )
    on conflict do nothing;
    exit when found;
  end loop;
  return jsonb_build_object('code', v_code, 'expires_at', v_expires);
end
$$;

-- MembershipGateway.join: binds this device to the member [p_code] was
-- issued for and records that they joined. Returns {member_id}, or
-- {error} with `unknown`, `used`, `expired` or `locked` (too many
-- failures): an error is a result, not an exception, so the failed
-- attempt is counted rather than rolled back.
create function public.join_circle(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_code private.invite_codes;
  v_problem text;
  v_max_failures constant int := 5;
begin
  if v_uid is null then
    raise exception 'not_member';
  end if;
  if exists (
    select 1 from private.join_attempts
    where uid = v_uid and locked_until > now()
  ) then
    return jsonb_build_object('error', 'locked');
  end if;

  select c.* into v_code
  from private.invite_codes c
  where c.code_hash = encode(sha256(convert_to(
    regexp_replace(upper(p_code), '[^A-Z0-9]', '', 'g'), 'UTF8'
  )), 'hex');
  if not found or exists (
    select 1 from private.members m
    where m.circle_id = v_code.circle_id
      and m.member_id = v_code.member_id
      and m.removed
  ) then
    v_problem := 'unknown';
  elsif v_code.used then
    v_problem := 'used';
  elsif v_code.expires_at <= now() then
    v_problem := 'expired';
  end if;

  if v_problem is not null then
    insert into private.join_attempts as a (uid, failed_count)
    values (v_uid, 1)
    on conflict (uid) do update set failed_count = a.failed_count + 1;
    update private.join_attempts
    set locked_until = now() + interval '15 minutes', failed_count = 0
    where uid = v_uid and failed_count >= v_max_failures;
    return jsonb_build_object('error', v_problem);
  end if;

  delete from private.join_attempts where uid = v_uid;
  perform 1 from private.circles where id = v_code.circle_id for update;
  update private.invite_codes
  set used = true
  where code_hash = v_code.code_hash;
  insert into private.device_bindings (uid, circle_id, member_id)
  values (v_uid, v_code.circle_id, v_code.member_id)
  on conflict (uid) do update
  set circle_id = excluded.circle_id,
    member_id = excluded.member_id,
    ended_at = null;
  perform private.system_event(
    v_code.circle_id,
    'joined-' || v_uid::text || '-'
      || (extract(epoch from clock_timestamp()) * 1000000)::bigint::text,
    'member_joined',
    jsonb_build_object('member_id', v_code.member_id)
  );
  perform private.ring(v_code.circle_id);
  return jsonb_build_object('member_id', v_code.member_id);
end
$$;

-- Deletes the device's circle with everything in it, at the request of
-- the person cared for (docs/privacy.md). The one operation that deletes
-- shared data; not an event. Admins only.
create function public.delete_circle()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_binding private.device_bindings := private.active_binding(auth.uid());
begin
  if v_binding.uid is null then
    raise exception 'not_member';
  end if;
  if not private.can(
    (select role from private.members
      where circle_id = v_binding.circle_id
        and member_id = v_binding.member_id),
    'manage_members'
  ) then
    raise exception 'forbidden';
  end if;
  delete from private.device_bindings where circle_id = v_binding.circle_id;
  delete from private.invite_codes where circle_id = v_binding.circle_id;
  delete from private.circles where id = v_binding.circle_id;
end
$$;

-- The device's current circle, for the Realtime channel `circle:<id>`.
create function public.current_circle()
returns uuid
language sql stable
security definer
set search_path = ''
as $$
  select (private.active_binding(auth.uid())).circle_id
$$;

-- Grants -------------------------------------------------------------------

revoke execute on function
  public.push_events(jsonb),
  public.events_after(text, int),
  public.create_circle(text, text, text),
  public.issue_code(text),
  public.join_circle(text),
  public.delete_circle(),
  public.current_circle()
from public, anon;

grant execute on function
  public.push_events(jsonb),
  public.events_after(text, int),
  public.create_circle(text, text, text),
  public.issue_code(text),
  public.join_circle(text),
  public.delete_circle(),
  public.current_circle()
to authenticated;

-- Only a current member hears its circle's channel.
create policy "members hear their circle"
on realtime.messages
for select
to authenticated
using (realtime.topic() = 'circle:' || public.current_circle()::text);
