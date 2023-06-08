<template>
  <div class="carousel">
    <Splide>
      <SplideSlide>
        <img src="https://picsum.photos/800/300" alt="image" />
      </SplideSlide>
      <SplideSlide>
        <img src="https://picsum.photos/800/300" alt="image" />
      </SplideSlide>
      <SplideSlide>
        <img src="https://picsum.photos/800/300" alt="image" />
      </SplideSlide>
      <SplideSlide>
        <img src="https://picsum.photos/800/300" alt="image" />
      </SplideSlide>
      <SplideSlide>
        <img src="https://picsum.photos/800/300" alt="image" />
      </SplideSlide>
    </Splide>
  </div>
</template>

<script setup>
import {Splide, SplideSlide} from '@splidejs/vue-splide';
import '@splidejs/vue-splide/css';
</script>
