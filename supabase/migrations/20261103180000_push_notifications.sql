-- Push notifications by event, phase 1 (docs/backend.md, "Push
-- notifications"): a note for the circle, a dose recorded twice for the
-- same slot, an appointment created, changed or cancelled.
--
-- The database decides who is told and what kind of news it is; the
-- `push` Edge Function only sends it through FCM. Messages carry no
-- names, medications or other health data, only the kind of news: they
-- travel through Google's and Apple's servers.
--
-- Nothing is sent until both Vault secrets exist (`push_function_url`,
-- `push_hook_secret`): local stacks and tests never call out.

create extension if not exists pg_net with schema extensions;

-- One FCM token per device, with the language its messages use.
create table private.device_tokens (
  uid uuid primary key references auth.users on delete cascade,
  token text not null,
  platform text not null check (platform in ('android', 'ios', 'web')),
  language text not null check (language in ('en', 'es')),
  updated_at timestamptz not null default now()
);
alter table private.device_tokens enable row level security;

-- API ----------------------------------------------------------------------

-- Keeps this device's FCM token, replacing the one before. Any signed-in
-- device may keep one; only current members' devices are ever sent to.
create function public.register_push_token(
  p_token text,
  p_platform text,
  p_language text
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'not_member';
  end if;
  insert into private.device_tokens (uid, token, platform, language)
  values (auth.uid(), p_token, p_platform, p_language)
  on conflict (uid) do update
  set token = excluded.token,
    platform = excluded.platform,
    language = excluded.language,
    updated_at = now();
end
$$;

-- Stops notifications to this device (notifications turned off, or the
-- phone leaving).
create function public.unregister_push_token()
returns void
language sql
security definer
set search_path = ''
as $$
  delete from private.device_tokens where uid = auth.uid()
$$;

revoke execute on function
  public.register_push_token(text, text, text),
  public.unregister_push_token()
from public, anon;
grant execute on function
  public.register_push_token(text, text, text),
  public.unregister_push_token()
to authenticated;

-- Rules --------------------------------------------------------------------

-- What kind of news [p_event] is for the rest of the circle, or null when
-- it is not worth a notification.
create function private.push_kind(p_event private.events)
returns text
language sql stable
set search_path = ''
as $$
  select case
    when p_event.type = 'care_note_added' then 'note'
    when p_event.type in (
      'appointment_created', 'appointment_updated', 'appointment_cancelled'
    ) then 'appointment'
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
-- members whose role reads its audience, except its author's.
create function private.push_targets(p_event private.events)
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
    and private.reads(m.role, p_event.audience)
$$;

-- Hands news to the `push` Edge Function, after commit (pg_net queues
-- the request): {kind, targets}. Never fails the event's insert.
create function private.notify_event()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_kind text := private.push_kind(new);
  v_targets jsonb;
  v_url text;
  v_secret text;
begin
  if v_kind is null then
    return null;
  end if;
  select decrypted_secret into v_url
  from vault.decrypted_secrets where name = 'push_function_url';
  select decrypted_secret into v_secret
  from vault.decrypted_secrets where name = 'push_hook_secret';
  if v_url is null or v_secret is null then
    return null;
  end if;
  v_targets := private.push_targets(new);
  if jsonb_array_length(v_targets) = 0 then
    return null;
  end if;
  begin
    perform net.http_post(
      url := v_url,
      body := jsonb_build_object('kind', v_kind, 'targets', v_targets),
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'x-icare-hook-secret', v_secret
      )
    );
  exception
    -- A lost notification is better than a lost dose record.
    when others then
      raise warning 'Notification not queued: %', sqlerrm;
  end;
  return null;
end
$$;

create trigger notify_event
after insert on private.events
for each row execute function private.notify_event();
