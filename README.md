# RegexHelp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Create a new release

```bash
./script/deploy
```

# Notes

## The asset pipeline
- The raw assets are owned by node and need to be compiled to `priv/static`.
- From there, they're digested by `mix phx.digest` and copied over to the release with `mix release`?