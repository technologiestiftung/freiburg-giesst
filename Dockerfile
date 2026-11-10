# Static build; VITE_* are read at runtime from /env.js (see docker/40-env.sh)
FROM node:24.21.0-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build -- --mode docker

FROM nginx:1.29-alpine
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --chmod=755 docker/40-env.sh /docker-entrypoint.d/40-env.sh
COPY --from=build /app/dist /usr/share/nginx/html
