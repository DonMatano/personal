<template>
  <div
    class="my-4 cursor-pointer hover:border-2 hover:border-accent-teal hover:text-accent-teal w-[33.75rem] pb-3 relative"
    @mouseenter="updateHover(true)" @mouseleave="updateHover(false)"
  >
    <NuxtLink>
      <div v-if="state.isHoveringCard" class="hidden lg:block max-w-full bg-black/60 absolute z-10 top-0 bottom-0 left-0 right-0 h-[25rem] ">
        <p class="m-auto text-center pt-6 text-white">
          {{ props.projectDescription }}
        </p>
      </div>
      <img class="block mb-3 aspect-[27/20]" :src="props.projectCoverImageURL" alt="project" />
      <p class="text-m uppercase my-3 block px-2">{{ props.projectTitle }}</p>
      <ul class="flex text-body text-light-grey gap-5 uppercase px-2">
        <li v-for="tag in props.projectTags" :key="tag.id">{{ tag.name }}</li>
      </ul>
    </NuxtLink>
  </div>
</template>

<script setup lang="ts">
import { Tag } from '~/utils/types';

interface Props {
  projectTitle: string;
  projectDescription: string;
  projectCoverImageURL: string;
  projectTags: Tag[];
}
const props = defineProps<Props>();
const state = reactive({ isHoveringCard: false })

function updateHover(hoveringState: boolean) {
  state.isHoveringCard = hoveringState;
}
</script>
