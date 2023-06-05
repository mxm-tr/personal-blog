+++
title = "Introduction to Docker - Part 2"
date = "2023-06-05"
toc = true
draft = true


[taxonomies]
tags = ["docker", "blog"]

[extra]
author = "mxmtr"
+++

# 🕹️ Play with Docker

In the previous part, we introduced some general concepts. In this one, we are going to practice a bit!

## Exercise 1: Get Docker

Let’s start with installing the Docker engine: 🔧

[Get Docker Installation Guide](https://docs.docker.com/engine/install/)

Check that it is installed correctly by running: ⚙️

```bash
docker run docker/whalesay cowsay boo
```

**What happens?** 🤔

Docker pulls the image from docker.io by default. 🐳

- Images are composed of layers. 🖼️
- Images are indexed by their tag (default latest), and have their signature, just like layers do! 🔖

## Exercise 2: Follow the official tutorial - Part 1

Install git (you should have it already!) 📥

Clone the repository: 📋

```bash
git clone https://github.com/docker/getting-started
```

Build and run the image: 🏗️

```bash
docker build -t docker101tutorial .
docker run -d -p 80:80 --name docker-tutorial docker101tutorial
```

Visit [http://localhost:80](http://localhost:80) 🌐

**Build: What happens?** 🧱

The build context is initialized.

Base images are pulled from Docker Hub.

```bash
docker build -t docker101tutorial .
```

[+] Building 18.7s (27/27) FINISHED

**Build: What happens?** 🧱

What does the `.dockerignore` file contain?

Run `docker images` and `docker ps` and see what it returns.

What is the tag of the image `docker101tutorial`?

What happens if I run the build command again?

What happens if I edit a requirements file and run the build command again?

The `-t` option specifies the image name and its tag:

```bash
docker build <context-path> -t <image-name>:<image-tag>
```

## Exercise 2: Follow the official tutorial - Part 2

Configure your IDE to highlight the Dockerfile syntax.

Create a `Dockerfile` in `app/`.

Build the image with the tag `getting-started:v0.1`, run it, and visit [http://localhost:3000](http://localhost:3000).

Create an item.

In the `src/static/js/app.js` file, update line 56.

Build the image again, run it again!

You may have to stop an already running container, use `docker ps` and `docker stop` to get it done!

... Wait, did we lose the item we added before? 😞

## Exercise 2: Follow the official tutorial - Part 3

**Docker cheat sheet - Container management** 📝

[More info](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

**Docker cheat sheet - Image management** 📝

[More info](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

## Building images - How it works 🐳

A Docker image is built up from a series of layers. Each layer represents an instruction in the image's Dockerfile. In this example, the following instructions create new layers:

- `WORKDIR`, `COPY`, and `RUN`
  
While the following instructions only affect image metadata:

- `CMD` and `EXPOSE`

Here's an example Dockerfile:

```Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
```

The resulting image will have the following layers:

1. `dc923cea9549`
2. `2a440eaba1d4`
3. `86b094789a6b`
4. `8e32fdda8502`

With corresponding labels:

- 🏷️ `node:18-alpine`
- 🏷️ `getting-started:v0.1`

You can check the image size using the command:

```bash
docker image ls
```

To view the build history and layer sizes, you can use the following command:

```bash
docker history getting-started:v0.1
```

To inspect the image metadata, you can use the `docker inspect` command. For example:

```bash
docker inspect docker.io/library/node:18-alpine > layer0.json
docker inspect getting-started:v0.1 > layer1.json
```

To compare the differences between the layers, you can use the `diff` command. For example:

```bash
diff -y layer0.json layer1.json
```

## Playing with Image Layers

Docker uses [UnionFS](https://en.wikipedia.org/wiki/UnionFS) storage drivers, with the default being `overlay2`. An image layer consists of three layers:

1. 🔒 Base layer or lowerdir (Read Only)
2. 🆕 Overlay layer or workdir (New files)
3. 🔄 Diff layer or upperdir (Changes in Base layer)

When mounting the layer, these layers are merged together.

You can create and manipulate image layers without Dockerfiles. For example:

```bash
docker run -it --name ugly-build alpine:latest
touch newfile
exit
docker diff ugly-build
docker commit ugly-build ugly-image:v0.1
```

You can also build an image with a large file inside and remove it in subsequent layers:

```bash
docker run -it --name ugly-build alpine:latest
fallocate -l 1000000000 newfile
ls -lh newfile
exit
docker commit ugly-build ugly-image:v0.1
docker run -it --name ugly-build-v2 ugly-image:v0.1
rm newfile
exit
docker commit ugly-build-v2 ugly-image:v0.2
```

**It means that removed files remain in the underlying layers! :alert: Removing files in a new layer won't make your image smaller! :alert:**

## Share Images with Registries

### Remote registry

You can share your Docker images with registries like Docker Hub. To push an image, you need to log in and use a token or username/password credentials.

To push an image to a private repository:

```bash
docker login docker.io
docker push <repository>:<tag>
```

### Local registry

If you don't want to use an external registry, you can also host your own! Multiple options exist, in this example we will deploy a small implementation of a registry: <https://github.com/docker/distribution-library-image>.

```bash
docker run -d -p 5000:5000 --name registry registry:2
docker pull ubuntu
docker image tag ubuntu localhost:5000/myfirstimage
docker push localhost:5000/myfirstimage
```

Voilà, you have a running registry!

<br>

Take a look inside the registry to see the image layers that have been pushed:

```bash
docker exec -it registry find /var/lib/registry/docker/registry/
```

All good? Now stop your registry and remove all data:

```bash
docker container stop registry && docker container rm -v registry
```

## Understand a complex multi-stage build

Take another look at the Dockerfile at <https://github.com/docker/getting-started>.

Try to draw an image dependency tree looking at the FROM instructions.

Example:

```Dockerfile
python:alpine AS base
base AS build
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
RUN mkdocs build
```

**Exercise 8: Build a ReactJS app**

Create a new React app.
More info at <https://reactjs.org/docs/create-a-new-react-app.html>.

Build a Docker image for this app, try to make it:

- Build faster; and
- The smallest possible.

```bash
npx create-react-app project_name
```

Done 🎉

Congrats, this first part is over! You should have learned:

- What is a container, what is a Docker image.
- What is a layer and how the build cache works.
- How to work with Docker registries.
- How to make multi-stage builds make images smaller.

Most details about concepts in this course can be found here:
[https://docs.docker.com/build/building/packaging/](https://docs.docker.com/build/building/packaging/).

---
