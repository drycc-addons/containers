# Drycc Object Storage Client based on MinIO&reg;

## What is Drycc Object Storage Client based on MinIO&reg;?

> MinIO&reg; Client is a Golang CLI tool that offers alternatives for ls, cp, mkdir, diff, and rsync commands for filesystems and object storage systems.

[Overview of Drycc Object Storage Client based on MinIO&reg;](https://min.io/)

This project has been forked from [bitnami-docker-minio-client](https://github.com/bitnami/bitnami-docker-minio-client),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Disclaimer: All software products, projects and company names are trademark(TM) or registered(R) trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and VMware provides the software on an AS-IS basis. MinIO(R) is a registered trademark of the MinIO, Inc in the US and other countries. Bitnami is not affiliated, associated, authorized, endorsed by, or in any way officially connected with MinIO Inc. MinIO(R) is licensed under GNU AGPL v3.0.

## TL;DR

```console
$ docker run --name minio-client quay.io/drycc-addons/minio-client:latest
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/drycc-addons/containers/main/containers/minio-client/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```
## Get this image

The recommended way to get the Drycc MinIO(R) Client Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/minio-client).

```console
$ docker pull quay.io/drycc-addons/minio-client:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/minio-client?tab=tags) in the Container Image Registry.

```console
$ docker pull quay.io/drycc-addons/minio-client:[TAG]
```

If you wish, you can also build the image yourself.

```console
$ docker build --build-arg="CODENAME=bookworm" -t quay.io/drycc-addons/minio-client 'https://github.com/drycc-addons/containers.git#main:containers/minio-client/2023'
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a MinIO(R) Client can be used to access other running containers such as [MinIO(R) server](https://github.com/drycc-addons/containers/tree/main/containers/minio).

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a MinIO(R) Client container that will connect to a MinIO(R) server container that is running on the same docker network.

#### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

#### Step 2: Launch the MinIO(R) server container

Use the `--network app-tier` argument to the `docker run` command to attach the MinIO(R) container to the `app-tier` network.

```console
$ docker run -d --name minio-server \
    --env MINIO_ROOT_USER="minio-root-user" \
    --env MINIO_ROOT_PASSWORD="minio-root-password" \
    --network app-tier \
    quay.io/drycc-addons/minio:latest
```

#### Step 3: Launch your MinIO(R) Client container

Finally we create a new container instance to launch the MinIO(R) client and connect to the server created in the previous step. In this example, we create a new bucket in the MinIO(R) storage server:

```console
$ docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="minio-server" \
    --env MINIO_SERVER_ACCESS_KEY="minio-root-user" \
    --env MINIO_SERVER_SECRET_KEY="minio-root-password" \
    --network app-tier \
    quay.io/drycc-addons/minio-client \
    mb minio/my-bucket
```

## Configuration

MinIO(R) Client (`mc`) can be setup so it is already configured to point to a specific MinIO(R) server by providing the environment variables below:

- `MINIO_SERVER_HOST`: MinIO(R) server host.
- `MINIO_SERVER_PORT_NUMBER`: MinIO(R) server port. Default: `9000`.
- `MINIO_SERVER_SCHEME`: MinIO(R) server scheme. Default: `http`.
- `MINIO_SERVER_ACCESS_KEY`: MinIO(R) server Access Key. Must be common on every node.
- `MINIO_SERVER_SECRET_KEY`: MinIO(R) server Secret Key. Must be common on every node.

For instance, use the command below to create a new bucket in the MinIO(R) Server `my.minio.domain`:

```console
$ docker run --rm --name minio-client \
    --env MINIO_SERVER_HOST="my.minio.domain" \
    --env MINIO_SERVER_ACCESS_KEY="minio-access-key" \
    --env MINIO_SERVER_SECRET_KEY="minio-secret-key" \
    quay.io/drycc-addons/minio-client \
    mb minio/my-bucket
```

Find more information about the client configuration in the [MinIO(R) Client documentation](https://docs.min.io/docs/minio-admin-complete-guide.html).

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues), or submit a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
