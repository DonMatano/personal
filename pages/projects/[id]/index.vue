<template>
  <div class="text-body">
    <h2 class="text-[2rem] md:text-[4rem] inline-block lg:text-l font-bold my-8">
      {{ state.selectedProject.title }}
    </h2>
      <div class="flex justify-end gap-6">
        <a
          v-if="state.selectedProject.demoLinkURL"
          :href="state.selectedProject.demoLinkURL"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal"
          target="_blank"
          >
          Demo
        </a>
        <a
          v-if="state.selectedProject.githubLinkURL"
          :href="state.selectedProject.githubLinkURL"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal"
          target="_blank"
          >
          Github
        </a>
        <NuxtLink
          v-if="isSignedIn"
          :to="`/projects/${state.selectedProject.id}/rekebisha`"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">
          Edit Project
        </NuxtLink>
    </div>
    <img
      v-if="state.selectedProject.coverImageURL"
      :src="state.selectedProject.coverImageURL"
      alt="Project cover image"
      class="w-full min-h-[25rem] object-cover object-center my-5"
    />
    <p class="text-body mt-4">{{ state.selectedProject.description }}</p>

    <Editor class="my-5" :body-content="state.selectedProject.overviewBody"/>

    <h3 class="text-[2rem] md:text-[4rem] lg:text-l font-bold my-8">
      Technology used
    </h3>
    <ul class="flex flex-wrap gap-3 mb-16">
      <li
          class="border border-accent-teal rounded-md text-white font-bold rounded-md px-2 py-1 mr-2 mb-2"
        v-if="state.selectedProject.tags"
        v-for="tag in state.selectedProject.tags" :key="tag.id">
        {{ tag.name }}
      </li>
    </ul>
    <Carousel
      v-if="state.selectedProject.images && state.selectedProject.images.length > 0"
     :images-urls="state.selectedProject.images.map((image) => image.url)" class="w-fit" />
  </div>
</template>

<script setup lang="ts">
import { Database } from '~/utils/database.types';
import { Project, Tag, Image } from '~/utils/types';
import {reactive} from 'vue';

const route = useRoute();
const router = useRouter();
const user = useSupabaseUser();
const supabaseClient = useSupabaseClient<Database>();
const isSignedIn = !!user.value;
const { id } = route.params;
const projects = useState<Project[]>('projects');
const getProject = async () : Promise<Project> => {
  const {data, error} = await supabaseClient
  .from('projects')
  .select('*')
  .eq('id', id)
  .single();
  if (error || !data) {
    throw error || new Error('Project not found');
  }
    const {data: projectTags, error: projectTagsError} = await supabaseClient
      .from('projects_tags')
      .select('tags(id, text)')
      .eq('project_id', id);
    console.log({projectTags, projectTagsError});
    if (projectTagsError) {
      throw projectTagsError;
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
      .eq('project_id', id);

    console.log({projectImages, imagesError});
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

  return  {
    id: data.id,
    title: data.title,
    description: data.description || '',
    coverImageURL: data.cover_image || '',
    tags,
    images,
    isPublished: data.is_published,
    githubLinkURL: data.github_link || '',
    demoLinkURL: data.hosting_link || '',
    overviewBody: data.overview_body || '',
  };
};

type State = {
  selectedProject: Project;
}
const state = reactive<State>(
{
  selectedProject: {
    id: '',
    title: '',
    description: '',
    coverImageURL: '',
    tags: [],
    images: [],
    overviewBody: '',
    githubLinkURL: '',
    demoLinkURL: '',
    isPublished: false,
}});

onMounted(async () => {
  let project = projects.value?.find((project) => project.id === id);
  if (!project) {
    project = await getProject();
  }
  if (!project) {
    router.push('/404');
  }
  state.selectedProject = project;
});

function navigateToEditProject() {
  return {
    path: '/projects/:id/rekebisha',
    params: {
      id: state.selectedProject.id,
    },
  };
}
</script>
