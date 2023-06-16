<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">Project Name</h2>
    <div class="w-full flex justify-between items-center">
      <h3 class="text-[2rem] md:text-[4rem] inline-block lg:text-l font-bold my-8">
        {{ state.selectedProject.title }}
      </h3>
      <div class="flex gap-6">
        <a
          v-if="state.selectedProject.demoLinkURL"
          :href="state.selectedProject.demoLinkURL"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal"
          target="_blank"
          >
          View Project Demo
        </a>
        <a
          v-if="state.selectedProject.githubLinkURL"
          :href="state.selectedProject.githubLinkURL"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal"
          target="_blank"
          >
          View Project Code on Github
        </a>
        <NuxtLink
          v-if="isSignedIn"
          to="#"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">
          Edit Project
        </NuxtLink>
      </div>
    </div>
    <p class="text-body">{{ state.selectedProject.description }}</p>

    <Editor class="my-5" :body-content="state.selectedProject.overviewBody"/>

    <h3 class="text-[2rem] md:text-[4rem] lg:text-l font-bold my-8">
      Technology used
    </h3>
    <ul class="grid grid-cols-2 gap-5 text-center md:grid-cols-3 text-m">
      <li
        v-if="state.selectedProject.tags"
        v-for="tag in state.selectedProject.tags" :key="tag.id">
        {{ tag.name }}
      </li>
    </ul>
    <Carousel
      v-if="state.selectedProject.images && state.selectedProject.images.length > 0"
     :images-urls="state.selectedProject.images.map((image) => image.url)" class="my-5 w-fit" />
  </div>
</template>

<script setup lang="ts">
import { Database } from '~/utils/database.types';
import { Project, Tag, Image } from '~/utils/types';

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
</script>
