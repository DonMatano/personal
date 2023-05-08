<template>
  <div 
    class="my-4 cursor-pointer hover:border-2 hover:border-accent-teal hover:text-accent-teal w-[33.75rem] pb-3 relative"
    @mouseenter="updateHover(true)" @mouseleave="updateHover(false)"
  >
    <NuxtLink>
      <div v-if="state.isHoveringCard" class="hidden lg:block max-w-full bg-black/60 absolute z-10 top-0 bottom-0 left-0 right-0 h-[25rem] ">
        <p class="m-auto text-center pt-6 text-white">
          Lorem ipsum dolor sit amet consectetur adipisicing elit. Magni quis delectus quod perspiciatis. Dolorem, expedita quisquam. Veniam necessitatibus, consectetur praesentium quae, iure esse laboriosam a ullam nostrum expedita autem voluptates nesciunt perspiciatis harum provident illo minima reprehenderit, eaque ipsam? Itaque doloribus, veritatis rem odio totam accusantium aliquid distinctio ducimus vitae?
        </p>
      </div>
      <img class="block mb-3 aspect-[27/20]" src="https://placehold.co/540x400?text=Project" alt="project" />
      <p class="text-m uppercase my-3 block px-2">Lorem, ipsum dolor.</p>
      <ul class="flex text-body text-light-grey gap-5 uppercase px-2">
        <li v-for="i in 3" :key="i">Lorem.</li>
      </ul>
    </NuxtLink>
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
