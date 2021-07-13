# Development Workspace

[![Development Workspace CI](https://github.com/cragonnyunt/development-workspace/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/cragonnyunt/development-workspace/actions/workflows/main.yml)

Development Workspace Docker is the base image of docker built for developers. It contains the most used tools that every developers needed, and well prepared for comfortable development environment.

Base image
- [phusion/baseimage:focal-1.0.0](https://hub.docker.com/r/phusion/baseimage)

Set of tools installed
- 7z
- git
- [cheat](https://github.com/cheat/cheat)
- ping
- mysql-client
- htop
- [tmux](https://github.com/tmux/tmux)
- zsh
- [ag](https://github.com/ggreer/the_silver_searcher)
- vim

## Pulling the image

```
docker pull cragonnyunt/development-docker
```

## Running the image

```
docker run --rm -it \
    -v $(pwd):/workspace \
    cragonnyunt/development-docker
```

## Building the image from source

First clone this repository and run
```
docker build -t <image-name> .
```

The docker uses tmux as screen multiplexer and zsh as default shell. The `devuser` is the default user for the `Development Workspace` docker and has default user id of `1000` and group id of `1000`. You can change the default values when you manually build the docker image.

```
docker build -t <image-name> \
    --build-arg TZ=$TZ \
    --build-arg UID=$UID \
    --build-arg GID=$GID \
    --build-arg LANG=$LANG \
    --build-arg WORKSPACE_USER=$WORKSPACE_USER \
    .
```

## Further works

The docker image is built for the base image of workspace dockers. For more specific tools and sets of dockers based on this, please look at the list below.

- [PHP Workspace Docker](https://github.com/cragonnyunt/php-workspace)
- [Nodejs Workspace Docker](https://github.com/cragonnyunt/nodejs-workspace)
- [Python Workspace Docker](https://github.com/cragonnyunt/python-workspace)
- [Java Workspace Docker](https://github.com/cragonnyunt/java-workspace)
