/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class",
  content: ["layouts/**/*.html", "content/**/*.{html, md}"],

  theme: {
    extend: {
      colors: {
        transparent: "transparent",
        accent: "#FF572D",
        "dark-background": "#202630",
        "light-background": "#F5F5F5",
      },

      typography: (theme) => ({
        default: {
          css: {
            pre: {
              color: theme("colors.grey.1000"),
              backgroundColor: theme("colors.grey.100"),
            },
            "pre code::before": {
              "padding-left": "unset",
            },
            "pre code::after": {
              "padding-right": "unset",
            },
            code: {
              backgroundColor: theme("colors.grey.100"),
              color: "#DD1144",
              fontWeight: "400",
              "border-radius": "0.25rem",
            },
            "code::before": {
              content: '""',
              "padding-left": "0.25rem",
            },
            "code::after": {
              content: '""',
              "padding-right": "0.25rem",
            },
          },
        },
      }),
    },
  },

  plugins: [
      require('postcss-import'),
      require("@tailwindcss/typography")
  ],
};
