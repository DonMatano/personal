<template>
  <div
   class="flex items-center justify-between px-4 py-2 my-2 text-sm font-medium text-white rounded-md border w-fit hover:border-accent-teal"
   @click="deleteTech">
    <span class="px-2 border-r">{{props.tech.name}}</span>
    <button
      class="flex-grow ml-4 hover:text-accent-teal"
      @click.stop.prevent="deleteTech"
    >X</button>
  </div>
</template>

<script setup lang="ts">
import {Tag} from '@/utils/types';
interface Props {
  tech: Tag;
}
const props = defineProps<Props>();

const emits = defineEmits<{
  (e: 'delete', id: string): void
}>()

function deleteTech() {
  emits('delete', props.tech.id);
}
</script>
