# JMX Exporter packaged by Bitnami

## What is JMX Exporter?

> A process for exposing JMX Beans via HTTP for Prometheus consumption.

[Overview of JMX Exporter](https://github.com/prometheus/jmx_exporter)

This project has been forked from [bitnami-docker-jmx-exporter](https://github.com/bitnami/bitnami-docker-jmx-exporter),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
$ docker run --name jmx-exporter quay.io/drycc-addons/jmx-exporter
```

## Get this image

The recommended way to get the Bitnami JMX Exporter Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/jmx-exporter).

```console
$ docker pull quay.io/drycc-addons/jmx-exporter
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/jmx-exporter?tab=tags) in the Container Image Registry.

```console
$ docker pull quay.io/drycc-addons/jmx-exporter:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build -t quay.io/drycc-addons/jmx-exporter 'https://github.com/bitnami/bitnami-docker-jmx-exporter.git#main:0.17.0/debian'
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create jmx-exporter-network --driver bridge
```

#### Step 2: Launch the jmx-exporter container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `jmx-exporter-network` network.

```console
$ docker run --name jmx-exporter-node1 --network jmx-exporter-network quay.io/drycc-addons/jmx-exporter
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

Find all the configuration options in the [JMX Prometheus Exporter documentation](https://github.com/prometheus/jmx_exporter#configuration).

## Logging

The Bitnami JMX Exporter Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs jmx-exporter
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of JMX Exporter, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull quay.io/drycc-addons/jmx-exporter
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop jmx-exporter
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v jmx-exporter
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name jmx-exporter quay.io/drycc-addons/jmx-exporter
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/drycc-docker-jmx-exporter/issues), or submit a [pull request](https://github.com/drycc-addons/drycc-docker-jmx-exporter/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/drycc-docker-jmx-exporter/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
