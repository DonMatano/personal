<script lang="ts" setup>
import { onMounted, onBeforeUnmount } from 'vue';
import EditorJS from '@editorjs/editorjs';
import Header from '@editorjs/header';

const DEFAULT_DATA: EditorJS.OutputData = {
  time: Date.now(),
  blocks: [
    {
      type: 'header',
      data: {
        text: 'Hello there',
        level: 3,
      }
    }
  ]
}

let editorRef: EditorJS.default;

onMounted(() => {
  const editor = new EditorJS({
    holder: 'editorjs',
    placeholder: 'Add Details',
    autofocus: true,
    tools: {
      header: Header,
    },
    data: DEFAULT_DATA,
    onReady: () => {
      editorRef = editor
    }
  });
})

onBeforeUnmount(() => {
  editorRef.destroy();
})

</script>
<template>
  <div>
    <div id="editorjs" class="bg-white border border-accent-teal text-black" />
  </div>
</template>
