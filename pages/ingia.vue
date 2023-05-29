<template>
  <div v-if="!isSignedIn" class="min-h-screen">
    <form class="flex flex-col">
      <input type="email" placeholder="email" v-model="email"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <input type="password" placeholder="password" v-model="password"
        class="bg-transparent border-b border-white py-3 px-4 outline-none focus:border-accent-teal" />
      <button type="button" @click.prevent="login">Login</button>
    </form>
    <p class="text-red-500">{{ invalidError }}</p>
    <p v-if="showSuccess" class="text-green-500">Successfully Signed in</p>
  </div>
  <button v-else @click.prevent="signout">
    Sign out
  </button>
</template>

<script setup lang="ts">
import { ref } from 'vue';
const client = useSupabaseAuthClient();
const user = useSupabaseUser();

const isSignedIn = !!user.value;


const email = ref('');
const password = ref('');
const invalidError = ref('');
const showSuccess = ref(false);

async function login() {
  if (!email.value || !password.value) {
    invalidError.value = 'Please enter email and password';
    return;
  }
  const {error} = await client.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  });
  if (error) {
    invalidError.value = error.message;
    return;
  }
  showSuccess.value = true;
  setTimeout(() => {
    navigateTo('/')
  }, 3000);
}

async function signout() {
  await client.auth.signOut();
  navigateTo('/');
}

</script>
