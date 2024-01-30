FROM node:19.3.0

# Set up project, install deck.gl
RUN npm install -g pnpm \
 && npx create-next-app test-app --ts --no-tailwind --no-eslint --no-app --use-pnpm --no-src-dir --import-alias '@/*'
WORKDIR test-app
RUN pnpm i deck.gl

# Prepend `import DeckGL from '@deck.gl/react/typed'` to pages/index.tsx
RUN echo "import DeckGL from '@deck.gl/react/typed'" > import.tsx \
 && cat pages/index.tsx >> import.tsx \
 && mv import.tsx pages/index.tsx

# ❌ Build fails:
# ```
# Type error: Cannot find module '@deck.gl/react/typed' or its corresponding type declarations.
# > 1 | import DeckGL from '@deck.gl/react/typed';
#     |                    ^
# ```
RUN npm run build
