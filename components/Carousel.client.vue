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
  <div v-show="showModal" class="relative z-20" aria-labelledby="modal-title" role="dialog" aria-modal="true">
  <!--
    Background backdrop, show/hide based on modal state.

    Entering: "ease-out duration-300"
      From: "opacity-0"
      To: "opacity-100"
    Leaving: "ease-in duration-200"
      From: "opacity-100"
      To: "opacity-0"
  -->
  <div
    class="fixed inset-0 bg-gray-500 z-10 bg-opacity-75 transition-opacity"
  />

  <div class="fixed inset-0  z-20 overflow-y-auto">
    <div class="flex h-screen justify-center p-4 text-center sm:items-center sm:p-0">
      <!--
        Modal panel, show/hide based on modal state.

        Entering: "ease-out duration-300"
          From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          To: "opacity-100 translate-y-0 sm:scale-100"
        Leaving: "ease-in duration-200"
          From: "opacity-100 translate-y-0 sm:scale-100"
          To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
      -->
      <div
        class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all w-full md:w-3/4">
        <div class="bg-white px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
          <button
          @click.prevent="() => showModal = false"
            type="button"
            class="mt-4 mr-4 inline-flex items-center justify-center text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:bg-gray-100 focus:text-gray-500 transition ease-in-out duration-150"
            aria-label="Close"
          >Close Modal</button>
          <Splide ref="mainCarousel" :options="mainOptions">
            <SplideSlide v-for="(url) in props.imagesUrls" :key="url">
              <img :src="url" :alt="url" />
            </SplideSlide>
          </Splide>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script setup lang="ts">
import {Options, Splide, SplideSlide} from '@splidejs/vue-splide';
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
