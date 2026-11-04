-- The member this device is, for a phone that has just recovered its
-- access (docs/roles.md, "Recoverable access"): joining returns the
-- member, signing in with Google does not.
create function public.current_member()
returns text
language sql stable
security definer
set search_path = ''
as $$
  select (private.active_binding(auth.uid())).member_id
$$;

revoke execute on function public.current_member() from public, anon;
grant execute on function public.current_member() to authenticated;
