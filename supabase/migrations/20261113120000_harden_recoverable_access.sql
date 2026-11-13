-- Recoverable access, after its review on 2026-11-13 (docs/roles.md,
-- "Recoverable access"). The server no longer depends on the phone to
-- keep these true:
-- - a recovery ends the account's other sessions here, in the same
--   transaction that tells the circle, and a session older than the one
--   on record is refused: a lost phone cannot take the access back;
-- - the circle is told once per recovery, however often it is confirmed;
-- - a protected account belongs to one member: it cannot join or create
--   a circle, and stops being protected the moment its binding ends, so
--   the next person on that phone starts with an access of their own and
--   a former member's Google data is not kept (docs/privacy.md);
-- - a phone whose session ended stops hearing the circle's channel.

-- Tables -------------------------------------------------------------------

-- When the session on record started: any other session of the account
-- that started at or before it is a phone left behind.
alter table private.device_bindings add column session_started timestamptz;

-- Sessions -----------------------------------------------------------------

-- As before, and `ended` too for a protected account's session that
-- started at or before the one on record.
create or replace function private.session_state()
returns text
language plpgsql
stable
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_session uuid := (auth.jwt() ->> 'session_id')::uuid;
  v_started timestamptz;
  v_binding private.device_bindings;
begin
  if v_uid is null or v_session is null then
    return 'ok';
  end if;
  select created_at into v_started from auth.sessions where id = v_session;
  if not found then
    return 'ended';
  end if;
  if coalesce((select is_anonymous from auth.users where id = v_uid), true)
  then
    return 'ok';
  end if;
  select b.* into v_binding
  from private.device_bindings b
  where b.uid = v_uid and b.ended_at is null;
  if not found or v_binding.session_id is not distinct from v_session then
    return 'ok';
  end if;
  if v_binding.session_id is not null
    and v_started <= v_binding.session_started
  then
    return 'ended';
  end if;
  return 'unconfirmed';
end
$$;

-- As before, and a protected account may not join or create a circle: it
-- is one member's way back in, never a way into another membership. A
-- path that cannot be read counts as any other, so it is refused.
create or replace function public.check_request()
returns void
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_state text := private.session_state();
  v_path text := current_setting('request.path', true);
begin
  if v_state = 'ended' then
    raise exception 'session_ended';
  end if;
  if v_state = 'unconfirmed'
    and v_path is distinct from '/rpc/confirm_session'
  then
    raise exception 'session_unconfirmed';
  end if;
  if v_path in ('/rpc/join_circle', '/rpc/create_circle')
    and not coalesce(
      (select is_anonymous from auth.users where id = auth.uid()), true
    )
  then
    raise exception 'forbidden';
  end if;
end
$$;

-- Records the caller's session as its binding's.
--
-- The first session on record is the phone that protected the access:
-- linking needs that phone's own session, so the session started before
-- the Google identity existed, or with it. Any later session comes from
-- signing in on another phone: the circle is told with
-- `access_recovered`, once, and every other session of the account ends
-- here, so locking the lost phone out does not depend on the new one. A
-- session older than the one on record is refused.
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

-- The device's current circle, for the Realtime channel `circle:<id>`;
-- none for a session the API would refuse, since Realtime does not run
-- `check_request`.
create or replace function public.current_circle()
returns uuid
language sql stable
security definer
set search_path = ''
as $$
  select (private.active_binding(auth.uid())).circle_id
  where private.session_state() = 'ok'
$$;

-- Accounts -----------------------------------------------------------------

-- Makes [p_uid] the anonymous user it was before its access was
-- protected: its Google identity, email and profile are deleted. Its
-- sessions stay, so a removed phone can still send what it had pending
-- and be told it is no longer a member.
create function private.unprotect(p_uid uuid)
returns void
language plpgsql
set search_path = ''
as $$
begin
  if coalesce((select is_anonymous from auth.users where id = p_uid), true)
  then
    return;
  end if;
  delete from auth.identities where user_id = p_uid;
  update auth.users
  set is_anonymous = true,
    email = null,
    email_confirmed_at = null,
    encrypted_password = null,
    raw_user_meta_data = '{}'::jsonb,
    raw_app_meta_data = '{}'::jsonb
  where id = p_uid;
end
$$;

-- A binding that ends (its device left, or its member was removed) takes
-- the account's protection with it.
create function private.unprotect_ended_binding()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform private.unprotect(new.uid);
  new.session_id := null;
  new.session_started := null;
  return new;
end
$$;

create trigger unprotect_ended_binding
before update of ended_at on private.device_bindings
for each row
when (old.ended_at is null and new.ended_at is not null)
execute function private.unprotect_ended_binding();
