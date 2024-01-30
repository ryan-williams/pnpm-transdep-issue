# pnpm-transdep-issue
Repro: [pnpm] doesn't correctly install transitive dependencies:

```bash
build() {
    docker build --build-arg npm=$1 --build-arg "cache_nonce=`date`" -t pnpm-transdep-issue --progress=plain .
}
build npm   # ✅ works
build pnpm  # ❌ fails
```

See [Dockerfile](Dockerfile):
- deck.gl [depends on][deck.gl dep] @deck.gl/react
- `npm install deck.gl` works as expected (installs `@deck.gl/react`)
- `pnpm install deck.gl` fails to install `@deck.gl/react`
  - As a result, compiling [deckgl-react.ts](deckgl-react.ts) failes:
    ```
    Cannot find module '@deck.gl/react/typed' or its corresponding type declarations.
    ```

The `build` command also runs `ls -l node_modules`, and we see that the `npm` version includes `node_modules/@deck.gl/…` while the `pnpm` version doesn't.

[pnpm]: https://pnpm.js.org/
[deck.gl dep]: https://unpkg.com/browse/deck.gl@8.9.34/package.json
