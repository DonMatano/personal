<template>
  <div class="text-body">
    <h2 
      class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold my-8">
      Create Project
    </h2>

    <form class="flex flex-col gap-4">
      <input  type="text" placeholder="Project Name" class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"/>
      <textarea row="10" maxlength="250" placeholder="Quick project description" class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <div class="flex flex-col">
      <Editor />
      <ImageUploader />
      </div>
      <input type="text" placeholder="Techs Used" class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
          <button type="button"
            class="self-end border-b border-accent-teal py-2  leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
            >CREATE</button>
    </form>
  </div>
</template>
