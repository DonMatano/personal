<template>
  <div class="my-4">
    <div class="relative cursor-pointer" @mouseover="updateHover(true)" @mouseleave="updateHover(false)">
      <div v-if="state.isHoveringCard" class="bg-black/60 absolute z-10 top-0 bottom-0 left-0 right-0 ">
        <div
          class="w-full h-full flex flex-col gap-9 justify-center items-center underline font-bold underline-offset-8 mt-4  decoration-accent-teal text-[1rem] uppercase leading-[1.625rem] tracking-[0.14em]">
          <a href="#" class="hover:text-accent-teal">View Project</a>
          <a href="#" class="hover:text-accent-teal">View Code</a>
        </div>
      </div>
      <img class="block mb-3" src="https://placehold.co/600x400?text=Project" alt="project" />
    </div>
    <p class="text-m uppercase my-3 block">Lorem, ipsum dolor.</p>
    <ul class="flex text-body text-light-grey gap-5 uppercase">
      <li v-for="i in 3" :key="i">Lorem.</li>
    </ul>
    <div
      class="flex gap-4 underline underline-offset-8 mt-4 decoration-accent-teal font-bold text-[1rem] uppercase leading-[1.625rem] tracking-[0.14em] lg:hidden">
      <a href="#">View Project</a>
      <a href="#">View Code</a>
    </div>
  </div>
</template>

<script lang="ts">

export default {
  setup() {
    const state = reactive({ isHoveringCard: false })

    function updateHover(hoveringState: boolean) {
      state.isHoveringCard = hoveringState;
    }
    return { state, updateHover };
  }


}

</script>
