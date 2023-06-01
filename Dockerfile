FROM ghcr.io/getzola/zola:v0.17.2 as zola

FROM debian:bullseye-slim as builder
COPY --from=zola /bin/zola /bin/zola
WORKDIR /site
COPY . /site
RUN zola build

FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=builder /site/public/ /usr/share/nginx/html/
EXPOSE 80