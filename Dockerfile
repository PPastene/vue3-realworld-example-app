FROM node:lts-alpine AS base

WORKDIR /client

COPY package.json .

RUN yarn install

COPY . .

EXPOSE 3000

FROM base AS development-stage

CMD yarn dev --host

FROM base AS build-stage

RUN yarn build

FROM nginx:stable-alpine AS production-stage

COPY --from=build-stage /client/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]