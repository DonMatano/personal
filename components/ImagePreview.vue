<script setup lang="ts">
const props = defineProps({
  imageURL: { type: String, default: '' },
  imageCaption: { type: String, default: '' },
  customWidth: { type: String, default: 'w-fit' },
  customHeight: { type: String, default: 'h-fit'},
});
const emit = defineEmits<{
  (e: 'delete_image', url: string): void
}>();

function onDeleteImage() {
  emit('delete_image', props.imageURL);
}
</script>

<template>
  <div class="relative w-fit flex gap-5 mx-auto">
    <img :class="`${customWidth} ${customHeight}`" :src="imageURL" :alt="imageCaption" />
    <button
        class="absolute z-20 top-1.5 right-1.5 border border-accent-teal rounded px-2 py-0.5 object-cover"
        @click.prevent="onDeleteImage"
    >&#10539;</button>
  </div>
</template>

<style scoped lang="css">

</style>