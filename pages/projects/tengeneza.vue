<template>
  <div class="text-body">
    <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
      Create Project
    </h2>

    <form class="flex flex-col gap-4">
      <input type="text" placeholder="Project Name"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <textarea row="10" maxlength="250" placeholder="Quick project description"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <div class="flex flex-col">
        <Editor  @dataSaved="bodyContentSaved" :body-content="bodyContent" />
      </div>
      <img :src="projectCoverPageURL">
      <button type="button" class="justify-end px-4 py-1 border border-accent-teal" @click="showModal">
        Upload project cover page
      </button>
      <ImageUploader
        :showModal="isShowingUploadCoverPageModal"
        @model_closed="isShowingUploadCoverPageModal = false" 
        @upload="addUploadCoverImage"
      />
      <div class="flex items-center">
        <select
          multiple
          v-model="selectedTagsIds"
          class="bg-transparent text-white border border-white py-3 px-4 outline-none focus:border-accent-teal w-1/4">
          <option value="" disabled>Select Techs Used</option>
          <option v-for="tag in tags" :value="tag.id">{{tag.name}}</option>
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
            @click="addTech">
            ADD
          </button>
        </form>
      </div>
      <TechItem v-for="tag in selectedTags" :key="tag.id" :tech="tag" @delete="deleteSelectedTech"/>
      <button type="button"
        class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal">CREATE</button>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue';
import {Tag} from '@/utils/types';
import {v4 as uuidV4} from 'uuid';

const bodyContent = ref('');
const tags = ref<Tag[]>([{id: '1', name: 'Vue'}, {id: '2', name: 'React'}, {id: '3', name: 'Angular'}]);

const isShowingUploadCoverPageModal = ref(false);
const isShowingAddTechForm = ref(false);
const selectedTagsIds = ref<string[]>([]);
const selectedTags = ref<Tag[]>([]);
const newTechName = ref('');
const projectCoverPageURL = ref('');
interface ProjectCoverPageData {
  file: File | undefined;
}
const projectCoverPageData: ProjectCoverPageData = reactive({
  file: undefined,
});

onBeforeMount(() => {
    bodyContent.value = localStorage.getItem('bodyContent') || '';
});

watch(selectedTagsIds, (newVal) => {
  selectedTags.value = newVal.map((id) => tags.value.find((tag) => tag.id === id)!);
});


function bodyContentSaved(savedContent: string) {
  bodyContent.value = savedContent;
  localStorage.setItem('bodyContent', savedContent);
}
function showModal() {
  isShowingUploadCoverPageModal.value = !isShowingUploadCoverPageModal.value;
}

function addUploadCoverImage(file: File) {
  projectCoverPageData.file = file;
  projectCoverPageURL.value = URL.createObjectURL(file);
  isShowingUploadCoverPageModal.value = false;
}

function addTech() {
  if (!newTechName.value) {
    newTechName.value = '';
    isShowingAddTechForm.value = false;
    return
  };
  const newTech = {
    id: uuidV4(),
    name: newTechName.value,
  };
  tags.value.push(newTech);
  newTechName.value = '';
  isShowingAddTechForm.value = false;
}

function deleteSelectedTech(id: string) {
  selectedTagsIds.value = selectedTagsIds.value.filter((tagId) => tagId !== id);
}

</script>
