# Drycc Object Storage based on Victoriametrics&reg;

## What is Drycc Object Storage based on Victoriametrics&reg;?

> VictoriaMetrics&reg; is an object storage server, compatible with Amazon S3 cloud storage service, mainly used for storing unstructured data (such as photos, videos, log files, etc.).

[Overview of Drycc Object Storage based on VictoriaMetrics&reg;](https://github.com/VictoriaMetrics/VictoriaMetrics)
Disclaimer: All software products, projects and company names are trademark(TM) or registered(R) trademarks of their respective holders, and use of them does not imply any affiliation or endorsement. This software is licensed to you subject to one or more open source licenses and Drycc provides the software on an AS-IS basis. Drycc is not affiliated, associated, authorized, endorsed by, or in any way officially connected with VictoriaMetrics. VictoriaMetrics is licensed under Apache 2.0.

## TL;DR

```console
docker run --name victoriametrics drycc-addons/victoriametrics:latest
```

### Docker Compose

```console
curl -sSL https://raw.githubusercontent.com/drycc-addons/containers/main/containers/victoriametrics/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

## Why use Drycc Images?

* Drycc closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Drycc images the latest bug fixes and features are available as soon as possible.
* Drycc containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [base](https://github.com/drycc/base) a minimalist Debian based container image which gives you a small base container image and the familiarity of a leading Linux distribution.
* Drycc container images are released on a regular basis with the latest distribution packages available.

## Get this image

The recommended way to get the Drycc VictoriaMetrics Docker Image is to pull the prebuilt image from the [Container Registry](https://registry.drycc.cc).

```console
docker pull registry.drycc.cc/drycc-addons/VictoriaMetrics:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc-addons/containers.git
cd drycc-addons/APP/VERSION/OPERATING-SYSTEM
docker build -t drycc-addons/APP:latest .
```

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues) or submitting a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new). For us to provide better support, be sure to include the following information in your issue:

* Host OS and version
* Docker version (`docker version`)
* Output of `docker info`
* Version of this container
* The command you used to run the container, and any relevant output you saw (masking any sensitive information)
