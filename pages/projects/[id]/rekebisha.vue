<script setup lang="ts">
import { computed, reactive, ref } from 'vue';
import { v4 as uuidV4 } from 'uuid';
import { Image, Project, Tag } from '@/utils/types';
import { Database } from '~/utils/database.types';

definePageMeta({
  title: 'Edit Project',
  description: 'Edit your project',
  middleware: 'auth',
});

const route = useRoute();
const router = useRouter();
const { id } = route.params;

const supabaseClient = useSupabaseClient<Database>();
const projects = useState<Project[]>('projects');
const getProject = async (): Promise<Project> => {
  const { data, error } = await supabaseClient
    .from('projects')
    .select('*')
    .eq('id', id)
    .single();
  if (error || !data) {
    throw error || new Error('Project not found');
  }
  const { data: projectTags, error: projectTagsError } = await supabaseClient
    .from('projects_tags')
    .select('tags(id, text)')
    .eq('project_id', id);
  if (projectTagsError) {
    throw projectTagsError;
  }
  const tags = projectTags
    .map(({ tags }) => {
      if (tags) {
        return {
          id: tags.id,
          name: tags.text,
        };
      }
      return undefined;
    })
    .filter((tag) => tag !== undefined) as Tag[];
  const { data: projectImages, error: imagesError } = await supabaseClient
    .from('projects_images')
    .select('images(url, caption)')
    .eq('project_id', id);

  if (imagesError) {
    throw imagesError;
  }

  const images = projectImages
    ?.map(({ images }) => {
      if (images) {
        return {
          url: images.url,
          caption: images.caption || '',
        };
      }
      return undefined;
    })
    .filter((image) => image !== undefined) as Image[];

  return {
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
  const { data, error } = await supabaseClient.from('tags').select('id, text');
  if (error) {
    throw error;
  }
  return (
    data?.map((tag) => ({
      id: tag.id,
      name: tag.text,
    })) || []
  );
};

const { data, error } = await useAsyncData('tags', () => {
  return getTags();
});

if (error.value) {
  // eslint-disable-next-line no-console
  console.error(error.value);
}
const tags = ref<Tag[]>(data.value || []);
type State = {
  selectedProject: Project;
};
const state = reactive<State>({
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
  },
});
const bodyContent = ref(state.selectedProject.overviewBody);

const isShowingUploadCoverPageModal = ref(false);
const isShowingUploadProjectFilesModal = ref(false);
const isShowingAddTechForm = ref(false);
const selectedTagsIds = ref<string[]>(
  state.selectedProject.tags.map((tag) => tag.id),
);
const newSelectedTagsIds = ref<string[]>(selectedTagsIds.value);
const deletedTagsIds = ref<string[]>([]);
const selectedTags = ref<Tag[]>(state.selectedProject.tags);
const isAddingTech = ref(false);
const newTechSuccessfullyUploaded = ref(false);
const projectCoverPageURL = ref(state.selectedProject.coverImageURL);
const oldProjectCoverPageURL = ref('');
const newProjectCoverPageFile = ref<File | null>(null);
const newProjectCoverPageURL = ref('');
const coverImageCaption = ref('');
const projectImagesURLs = ref<string[]>(
  state.selectedProject.images.map((image) => image.url),
);
const newProjectImagesURLs = ref<string[]>(projectImagesURLs.value);
const deletedProjectImagesURLs = ref<string[]>([]);
const newProjectImagesFiles = ref<File[]>([]);
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
  selectedTagsIds.value = state.selectedProject.tags.map((tag) => tag.id);
  selectedTags.value = state.selectedProject.tags;
  projectCoverPageURL.value = state.selectedProject.coverImageURL;
  coverImageCaption.value = '';
  projectImagesURLs.value = state.selectedProject.images.map(
    (image) => image.url,
  );
  projectName.value = state.selectedProject.title;
  demoLink.value = state.selectedProject.demoLinkURL;
  projectGithubURL.value = state.selectedProject.githubLinkURL;
  projectDescription.value = state.selectedProject.description;
};

