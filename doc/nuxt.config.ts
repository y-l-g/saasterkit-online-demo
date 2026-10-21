import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
  site: {
    url: "https://doc.saasterkit.com",
  },
  routeRules: {
    "/": { redirect: "/getting-started/introduction" },
  },
  content: {
    build: {
      markdown: {
        highlight: {
          theme: {
            default: "github-light",
            dark: "github-dark",
            sepia: "monokai",
          },
          langs: ["ts", "php", "vue"],
        },
      },
    },
  },
});
