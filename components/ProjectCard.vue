<template>
  <div class="my-4">
    <img class="block mb-3" src="https://placehold.co/600x400?text=Project" alt="project" />
    <p class="text-m uppercase my-3 block">Lorem, ipsum dolor.</p>
    <ul class="flex text-body text-light-grey gap-5 uppercase">
      <li v-for="i in 3" :key="i">Lorem.</li>
    </ul>
    <div class="flex gap-4 underline underline-offset-8 mt-4 decoration-accent-teal text-[1rem] uppercase leading-[1.625rem] tracking-[0.14em]">
      <a href="#">View Project</a>
      <a href="#">View Code</a>
    </div>
  </div>
</template>
