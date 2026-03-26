import html from "eslint-plugin-html";

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
        window: "readonly",
        document: "readonly",
        console: "readonly",
        ethers: "readonly"
      }
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
      "no-console": "warn"
    }
  }
];
