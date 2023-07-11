drop policy "Enable access for authenticated users only" on "public"."projects";

create policy "Enable all for authenticated users"
on "public"."images"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "Enable all access to authenticated users only"
on "public"."projects"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "Enable insert for authenticated users only"
on "public"."projects"
as permissive
for update
to authenticated
with check (true);


create policy "Enable all for authenticated users"
on "public"."projects_images"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "Enable all for authenticated users"
on "public"."projects_tags"
as permissive
for all
to authenticated
using (true)
with check (true);


create policy "Enable all for authenticated users"
on "public"."tags"
as permissive
for all
to authenticated
using (true)
with check (true);



