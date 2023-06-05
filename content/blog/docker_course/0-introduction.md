+++
title = "Introduction to Docker - Part 1"
date = "2023-05-25"
toc = true


[taxonomies]
tags = ["docker", "blog"]

[extra]
author = "mxmtr"

+++


# Key Concepts 🔑🧠

Wait, this is the millionth time I've seen an article with this title! 🤯📰

Yup, and just like any other article out there, it does note replace the [official documentation](https://docs.docker.com/get-started/overview/).

<br/>

**TLDR: In short, Docker deploys containers, and containers are great to package and deploy applications.**

<br/>

When we say *Docker*, we often refer to a set of platform as a service (PaaS) products developed by Docker, Inc. The core component responsible for hosting containers is called Docker Engine. Docker offers both free and premium tiers for its services. Some of Docker's products include:

- Docker Hub: Used for sharing containers. 📦
- Docker Engine: Enables building and running containers through a command-line interface (CLI). ⚙️💻
- Docker Desktop: Provides a graphical user interface (GUI) for building and running containers. 🖥️🐳

<br>

Before diving into the features offered by Docker products, let's review two main concepts:

- What is [Software Package Management](#software-package-management) 📦🔧
- What is [Containerization](#os-level-virtualization-containerization) 📦🚀

## Software Package Management

A software package management system is responsible for packaging and distributing applications. It allows you to build application packages, publish them in a remote repository, and download and install them. Some examples of package management systems include APT, npm, pip, Maven, as well as popular app stores like the Apple App Store and Google Play Store. Docker is primarily a software package management system. 📦💻

### Docker as a Package Management System

As a package manager, Docker offers features for building, installing, and publishing packages. Some key functions include:

- **Build**: Using commands like `docker build` to build container images. 🏗️🐳
- **Install**: Installing packages using commands like `docker build` or `docker pull`. 📥🐳
- **Publish**: Uploading packages to repositories using commands like `docker push`. 📤🐳
- **Runtime**: Running containers using commands like `docker run`, which allocates resources such as storage and network and controls the lifecycle of the application. ⏯️🐳

<br>

Docker serves as more than just a package management system, as it offers tools to also run your containers. 🐳📦🚀

<br>

Here is a comparison of features and commands of other package managers:

| Package manager                             | Pip               | Npm                        | Docker                          |
| ------------------------------------------- | ----------------- | -------------------------- | ------------------------------- |
| Build                                       | `python -m build` | `npm build`                | `docker build`                  |
| Install                                     | `pip install`     | `npm install`              | `docker build`<br>`docker pull` |
| Publish                                     | `twine upload`    | `npm publish`              | `docker push`                   |
| Run                                         | ❌                 | `npm serve`<br>`npm start` | `docker run`                    |
| Allocate resources (Storage, Network, etc.) | ❌                 | ❌                          | `docker run <options>`          |

### Docker Images 🐳📦

Docker packages (or images) adhere to the Open Container Initiative **(OCI) Image Format Specification**. This specification defines the standards for containers, describing their image format, runtime, and distribution. For more detailed information, refer to the OCI's official documentation. 📃🐳📦

<br>

**More info:**

- [https://opencontainers.org/about/overview/](https://opencontainers.org/about/overview/)
- [https://github.com/opencontainers/image-spec](https://github.com/opencontainers/image-spec)

### Docker Images and Registries 🐳📦🔍

Docker images can be obtained from Docker registries, which are servers responsible for distributing Docker images following the **OCI Distribution Specification**. Registries can be public or private, and you can even host your own registry. Some well-known public registries include docker.io, gcr.io, and quay.io. Docker provides documentation on how to work with registries. 🐳📦🔍🌐

<br>

**More info:**

- [https://docs.docker.com/registry/](https://docs.docker.com/registry/)
- [https://github.com/opencontainers/distribution-spec/blob/main/spec.md](https://github.com/opencontainers/distribution-spec/blob/main/spec.md)

### Containers vs Images 🐳📦🚀

In Docker, containers and images are key concepts:

- **Container**: A container is an application that runs within a Docker environment. It is created from a container image. 🐳🚀
- **Image**: An image is a package containing all the dependencies and configuration required to run an application. It serves as the basis for creating containers. 📦🐳
- **Container Registry**: A container registry is a repository for storing container images. It acts as a package management system for Docker.
- **Dockerfile**: A Dockerfile is a script that defines the steps to build a container image. It includes instructions for installing dependencies, configuring the environment, and running the application.

<br>

To get started with Docker, it's essential to understand these concepts and how they interact with each other.

<br>

**More info**: [https://docs.docker.com/get-started/overview](https://docs.docker.com/get-started/overview)

---

## OS-Level Virtualization (Containerization)

How to package and deliver an application? Managing the packaging and delivery of applications can become challenging as each application may require a unique set of dependencies to be installed. As the number of applications increases, this task becomes even more complex to handle effectively.

<br>

The [history of package management system](https://en.wikipedia.org/wiki/List_of_software_package_management_systems) is quite long, but in the end everyone understood that **isolating apps and their dependencies** from one another was the way to go. This isolation can be performed using [virtualization](https://en.wikipedia.org/wiki/Timeline_of_virtualization_development).

<br>

*Containerization* is the term employed to describe the isolation of applications at the kernel level, using *namespaces* and *cgroups* (Released in 2008, developed by Google since 2006, docker was created in 2013).

<br>

In short:

- *cgroups* determine how much of the host resources your application can use,
- *namespaces* segregate the host resources you can use.

### Why do I need containers?

Let's take the following example of a stack, where your app consists of three services:

- Each of them depends on libraries,
- Each library has dependencies with the OS,
- Your OS has some dependencies on your underlying infrastructure...

<br/>

Can you imagine what managing these dependencies would cost?!! 🤯 This dependency matrix is also known as the 🔥 **matrix from hell** 🔥

<br/>

To make this easier, containers <span style="color: red;">(in red)</span> allow us to make sure that **dependencies are shipped with our app**! It reduces the risk of breaking everything down when upgrading our services.

{{ show_figures(paths=["blog/docker_course/containerization_container.png"], legends=["Dependencies of a stack. In red, a container"]) }}

To sum things up, in the past we used to deliver apps using a *breakbulk cargo* mentality: each app was manually carried and placed on the ship, and we had to spend a lot of time and energy to prevent the apps from collapsing each time an app was upgraded.

<br/>

Now, containers allow us to install our apps on cargo ships using container runtimes, without having to worry too much about the other applications dependencies.

{{ show_figures(paths=["blog/docker_course/containerization_breakbulk_cargo.png", "blog/docker_course/containerization_cargo_ship.jpg"], legends=["Engineers shipping their applications, circa 1912", "Applications shipped with standardized containers, today"]) }}

### Why should I use container when I have virtual machines?

We don't want to start another war with the *VMs vs containers* debate: both guarantee a certain level of isolation between apps. 📦🆚🐳

<br/>

However, with VMs you get a few cons ❌:

- Bigger files: Virtualization or emulation can result in larger file sizes. 📁📈
- Longer boot time: It takes more time to start up virtualized or emulated environments. ⏳⬆️
- More runtime overhead: Virtualization or emulation uses more memory and CPU resources. 🖥️⚡

<br/>

But also a few pros ✅:

- Virtualization solves the hardware and/or OS compatibility issues: you can run software on different CPU architectures, Operating Systems, or even on another kernel version. 🛠️✅
- More isolation: Virtualization or emulation provides extra layers, which brings more security according to the [Swiss cheese model](https://en.wikipedia.org/wiki/Swiss_cheese_model). 🔒🔁

<br/>

{{ show_figures(paths=["blog/docker_course/containerization_vms.png"], legends=[""]) }}

**As a conclusion: containers are smaller, faster, and easier to interface with one another.**

## Docker glossary

Docker uses a lot of new words to describe its components!

Here are the few objects that Docker can manage:

- **Container images**: a file containing your application and its metadata.
- **Dockerfile**: a script to package your applications and create container images.
- **Container Registry**: where you will store container images.
- **Container**: an application started from a container image.
- **Docker Host**: the computer running the containers.

{{ show_figures(paths=["blog/docker_course/docker_architecture.svg"], legends=["Docker products architecture"]) }}

Here are some parts of the Docker products:

- **Docker daemon**: the container runtime that manages containers for you.
- **Docker client**: Client that talks to the Docker daemon.
- **Docker engine**: Docker client + Docker daemon.

<br>

These docker products implement some open standards:

- **Container runtime**: Server that implements the OCI Runtime specification.
- **OCI Runtime Specification**: standard implemented by container runtimes.
- **OCI**: Open Container Initiative, a consortium to standardize container technologies.

<br>

**It means that Docker is not the only product that can help you build, distribute and run container images: as long as your product supports the OCI standards, you should be fine.**

<br>

More info:

- [Runtime specifications](https://github.com/opencontainers/runtime-spec)
- [Open Containers Initiative website](https://opencontainers.org/about/overview/)
