<template>
  <div>
    <div class="md:flex md:gap-4 md:flex-row-reverse md:items-center border-b border-light-grey pb-20">
      <img class="md:w-1/2" src="~/assets/images/matano.jpg" alt="" />
      <section class="mt-6 text-center md:text-left  md:w-1/2">
        <h1
          class="text-[2.5rem] font-bold leading-[2.5rem] tracking-[-0.028em] md:text-[4.5rem] md:leading-[4.5rem] lg:text-xl">
          <span>
            Nice to meet you!
          </span>
          <br />
          <span>
            I am Matano.
          </span>
        </h1>
        <p class="text-body block mt-4">
          Based in Kenya, I'm a fullstack developer passionate about making software that changes people lives.
        </p>
        <a href="#contactForm"
          class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px] hover:text-accent-teal">
          Contact Me
        </a>
      </section>
    </div>
    <section class="my-7 mb-5">
      <ul class="text-[2rem] text-center font-bold leading-[2.5rem] grid grid-cols-2 md:text-l md:grid-cols-3 gap-6">
        <li>NodeJS</li>
        <li>React</li>
        <li>Vue</li>
        <li>Golang</li>
        <li>Docker</li>
        <li>Flutter</li>
      </ul>
    </section>
    <section class="mt-10 text-white">
      <div class="flex justify-between items-center">
        <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">Projects</h2>
        <div>
        <NuxtLink to="/projects/tengeneza"
          class="uppercase underline mr-3 underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
          Create new project
        </NuxtLink>
        <NuxtLink to="/projects"
          class="uppercase underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
          View more projects
        </NuxtLink>
        </div>
      </div>
      <ProjectList />
    </section>
  </div>
</template>

<style lang="css">
html {
  height: 100%;
  width: 100%;
}

body {
  min-height: 100vh;
  min-width: 100vw;
  background-color: #151515;
}
</style>
