<template>
  <div class="my-4">
    <Dashboard :uppy="uppy" :plugins="['ImageEditor']" />
  </div>
</template>

<script setup lang="ts">
import {Dashboard} from '@uppy/vue';
import Uppy from '@uppy/core';
import ImageEditor from '@uppy/image-editor';

import '@uppy/core/dist/style.min.css';
import '@uppy/dashboard/dist/style.min.css';
import '@uppy/image-editor/dist/style.min.css';

const uppy = new Uppy().use(ImageEditor, {quality: 0.8});

</script>
