/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./layouts/**/*.html", "./content/**/*.md"],
    theme: {
        colors: {
            'accent': '#ff6b01',
        },
        extend: {
            typography: ({ theme }) => ({
                gray: {
                    css: {
                        '--tw-prose-invert-headings': theme('colors.accent'),
                    },
                },
            }),
        },
    },
    plugins: [
        require('@tailwindcss/typography'),
    ],
}

