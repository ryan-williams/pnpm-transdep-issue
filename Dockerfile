FROM node:19.3.0
RUN npm install -g pnpm
WORKDIR src
COPY package.json .
# Use `npm` or `pnpm` to install dependencies
ARG npm=pnpm
RUN $npm install
# npm shows @deck.gl here, pnpm doesn't
RUN ls -l node_modules
COPY . .
RUN node_modules/.bin/tsc -p deckgl.json        # ✅ succeeds with npm and pnpm
RUN node_modules/.bin/tsc -p deckgl-react.json  # ⚠️  succeeds with npm, fails with pnpm: "Cannot find module '@deck.gl/react/typed'"
