<script lang="ts">
import { reactive } from 'vue';
export default {
  setup() {
    const formState = reactive({
      email: { value: '', isValid: true, errorMessage: '' },
      name: { value: '', isValid: true, errorMessage: '' },
      message: { value: '', isValid: true, errorMessage: '' },
    });
    function validateForm() {
      const resetValues = () => {
        const defaultValues = { isValid: true, errorMessage: '' };
        formState.email = { ...defaultValues, value: formState.email.value };
        formState.name = { ...defaultValues, value: formState.name.value };
        formState.message = {
          ...defaultValues,
          value: formState.message.value,
        };
      };
      const isNameValid = () => {
        return !!formState.name.value.trim();
      };
      const isEmailValid = () => {
        const emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g;
        return emailRegex.test(formState.email.value);
      };
      const isMessageValid = () => {
        return !!formState.message.value.trim();
      };

      resetValues();

      formState.name.isValid = isNameValid();
      if (!isNameValid())
        formState.name.errorMessage = 'Name should not be empty';

      formState.email.isValid = isEmailValid();
      if (!isEmailValid())
        formState.email.errorMessage = 'Email format is incorrect';

      formState.message.isValid = isMessageValid();
      if (!isMessageValid())
        formState.message.errorMessage = 'Message should not be empty';
    }

    return { formState, validateForm };
  },
};
</script>

<template>
  <section
    id="contactForm"
    class="bg-dark-grey -mx-3 mt-20 md:-mx-10 px-3 py-10 md:px-40 lg:-mx-28 lg:flex lg:justify-between text-center lg:text-start lg:px-28 lg:gap-20 border-b border-white"
  >
    <div class="lg:w-1/2">
      <h2
        class="text-[2.5rem] md:text-[4.5rem] lg:text-xl font-bold leading-[4.5rem] tracking-[-0.028em] my-3"
      >
        Contact
      </h2>
      <p class="leading-[1.625rem]">
        Have a project you think I would be a great fit for? Contact me by
        filling the form below, and I'll get back to you soon.
      </p>
    </div>
    <form class="flex flex-col gap-4 mt-6 caret-accent-teal flex-grow">
      <div class="flex flex-col">
        <input
          v-model="formState.name.value"
          class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
          type="text"
          placeholder="NAME"
          :class="{ 'border-danger': !formState.name.isValid }"
        />
        />
        <p v-if="!formState.name.isValid" class="text-danger text-end">
          {{ formState.name.errorMessage }}
        </p>
      </div>
      <div class="flex flex-col">
        <input
          v-model="formState.email.value"
          class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal caret-accent-teal"
          :class="{ 'border-danger': !formState.email.isValid }"
          type="email"
          placeholder="EMAIL"
        />
        />
        <p v-if="!formState.email.isValid" class="text-danger text-end">
          {{ formState.email.errorMessage }}
        </p>
      </div>
      <div class="flex flex-col">
        <textarea
          v-model="formState.message.value"
          class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal"
          rows="4"
          placeholder="MESSAGE"
          :class="{ 'border-danger': !formState.message.isValid }"
        />
        />
        <p v-if="!formState.message.isValid" class="text-danger text-end">
          {{ formState.message.errorMessage }}
        </p>
      </div>
      <button
        type="button"
        class="self-end border-b border-accent-teal py-2 leading-[1.625rem] tracking-[0.14em] font-bold hover:text-accent-teal"
        @click.prevent="validateForm"
      >
        SEND MESSAGE
      </button>
    </form>
  </section>
</template>
