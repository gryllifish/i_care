-- The stage 2 backend (supabase/migrations/*_care_backend.sql) against
-- docs/roles.md and docs/backend.md. Run with `supabase test db`.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(39);

-- Devices: one anonymous user each.
insert into auth.users (id)
values
  ('00000000-0000-0000-0000-0000000000a1'), -- Ana's phone
  ('00000000-0000-0000-0000-0000000000b1'), -- Rosa's phone
  ('00000000-0000-0000-0000-0000000000c1'), -- a stranger
  ('00000000-0000-0000-0000-0000000000d1'); -- Rosa's second phone

-- Acting as a device: what PostgREST does for a signed-in request.
create function pg_temp.act_as(p_uid text) returns void language sql as $$
  select set_config(
    'request.jwt.claims',
    json_build_object('sub', p_uid, 'role', 'authenticated')::text,
    true
  );
$$;

-- An event as CareEventCodec writes it; the server reads only these.
create function pg_temp.ev(
  p_id text, p_author text, p_type text, p_fields jsonb default '{}'
) returns jsonb language sql as $$
  select jsonb_build_object(
    'v', 1, 'id', p_id, 'caregiver_id', p_author,
    'occurred_at', '2026-11-03T09:00:00.000', 'received_at', null,
    'type', p_type
  ) || p_fields;
$$;

grant execute on all functions in schema pg_temp to authenticated, anon;

-- Creating a circle ----------------------------------------------------------

set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select set_config('test.ana', public.create_circle('Ana', 'Elena'), true);

select is(
  jsonb_array_length(public.events_after(null) -> 'events'), 3,
  'a new circle starts with circle_created, member_invited and member_joined'
);
select is(
  (select jsonb_agg(e ->> 'server_seq' order by e ->> 'server_seq')
    from jsonb_array_elements(public.events_after(null) -> 'events') e),
  '["1", "2", "3"]'::jsonb,
  'events are numbered in order'
);
select is(public.events_after(null) ->> 'cursor', '3', 'the cursor is the last seq');
select throws_ok(
  $$ select public.create_circle('Ana', 'Elena') $$,
  'forbidden',
  'a device already in a circle cannot create another'
);

-- Inviting and joining --------------------------------------------------------

select is(
  jsonb_array_length(public.push_events(jsonb_build_array(
    pg_temp.ev('inv-rosa', current_setting('test.ana'), 'member_invited',
      '{"member_id": "rosa", "name": "Rosa", "role": "helper", "color_index": 1}')
  )) -> 'stored'),
  1,
  'an admin invites a helper'
);
select set_config('test.code', public.issue_code('rosa') ->> 'code', true);
select matches(
  current_setting('test.code'), '^[A-HJKMNP-Z2-9]{6}$',
  'codes are six unambiguous characters'
);
select throws_ok(
  $$ select public.issue_code('nobody') $$, 'not_found',
  'no code for someone who is not a member'
);

select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select throws_ok(
  $$ select public.issue_code('rosa') $$, 'not_member',
  'a device outside the circle cannot issue codes'
);
select is(
  public.join_circle('XXXXXX'), '{"error": "unknown"}'::jsonb,
  'an unknown code is refused'
);
select is(
  public.join_circle(lower(substr(current_setting('test.code'), 1, 3)) || '-'
    || lower(substr(current_setting('test.code'), 4))),
  '{"member_id": "rosa"}'::jsonb,
  'a code joins its member, typed in lower case with a dash'
);
select is(
  (public.events_after(null) -> 'events' -> -1) ->> 'type', 'member_joined',
  'joining is recorded as member_joined by system'
);
select throws_ok(
  $$ select public.issue_code('rosa') $$, 'forbidden',
  'only admins issue codes'
);

select pg_temp.act_as('00000000-0000-0000-0000-0000000000d1');
select is(
  public.join_circle(current_setting('test.code')), '{"error": "used"}'::jsonb,
  'a code works once'
);

select pg_temp.act_as('00000000-0000-0000-0000-0000000000c1');
select public.join_circle('AAAAAA') from generate_series(1, 4);
select is(
  public.join_circle('AAAAAA'), '{"error": "unknown"}'::jsonb,
  'the fifth failure is still answered'
);
select is(
  public.join_circle('AAAAAA'), '{"error": "locked"}'::jsonb,
  'then the device has to wait'
);

-- Checking events -------------------------------------------------------------

select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select set_config('test.push', public.push_events(jsonb_build_array(
  pg_temp.ev('dose-1', 'rosa', 'dose_given'),
  pg_temp.ev('med-1', 'rosa', 'medication_created'),
  pg_temp.ev('dose-2', current_setting('test.ana'), 'dose_given'),
  pg_temp.ev('joined-fake', 'rosa', 'member_joined', '{"member_id": "rosa"}'),
  pg_temp.ev('newer', 'rosa', 'dose_given') || '{"v": 2}'
))::text, true);
select is(
  jsonb_path_query_array(current_setting('test.push')::jsonb, '$.stored[*].id'),
  '["dose-1"]'::jsonb,
  'a helper records a dose'
);
select is(
  current_setting('test.push')::jsonb -> 'rejected',
  '[
    {"id": "med-1", "reason": "not_allowed"},
    {"id": "dose-2", "reason": "wrong_author"},
    {"id": "joined-fake", "reason": "not_allowed"},
    {"id": "newer", "reason": "not_allowed"}
  ]'::jsonb,
  'each refused event says why, without blocking the others'
);
select is(
  public.push_events(jsonb_build_array(pg_temp.ev('dose-1', 'rosa', 'dose_given')))
    -> 'stored' -> 0,
  current_setting('test.push')::jsonb -> 'stored' -> 0,
  'pushing an event twice returns it as first stored'
);

select set_config('test.pair', public.push_events(jsonb_build_array(
  pg_temp.ev('z-first', 'rosa', 'dose_given'),
  pg_temp.ev('a-second', 'rosa', 'dose_given',
    '{"server_seq": 1, "from_former_member": true}')
))::text, true);
select ok(
  (current_setting('test.pair')::jsonb #>> '{stored,1,server_seq}')::int
    = (current_setting('test.pair')::jsonb #>> '{stored,0,server_seq}')::int + 1,
  'events of one push are numbered in arrival order'
);
select ok(
  current_setting('test.pair')::jsonb #>> '{stored,1,received_at}'
    > current_setting('test.pair')::jsonb #>> '{stored,0,received_at}',
  'and their received_at keeps increasing'
);
select ok(
  not (current_setting('test.pair')::jsonb -> 'stored' -> 1 ? 'from_former_member'),
  'only the server sets from_former_member and server_seq'
);

-- Undos: one's own, anyone's, a conflict review.
select is(
  jsonb_array_length(public.push_events(jsonb_build_array(
    pg_temp.ev('undo-own', 'rosa', 'dose_undone', '{"target_event_id": "dose-1"}')
  )) -> 'stored'),
  1,
  'a helper takes back their own record'
);
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select is(
  jsonb_array_length(public.push_events(jsonb_build_array(
    pg_temp.ev('undo-any', current_setting('test.ana'), 'dose_undone',
      '{"target_event_id": "z-first"}')
  )) -> 'stored'),
  1,
  'an admin takes back someone else''s record'
);

-- Audiences.
select public.push_events(jsonb_build_array(
  pg_temp.ev('appt-1', current_setting('test.ana'), 'appointment_created')
));
select ok(
  public.events_after(null) -> 'events' @> '[{"id": "appt-1"}]',
  'an admin reads appointments'
);
select set_config('test.cursor', public.events_after(null) ->> 'cursor', true);
select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select ok(
  not (public.events_after(null) -> 'events' @> '[{"id": "appt-1"}]'),
  'a helper does not'
);
select is(
  public.events_after(null) ->> 'cursor', current_setting('test.cursor'),
  'the helper''s cursor still covers it, so nothing is sent twice'
);
select is(
  jsonb_array_length(public.events_after(null, 2) -> 'events'), 2,
  'reading comes in pages'
);
select is(
  public.events_after(null, 2) ->> 'cursor', '2',
  'a full page resumes after its last event'
);

-- Members ---------------------------------------------------------------------

select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select is(
  public.push_events(jsonb_build_array(
    pg_temp.ev('demote-ana', current_setting('test.ana'), 'role_changed',
      jsonb_build_object('member_id', current_setting('test.ana'),
        'role', 'caregiver', 'base_version', 1))
  )) -> 'rejected',
  '[{"id": "demote-ana", "reason": "last_admin"}]'::jsonb,
  'the circle never loses its last admin'
);
select is(
  public.push_events(jsonb_build_array(
    pg_temp.ev('bad-role', current_setting('test.ana'), 'member_invited',
      '{"member_id": "x", "name": "X", "role": "boss", "color_index": 2}')
  )) -> 'rejected',
  '[{"id": "bad-role", "reason": "not_allowed"}]'::jsonb,
  'a malformed event is refused alone'
);
select public.push_events(jsonb_build_array(
  pg_temp.ev('remove-rosa', current_setting('test.ana'), 'member_removed',
    '{"member_id": "rosa", "base_version": 1}')
));

select pg_temp.act_as('00000000-0000-0000-0000-0000000000b1');
select throws_ok(
  $$ select public.events_after(null) $$, 'not_member',
  'a removed device learns it when it reads'
);
select set_config('test.late', public.push_events(jsonb_build_array(
  pg_temp.ev('late-dose', 'rosa', 'dose_given'),
  pg_temp.ev('late-note', 'rosa', 'care_note_added', '{"text": "hi"}')
))::text, true);
select is(
  current_setting('test.late')::jsonb #> '{stored,0,from_former_member}',
  'true'::jsonb,
  'a former member''s fact is kept, flagged'
);
select is(
  current_setting('test.late')::jsonb -> 'rejected',
  '[{"id": "late-note", "reason": "not_member"}]'::jsonb,
  'anything else from a former member is refused'
);

-- The permission matrix (lib/features/care/domain/permissions.dart) ------------

reset role;
select is(
  (select count(*) from (values
    -- action, admin, caregiver, helper, viewer
    ('record_care',         true,  true,  true,  false),
    ('remove_own_record',   true,  true,  true,  false),
    ('leave_note',          true,  true,  true,  false),
    ('review_conflict',     true,  true,  false, false),
    ('manage_medications',  true,  true,  false, false),
    ('manage_tasks',        true,  true,  false, false),
    ('manage_appointments', true,  true,  false, false),
    ('manage_reasons',      true,  true,  false, false),
    ('edit_emergency_card', true,  true,  false, false),
    ('remove_any_record',   true,  false, false, false),
    ('manage_members',      true,  false, false, false),
    ('reset_demo',          true,  false, false, false),
    ('leave_circle',        true,  true,  true,  true)
  ) as m(action, admin, caregiver, helper, viewer)
  where private.can('admin', action) <> admin
    or private.can('caregiver', action) <> caregiver
    or private.can('helper', action) <> helper
    or private.can('viewer', action) <> viewer),
  0::bigint,
  'every cell of the permission matrix matches docs/roles.md'
);

-- Security --------------------------------------------------------------------

set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select throws_ok(
  $$ select * from private.events $$, '42501', null,
  'clients cannot read tables'
);
set local role anon;
select throws_ok(
  $$ select public.events_after(null) $$, '42501', null,
  'signed-out requests cannot call the API'
);

-- Deleting a circle -------------------------------------------------------------

-- Other circles may exist (the Dart suite's): count only this one.
reset role;
select set_config('test.circle', (
  select circle_id::text from private.device_bindings
  where uid = '00000000-0000-0000-0000-0000000000a1'
), true);
set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a1');
select lives_ok($$ select public.delete_circle() $$, 'an admin deletes the circle');
reset role;
select is(
  (select count(*) from private.events
    where circle_id = current_setting('test.circle')::uuid),
  0::bigint,
  'with every event in it'
);
select is(
  (select count(*) from private.device_bindings
    where circle_id = current_setting('test.circle')::uuid),
  0::bigint,
  'and its devices unbound'
);

select * from finish();
rollback;
