import { defineNuxtConfig } from "nuxt/config";

export default defineNuxtConfig({
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
