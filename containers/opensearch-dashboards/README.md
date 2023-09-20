# OpenSearch Dashboards packaged by Drycc

## What is OpenSearch Dashboards?

> OpenSearch Dashboards is a visualization tool for OpenSearch installations. OpenSearch is a scalable open-source solution for search, analytics, and observability.

[Overview of OpenSearch Dashboards](https://opensearch.org/)
This project has been forked from [bitnami-containers](https://github.com/bitnami/containers),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run -it --name opensearch-dashboards registry.drycc.cc/drycc-addons/opensearch-dashboards
```

### Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/drycc-addons/containers/main/containers/opensearch-dashboards/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

## Get this image

The recommended way to get the Drycc OpenSearch Dashboards Docker Image is to pull the prebuilt image from the [Drycc Registry](https://quay.io/repository/drycc-addons).

```console
docker pull registry.drycc.cc/drycc-addons/opensearch-dashboards:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/opensearch?tab=tags) in the Container Image Registry.

```console
docker pull registry.drycc.cc/drycc-addons/opensearch-dashboards:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc/containers.git
cd drycc/APP/VERSION
docker build -t drycc/APP:latest .
```

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of OpenSearch Dashboards, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull registry.drycc.cc/drycc-addons/opensearch-dashboards:latest
```

or if you're using Docker Compose, update the value of the image property to `registry.drycc.cc/drycc-addons/opensearch-dashboards:latest`.

#### Step 2: Remove the currently running container

```console
docker rm -v opensearch-dashboards
```

or using Docker Compose:

```console
docker-compose rm -v opensearch-dashboards
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
docker run --name opensearch-dashboards registry.drycc.cc/drycc-addons/opensearch-dashboards:latest
```

or using Docker Compose:

```console
docker-compose up opensearch-dashboards
```

## Configuration

### Running commands

To run commands inside this container you can use `docker run`, for example to execute `opensearch-dashboards --help` you can follow the example below:

```console
docker run --rm --name opensearch-dashboards registry.drycc.cc/drycc-addons/opensearch-dashboards:latest --help
```

Check the [official OpenSearch Dashboards documentation](https://opensearch.org/docs/) for more information about how to use OpenSearch Dashboards.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues), or submit a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
