-- Recoverable access (docs/roles.md, "Recoverable access"): a member who
-- links a Google identity to their phone's anonymous user can get back
-- into the circle on a new phone. The server makes sure that:
-- - a session ended by that recovery is refused at once, not when its
--   access token expires;
-- - the circle hears of every recovery (`access_recovered`), whether or
--   not the new phone asks for it;
-- - accounts linked to no one, and a deleted circle's accounts, go away;
-- - the operator can issue a code when nothing else works.

-- Tables -------------------------------------------------------------------

-- The last session the server saw for a protected account's binding.
-- A different one is a new phone until `confirm_session` says otherwise.
alter table private.device_bindings add column session_id uuid;

-- Sessions -----------------------------------------------------------------

-- Whether the caller's session may use the API: `ok`, `ended` (signed
-- out elsewhere, its access token not yet expired) or `unconfirmed` (a
-- protected account's new session, before `confirm_session`). Tokens
-- without a session (the service role, tests) are `ok`.
create function private.session_state()
returns text
language plpgsql
stable
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_session uuid := (auth.jwt() ->> 'session_id')::uuid;
  v_seen uuid;
begin
  if v_uid is null or v_session is null then
    return 'ok';
  end if;
  if not exists (select 1 from auth.sessions where id = v_session) then
    return 'ended';
  end if;
  if (select is_anonymous from auth.users where id = v_uid) then
    return 'ok';
  end if;
  select b.session_id into v_seen
  from private.device_bindings b
  where b.uid = v_uid and b.ended_at is null;
  if not found or v_seen is not distinct from v_session then
    return 'ok';
  end if;
  return 'unconfirmed';
end
$$;

-- PostgREST runs this before every request (`db_pre_request`), so every
-- function, present and future, refuses an ended session; and all but
-- `confirm_session` an unconfirmed one. On `session_ended` the phone
-- signs in again as a new anonymous device: if it no longer belongs to
-- anyone, the next call says `not_member` and it clears itself.
create function public.check_request()
returns void
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_state text := private.session_state();
begin
  if v_state = 'ended' then
    raise exception 'session_ended';
  end if;
  if v_state = 'unconfirmed'
    and current_setting('request.path', true) <> '/rpc/confirm_session'
  then
    raise exception 'session_unconfirmed';
  end if;
end
$$;

alter role authenticator set pgrst.db_pre_request = 'public.check_request';
notify pgrst, 'reload config';

-- Records the caller's session as its binding's. A protected account's
-- session that started after it was protected comes from signing in on
-- another phone: the circle is told with `access_recovered`. One that
-- started earlier, or with the protection itself, is this same phone.
create function public.confirm_session()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_session uuid := (auth.jwt() ->> 'session_id')::uuid;
  v_binding private.device_bindings := private.active_binding(v_uid);
  v_started timestamptz;
  v_protected timestamptz;
begin
  if v_binding.uid is null or v_session is null
    or v_binding.session_id is not distinct from v_session
    or (select is_anonymous from auth.users where id = v_uid)
  then
    return;
  end if;
  perform 1 from private.circles where id = v_binding.circle_id for update;
  select created_at into v_started from auth.sessions where id = v_session;
  select min(created_at) into v_protected
  from auth.identities
  where user_id = v_uid;
  if v_started > v_protected + interval '1 minute' then
    perform private.system_event(
      v_binding.circle_id,
      'recovered-' || v_session::text,
      'access_recovered',
      jsonb_build_object('member_id', v_binding.member_id)
    );
    perform private.ring(v_binding.circle_id);
  end if;
  update private.device_bindings
  set session_id = v_session
  where uid = v_uid;
end
$$;

-- Accounts -----------------------------------------------------------------

-- Deletes the caller's user when it is a Google account linked to no
-- one: signing in with it created the user. Anonymous users stay, since
-- they may still join. Returns whether it was deleted.
create function public.discard_unbound_user()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null
    or (select is_anonymous from auth.users where id = v_uid)
    or exists (select 1 from private.device_bindings where uid = v_uid)
  then
    return false;
  end if;
  delete from auth.users where id = v_uid;
  return true;
end
$$;

-- Same as before, and the circle's protected accounts go too: their
-- Google identities are personal data (docs/privacy.md). Anonymous
-- phones keep their users, which hold nothing, as before.
create or replace function public.delete_circle()
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
  delete from auth.users
  where not is_anonymous
    and id in (
      select uid from private.device_bindings
      where circle_id = v_binding.circle_id
    );
  delete from private.device_bindings where circle_id = v_binding.circle_id;
  delete from private.invite_codes where circle_id = v_binding.circle_id;
  delete from private.circles where id = v_binding.circle_id;
end
$$;

-- Users that belong to no circle: anonymous ones a day old that never
-- joined (a phone left on the welcome screen signs in again), and
-- accounts discard_unbound_user missed. The operator runs it
-- (docs/backend.md, "Operator"). Returns how many were deleted.
create function private.discard_stray_users()
returns int
language sql
set search_path = ''
as $$
  with deleted as (
    delete from auth.users u
    where u.created_at < now() - interval '1 day'
      and not exists (
        select 1 from private.device_bindings b where b.uid = u.id
      )
    returning 1
  )
  select count(*)::int from deleted
$$;

-- Operator -----------------------------------------------------------------

-- A one-time code for [p_member_id] of [p_circle], as an admin would
-- issue it, for a member who lost every way back in. The operator runs
-- it in the SQL editor after confirming who is asking by a channel of
-- their own (docs/backend.md, "Operator"). Clients cannot call it.
create function private.operator_issue_code(p_circle uuid, p_member_id text)
returns text
language plpgsql
set search_path = ''
as $$
declare
  v_alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_code text;
  v_bytes bytea;
begin
  perform 1 from private.circles where id = p_circle for update;
  if not exists (
    select 1 from private.members
    where circle_id = p_circle and member_id = p_member_id and not removed
  ) then
    raise exception 'not_found';
  end if;
  update private.invite_codes
  set used = true
  where circle_id = p_circle and member_id = p_member_id and not used;
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
      p_circle, p_member_id, now() + interval '48 hours'
    )
    on conflict do nothing;
    exit when found;
  end loop;
  return v_code;
end
$$;

-- Grants -------------------------------------------------------------------

revoke execute on function
  public.confirm_session(),
  public.discard_unbound_user()
from public, anon;
grant execute on function
  public.confirm_session(),
  public.discard_unbound_user()
to authenticated;

-- PostgREST calls it for every request, whatever its role.
revoke execute on function public.check_request() from public;
grant execute on function public.check_request() to anon, authenticated;
