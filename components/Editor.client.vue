<script lang="ts" setup>
import { onMounted, onBeforeUnmount, ref, reactive, defineEmits } from 'vue';
import EditorJS from '@editorjs/editorjs';
import Header from '@editorjs/header';
import List from '@editorjs/list';

const emit = defineEmits<{
  (e: 'dataSaved', stringifiedBody: string): void;
}>();

const props = defineProps({
  canEdit: {
    type: Boolean,
    default: false,
  },
  bodyContent: { type: String, default: '' },
  tags: { type: Array<String>, default: [] },
});

let editorRef: EditorJS.default;
interface EditorData {
  outputData: EditorJS.OutputData | undefined;
}
const editorData: EditorData = reactive({
  outputData: undefined,
});
const htmlOutput = ref('');
const stringifiedEditorData = ref('');
const showEdit = ref(false);
watch(
  () => props.bodyContent,
  () => {
    deStringifyBodyContent();
  },
);
watch(
  () => editorData.outputData,
  () => {
    if (editorData.outputData) {
      parseDataToHtml(editorData.outputData);
    }
  },
);
onMounted(async () => {
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
          defaultStyle: 'unordered',
        },
      },
    },
    data: editorData?.outputData,
    // readOnly: true,
    onReady: () => {
      editorRef = editor;
    },
  });
  if (editorData.outputData) {
    await parseDataToHtml(editorData.outputData);
    stringifyBodyContent();
  }
});

onBeforeUnmount(() => {
  editorRef.destroy();
});

const stringifyBodyContent = () => {
  if (editorData) {
    stringifiedEditorData.value = JSON.stringify(editorData.outputData);
  }
};

const deStringifyBodyContent = () => {
  try {
    console.log('props.bodyContent', props.bodyContent);
    const res = JSON.parse(props.bodyContent) as EditorJS.OutputData;
    console.log('parsed bodyContent', res);
    editorData.outputData = res;
    editorRef.render(res);
  } catch (e) {
    console.error('Error parsing bodyContent', e);
  }
};

if (props.bodyContent) deStringifyBodyContent();

async function parseDataToHtml(contentData: EditorJS.OutputData) {
  htmlOutput.value = '';
  contentData.blocks.forEach((block) => {
    switch (block.type) {
      case 'header': {
        const heading = block.data;
        htmlOutput.value += `
<h${heading.level} class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold leading-[4.5rem] tracking-[-0.028em] my-3">
  ${heading.text}
</h${heading.level}>`;
        break;
      }
      case 'paragraph': {
        const paragraph = block.data;
        htmlOutput.value += `<p class="text-body my-2">${paragraph.text}</p>`;
        break;
      }
      case 'list': {
        const list = block.data;
        const typeOfList = list.style === 'unordered' ? 'ul' : 'ol';
        htmlOutput.value += `
          <${typeOfList}>
  ${list.items.reduce(
    (appended: string, item: string) => appended + `<li my-1>${item}</li>`,
    '',
  )}
</${typeOfList}>
`;
        break;
      }

      default:
        htmlOutput;
    }
  });
}

async function contentSaved() {
  try {
    const contentData = await editorRef.save();
    editorData.outputData = contentData;
    parseDataToHtml(contentData);
    stringifyBodyContent();
    emit('dataSaved', stringifiedEditorData.value);
    showEdit.value = false;
  } catch (error) {
    console.error('Error saving content', error);
  }
}

function toggleShowEdit() {
  if (!showEdit.value) {
    if (editorData.outputData) {
      editorRef.render(editorData.outputData);
    }
  }
  showEdit.value = !showEdit.value;
}
</script>
<template>
  <div class="flex flex-col gap-4">
    <div
      v-show="showEdit"
      id="editorjs"
      class="bg-white border border-accent-teal text-black"
    />
    <div v-show="!showEdit" v-html="htmlOutput" />
    <button
      v-if="canEdit"
      type="button"
      class="justify-end px-4 py-1 border border-accent-teal"
      @click="toggleShowEdit"
    >
      {{ showEdit ? 'Cancel' : 'Edit' }}
    </button>
    <button
      v-if="showEdit"
      type="button"
      class="justify-end px-4 py-1 border border-accent-teal"
      @click="contentSaved"
    >
      Save
    </button>
  </div>
</template>
