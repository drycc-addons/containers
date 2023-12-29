# Bitnami package for Git

## What is Git?

> Git is an open source distributed version control system that can handle both small and large projects with speed and efficiency.

[Overview of Git](https://git-scm.com/)
This project has been forked from [bitnami-containers](https://github.com/bitnami/containers),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Drycc. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name git registry.drycc.cc/drycc-addons/git:latest
```

## Get this image

The recommended way to get the Git Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/git).


```console
docker pull registry.drycc.cc/drycc-addons/git:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/git?tab=tags) in the Container image Registry.

```console
docker pull registry.drycc.cc/drycc-addons/git:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build --build-arg="CODENAME=bookworm" -t quay.io/drycc-addons/git 'https://github.com/drycc-addons/containers.git#main:containers/git/2'
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `git version` you can follow below example

```console
docker run --name git registry.drycc.cc/drycc-addons:latest git --version
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues), or submit a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)