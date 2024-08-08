/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./templates/*.hbs"
  ],
  theme: {
    extend: {
      fontFamily: {
        body: '"Open Sans", sans-serif',
        mono: '"Roboto Mono", monospace'
      },
      colors: {
        black: '#2b2d42',
        white: '#edf2f4',
        on: '#8d99ae'
      }
    },
  },
  plugins: [],
}

