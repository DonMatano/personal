<template>
  <div class="min-h-screen bg-primary-dark text-white px-3 md:px-44">
    <Navbar />
    <section class="mt-6 w-1/2">
      <h1 class="text-7xl font-bold leading-[88px] tracking-[-2.5px]">
        <span>
          Nice to meet you!
        </span>
        <br />
        <span>
         I am Matano.
        </span>
      </h1>
      <p class="text-lg block mt-4">
        Based in Kenya, I'm a fullstack developer passionate about making software that changes people lives.
      </p>
      <a href="#" class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-lg font-bold">
        Contact Me
      </a>
    </section>
    <section class="my-7">
      <ul class="text-2xl font-bold leading-[56px] grid grid-cols-2 md:grid-cols-5">
        <li>NodeJS</li>
        <li>React</li>
        <li>Vue</li>
        <li>Golang</li>
        <li>Docker</li>
        <li>Flutter</li>
      </ul>
    </section>
    <section>
      <h2 class="text-7xl font-bold my-8">Projects</h2>
      <ul class="grid grid-cols-2 gap-4 gap-y-7 justify-between">
        <li v-for="i in 6" :key="i">
          <ProjectCard />
        </li>
      </ul>
    </section>
  </div>
</template>

<style lang="css">
html {
height: 100%;
}
body {
min-height: 100vh;
}
</style>
