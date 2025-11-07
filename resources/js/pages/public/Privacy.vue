<script setup lang="ts">
import PublicLayout from '@/layouts/PublicLayout.vue';

defineProps<{ content: string }>();

useSeoMeta({
    title: 'Privacy',
    description: 'Privacy page of Saasterkit',
});
</script>

<template>
    <PublicLayout>
        <UContainer class="my-20 prose max-w-3xl dark:prose-invert"
            ><div v-html="content"></div
        ></UContainer>
    </PublicLayout>
</template>
