<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
      Create Project
    </h2>

    <form class="flex flex-col gap-4">
      <input type="text" placeholder="Project Name"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
        v-model="projectName"
      />
      <input type="text" placeholder="Demo Link"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
        v-model="demoLink"
      />
      <input type="text" placeholder="Github Link"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
        v-model="projectGithubURL"
        />
      <textarea row="10" maxlength="250" placeholder="Quick project description"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
        v-model="projectDescription"
      />
      <div class="flex flex-col">
        <Editor  @dataSaved="bodyContentSaved" :body-content="bodyContent" can-edit />
      </div>
      <img
        v-if="projectCoverPageURL"
        :src="projectCoverPageURL"
        class="w-full h-96 object-cover object-center"
      />
      <button type="button" class="justify-end px-4 py-1 border border-accent-teal" @click="showModal">
        Upload project cover page
      </button>
      <ImageUploader
        :showModal="isShowingUploadCoverPageModal"
        @model_closed="isShowingUploadCoverPageModal = false" 
        @upload="addUploadCoverImage"
      />
      <input v-if="projectCoverPageURL" type="text" placeholder="Cover Image Caption"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
        v-model="coverImageCaption"
      />
      <div class="flex items-center">
        <select
          multiple
          v-model="selectedTagsIds"
          class="bg-transparent text-white border border-white py-3 px-4 outline-none focus:border-accent-teal w-1/4">
          <option value="" disabled>Select Techs Used</option>
          <option v-for="tag in tags" :value="tag.id" class="uppercase">{{tag.name}}</option>
        </select>

        <button v-if="!isShowingAddTechForm" type="button"
          class="border-b border-accent-teal py-2 ml-6 leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
          @click="isShowingAddTechForm = true">
          ADD TECH
        </button>
        <form v-else class="ml-6 flex items-center gap-4"> 
          <input v-model.trim="newTechName" type="text" placeholder="Tech Name"
            class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
          <button type="button"
            class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
            :disabled="isAddingTech"
            @click="addTech">
            {{ isAddingTech ? 'ADDING' : 'ADD' }}
          </button>
        </form>
      </div>
      <div class="flex flex-wrap gap-2">
        <TechItem v-for="tag in selectedTags" :key="tag.id" :tech="tag" @delete="deleteSelectedTech"/>
      </div>
      <div class="flex flex-wrap">
        <img v-for="fileURL in projectImagesURLs" :src="fileURL">
      </div>
      <button type="button" class="justify-end px-4 py-1 border border-accent-teal" @click="isShowingUploadProjectFilesModal = true">
        Upload project files
      </button>
      <ImageUploader
        multiple
        :showModal="isShowingUploadProjectFilesModal"
        @model_closed="isShowingUploadProjectFilesModal = false"
        @upload="addProjectImages"
      />
      <button type="button"
        :disabled="submitting"
        class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
        @click="createProject"
      >
        {{ buttonLabel }}
      </button>
      <p v-if="errorText" class=" text-red-400">Error: {{ errorText }}</p>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import {Tag} from '@/utils/types';
import {v4 as uuidV4} from 'uuid';
import { Database } from '~/utils/database.types';

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
  const tags = data?.map((tag) => ({
    id: tag.id,
    name: tag.text,
  })) || [];
  return tags;
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
const newTechName = ref('');
const isAddingTech = ref(false);
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
function showModal() {
  isShowingUploadCoverPageModal.value = !isShowingUploadCoverPageModal.value;
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

async function addTech() {
  try {
  if (!newTechName.value) {
    newTechName.value = '';
    isShowingAddTechForm.value = false;
    return
  };
  isAddingTech.value = true;
  const listOfTechsToAdd = newTechName.value.split(',').map((tech) => {
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
  newTechName.value = '';
  isShowingAddTechForm.value = false;
} catch (error) {
  console.error(error);
  isAddingTech.value = false;
}
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
  const urls = await Promise.all(uploads);
  return urls;
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
    };

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
    saveImagesToDB(storedProjectImagesURLs.map((url) => ({
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
};

</script>
