<template>
    <ul class="flex flex-col gap-5 md:grid md:grid-cols-2 md:gap-3 md:gap-y-3 md:justify-between">
      <li v-for="project in projects" :key="project.id">
        <ProjectCard
          :project-cover-image-u-r-l="project.coverImageURL"
          :project-title="project.title"
          :project-description="project.description"
          :project-tags="project.tags"
        />
      </li>
    </ul>
</template>

<script setup lang="ts">
import { Project } from '~/utils/types';

interface Props {
  projects : Project[];
}
const props = defineProps<Props>();
</script>
