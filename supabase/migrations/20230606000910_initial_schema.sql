create table "public"."images" (
    "url" text not null,
    "created_at" timestamp with time zone default now(),
    "caption" text
);


alter table "public"."images" enable row level security;

create table "public"."projects" (
    "id" uuid not null,
    "created_at" timestamp with time zone default now(),
    "title" text not null,
    "cover_image" text,
    "description" text,
    "overview_body" text
);


alter table "public"."projects" enable row level security;

create table "public"."projects_images" (
    "id" uuid not null,
    "created_at" timestamp with time zone default now(),
    "project_id" uuid not null,
    "image_url" text not null
);


alter table "public"."projects_images" enable row level security;

create table "public"."projects_tags" (
    "id" uuid not null,
    "created_at" timestamp with time zone default now(),
    "project_id" uuid not null,
    "tag_id" uuid not null
);


alter table "public"."projects_tags" enable row level security;

create table "public"."tags" (
    "id" uuid not null,
    "created_at" timestamp with time zone default now(),
    "text" text not null
);


alter table "public"."tags" enable row level security;

CREATE UNIQUE INDEX images_pkey ON public.images USING btree (url);

CREATE UNIQUE INDEX projects_images_pkey ON public.projects_images USING btree (id);

CREATE UNIQUE INDEX projects_pkey ON public.projects USING btree (id);

CREATE UNIQUE INDEX projects_tags_pkey ON public.projects_tags USING btree (id);

CREATE UNIQUE INDEX tags_pkey ON public.tags USING btree (id);

alter table "public"."images" add constraint "images_pkey" PRIMARY KEY using index "images_pkey";

alter table "public"."projects" add constraint "projects_pkey" PRIMARY KEY using index "projects_pkey";

alter table "public"."projects_images" add constraint "projects_images_pkey" PRIMARY KEY using index "projects_images_pkey";

alter table "public"."projects_tags" add constraint "projects_tags_pkey" PRIMARY KEY using index "projects_tags_pkey";

alter table "public"."tags" add constraint "tags_pkey" PRIMARY KEY using index "tags_pkey";

alter table "public"."projects" add constraint "projects_cover_image_fkey" FOREIGN KEY (cover_image) REFERENCES images(url) not valid;

alter table "public"."projects" validate constraint "projects_cover_image_fkey";

alter table "public"."projects_images" add constraint "projects_images_image_url_fkey" FOREIGN KEY (image_url) REFERENCES images(url) ON DELETE SET NULL not valid;

alter table "public"."projects_images" validate constraint "projects_images_image_url_fkey";

alter table "public"."projects_images" add constraint "projects_images_project_id_fkey" FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL not valid;

alter table "public"."projects_images" validate constraint "projects_images_project_id_fkey";

alter table "public"."projects_tags" add constraint "projects_tags_project_id_fkey" FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE SET NULL not valid;

alter table "public"."projects_tags" validate constraint "projects_tags_project_id_fkey";

alter table "public"."projects_tags" add constraint "projects_tags_tag_id_fkey" FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE SET NULL not valid;

alter table "public"."projects_tags" validate constraint "projects_tags_tag_id_fkey";

create policy "Enable insert for authenticated users only"
on "public"."images"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."images"
as permissive
for select
to public
using (true);


create policy "Enable access for authenticated users only"
on "public"."projects"
as permissive
for all
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."projects"
as permissive
for select
to public
using (true);


create policy "Enable access for authenticated users only"
on "public"."projects_images"
as permissive
for all
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."projects_images"
as permissive
for select
to public
using (true);


create policy "Enable access for authenticated users only"
on "public"."projects_tags"
as permissive
for insert
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."projects_tags"
as permissive
for select
to public
using (true);


create policy "Enable access for authenticated users"
on "public"."tags"
as permissive
for all
to authenticated
with check (true);


create policy "Enable read access for all users"
on "public"."tags"
as permissive
for select
to public
using (true);



create policy "Give anon users access to images in folder f5gjby_0"
on "storage"."objects"
as permissive
for select
to public
using (((bucket_id = 'projectFiles'::text) AND (lower((storage.foldername(name))[1]) = 'files'::text) AND (auth.role() = 'anon'::text)));


create policy "Give users authenticated access to folder f5gjby_0"
on "storage"."objects"
as permissive
for select
to authenticated
using (((bucket_id = 'projectFiles'::text) AND (auth.role() = 'authenticated'::text)));


create policy "Give users authenticated access to folder f5gjby_1"
on "storage"."objects"
as permissive
for insert
to authenticated
with check (((bucket_id = 'projectFiles'::text) AND (auth.role() = 'authenticated'::text)));


create policy "Give users authenticated access to folder f5gjby_2"
on "storage"."objects"
as permissive
for update
to authenticated
using (((bucket_id = 'projectFiles'::text) AND (auth.role() = 'authenticated'::text)));


create policy "Give users authenticated access to folder f5gjby_3"
on "storage"."objects"
as permissive
for delete
to authenticated
using (((bucket_id = 'projectFiles'::text) AND (auth.role() = 'authenticated'::text)));



