import html from "eslint-plugin-html";
import globals from "globals";

export default [
  {
    files: ["web/index.html"],
    plugins: {
      html: html
    },
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.browser,
        ethers: "readonly",
        CONFIG: "readonly"
      }
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
      "no-console": "warn"
    }
  },
  {
    files: ["web/**/*.js"],

    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.browser,
        ethers: "readonly",
        CONFIG: "readonly"
      }
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
    }

  }
];
