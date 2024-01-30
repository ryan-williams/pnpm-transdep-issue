# pnpm-deck.gl-issue
[`pnpm`] doesn't correctly install transitive dependencies:

```bash
docker build -t pnpm-deck.gl-issue --build-arg npm=npm  .  # ✅ works
docker build -t pnpm-deck.gl-issue --build-arg npm=pnpm .  # ❌ fails
```

See [Dockerfile](Dockerfile):
- deck.gl [depends on][deck.gl dep] @deck.gl/react
- `pnpm install deck.gl` fails to install `@deck.gl/react`
- `npm install deck.gl` works as expected (installs `@deck.gl/react`)

[`pnpm`]: https://pnpm.js.org/
[deck.gl dep]: https://unpkg.com/browse/deck.gl@8.9.34/package.json
