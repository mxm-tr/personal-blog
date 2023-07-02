
# Personal blog

## Prerequisites

Install Sass

https://sass-lang.com/install/

## Run the app

Build

```bash
docker run -u "$(id -u):$(id -g)" -v $PWD:/app --workdir /app ghcr.io/getzola/zola:v0.17.2 build
```

Dev

```bash
docker run -u "$(id -u):$(id -g)" -v $PWD:/app --workdir /app -p 8080:8080 -p 1024:1024 ghcr.io/getzola/zola:v0.17.2 serve --interface 0.0.0.0 --port 8080 --base-url localhost
sass -w ./sass/main.scss ./public/assets/css/main.css
```
