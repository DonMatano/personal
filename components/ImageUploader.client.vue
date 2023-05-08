<template>
  <div class="my-4">
    <DashboardModal :uppy="uppy" :plugins="['ImageEditor']" :open="props.showModal"  />
  </div>
</template>

<script setup lang="ts">
import {DashboardModal} from '@uppy/vue';
import Uppy from '@uppy/core';
import ImageEditor from '@uppy/image-editor';

import '@uppy/core/dist/style.min.css';
import '@uppy/dashboard/dist/style.min.css';
import '@uppy/image-editor/dist/style.min.css';

const props = defineProps({
  showModal: {type: Boolean, default: false}
})

const emit = defineEmits<{
(e: 'model_closed'): void
}>()

const uppy = new Uppy().use(ImageEditor, {quality: 0.8, cropperOptions: {aspectRatio: 27/20}});
uppy.on('dashboard:modal-closed', () => {
  emit('model_closed')
})

</script>
