-- Push notifications (supabase/migrations/*_push_notifications.sql): who
-- is told, about what, and that nothing leaves without its secrets or
-- with health data in it. Run with `supabase test db`.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(14);

insert into auth.users (id)
values
  ('00000000-0000-0000-0000-0000000000a2'), -- Ana, admin
  ('00000000-0000-0000-0000-0000000000b2'), -- Martín, caregiver
  ('00000000-0000-0000-0000-0000000000c2'), -- Rosa, helper
  ('00000000-0000-0000-0000-0000000000e2'); -- a stranger

create function pg_temp.act_as(p_uid text) returns void language sql as $$
  select set_config(
    'request.jwt.claims',
    json_build_object('sub', p_uid, 'role', 'authenticated')::text,
    true
  );
$$;

create function pg_temp.ev(
  p_id text, p_author text, p_type text, p_fields jsonb default '{}'
) returns jsonb language sql as $$
  select jsonb_build_object(
    'v', 1, 'id', p_id, 'caregiver_id', p_author,
    'occurred_at', '2026-11-03T09:00:00.000', 'received_at', null,
    'type', p_type
  ) || p_fields;
$$;

-- What the database would tell about the stored event [p_id].
create function pg_temp.kind(p_id text) returns text language sql as $$
  select private.push_kind(e) from private.events e where e.id = p_id;
$$;
create function pg_temp.told(p_id text) returns jsonb language sql as $$
  select coalesce(jsonb_agg(t ->> 'token' order by t ->> 'token'), '[]')
  from private.events e,
    jsonb_array_elements(private.push_targets(e)) t
  where e.id = p_id;
$$;

grant execute on all functions in schema pg_temp to authenticated, anon;

-- A circle of three, each phone with a token -----------------------------------

set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a2');
select public.create_circle('Ana', 'Elena', 'ana');
select public.push_events(jsonb_build_array(
  pg_temp.ev('inv-martin', 'ana', 'member_invited',
    '{"member_id": "martin", "name": "Martín", "role": "caregiver", "color_index": 1}'),
  pg_temp.ev('inv-rosa', 'ana', 'member_invited',
    '{"member_id": "rosa", "name": "Rosa", "role": "helper", "color_index": 2}')
));
select set_config('test.martin', public.issue_code('martin') ->> 'code', true);
select set_config('test.rosa', public.issue_code('rosa') ->> 'code', true);
select public.register_push_token('token-ana', 'android', 'es');

select pg_temp.act_as('00000000-0000-0000-0000-0000000000b2');
select public.join_circle(current_setting('test.martin'));
select public.register_push_token('token-martin', 'web', 'es');

select pg_temp.act_as('00000000-0000-0000-0000-0000000000c2');
select public.join_circle(current_setting('test.rosa'));
select public.register_push_token('token-rosa-old', 'android', 'en');
select lives_ok(
  $$ select public.register_push_token('token-rosa', 'android', 'en') $$,
  'a device replaces its token'
);

select pg_temp.act_as('00000000-0000-0000-0000-0000000000e2');
select public.register_push_token('token-stranger', 'web', 'en');

set local role anon;
select throws_ok(
  $$ select public.register_push_token('x', 'web', 'en') $$, '42501', null,
  'signed-out requests cannot register a token'
);

-- Who is told ------------------------------------------------------------------

set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a2');
select public.push_events(jsonb_build_array(
  pg_temp.ev('note-1', 'ana', 'care_note_added', '{"text": "Le subió la presión"}'),
  pg_temp.ev('appt-1', 'ana', 'appointment_created'),
  pg_temp.ev('med-1', 'ana', 'medication_created')
));

reset role;
select is(pg_temp.kind('note-1'), 'note', 'a note for the circle is news');
select is(
  pg_temp.told('note-1'), '["token-martin", "token-rosa"]'::jsonb,
  'everyone else in the circle is told, not its author, nor strangers'
);
select is(pg_temp.kind('appt-1'), 'appointment', 'so is an appointment');
select is(
  pg_temp.told('appt-1'), '["token-martin"]'::jsonb,
  'but a helper, who does not read appointments, is not told'
);
select is(pg_temp.kind('med-1'), null, 'everyday changes are not news');

-- A dose recorded twice --------------------------------------------------------

set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000c2');
select public.push_events(jsonb_build_array(
  pg_temp.ev('dose-rosa', 'rosa', 'dose_given',
    '{"medication_id": "m1", "slot_at": "2026-11-03T08:00:00.000", "known_dose_ids": []}')
));
select pg_temp.act_as('00000000-0000-0000-0000-0000000000b2');
select public.push_events(jsonb_build_array(
  pg_temp.ev('dose-martin', 'martin', 'dose_given',
    '{"medication_id": "m1", "slot_at": "2026-11-03T08:00:00.000", "known_dose_ids": []}'),
  pg_temp.ev('dose-knowing', 'martin', 'dose_given',
    '{"medication_id": "m1", "slot_at": "2026-11-03T08:00:00.000", "known_dose_ids": ["dose-rosa", "dose-martin"]}'),
  pg_temp.ev('dose-other-slot', 'martin', 'dose_given',
    '{"medication_id": "m1", "slot_at": "2026-11-03T20:00:00.000", "known_dose_ids": []}')
));

reset role;
select is(pg_temp.kind('dose-rosa'), null, 'a first dose is not news');
select is(
  pg_temp.kind('dose-martin'), 'double_dose',
  'a second dose for the same slot is'
);
select is(
  pg_temp.kind('dose-knowing'), null,
  'unless the caregiver confirmed it knowing the others'
);
select is(pg_temp.kind('dose-other-slot'), null, 'another slot is not news');

-- Sending ----------------------------------------------------------------------

select is(
  (select count(*) from net.http_request_queue), 0::bigint,
  'nothing is sent without the Vault secrets'
);

select vault.create_secret('http://example.invalid/push', 'push_function_url');
select vault.create_secret('test-secret', 'push_hook_secret');
set local role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-0000000000a2');
select public.push_events(jsonb_build_array(
  pg_temp.ev('note-2', 'ana', 'care_note_added', '{"text": "Le subió la presión"}')
));
reset role;
select is(
  (select convert_from(body, 'UTF8')::jsonb -> 'kind'
    from net.http_request_queue order by id desc limit 1),
  '"note"'::jsonb,
  'with them, the news is queued for the push function'
);
select ok(
  (select convert_from(body, 'UTF8') not like '%presión%'
      and convert_from(body, 'UTF8') not like '%Ana%'
    from net.http_request_queue order by id desc limit 1),
  'carrying no names or health data'
);

select * from finish();
rollback;
