-- Recoverable access (supabase/migrations/*_recoverable_access.sql and
-- *_harden_recoverable_access.sql) against docs/roles.md, "Recoverable
-- access". Run with
-- `supabase test db`.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(39);

-- Ana's phone starts anonymous; Rosa's stays so. A stranger signed in
-- with a Google account linked to no one.
insert into auth.users (id, is_anonymous)
values
  ('00000000-0000-0000-0000-0000000000a1', true),  -- Ana
  ('00000000-0000-0000-0000-0000000000b1', true),  -- Rosa's phone
  ('00000000-0000-0000-0000-0000000000c1', false); -- the stranger

-- Ana's sessions: her first phone's (08:00), the one protecting it
-- (09:00) and a new phone's (10:00). The other phone has one, and
-- another from signing in half a minute after it is protected (12:00).
insert into auth.sessions (id, user_id, created_at)
values
  ('00000000-0000-0000-0000-00000000a5a0',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 08:00+00'),
  ('00000000-0000-0000-0000-00000000a5a1',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 09:00+00'),
  ('00000000-0000-0000-0000-00000000a5a2',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 10:00+00'),
  ('00000000-0000-0000-0000-00000000b5b0',
    '00000000-0000-0000-0000-0000000000b1', '2026-11-04 08:00+00'),
  ('00000000-0000-0000-0000-00000000b5b1',
    '00000000-0000-0000-0000-0000000000b1', '2026-11-04 12:00:30+00');

-- Acting as a device in a session: what PostgREST does for a signed-in
-- request, with the path it asks for.
create function pg_temp.act_as(
  p_uid text, p_session text default null, p_path text default '/rpc/x'
) returns void language sql as $$
  select set_config(
    'request.jwt.claims',
    json_build_object(
      'sub', p_uid, 'role', 'authenticated', 'session_id', p_session
    )::text,
    true
  ), set_config('request.path', p_path, true);
$$;

-- The circle's `access_recovered` events, read as the server.
create function pg_temp.recovered() returns int
language sql security definer as $$
  select count(*)::int from private.events where type = 'access_recovered';
$$;
create function pg_temp.recovered_field(p_field text) returns text
language sql security definer as $$
  select case p_field
    when 'author' then author
    else payload ->> p_field
  end
  from private.events where type = 'access_recovered';
$$;


-- An event as CareEventCodec writes it; the server reads only these.
create function pg_temp.ev(
  p_id text, p_author text, p_type text, p_fields jsonb default '{}'
) returns jsonb language sql as $$
  select jsonb_build_object(
    'v', 1, 'id', p_id, 'caregiver_id', p_author,
    'occurred_at', '2026-11-04T09:00:00.000', 'received_at', null,
    'type', p_type
  ) || p_fields;
$$;

-- An account as the server keeps it: whether it is still protected, how
-- many identities and sessions it has, and its binding's session.
create function pg_temp.account(p_uid text, p_what text) returns text
language sql security definer as $$
  select case p_what
    when 'anonymous' then
      (select is_anonymous::text from auth.users where id = p_uid::uuid)
    when 'email' then
      (select email from auth.users where id = p_uid::uuid)
    when 'identities' then
      (select count(*)::text from auth.identities where user_id = p_uid::uuid)
    when 'sessions' then
      (select count(*)::text from auth.sessions where user_id = p_uid::uuid)
    when 'session' then
      (select session_id::text from private.device_bindings
        where uid = p_uid::uuid)
    when 'token' then
      (select token from private.device_tokens where uid = p_uid::uuid)
  end;
$$;

grant execute on all functions in schema pg_temp to authenticated, anon;

select is(
  (select count(*)::int
    from pg_db_role_setting s
    join pg_roles r on r.oid = s.setrole
    where r.rolname = 'authenticator'
      and 'pgrst.db_pre_request=public.check_request' = any (s.setconfig)),
  1,
  'the API runs check_request before every request'
);

-- Ana creates a circle on her anonymous phone --------------------------------

set local role authenticated;
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a0'
);
select set_config('test.ana', public.create_circle('Ana', 'Elena'), true);
select lives_ok(
  $$ select public.check_request() $$,
  'an anonymous phone needs no confirmation'
);

-- Ana protects her access ----------------------------------------------------

reset role;
update auth.users set is_anonymous = false, email = 'ana@example.com'
where id = '00000000-0000-0000-0000-0000000000a1';
insert into auth.identities (provider_id, user_id, identity_data, provider, created_at)
values (
  'google-ana', '00000000-0000-0000-0000-0000000000a1', '{}', 'google',
  '2026-11-04 09:00+00'
);
set local role authenticated;

select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_unconfirmed',
  'a protected account''s session is unconfirmed until confirmed'
);
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1',
  '/rpc/confirm_session'
);
select lives_ok(
  $$ select public.check_request() $$,
  'confirming is the one call an unconfirmed session may make'
);
select public.confirm_session();
select is(pg_temp.recovered(), 0, 'protecting the phone tells no one');
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select lives_ok(
  $$ select public.check_request() $$,
  'a confirmed session uses the API'
);

-- A session older than the one on record is a phone left behind.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a0'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_ended',
  'a session older than the one on record is refused'
);

-- A protected account is one member's way back in, nothing else.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1',
  '/rpc/join_circle'
);
select throws_ok(
  $$ select public.check_request() $$,
  'forbidden',
  'a protected account cannot join a circle'
);
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1',
  '/rpc/create_circle'
);
select throws_ok(
  $$ select public.check_request() $$,
  'forbidden',
  'nor create one'
);
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000b1',
  '00000000-0000-0000-0000-00000000b5b0',
  '/rpc/join_circle'
);
select lives_ok(
  $$ select public.check_request() $$,
  'an anonymous phone can'
);

-- Only the server says that someone is on a new phone.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select is(
  public.push_events(jsonb_build_array(pg_temp.ev(
    'forged', current_setting('test.ana'), 'access_recovered',
    jsonb_build_object('member_id', current_setting('test.ana'))
  ))) -> 'rejected' -> 0 ->> 'reason',
  'not_allowed',
  'a phone cannot write access_recovered itself'
);

-- Ana recovers on a new phone ------------------------------------------------

-- Her old phone had notifications on.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select public.register_push_token('token-old-phone', 'android', 'es');

select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a2'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_unconfirmed',
  'a new phone cannot read before confirming'
);
select is(
  public.current_circle(), null,
  'nor hear the circle''s channel'
);
select public.confirm_session();
select is(pg_temp.recovered(), 1, 'a new phone tells the circle');
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000a1', 'sessions'),
  '1',
  'and the server ends the account''s other sessions itself'
);
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000a1', 'token'),
  null,
  'and forgets the old phone''s push token'
);
select is(
  public.current_member(),
  current_setting('test.ana'),
  'the new phone learns which member it is'
);
select is(
  pg_temp.recovered_field('member_id'),
  current_setting('test.ana'),
  'about the member who recovered'
);
select is(
  pg_temp.recovered_field('author'),
  'system',
  'written by the server'
);
select public.confirm_session();
select is(pg_temp.recovered(), 1, 'confirming again tells no one twice');

-- The old phone's token is refused at once, though it has not expired.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_ended',
  'an ended session is refused before its token expires'
);

-- Even a session of the old phone that outlived the recovery cannot
-- take the access back.
reset role;
insert into auth.sessions (id, user_id, created_at)
values (
  '00000000-0000-0000-0000-00000000a5a1',
  '00000000-0000-0000-0000-0000000000a1', '2026-11-04 09:00+00'
);
set local role authenticated;
select throws_ok(
  $$ select public.check_request() $$,
  'session_ended',
  'a session of the old phone that survived is refused'
);
select throws_ok(
  $$ select public.confirm_session() $$,
  'session_ended',
  'and cannot confirm itself'
);
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000a1', 'session'),
  '00000000-0000-0000-0000-00000000a5a2',
  'the new phone keeps the access'
);

-- Confirming a recovery again, whatever is on record, tells no one twice.
reset role;
update private.device_bindings
set session_id = null, session_started = null
where uid = '00000000-0000-0000-0000-0000000000a1';
set local role authenticated;
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a2'
);
select lives_ok(
  $$ select public.confirm_session() $$,
  'a recovery confirmed twice does not fail'
);
select is(pg_temp.recovered(), 1, 'nor is the circle told twice');

-- A session that never existed is refused too, anonymous or not.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000b1',
  '00000000-0000-0000-0000-0000000000ff'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_ended',
  'an unknown session is refused'
);

-- Accounts linked to no one --------------------------------------------------

select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select is(public.discard_unbound_user(), false, 'an anonymous phone is kept');
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select is(public.discard_unbound_user(), false, 'a bound account is kept');
select pg_temp.act_as('00000000-0000-0000-0000-0000000000c1');
select is(public.discard_unbound_user(), true, 'a Google account linked to no one is deleted');

-- The operator ---------------------------------------------------------------

reset role;
select set_config(
  'test.code',
  private.operator_issue_code(
    (select circle_id from private.device_bindings
      where uid = '00000000-0000-0000-0000-0000000000a1'),
    current_setting('test.ana')
  ),
  true
);
set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select is(
  public.join_circle(current_setting('test.code')) ->> 'member_id',
  current_setting('test.ana'),
  'the operator''s code works as any other'
);

select throws_ok(
  $$ select private.operator_issue_code(gen_random_uuid(), 'x') $$,
  '42501',
  null,
  'clients cannot issue codes as the operator'
);

-- A binding that ends takes the protection with it ----------------------------

-- Ana protects her second phone with another account, and half a minute
-- later someone signs in with it elsewhere before that phone confirmed.
reset role;
update auth.users set is_anonymous = false, email = 'ana2@example.com'
where id = '00000000-0000-0000-0000-0000000000b1';
insert into auth.identities (provider_id, user_id, identity_data, provider, created_at)
values (
  'google-ana2', '00000000-0000-0000-0000-0000000000b1', '{}', 'google',
  '2026-11-04 12:00+00'
);
set local role authenticated;
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000b1',
  '00000000-0000-0000-0000-00000000b5b1'
);
select public.confirm_session();
select is(
  pg_temp.recovered(), 2,
  'a first session that starts after the account was protected is a new phone'
);

-- That phone leaves the circle.
select is(
  jsonb_array_length(public.push_events(jsonb_build_array(pg_temp.ev(
    'left-1', current_setting('test.ana'), 'member_left',
    jsonb_build_object('member_id', current_setting('test.ana'))
  ))) -> 'stored'),
  1,
  'a protected phone leaves the circle'
);
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000b1', 'anonymous'),
  'true',
  'and its account is anonymous again'
);
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000b1', 'identities')
    || ' ' || coalesce(
      pg_temp.account('00000000-0000-0000-0000-0000000000b1', 'email'),
      'no email'
    ),
  '0 no email',
  'with its Google identity and email deleted'
);
select is(
  pg_temp.account('00000000-0000-0000-0000-0000000000b1', 'session'),
  null,
  'and no session on record for whoever uses the phone next'
);

-- Deleting the circle --------------------------------------------------------

select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select public.delete_circle();
reset role;
select is(
  (select array_agg(id::text order by id) from auth.users
    where id in (
      '00000000-0000-0000-0000-0000000000a1',
      '00000000-0000-0000-0000-0000000000b1'
    )),
  array['00000000-0000-0000-0000-0000000000b1'],
  'deleting the circle deletes its protected accounts, not anonymous phones'
);

-- Stray users ----------------------------------------------------------------

insert into auth.users (id, is_anonymous, created_at)
values
  ('00000000-0000-0000-0000-0000000000e1', true, now() - interval '2 days'),
  ('00000000-0000-0000-0000-0000000000e2', true, now()),
  ('00000000-0000-0000-0000-0000000000e3', false, now() - interval '2 days');
-- Other strays in the database go too: only these three are checked.
select private.discard_stray_users();
select is(
  (select array_agg(right(id::text, 2) order by id) from auth.users
    where id::text like '00000000-0000-0000-0000-0000000000e_'),
  array['e2'],
  'users a day old that belong to no circle are discarded, Google or not'
);

select * from finish();
rollback;
