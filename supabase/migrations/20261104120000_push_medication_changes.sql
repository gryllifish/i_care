-- Push notifications: also when a medication is added, changed (details
-- or schedule) or stopped, since whoever gives the next dose must know.
-- Stock counts and refills stay quiet, as do doses given and tasks.

-- What kind of news [p_event] is for the rest of the circle, or null when
-- it is not worth a notification.
create or replace function private.push_kind(p_event private.events)
returns text
language sql stable
set search_path = ''
as $$
  select case
    when p_event.type = 'care_note_added' then 'note'
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
