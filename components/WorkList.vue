<template>
  <ul>
    <h1 class="text-[2.5rem] text-center font-bold mb-3">Work Experience</h1>
    <li
      v-for="work in workExperiences"
      :key="work.id"
      class="border-2 border-accent-teal p-3 rounded-md mb-3"
    >
      <div class="flex justify-between">
        <h2 class="text-[2rem] font-bold">{{ work.companyName }}</h2>
        <p class=" italic ">
         (5 years) From {{ work.startDate }} to {{ work.isCurrentJob ? 'Present' : work.endDate }}
        </p>
      </div>
      <h3 class="text-[1.6rem]">{{ work.position }}</h3>
      <div>
        <span class="font-bold">Responsibilities:</span>
        <ul>
          <li v-for="responsibility in work.responsibilities"
            :key="responsibility"
            class="list-disc list-inside my-2"
          >
            {{ responsibility }}
          </li>
        </ul>
      </div>
      <h3 class="text-[1.6rem]">Technologies used:</h3>
      <ul class="flex flex-wrap gap-3">
        <li
          v-for="technology in work.techsUsed"
          :key="technology"
          class="border border-accent-teal rounded-md text-white font-bold rounded-md px-2 py-1 mr-2 mb-2"
        >
          {{ technology }}
        </li>
      </ul>
    </li>
  </ul>
</template>

<script setup lang="ts">
import { Work } from '~/utils/types';


const workExperiences: Work[] = [{
  id: '1',
  position: 'Fullstack Engineer',
  companyName: 'Raise Inc',
  companyLogoURL: '',
  companyWebsiteURL: '',
  startDate: '11th November 2018',
  isCurrentJob: true,
  endDate: '',
  description: '',
  responsibilities: [
    'Deployment of product through Continuous Integration using Fly.io/ Github and Google Cloud hence Increasing the rate of the dev team for pushing out features to production.',
    'Add Sentry on the platform which has improved the bug tracking of the platform reducing the resolution time of bugs by 60%.',
    'Add Stripe on the platform to help in managing payment by users, increasing the revenue of the company to 74%',
    'Add Growthbook for A/B testing of the platform to slowly release features to users, reducing new features bugs affecting users by 60%',
    'Involved in building the first version of the platform in Vue and Nodejs.',
    'Spearheading the migration of the platform from Vue to React/Remix and Golang for the backend.',
    'Involved in the discussion of new features with the product team giving my suggestion and estimation on delivery.',
    'Helping new engineers to onboard the codebase.',
  ],
  techsUsed: [
    'Vue', 'React', 'Nodejs', 'Golang', 'Postgres', 'Docker', 'Fly.io', 'Google Cloud', 'Stripe', 'Sentry', 'Growthbook'
  ]
}

]

</script>
