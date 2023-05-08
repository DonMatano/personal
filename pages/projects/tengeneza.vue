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
        <Editor />
      </div>
      <button type="button" class="justify-end px-4 py-1 border border-accent-teal" 
        @click="showModal"
      >
        Upload project cover page
      </button>
      <ImageUploader :showModal="isShowingUploadCoverPageModal" @model_closed="isShowingUploadCoverPageModal = false" />
      <input type="text" placeholder="Techs Used"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <button type="button"
        class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal">CREATE</button>
    </form>
  </div>
</template>

<script setup lang="ts">
import {ref} from 'vue';

const isShowingUploadCoverPageModal = ref(false);
function showModal() {
  isShowingUploadCoverPageModal.value = !isShowingUploadCoverPageModal.value;
}
</script>
