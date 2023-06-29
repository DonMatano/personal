<template>
  <div class="carousel">
    <Splide
      ref="thumbnailCarousel"
      :options="thumbsOptions"
      @splide:click="handleThumbImageClick"
    >
      <SplideSlide v-for="(url) in props.imagesUrls" :key="url">
        <img :src="url" :alt="url" />
      </SplideSlide>
    </Splide>
  </div>
  <VueFinalModal 
    class=" bg-gray-900 bg-opacity-90 overflow-auto flex justify-center items-center " 
    v-model="showModal"
    @click-outside="showModal = false"
    click-to-close
    hide-overlay
  >
    <div class="flex justify-center items-center relative">
      <div class="bg-black absolute top-10 z-50 p-2">
        <p class="text-m font-bold text-white">Click esc to close</p>
      </div>
      <Splide class="my-5 w-9/12" ref="mainCarousel" :options="mainOptions">
        <SplideSlide v-for="(url) in props.imagesUrls" :key="url">
          <div class="flex justify-center items-center pt-4 overflow-auto">
            <img class="" :src="url" :alt="url" />
          </div>
        </SplideSlide>
      </Splide>
    </div>
  </VueFinalModal>
</template>

<script setup lang="ts">
import {Options, Splide, SplideSlide} from '@splidejs/vue-splide';
import {VueFinalModal, ModalsContainer} from 'vue-final-modal';
import '@splidejs/vue-splide/css';

type Props = {
  imagesUrls: string[];
}

const showModal = ref(false);

const props = withDefaults(defineProps<Props>(), {
  imagesUrls: () => [],
});

const mainCarousel = ref<InstanceType<typeof Splide>>();
const thumbnailCarousel = ref<InstanceType<typeof Splide>>();


const mainOptions: Options = {
  type: 'loop',
  perPage: 1,
  perMove: 1,
  rewind: true,
}

const thumbsOptions: Options = {
  type: 'slide',
  rewind: true,
  perPage: 3,
  perMove: 1,
  gap: '1rem',
  pagination: false,
  focus: 'center',
  isNavigation: true,
  breakpoints: {
    640: {
      perPage: 2,
    },
    480: {
      perPage: 1,
    },
  },
  updateOnMove: true,
}

function handleThumbImageClick(slide: InstanceType<typeof Splide>) {
  const index = slide.index ;
  console.log(index);
  showModal.value = true;
  mainCarousel.value?.go(index);
}

onMounted(() => {
})



</script>
