<script setup lang="ts">
import {reactive, ref, watch} from 'vue';
import {Image, Project, Tag} from '@/utils/types';
import {v4 as uuidV4} from 'uuid';
import {Database} from '~/utils/database.types';

definePageMeta({
  title: 'Edit Project',
  description: 'Edit your project',
  middleware: 'auth'
});

const route = useRoute();
const router = useRouter();
const { id } = route.params;

const supabaseClient = useSupabaseClient<Database>();
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
    isPublished: data.is_published || false,
    githubLinkURL: data.github_link || '',
    demoLinkURL: data.hosting_link || '',
    overviewBody: data.overview_body || '',
  };
};
const getTags = async () => {
  const {data, error} = await supabaseClient
      .from('tags')
      .select('id, text');
  if (error) {
    throw error;
  }
  return data?.map((tag) => ({
    id: tag.id,
    name: tag.text,
  })) || [];
};

const {data, error } = await useAsyncData('tags', async () => {
  return getTags();
});

if (error.value) {
  console.error(error.value);
}
const tags = ref<Tag[]>(data.value || []);
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
const bodyContent = ref(state.selectedProject.overviewBody);

const isShowingUploadCoverPageModal = ref(false);
const isShowingUploadProjectFilesModal = ref(false);
const isShowingAddTechForm = ref(false);
const selectedTagsIds = ref<string[]>(state.selectedProject.tags.map(tag => tag.id));
const selectedTags = ref<Tag[]>(state.selectedProject.tags);
const isAddingTech = ref(false);
const newTechSuccessfullyUploaded = ref(false);
const projectCoverPageURL = ref(state.selectedProject.coverImageURL);
const coverImageCaption = ref('');
const projectImagesURLs = ref<string[]>(state.selectedProject.images.map(image => image.url));
const projectImagesFiles = ref<File[]>([]);
const projectName = ref(state.selectedProject.title);
const demoLink = ref(state.selectedProject.demoLinkURL);
const projectGithubURL = ref(state.selectedProject.githubLinkURL);
const projectDescription = ref(state.selectedProject.description);
const submitting = ref(false);
const buttonLabel = ref('UPDATE PROJECT');
const techButtonLabel = ref('ADD TECH');
const errorText = ref('');
const isPublished = ref(state.selectedProject.isPublished);
onMounted(async () => {
  let project = projects.value?.find((project) => project.id === id);
  if (!project) {
    project = await getProject();
  }
  if (!project) {
    router.push('/404');
  }
  state.selectedProject = project;
  _updateProjectDetails();
});

const _updateProjectDetails = () => {
  bodyContent.value = state.selectedProject.overviewBody;
  selectedTagsIds.value = state.selectedProject.tags.map(tag => tag.id);
  selectedTags.value = state.selectedProject.tags;
  projectCoverPageURL.value = state.selectedProject.coverImageURL;
  coverImageCaption.value = '';
  projectImagesURLs.value = state.selectedProject.images.map(image => image.url);
  projectImagesFiles.value = [];
  projectName.value = state.selectedProject.title;
  demoLink.value = state.selectedProject.demoLinkURL;
  projectGithubURL.value = state.selectedProject.githubLinkURL;
  projectDescription.value = state.selectedProject.description;
};


interface ProjectFileData {
  file: File | undefined;
}
const projectCoverPageData: ProjectFileData = reactive({
  file: undefined,
});
function bodyContentSaved(savedContent: string) {
  bodyContent.value = savedContent;
}
function addUploadCoverImage(file: File) {
  projectCoverPageData.file = file;
  projectCoverPageURL.value = URL.createObjectURL(file);
  isShowingUploadCoverPageModal.value = false;
}
function addProjectImages(files: File[]) {
  projectImagesFiles.value = files;
  projectImagesURLs.value = files.map((file) => URL.createObjectURL(file));
  isShowingUploadProjectFilesModal.value = false;
}
async function addTech(newTechName: string) {
  try {
    newTechSuccessfullyUploaded.value = false;
    isAddingTech.value = true;
    const listOfTechsToAdd = newTechName.split(',').map((tech) => {
      tech.trim()
      return {
        id: uuidV4(),
        name: tech.toLowerCase(),
      };
    });
    const {error} = await supabaseClient
        .from('tags')
        .insert(listOfTechsToAdd.map((tech) => ({
          id: tech.id,
          text: tech.name,
        })));
    if (error) {
      console.error(error);
      isAddingTech.value = false;
      return;
    }
    tags.value.push(...listOfTechsToAdd);
    isAddingTech.value = false;
    isShowingAddTechForm.value = false;
    newTechSuccessfullyUploaded.value = true;

  } catch (error) {
    console.error(error);
    isAddingTech.value = false;
  }
}
function deleteCoverImage() {
  projectCoverPageData.file = undefined;
  projectCoverPageURL.value = '';
}
function deleteProjectImage(url: string) {
  const index = projectImagesURLs.value.findIndex((imageURL) => imageURL === url);
  if (index === -1) {
    console.error('Image not found');
    return;
  }
  projectImagesFiles.value.splice(index, 1);
  projectImagesURLs.value.splice(index, 1);
}
function deleteSelectedTech(id: string) {
  selectedTagsIds.value = selectedTagsIds.value.filter((tagId) => tagId !== id);
}
const uploadImages = async (files: File[]) => {
  const uploads = files.map(async (file) => {
    const time = uuidV4();
    const {error} = await supabaseClient
        .storage
        .from('projectFiles')
        .upload(`files/${file.name}-${time}`, file);
    if (error) {
      throw error;
    }
    const {data: {publicUrl}} = supabaseClient
        .storage
        .from('projectFiles')
        .getPublicUrl(`files/${file.name}-${time}`);
    return publicUrl;
  })
  return await Promise.all(uploads);
}
function editProject() {
  console.log('edit project');
}
</script>

<template>
<div class="text-body">
  <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
    Edit Project
  </h2>

  <ProjectForm
      @submit_button_clicked="editProject"
      @project_name_updated="projectName = $event"
      @demo_link_updated="demoLink = $event"
      @project_github_url_updated="projectGithubURL = $event"
      @project_description_updated="projectDescription = $event"
      @cover_image_caption_updated="coverImageCaption = $event"
      @selected_tags_ids_updated="selectedTagsIds = $event"
      @body_content_updated="bodyContentSaved"
      @project_cover_image_updated="addUploadCoverImage"
      @project_cover_image_deleted="deleteCoverImage"
      @project_images_updated="addProjectImages"
      @add_tech="addTech"
      @delete_selected_tech="deleteSelectedTech"
      @project_image_deleted="deleteProjectImage"
      @publish_updated="isPublished = $event"
      :projectName="projectName"
      :demoLink="demoLink"
      :projectGithubURL="projectGithubURL"
      :projectDescription="projectDescription"
      :coverImageCaption="coverImageCaption"
      :selectedTagsIds="selectedTagsIds"
      :projectImagesURLs="projectImagesURLs"
      :bodyContent="bodyContent"
      :projectCoverPageURL="projectCoverPageURL"
      :tags="tags"
      :isAddingTech="isAddingTech"
      :addTechButtonLabel="techButtonLabel"
      :createButtonLabel="buttonLabel"
      :errorText="errorText"
      :isSubmitting="submitting"
      :isPublished="isPublished"
  />

</div>
</template>

<style scoped lang="css">

</style>
