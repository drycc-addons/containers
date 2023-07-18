[![Build Status](https://woodpecker.drycc.cc/api/badges/drycc-addons/containers/status.svg)](https://woodpecker.drycc.cc/drycc-addons/containers)

# The Drycc Addons Containers Library

Popular applications, provided by [Drycc Addons](https://github.com/drycc-addons), containerized and ready to launch.

## Why use Drycc Addons Images?

* Drycc Addons closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Drycc Addons images the latest bug fixes and features are available as soon as possible.
* Drycc Addons containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [base](https://github.com/drycc/base) a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution.
* Drycc Addons container images are released on a regular basis with the latest distribution packages available.

Looking to use our applications in production? [Service Catalog](https://github.com/drycc-addons/service-catalog) lets you provision cloud services directly from the comfort of native Kubernetes tooling.

## Run the application using Docker Compose

The main folder of each application contains a functional `docker-compose.yml` file. Run the application using it as shown below:

```console
curl -sSL https://raw.githubusercontent.com/drycc-containers/containers/main/containers/APP/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

> Remember to replace the `APP` placeholder in the example command above with the correct value.

## Vulnerability scan in Drycc Addons container images

As part of the release process, the Drycc Addons container images are analyzed for vulnerabilities. At this moment, we are using two different tools:

* [Trivy](https://github.com/aquasecurity/trivy)
* [Grype](https://github.com/anchore/grype)

This scanning process is triggered via a GH action for every PR affecting the source code of the containers, regardless of its nature or origin.

## Contributing

We'd love for you to contribute to those container images. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues/new/choose), or submit a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.
