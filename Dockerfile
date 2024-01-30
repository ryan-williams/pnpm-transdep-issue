FROM node:19.3.0
RUN npm install -g pnpm typescript
WORKDIR src
COPY package.json .
# Use `npm` or `pnpm` to install dependencies
ARG npm=pnpm
RUN $npm install
# `npm` shows a @deck.gl subdir here, `pnpm` doesn't
RUN ls -l node_modules
COPY . .
RUN tsc --skipLibCheck deckgl.ts        # ✅ succeeds with npm and pnpm
RUN tsc --skipLibCheck deckgl-react.ts  # ⚠️  succeeds with npm, fails with pnpm: "Cannot find module '@deck.gl/>
