<template>
  <div class="min-h-screen bg-primary-dark text-white px-3 min-w-screen md:px-44">
    <Navbar />
    <img src="~/assets/images/matano.jpg" alt="" />
    <section class="mt-6 text-center">
      <h1 class="text-[40px] font-bold leading-[40px] tracking-[-1.14px]">
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
      <a href="#"
        class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
        Contact Me
      </a>
    </section>
    <section class="my-7">
      <ul class="text-[2rem] text-center font-bold leading-[2.5rem] grid grid-cols-2 md:grid-cols-5">
        <li>NodeJS</li>
        <li>React</li>
        <li>Vue</li>
        <li>Golang</li>
        <li>Docker</li>
        <li>Flutter</li>
      </ul>
    </section>
    <section>
      <h2 class="text-[2.5rem] font-bold my-8">Projects</h2>
      <ul class="flex flex-col gap-5 md:grid md:grid-cols-2 md:gap-4 md:gap-y-7 md:justify-between">
        <li class="mx-3" v-for="i in 6" :key="i">
          <ProjectCard class="mx-3" />
        </li>
      </ul>
    </section>
    <section class="bg-dark-grey -mx-3 px-3 py-10 text-center border-b border-white">
      <h2 class="text-[2.5rem] font-bold leading-[2.5rem] tracking-[-0.028em] my-3">Contact</h2>
      <p class="leading-[1.625rem]">Have a project you think I would be a great fit for? Contact me by filling the form
        below, and I'll get back to you soon.</p>
      <form class="flex flex-col gap-4 mt-6 caret-accent-teal">
        <input class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" type="text"
          placeholder="NAME">
        <input
          class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal caret-accent-teal"
          type="email" placeholder="EMAIL">
        <textarea class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" rows="4"
          placeholder="MESSAGE" />
        <button type="button"
          class="self-end border-b border-accent-teal py-2 leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal">SEND
          MESSAGE</button>
      </form>
    </section>
    <Navbar class="bg-dark-grey -mx-3 pt-6 px-3" />
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
