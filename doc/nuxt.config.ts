import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
  site: {
    url: "https://doc.saasterkit.y-l.fr",
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
