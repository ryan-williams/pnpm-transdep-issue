# pnpm-transdep-issue
Repro: [pnpm] doesn't correctly install transitive dependencies:

## Github Actions repro
See [this example run][GHA]:
- `npm` [succeeds][GHA npm]
- `pnpm` [fails][GHA pnpm] with error:
  ```
  deckgl-react.ts(1,20): error TS2307: Cannot find module '@deck.gl/react/typed' or its corresponding type declarations.
  ```

For some reason, `pnpm install deck.gl` fails to install [deck.gl's dependencies][deck.gl dep] (original discussion: [deck.gl#8456])

Also note that `node_modules/@deck.gl` [exists in the npm job][npm ls] but [not in the pnpm job][pnpm ls].

## Docker repro
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
[GHA]: https://github.com/ryan-williams/pnpm-transdep-issue/actions/runs/7706228027
[GHA npm]: https://github.com/ryan-williams/pnpm-transdep-issue/actions/runs/7706228027/job/21001441987
[GHA pnpm]: https://github.com/ryan-williams/pnpm-transdep-issue/actions/runs/7706228027/job/21001442089#step:9:5
[deck.gl#8456]: https://github.com/visgl/deck.gl/issues/8456
[npm ls]: https://github.com/ryan-williams/pnpm-transdep-issue/actions/runs/7706228027/job/21001441987#step:6:7
[pnpm ls]: https://github.com/ryan-williams/pnpm-transdep-issue/actions/runs/7706228027/job/21001442089#step:6:6
