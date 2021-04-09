# how to add Tailwind

- install packages
```bash
cd assets
npm install tailwindcss postcss autoprefixer postcss-loader@4.2 --save-dev
```
- create `postcss.config.js`:
```js
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  }
}
```
- in `assets/webpack.config.js` add `'postcss-loader',` in between `css-loader` and `sass-loader` so it looks like this:
```js
{
  test: /\.[s]?css$/,
  use: [
    MiniCssExtractPlugin.loader,
    'css-loader',
    'postcss-loader',
    'sass-loader',
  ],
}
```
- create tailwind config file
```bash
cd assets

npx tailwindcss init
```
- configure purge in tailwind config:
```js
purge: [
  '../lib/**/*.ex',
  '../lib/**/*.leex',
  '../lib/**/*.eex',
  './js/**/*.js'
],
```
- update deploy JS script in `package.json` to set NODE_ENV
```js
"deploy": "NODE_ENV=production webpack --mode production"
```
- add tailwind directives to `assets/css/app.scss`
```css
@tailwind base;

@tailwind components;

@tailwind utilities;
```