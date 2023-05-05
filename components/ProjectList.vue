<template>
    <ul class="flex flex-col gap-5 md:grid md:grid-cols-2 md:gap-3 md:gap-y-3 md:justify-between">
      <li v-for="i in 12" :key="i">
        <ProjectCard />
      </li>
    </ul>
</template>