interface ProjectFileData {
  file: File | undefined;
}
const newProjectCoverPageData: ProjectFileData = reactive({
  file: undefined,
});
function bodyContentSaved(savedContent: string) {
  bodyContent.value = savedContent;
}
function addUploadCoverImage(file: File) {
  newProjectCoverPageData.file = file;
  newProjectCoverPageURL.value = URL.createObjectURL(file);
  isShowingUploadCoverPageModal.value = false;
}
function addProjectImages(files: File[]) {
  newProjectImagesFiles.value = files;
  newProjectImagesURLs.value = files.map((file) => URL.createObjectURL(file));
  isShowingUploadProjectFilesModal.value = false;
}
async function addTech(newTechName: string) {
  try {
    newTechSuccessfullyUploaded.value = false;
    isAddingTech.value = true;
    const listOfTechsToAdd = newTechName.split(',').map((tech) => {
      tech.trim();
      return {
        id: uuidV4(),
        name: tech.toLowerCase(),
      };
    });
    const { error } = await supabaseClient.from('tags').insert(
      listOfTechsToAdd.map((tech) => ({
        id: tech.id,
        text: tech.name,
      })),
    );
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
  newProjectCoverPageData.file = undefined;
  newProjectCoverPageURL.value = '';
  if (!oldProjectCoverPageURL.value) {
    oldProjectCoverPageURL.value = projectCoverPageURL.value;
  }
}
function deleteProjectImage(url: string) {
  const index = projectImagesURLs.value.findIndex(
    (imageURL) => imageURL === url,
  );
  if (index === -1) {
    console.error('Image not found');
    return;
  }
  if (newProjectImagesURLs.value.includes(url)) {
    newProjectImagesURLs.value = newProjectImagesURLs.value.filter(
      (imageURL) => imageURL !== url,
    );
    return;
  }
  if (!deletedProjectImagesURLs.value.includes(url)) {
    deletedProjectImagesURLs.value.push(url);
  }
}
function deleteSelectedTech(id: string) {
  if (newSelectedTagsIds.value.includes(id)) {
    newSelectedTagsIds.value = newSelectedTagsIds.value.filter(
      (tagId) => tagId !== id,
    );
    return;
  }
  if (!deletedTagsIds.value.includes(id)) {
    deletedTagsIds.value.push(id);
  }
}
const computedListOfImagesURLs = computed(() => {
  const listOfURLs = [
    ...projectImagesURLs.value,
    ...newProjectImagesURLs.value,
  ];
  return listOfURLs.filter(
    (url) => !deletedProjectImagesURLs.value.includes(url),
  );
});

const computedSelectedListOfTagsID = computed(() => {
  const listOfNewTags = newSelectedTagsIds.value
    .map((tagId) => tags.value.find((tag) => tag.id === tagId))
    .filter((tag) => tag !== undefined) as Tag[];
  const listOfTags = [...selectedTags.value, ...listOfNewTags];
  return listOfTags
    .map((tag) => tag.id)
    .filter((tagID) => !deletedTagsIds.value.includes(tagID));
});

const computedCoverImageURL = computed(
  () => newProjectCoverPageURL.value || projectCoverPageURL.value,
);

const uploadImages = async (files: File[]) => {
  const uploads = files.map(async (file) => {
    const time = uuidV4();
    const { error } = await supabaseClient.storage
      .from('projectFiles')
      .upload(`files/${file.name}-${time}`, file);
    if (error) {
      throw error;
    }
    const {
      data: { publicUrl },
    } = supabaseClient.storage
      .from('projectFiles')
      .getPublicUrl(`files/${file.name}-${time}`);
    return publicUrl;
  });
  return Promise.allSettled(uploads);
};
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
  return true;
};
const saveImagesToDB = async (images: Image[]) => {
  const { error } = await supabaseClient.from('images').insert(images);
  if (error) {
    throw error;
  }
};
const deleteImagesFromDB = async (imagesURLs: string[]) => {
  const { error } = await supabaseClient
    .from('images')
    .delete()
    .match({ url: imagesURLs });
  if (error) {
    throw error;
  }
};
const handleError = (message = 'Failed to edit project') => {
  console.error(error);
  submitting.value = false;
  buttonLabel.value = 'Edit Project';
  errorText.value = message;
};
async function editProject() {
  errorText.value = '';
  submitting.value = true;
  buttonLabel.value = 'Editing...';
  if (!validateForm()) {
    submitting.value = false;
    buttonLabel.value = 'Edit Project';
    return;
  }
  try {
    const projectTitle = projectName.value.trim();
    const description = projectDescription.value.trim();
    const failedToUploadImages = [];
    const overview = bodyContent.value.trim();
    let coverPageURL = '';
    let newProjectImagesURLs: string[] = [];
    if (newProjectCoverPageData.file) {
      const [res] = await uploadImages([newProjectCoverPageData.file]);
      if (res.status === 'rejected') {
        errorText.value = res.reason;
        return;
      }
      coverPageURL = res.value;
      await saveImagesToDB([
        {
          url: coverPageURL,
          caption: coverImageCaption.value,
        },
      ]);
      await deleteImagesFromDB([oldProjectCoverPageURL.value]);
    } else {
      coverPageURL = projectCoverPageURL.value;
    }
    if (newProjectImagesFiles.value.length) {
      const storeProjectImagesURLs = await uploadImages(
        newProjectImagesFiles.value,
      );
      storeProjectImagesURLs.forEach((res, i) => {
        if (res.status === 'rejected') {
          errorText.value = res.reason;
          failedToUploadImages.push({
            file: newProjectImagesFiles.value[i],
            reason: res.reason,
          });
        } else {
          newProjectImagesURLs.push(res.value);
        }
      });
      if (failedToUploadImages.length) {
        errorText.value = `Failed to upload ${failedToUploadImages.length} images`;
      }
      await saveImagesToDB(
        newProjectImagesURLs.map((url) => ({
          url
        })),
      );
      const projectImages = newProjectImagesURLs.map((url) => ({
        id: uuidV4(),
        image_url: url,
        project_id: id as string,
      }));
      const { error: projectImagesError } = await supabaseClient
          .from('projects_images')
          .insert(projectImages);
      if (projectImagesError) {
         handleError(projectImagesError.message);
      }
    }
    if (deletedProjectImagesURLs.value.length) {
      await deleteImagesFromDB(deletedProjectImagesURLs.value);
      const { error: projectImagesError } = await supabaseClient
          .from('projects_images')
          .delete()
          .match({ image_url: deletedProjectImagesURLs.value });
      if (projectImagesError) {
          handleError(projectImagesError.message);
      }
    }
    if (newSelectedTagsIds.value.length) {
      const projectTags = newSelectedTagsIds.value.map((tagId) => ({
        id: uuidV4(),
        project_id: id as string,
        tag_id: tagId,
      }));
      const { error: projectTagsError } = await supabaseClient
        .from('projects_tags')
        .insert(projectTags);
      if (projectTagsError) {
        handleError(projectTagsError.message);
      }
    }
    if (deletedTagsIds.value.length) {
      const { error: projectTagsError } = await supabaseClient
        .from('projects_tags')
        .delete()
        .eq('tag_id', deletedTagsIds.value);
      if (projectTagsError) {
        handleError(projectTagsError.message);
      }
    }
    const { error, data } = await supabaseClient
      .from('projects')
      .update({
        title: projectTitle,
        description,
        overview_body: overview,
        cover_image: coverPageURL,
        hosting_link: demoLink.value,
        github_link: projectGithubURL.value,
        is_published: isPublished.value,
      })
      .eq('id', id as string).select('*');
    if (error) {
      handleError(error.message);
    } else {
      console.log('data', data);
      submitting.value = false;
      buttonLabel.value = 'Successfully Edited';
      clearNuxtState()
      setTimeout(() => {
        router.push(`/projects/${id}`);
      }, 2000);
    }
  } catch (e) {
    console.error(e);
    errorText.value = e?.message;
    submitting.value = false;
    buttonLabel.value = 'Edit Project';
  }
}
</script>

