# Fluent Bit packaged by Drycc

## What is Fluent Bit?

> Fluent Bit is a Fast and Lightweight Log Processor and Forwarder. It has been made with a strong focus on performance to allow the collection of events from different sources without complexity.

[Overview of Fluent Bit](http://fluentbit.io/)
Trademarks: This software listing is packaged by Drycc. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## Get this image

The recommended way to get the drycc-addons Fluent Bit Docker Image is to pull the prebuilt image from the [Drycc Registry](https://registry.drycc.cc).

```console
docker pull registry.drycc.cc/drycc-addons/fluentbit:canary
```

To use a specific version, you can pull a versioned tag.

```console
docker pull registry.drycc.cc/drycc-addons/fluentbit:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc-addons/containers
cd containers/APP/VERSION/OPERATING-SYSTEM
docker build -t registry.drycc.cc/drycc-addons
```

## Configuration

Fluent Bit is flexible enough to be configured either from the command line or through a configuration file. For production environments, Fluent Bit strongly recommends to use the configuration file approach.

[Configuration reference](http://fluentbit.io/documentation/)

## Plugins

Fluent Bit supports multiple extensions via plugins.

[Plugins reference](http://fluentbit.io/documentation/)

## Logging

The Drycc fluentbit Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs fluentbit
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues) or submitting a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.
