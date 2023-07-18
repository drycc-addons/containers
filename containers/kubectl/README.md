# Kubectl packaged by Bitnami

## What is Kubectl?

> Kubectl is the Kubernetes command line interface. It allows to manage Kubernetes cluster by providing a wide set of commands that allows to communicate with the Kubernetes API in a friendly way.

[Overview of Kubectl](https://github.com/kubernetes/kubectl)

This project has been forked from [bitnami-docker-kubectl](https://github.com/bitnami/bitnami-docker-kubectl),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Drycc. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or [Container Image Registry](https://quay.io/repository/drycc-addons/kubectl)

endorsement.

## TL;DR

```console
$ docker run --name kubectl quay.io/drycc-addons/kubectl:latest
```

## Get this image

The recommended way to get the Drycc Kubectl Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/kubectl).

```console
$ docker pull quay.io/drycc-addons/kubectl:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/drycc-addons/kubectl/tags/) in the Docker Hub Registry.

```console
$ docker pull quay.io/drycc-addons/kubectl:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t quay.io/drycc-addons/kubectl:latest 'https://github.com/drycc-addons/drycc-docker-kubectl.git#main1.24/debian'
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `kubectl version` you can follow the example below:

```console
$ docker run --rm --name kubectl quay.io/drycc-addons/kubectl:latest version
```

Consult the [Kubectl Reference Documentation](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands) to find the completed list of commands available.

### Loading your own configuration

It's possible to load your own configuration, which is useful if you want to connect to a remote cluster:

```console
$ docker run --rm --name kubectl -v /path/to/your/kube/config:/.kube/config quay.io/drycc-addons/kubectl:latest
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/drycc-docker-kubectl/issues), or submit a [pull request](https://github.com/drycc-addons/drycc-docker-kubectl/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/drycc-docker-kubectl/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

