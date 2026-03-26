import html from "eslint-plugin-html";

export default [
  {
    files: ["**/*.js", "**/*.html"],
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
        ethers: "readonly"   // since you use ethers.js
      }
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
      "no-console": "warn"
    }
  },
  {
    // This enables extraction of <script> tags from HTML files
    files: ["**/*.html"],
    processor: "html/html"
  }
];
