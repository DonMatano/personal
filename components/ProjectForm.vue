<script setup lang="ts">
import {Tag} from "~/utils/types";
import {ref} from "vue";

type PropsTypes = {
  projectName: string,
  demoLink: string,
  projectGithubURL: string,
  projectDescription: string,
  bodyContent: string,
  projectCoverPageURL: string,
  coverImageCaption: string,
  selectedTagsIds: string[],
  isAddingTech: boolean,
  addTechButtonLabel: string,
  tags: Tag[],
  isSubmitting: boolean,
  createButtonLabel: string,
  projectImagesURLs: string[],
  errorText: string,
}
const props = defineProps<PropsTypes>()
const emit = defineEmits<{
  (e: 'project_name_updated', projectName: string): void
  (e: 'demo_link_updated', demoLink: string): void
  (e: 'project_github_url_updated', projectGithubURL: string): void
  (e: 'project_description_updated', projectDescription: string): void
  (e: 'body_content_updated', bodyContent: string): void
  (e: 'project_cover_image_updated', projectCoverPageURL: File): void
  (e: 'cover_image_caption_updated', coverImageCaption: string): void
  (e: 'selected_tags_ids_updated', selectedTagsIds: string[]): void
  (e: 'project_images_updated', projectImages: File[]): void
  (e: 'add_tech', newTechName: string): void
  (e: 'submit_button_clicked'): void
  (e: 'delete_selected_tech', techId: string): void
}>()

const isShowingUploadCoverPageModal = ref(false);
const isShowingUploadProjectFilesModal = ref(false);
const isShowingAddTechForm = ref(false);
const newTechName = ref('');

const selectedTags = computed(() => {
  return props.tags.filter((tag) => props.selectedTagsIds.includes(tag.id));
})

function bodyContentSaved(savedContent: string) {
  emit('body_content_updated', savedContent);
}
function showModal() {
  isShowingUploadCoverPageModal.value = !isShowingUploadCoverPageModal.value;
}
function addUploadCoverImage(file: File) {
  emit('project_cover_image_updated', file);
  isShowingUploadCoverPageModal.value = false;
}
function addProjectImages(files: File[]) {
  emit('project_images_updated', [...files]);
  isShowingUploadProjectFilesModal.value = false;
}

function addTech() {
  const newName = newTechName.value.trim();
  if (newName) {
    emit('add_tech', newName);
  } else {
    isShowingAddTechForm.value = false;
  }
}

function createProject() {
  emit('submit_button_clicked');
}


</script>

<template>
  <form class="flex flex-col gap-4">
    <input type="text" placeholder="Project Name"
           class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
           @input="(e) => emit('project_name_updated', e.target.value)"
    />
    <input type="text" placeholder="Demo Link"
           class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
           @input="(e) => emit('demo_link_updated', e.target.value)"
    />
    <input type="text" placeholder="Github Link"
           class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
           @input="(e) => emit('project_github_url_updated', e.target.value)"
    />
    <textarea row="10" maxlength="250" placeholder="Quick project description"
              class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
              @input="(e) => emit('project_description_updated', e.target.value)"
    />
    <div class="flex flex-col">
      <Editor  @dataSaved="bodyContentSaved" :body-content="bodyContent" can-edit />
    </div>
    <img
        v-if="projectCoverPageURL"
        :src="projectCoverPageURL"
        class="w-full h-96 object-cover object-center"
    />
    <button
        type="button"
        class="justify-end px-4 py-1 border border-accent-teal"
        @click="showModal"
    >
      Upload project cover page
    </button>
    <ImageUploader
        :showModal="isShowingUploadCoverPageModal"
        @model_closed="isShowingUploadCoverPageModal = false"
        @upload="addUploadCoverImage"
    />
    <input v-if="projectCoverPageURL" type="text" placeholder="Cover Image Caption"
           class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
           @input="(e) => emit('cover_image_caption_updated', e.target.value)"
    />
    <div class="flex items-center">
      <select
          multiple
          @change="(e) => emit('selected_tags_ids_updated', Array.from(e.target.selectedOptions).map((option) => option.value))"
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
      <TechItem v-for="tag in selectedTags" :key="tag.id" :tech="tag" @delete="id => emit('delete_selected_tech', id)"/>
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
            :disabled="isSubmitting"
            class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
            @click="createProject"
    >
      {{ createButtonLabel }}
    </button>
    <p v-if="errorText" class=" text-red-400">Error: {{ errorText }}</p>
  </form>
</template>