/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: [
    "./themes/**/layouts/**/*.html",
    "./themes/**/content/**/*.html",
    "./layouts/**/*.html",
    "./content/**/*.{html, md}",
  ],

  purge: {
		enabled: process.env.HUGO_ENVIRONMENT === 'production',
  },

  theme: {
    extend: {
      colors: {
        transparent: "transparent",
        accent: "#FF572D",
        "dark-background": "#202630",
        "light-background": "#F5F5F5"
      },
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
