module.exports = {
  mode: 'jit',
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    '../lib/**/*.heex',
    './js/**/*.js'
  ],
  theme: {},
  variants: {},
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
