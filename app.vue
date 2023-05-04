<script lang="ts">

export default {
  setup() {
    const formState = reactive({
      email: { value: '', isValid: true, errorMessage: '' },
      name: { value: '', isValid: true, errorMessage: '' },
      message: { value: '', isValid: true, errorMessage: '' },
    })
    function validateForm() {
      const resetValues = () => {
        const defaultValues = { isValid: true, errorMessage: '' };
        formState.email = { ...defaultValues, value: formState.email.value };
        formState.name = { ...defaultValues, value: formState.name.value };
        formState.message = { ...defaultValues, value: formState.message.value };
      }
      const isNameValid = () => {
        return !!formState.name.value.trim();
      }
      const isEmailValid = () => {
        const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g
        return emailRegex.test(formState.email.value);
      }
      const isMessageValid = () => {
        return !!formState.message.value.trim();
      }

      resetValues();

      formState.name.isValid = isNameValid();
      if (!isNameValid()) formState.name.errorMessage = 'Name should not be empty';

      formState.email.isValid = isEmailValid();
      if (!isEmailValid()) formState.email.errorMessage = 'Email format is incorrect';

      formState.message.isValid = isMessageValid();
      if (!isMessageValid()) formState.message.errorMessage = 'Message should not be empty';

    }

    return { formState, validateForm }
  }
}

</script>

<template>
  <div>
    <div class="min-h-screen bg-primary-dark text-white px-3 min-w-screen md:px-10 lg:px-24">
      <Navbar class="w-full" />
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
            class="uppercase block underline underline-offset-8 decoration-accent-teal mt-10 text-body font-bold tracking-[2.29px]">
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
      <section class="mt-10">
        <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">Projects</h2>
        <ul class="flex flex-col gap-5 md:grid md:grid-cols-2 md:gap-3 md:gap-y-3 md:justify-between">
          <li v-for="i in 6" :key="i">
            <ProjectCard />
          </li>
        </ul>
      </section>
      <section id="contactForm"
        class="bg-dark-grey -mx-3 mt-20 md:-mx-10 px-3  py-10 md:px-40 lg:-mx-28 lg:flex lg:justify-between text-center lg:text-start lg:px-28 lg:gap-20 border-b border-white">
        <div class="lg:w-1/2">
          <h2 class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold leading-[4.5rem] tracking-[-0.028em] my-3">
            Contact</h2>
          <p class="leading-[1.625rem]">Have a project you think I would be a great fit for? Contact me by filling the
            form
            below, and I'll get back to you soon.</p>
        </div>
        <form class="flex flex-col gap-4 mt-6 caret-accent-teal flex-grow">
          <div class="flex flex-col">
            <input class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
              type="text" placeholder="NAME" :class="{ 'border-danger': !formState.name.isValid }"
              v-model="formState.name.value">
            <p class="text-danger text-end" v-if="!formState.name.isValid">{{ formState.name.errorMessage }}</p>
          </div>
          <div class="flex flex-col">
            <input
              class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal caret-accent-teal"
              :class="{ 'border-danger': !formState.email.isValid }" type="email" placeholder="EMAIL"
              v-model="formState.email.value">
            <p class="text-danger text-end" v-if="!formState.email.isValid">{{ formState.email.errorMessage }}</p>
          </div>
          <div class="flex flex-col">
            <textarea class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
              rows="4" placeholder="MESSAGE" :class="{ 'border-danger': !formState.message.isValid }"
              v-model="formState.message.value" />
            <p class="text-danger text-end" v-if="!formState.message.isValid">{{ formState.message.errorMessage }}</p>
          </div>
          <button type="button"
            class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
            @click.prevent="validateForm">SEND
            MESSAGE</button>
        </form>
      </section>
      <footer>
        <Navbar class="bg-dark-grey -mx-3 pt-6 px-3 md:-mx-10 md:px-10 lg:-mx-28 lg:px-28" />
      </footer>
    </div>
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
