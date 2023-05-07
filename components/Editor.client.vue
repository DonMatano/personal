<script lang="ts" setup>
import { onMounted, onBeforeUnmount, onUpdated, ref } from 'vue';
import EditorJS from '@editorjs/editorjs';
import Header from '@editorjs/header';
import List from '@editorjs/list';

const DEFAULT_DATA: EditorJS.OutputData = {
  time: Date.now(),
  blocks: [
    {
      type: 'header',
      data: {
        text: 'Hello there',
        level: 1,
      }
    },
    {
      type: 'list',
      data: {
        items: [
          'Heoy',
        ]
      }

    }
  ]
}

let editorRef: EditorJS.default;
const htmlOutput = ref('');
const showEdit = ref(false);
onMounted(() => {
  const editor = new EditorJS({
    holder: 'editorjs',
    placeholder: 'Add Details',
    autofocus: true,
    tools: {
      header: {
        class: Header,
        inlineToolbar: true,
      },
      list: {
        class: List,
        inlineToolbar: true,
        config: {
          defaultStyle: 'unordered'
        }
      },
    },
    data: DEFAULT_DATA,
    // readOnly: true,
    onReady: () => {
      editorRef = editor
    },
  });
  parseDataToHtml(DEFAULT_DATA);
})

onBeforeUnmount(() => {
  editorRef.destroy();
})

onUpdated(() => console.log('showEdit', showEdit));

async function parseDataToHtml(contentData: EditorJS.OutputData) {

  contentData.blocks.forEach((block) => {
    switch (block.type) {
      case 'header': {
        const heading = block.data;
        htmlOutput.value += `
<h${heading.level} class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold leading-[4.5rem] tracking-[-0.028em] my-3">
  ${heading.text}
</h${heading.level}>`
        break;
      };
      case 'paragraph': {
        const paragraph = block.data;
        htmlOutput.value += `<p class="text-body">${paragraph.text}</p>`
        break;
      }
      case 'list': {
        const list = block.data;
        const typeOfList = list.style === 'unordered' ? 'ul' : 'ol';
        htmlOutput.value += `
          <${typeOfList}>
  ${list.items.reduce((appended: string, item: string) => appended + `<li>${item}</li>`, '')}
</${typeOfList}>
`
        break;
      }

      default: htmlOutput;
    }
  })

}

async function contentSaved() {
  const contentData = await editorRef.save();
  parseDataToHtml(contentData)
  console.log('htmlOutput', htmlOutput);
}

function toggleShowEdit() {
  showEdit.value = !showEdit.value;
}



</script>
<template>
  <div class="flex flex-col gap-4">
    <div id="editorjs" v-show="showEdit" class="bg-white border border-accent-teal text-black" />
    <div v-show="!showEdit" v-html="htmlOutput" />
    <button type="button" class="justify-end px-4 py-1 border border-accent-teal"
      @click="toggleShowEdit">
      {{showEdit ? 'Cancel' : 'Edit'}}
    </button>
    <button v-if="showEdit" type="button" class="justify-end px-4 py-1 border border-accent-teal" @click="contentSaved">
      Save
    </button>
  </div>
</template>