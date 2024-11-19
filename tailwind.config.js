/** @type {import('tailwindcss').Config} */
module.exports = {
  content: {
    // Always resolve paths in relation to the location of this `tailwind.config.js` file.
    // https://tailwindcss.com/docs/content-configuration#using-relative-paths
    relative: true,
    // Files which contain TailwindCSS classes
    // TODO: This should be relying on TEMPLATES_DIR from config.py
    files: [
      './templates/**/*.html',
    ],
  },
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}

