<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">Project Name</h2>
    <div class="w-full flex justify-between items-center">
      <h3 class="text-[2rem] md:text-[4rem] inline-block lg:text-l font-bold my-8">
        {{ state.selectedProject.title }}
      </h3>
      <NuxtLink 
        to="#"
        class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">
        Edit Project
      </NuxtLink>
    </div>
    <p class="text-body">{{ state.selectedProject.description }}</p>

    <h3 class="text-[2rem] md:text-[4rem] lg:text-l font-bold my-8">
      Technology used
    </h3>
    <Carousel class="my-5 w-fit"/>
    <ul class="grid grid-cols-2 gap-5 text-center md:grid-cols-3 text-m">
      <li v-for="tag in state.selectedProject.tags" :key="tag.id">
        {{ tag.name }}
      </li>
    </ul>
  </div>
</template>

<script setup lang="ts">
import { Database } from '~/utils/database.types';
import { Project, Tag } from '~/utils/types';

const route = useRoute();
const router = useRouter();
const user = useSupabaseUser();
const supabaseClient = useSupabaseClient<Database>();
const isSignedIn = !!user.value;
const { id } = route.params;
const getTags = async () : Promise<Tag[]> => {
  const {data, error} = await supabaseClient
  .from('tags')
  .select('id, text');
  if (error) {
    throw error;
  }
  console.log('tags', data);
  const tags = data?.map((tag) => ({
    id: tag.id,
    name: tag.text,
  })) || [];
  return tags;
};
const projects = useState<Project[]>('projects');
const tags = useState<Tag[]>('tags');
const getProject = async () : Promise<Project> => {
  const {data, error} = await supabaseClient
  .from('projects')
  .select('*')
  .eq('id', id)
  .single();
  if (error || !data) {
    throw error || new Error('Project not found');
  }
  if (!tags.value || tags.value.length === 0) {
    tags.value = await getTags();
    useState('tags', () => tags.value);
  }

  return  {
    id: data.id,
    title: data.title,
    description: data.description || '',
    coverImageURL: data.cover_image || '',
    tags: [],
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
    overviewBody: '',
}});

if (!projects.value || projects.value.length === 0) {
   state.selectedProject = await getProject();
} else {
  const project = projects.value.find((project) => project.id === id);
  if (!project) {
    console.error('Project not found');
  } else {
    state.selectedProject = project;
  }
}
onMounted(() => {
  console.log('mounted');
  console.log('projects', projects);
  console.log('tags', tags);
});
</script>