<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
      Edit Project
    </h2>

    <ProjectForm
      :add-tech-button-label="techButtonLabel"
      :body-content="bodyContent"
      :cover-image-caption="coverImageCaption"
      :create-button-label="buttonLabel"
      :demo-link="demoLink"
      :error-text="errorText"
      :is-adding-tech="isAddingTech"
      :is-published="isPublished"
      :is-submitting="submitting"
      :project-cover-page-u-r-l="computedCoverImageURL"
      :project-description="projectDescription"
      :project-github-u-r-l="projectGithubURL"
      :project-images-u-r-ls="computedListOfImagesURLs"
      :project-name="projectName"
      :selected-tags-ids="computedSelectedListOfTagsID"
      :tags="tags"
      @add_tech="addTech"
      @body_content_updated="bodyContentSaved"
      @cover_image_caption_updated="coverImageCaption = $event"
      @delete_selected_tech="deleteSelectedTech"
      @demo_link_updated="demoLink = $event"
      @project_cover_image_deleted="deleteCoverImage"
      @project_cover_image_updated="addUploadCoverImage"
      @project_description_updated="projectDescription = $event"
      @project_github_url_updated="projectGithubURL = $event"
      @project_image_deleted="deleteProjectImage"
      @project_images_updated="addProjectImages"
      @project_name_updated="projectName = $event"
      @publish_updated="isPublished = $event"
      @selected_tags_ids_updated="selectedTagsIds = $event"
      @submit_button_clicked="editProject"
    />
  </div>
</template>
