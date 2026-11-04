-- Recoverable access (supabase/migrations/*_recoverable_access.sql)
-- against docs/roles.md, "Recoverable access". Run with
-- `supabase test db`.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(20);

-- Ana's phone starts anonymous; Rosa's stays so. A stranger signed in
-- with a Google account linked to no one.
insert into auth.users (id, is_anonymous)
values
  ('00000000-0000-0000-0000-0000000000a1', true),  -- Ana
  ('00000000-0000-0000-0000-0000000000b1', true),  -- Rosa's phone
  ('00000000-0000-0000-0000-0000000000c1', false); -- the stranger

-- Ana's sessions: her first phone's (08:00), the one protecting it
-- (09:00) and a new phone's (10:00). Rosa's phone has one.
insert into auth.sessions (id, user_id, created_at)
values
  ('00000000-0000-0000-0000-00000000a5a0',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 08:00+00'),
  ('00000000-0000-0000-0000-00000000a5a1',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 09:00+00'),
  ('00000000-0000-0000-0000-00000000a5a2',
    '00000000-0000-0000-0000-0000000000a1', '2026-11-04 10:00+00'),
  ('00000000-0000-0000-0000-00000000b5b0',
    '00000000-0000-0000-0000-0000000000b1', '2026-11-04 08:00+00');

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

grant execute on all functions in schema pg_temp to authenticated, anon;

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
update auth.users set is_anonymous = false
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

-- The session before protecting, still on the same phone, is no new phone.
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a0'
);
select public.confirm_session();
select is(pg_temp.recovered(), 0, 'an older session of the same phone tells no one');

-- Ana recovers on a new phone ------------------------------------------------

select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a2'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_unconfirmed',
  'a new phone cannot read before confirming'
);
select public.confirm_session();
select is(pg_temp.recovered(), 1, 'a new phone tells the circle');
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

-- The old phone is signed out: its token is refused at once.
reset role;
delete from auth.sessions
where id in (
  '00000000-0000-0000-0000-00000000a5a0',
  '00000000-0000-0000-0000-00000000a5a1'
);
set local role authenticated;
select pg_temp.act_as(
  '00000000-0000-0000-0000-0000000000a1',
  '00000000-0000-0000-0000-00000000a5a1'
);
select throws_ok(
  $$ select public.check_request() $$,
  'session_ended',
  'an ended session is refused before its token expires'
);

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
  ('00000000-0000-0000-0000-0000000000e2', true, now());
select is(
  private.discard_stray_users(),
  1,
  'only users a day old that belong to no circle are discarded'
);

select * from finish();
rollback;
