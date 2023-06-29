<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
      Create Project
    </h2>

    <ProjectForm
      @submit_button_clicked="createProject"
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
    />
  </div>
</template>

<script setup lang="ts">
import {ref, watch} from 'vue';
import {Tag} from '@/utils/types';
import {v4 as uuidV4} from 'uuid';
import {Database} from '~/utils/database.types';

definePageMeta({
  title: 'Tengeneza',
  description: 'Create a new project',
  middleware: 'auth'
});

const supabaseClient = useSupabaseClient<Database>();

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

const router = useRouter();

const bodyContent = ref('');

const isShowingUploadCoverPageModal = ref(false);
const isShowingUploadProjectFilesModal = ref(false);
const isShowingAddTechForm = ref(false);
const selectedTagsIds = ref<string[]>([]);
const selectedTags = ref<Tag[]>([]);
const isAddingTech = ref(false);
const newTechSuccessfullyUploaded = ref(false);
const projectCoverPageURL = ref('');
const coverImageCaption = ref('');
const projectImagesURLs = ref<string[]>([]);
const projectImagesFiles = ref<File[]>([]);
const projectName = ref('');
const demoLink = ref('');
const projectGithubURL = ref('');
const projectDescription = ref('');
const submitting = ref(false);
const buttonLabel = ref('CREATE');
const techButtonLabel = ref('ADD TECH');
const errorText = ref('');
interface ProjectFileData {
  file: File | undefined;
}
const projectCoverPageData: ProjectFileData = reactive({
  file: undefined,
});

watch(selectedTagsIds, (newVal) => {
  selectedTags.value = newVal.map((id) => tags.value.find((tag) => tag.id === id)!);
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

type Image = {
  url: string;
  caption?: string;
}

const saveImagesToDB = async (images: Image[]) => {
  const {error} = await supabaseClient
    .from('images')
    .insert(images);
  if (error) {
    throw error;
  }
}

const validateForm = () => {
  if (!projectName.value) {
    errorText.value = 'Project name is required';
    return false;
  }
  if (!projectDescription.value) {
    errorText.value = 'Project description is required';
    return false;
  }
  if (!bodyContent.value) {
    errorText.value = 'Project overview is required';
    return false;
  }
  if (!projectCoverPageData.file) {
    errorText.value = 'Project cover image is required';
    return false;
  }
  return true;
}

async function createProject() {
  errorText.value = '';
  submitting.value = true;
  buttonLabel.value = 'CREATING...';
  if (!validateForm()) {
    submitting.value = false;
    buttonLabel.value = 'CREATE';
    return;
  }
  try {
    const projectId = uuidV4();
    const projectTitle = projectName.value;
    const description = projectDescription.value;
    const overview = bodyContent.value;
    const coverImage = projectCoverPageData.file;
    let coverImageURL = '';
    if (coverImage) {
      [coverImageURL] = await uploadImages([coverImage]);
    }
    if (!coverImageURL) {
      throw new Error('Cover image is required');
    }
    // Store Cover Image to DB
    await saveImagesToDB([{
      url: coverImageURL,
      caption: coverImageCaption.value,
    }]);
    // Store Project Images to DB
    const {error} = await supabaseClient
      .from('projects')
      .insert({
        id: projectId,
        title: projectTitle,
        description,
        overview_body: overview,
        cover_image: coverImageURL,
        hosting_link: demoLink.value,
        github_link: projectGithubURL.value,
      });
    if (error) {
      submitting.value = false;
      buttonLabel.value = 'CREATE';
      errorText.value = error.message;
    }

    // Store Project Tags to DB
    const projectTags = selectedTagsIds.value.map((tagId) => ({
      id: uuidV4(),
      project_id: projectId,
      tag_id: tagId,
    }));
    const {error: projectTagsError} = await supabaseClient
      .from('projects_tags')
      .insert(projectTags);

    // Upload Project Images to Storage
    let storedProjectImagesURLs: string[] = [];
    if (projectImagesFiles.value.length > 0) {
     storedProjectImagesURLs = await uploadImages(projectImagesFiles.value);
    }

    console.log('storedProjectImagesURLs', storedProjectImagesURLs);

    // Store Project Images to DB
    await saveImagesToDB(storedProjectImagesURLs.map((url) => ({
      url,
    })));
    const projectImages = storedProjectImagesURLs.map((url) => {
      console.log('url', url, projectId);
      return {id: uuidV4(),
      project_id: projectId,
      image_url: url}
    }
    );

    const {error: projectImagesError} = await supabaseClient
      .from('projects_images')
      .insert(projectImages);

    if (projectTagsError || projectImagesError) {
      submitting.value = false;
      buttonLabel.value = 'CREATE';
      errorText.value = projectTagsError?.message || projectImagesError?.message || 'Error gotten while saving project tags and images';
    }
    buttonLabel.value = 'CREATED';

    setTimeout(() => {
      router.push(`/`);
    }, 1500);

  } catch (e) {
    submitting.value = false;
    buttonLabel.value = 'CREATE';
    errorText.value = 'Something went wrong: ' + e;
    console.error(e);
  }
}

</script>
