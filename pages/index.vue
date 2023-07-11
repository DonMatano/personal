<template>
  <div>
    <div class="md:flex md:gap-4 md:flex-row-reverse md:items-center border-b border-light-grey pb-20">
      <img class="md:w-1/2" src="~/assets/images/matano.jpg" alt="" />
      <section class="mt-6 text-center md:text-left  md:w-1/2">
        <h1
          class="text-[2.5rem] font-bold leading-[2.5rem] tracking-[-0.028em] md:text-[4.5rem] md:leading-[4.5rem] lg:text-xl">
          <span>
            Nice to meet you!
          </span>
          <br />
          <span>
            I am Matano.
          </span>
        </h1>
        <p class="text-body block mt-4">
          Based in Kenya, I'm an experienced fullstack developer passionate about making software that changes people lives.
        </p>
<!--        <a href="#contactForm"-->
<!--          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">-->
<!--          Contact Me-->
<!--        </a>-->
        <a download href="/CV.pdf" target="_blank" alt="Download CV"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">
          Download CV
        </a>
      </section>
    </div>
<!--    <section class="my-7 mb-5">-->
<!--      <ul class="text-[2rem] text-center font-bold leading-[2.5rem] grid grid-cols-2 md:text-l md:grid-cols-3 gap-6">-->
<!--        <li>NodeJS</li>-->
<!--        <li>React</li>-->
<!--        <li>Vue</li>-->
<!--        <li>Golang</li>-->
<!--        <li>Docker</li>-->
<!--        <li>Flutter</li>-->
<!--      </ul>-->
<!--    </section>-->
    <section class="my-10">
      <WorkList />
    </section>
    <section class="mt-10 text-white">
      <div class="flex justify-between items-center">
        <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">Projects</h2>
        <div>
        <NuxtLink v-if="isSignedIn" to="/projects/tengeneza"
          class="uppercase underline mr-3 underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
          Create new project
        </NuxtLink>
        <NuxtLink v-if="projectWithTags.length > 5" to="/projects"
          class="uppercase underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
          View more projects
        </NuxtLink>
        </div>
      </div>
      <ProjectList :projects="projectWithTags" />
    </section>
  </div>
</template>

<script setup lang="ts">
import { Database } from '~/utils/database.types';
import { Project, Tag, Image } from '~/utils/types';
import {ref} from 'vue';

const user = useSupabaseUser();
const supabaseClient = useSupabaseClient<Database>();
const isSignedIn = !!user.value;

const {data: projectData, error} = await useAsyncData('projects', async () => {
  const {data, error} = isSignedIn ? await supabaseClient
    .from('projects')
    .select(`
      id,
      title,
      description,
      created_at,
      overview_body,
      github_link,
      hosting_link,
      cover_image`
    ): await supabaseClient
      .from('projects')
      .select(`
      id,
      title,
      description,
      created_at,
      overview_body,
      github_link,
      hosting_link,
      cover_image`
      ).eq('is_published', true)
  ;
  if (error) {
    throw error;
  }
  const projectsRes = data?.map(async (project) => {
    const {data: projectTags, error} = await supabaseClient
      .from('projects_tags')
      .select('tags(id, text)')
      .eq('project_id', project.id);
    if (error) {
      throw error;
    }
    const tags = projectTags.map(({tags}) => {
      if (tags) {
        return {
          id: tags.id,
          name: tags.text,
        };
      }
    }).filter(tag => tag !== undefined) as Tag[];
    const {data: projectImages, error: imagesError} = await supabaseClient
      .from('projects_images')
      .select('images(url, caption)')
      .eq('project_id', project.id);

    if (imagesError) {
      throw imagesError;
    }

    const images = projectImages?.map(({images}) => {
      if (images) {
        return {
          url: images.url,
          caption: images.caption || '',
        };
      }
    }).filter(image => image !== undefined) as Image[];

    return {
    id: project.id,
    title: project.title,
    description: project.description,
    overviewBody: project.overview_body,
    coverImageURL: project.cover_image,
    githubLinkURL: project.github_link,
    demoLinkURL: project.hosting_link,
    tags,
    images,
    };
  }) || [];
  const projects = await Promise.all(projectsRes);
  return projects as Project[];
});
if (error) {
  console.error(error);
}

const projectWithTags = ref<Project[]>(projectData?.value|| []);
useState('projects', () => projectWithTags.value || []);
</script>

<style lang="css">
html {
  height: 100%;
  width: 100%;
}

body {
  min-height: 100vh;
  min-width: 100vw;
  background-color: #151515;
}
</style>
