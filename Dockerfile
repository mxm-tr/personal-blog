FROM ghcr.io/getzola/zola:v0.17.2 as zola

FROM node:20-bullseye as builder
COPY --from=zola /bin/zola /bin/zola
RUN npm install sass -g
WORKDIR /site
COPY . /site
RUN zola build && sass ./sass/main.scss ./public/assets/css/main.css

FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=builder /site/public/ /usr/share/nginx/html/
EXPOSE 80