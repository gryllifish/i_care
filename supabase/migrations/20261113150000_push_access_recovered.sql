-- A push when someone recovers their access (docs/roles.md,
-- "Recoverable access"): the event in the log is how a stolen Google
-- account shows, so the circle's admins should not have to open the app
-- to see it.

-- As before, and a recovered access is news.
create or replace function private.push_kind(p_event private.events)
returns text
language sql stable
set search_path = ''
as $$
  select case
    when p_event.type = 'care_note_added' then 'note'
    -- Someone signed in on another phone with a member's Google account.
    when p_event.type = 'access_recovered' then 'access'
    when p_event.type in (
      'appointment_created', 'appointment_updated', 'appointment_cancelled'
    ) then 'appointment'
    -- Whoever gives the next dose must know it changed.
    when p_event.type in (
      'medication_created', 'medication_updated', 'schedule_changed',
      'medication_archived'
    ) then 'medication'
    -- An earlier dose for the same slot that is still standing and that
    -- the caregiver did not knowingly confirm (`knownDoseIds`).
    when p_event.type = 'dose_given'
      and p_event.payload ->> 'slot_at' is not null
      and exists (
        select 1
        from private.events other
        where other.circle_id = p_event.circle_id
          and other.seq < p_event.seq
          and other.type = 'dose_given'
          and other.payload ->> 'medication_id'
            = p_event.payload ->> 'medication_id'
          and other.payload ->> 'slot_at' = p_event.payload ->> 'slot_at'
          and not coalesce(
            p_event.payload -> 'known_dose_ids' ? other.id, false
          )
          and not exists (
            select 1
            from private.events undo
            where undo.circle_id = other.circle_id
              and undo.type = 'dose_undone'
              and undo.payload ->> 'target_event_id' = other.id
          )
      ) then 'double_dose'
  end
$$;

-- Who is told about [p_event]: the devices of the circle's current
-- members whose role reads its audience, except its author's. A
-- recovered access is told to admins, who can remove the member, and to
-- the member's other phones, where they would know it was not them.
create or replace function private.push_targets(p_event private.events)
returns jsonb
language sql stable
set search_path = ''
as $$
  select coalesce(
    jsonb_agg(jsonb_build_object(
      'token', t.token, 'platform', t.platform, 'language', t.language
    )),
    '[]'::jsonb
  )
  from private.device_tokens t
  join private.device_bindings b
    on b.uid = t.uid and b.ended_at is null
  join private.members m
    on m.circle_id = b.circle_id
    and m.member_id = b.member_id
    and not m.removed
  where b.circle_id = p_event.circle_id
    and b.member_id <> p_event.author
    and case
      when p_event.type = 'access_recovered' then
        m.role = 'admin'
          or m.member_id = p_event.payload ->> 'member_id'
      else private.reads(m.role, p_event.audience)
    end
$$;

-- As before, and the account's push token is forgotten on a recovery:
-- it is the old phone's, since the account is the same user on both. The
-- new phone registers its own when it starts.
create or replace function public.confirm_session()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_session uuid := (auth.jwt() ->> 'session_id')::uuid;
  v_binding private.device_bindings;
  v_started timestamptz;
  v_protected timestamptz;
  v_recovered boolean := true;
  v_event_id text;
begin
  if v_uid is null or v_session is null
    or coalesce((select is_anonymous from auth.users where id = v_uid), true)
  then
    return;
  end if;
  v_binding := private.active_binding(v_uid);
  if v_binding.uid is null then
    return;
  end if;
  -- One confirmation at a time: read again once the circle is locked.
  perform 1 from private.circles where id = v_binding.circle_id for update;
  v_binding := private.active_binding(v_uid);
  if v_binding.uid is null
    or v_binding.session_id is not distinct from v_session
  then
    return;
  end if;
  select created_at into v_started from auth.sessions where id = v_session;
  if not found
    or (v_binding.session_id is not null
      and v_started <= v_binding.session_started)
  then
    raise exception 'session_ended';
  end if;
  if v_binding.session_id is null then
    select min(created_at) into v_protected
    from auth.identities
    where user_id = v_uid;
    -- Without an identity to compare with, assume another phone.
    v_recovered := coalesce(
      v_started > v_protected + interval '10 seconds', true
    );
  end if;
  if v_recovered then
    -- The token on record is the phone left behind's: forgotten before
    -- the circle is told, so that phone hears no more of it.
    delete from private.device_tokens where uid = v_uid;
    v_event_id := 'recovered-' || v_session::text;
    if not exists (
      select 1 from private.events
      where circle_id = v_binding.circle_id and id = v_event_id
    ) then
      perform private.system_event(
        v_binding.circle_id,
        v_event_id,
        'access_recovered',
        jsonb_build_object('member_id', v_binding.member_id)
      );
      perform private.ring(v_binding.circle_id);
    end if;
    delete from auth.sessions where user_id = v_uid and id <> v_session;
  end if;
  update private.device_bindings
  set session_id = v_session, session_started = v_started
  where uid = v_uid;
end
$$;
