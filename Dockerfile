FROM node:22 AS build

WORKDIR /opt/node_app

COPY . .
ARG \
    NODE_ENV=production \
    YARN_CACHE_FOLDER=/root/.yarn

# do not ignore optional dependencies:
# Error: Cannot find module @rollup/rollup-linux-x64-gnu
RUN yarn --network-timeout 600000


RUN --mount=type=cache,target=/root/.yarn yarn build:app:docker

FROM nginx:1.31-alpine

COPY --from=build /opt/node_app/excalidraw-app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
