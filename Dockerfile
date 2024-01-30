FROM node:19.3.0
RUN npm install -g pnpm
WORKDIR src
COPY package.json .
ARG npm=pnpm
RUN $npm install
COPY . .
RUN node_modules/.bin/tsc -p deckgl.json        # ✅ succeeds with npm and pnpm
RUN node_modules/.bin/tsc -p deckgl-react.json  # ⚠️  succeeds with npm, fails with pnpm: "Cannot find module '@deck.gl/react/typed'"
