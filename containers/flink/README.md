# Bitnami package for Apache Flink

## What is Apache Flink?

> Apache Flink is a framework and distributed processing engine for stateful computations over unbounded and bounded data streams.

[Overview of Apache Flink](https://flink.apache.org/)

This project has been forked from [bitnami-docker-redis-sentinel](https://github.com/bitnami/containers),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

```console
docker run --name flink registry.drycc.cc/drycc-addons/flink:latest
```

## Get this image

The recommended way to get the Bitnami flink Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/registry.drycc.cc/drycc-addons/flink).

```console
docker pull registry.drycc.cc/drycc-addons/flink:latest
```

To use a specific version, you can pull a versioned tag. You can view the(https://quay.io/repository/drycc-addons/flink?tab=tags) in the Container Image Registry.

in the Docker Hub Registry.

```console
docker pull registry.drycc.cc/drycc-addons/flink:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc-addons/containers.git
cd containers/APP/VERSION
docker build -t drycc-addons/APP:latest .
```

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Configuration

### Environment variables

#### Customizable environment variables

| Name                                      | Description                                      | Default Value                         |
|-------------------------------------------|--------------------------------------------------|---------------------------------------|
| `FLINK_MODE`                              | Flink default mode.                              | `jobmanager`                          |
| `FLINK_CFG_REST_PORT`                     | The port that the client connects to.            | `8081`                                |
| `FLINK_TASK_MANAGER_NUMBER_OF_TASK_SLOTS` | Number of task slots for taskmanager.            | `$(grep -c ^processor /proc/cpuinfo)` |
| `APACHE_FLINK_USERNAME`                   | Flink user to configure basic authentication     | `user`                                |
| `APACHE_FLINK_PASSWORD`                   | Flink password to configure basic authentication | `bitnami`                             |

#### Read-only environment variables

| Name                         | Description                                                                                                                 | Value                                                     |
|------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| `FLINK_BASE_DIR`             | Flink installation directory.                                                                                               | `${BITNAMI_ROOT_DIR}/flink`                               |
| `FLINK_BIN_DIR`              | Flink installation directory.                                                                                               | `${FLINK_BASE_DIR}/bin`                                   |
| `FLINK_WORK_DIR`             | Flink installation directory.                                                                                               | `${FLINK_BASE_DIR}`                                       |
| `FLINK_LOG_DIR`              | Flink log directory.                                                                                                        | `${FLINK_BASE_DIR}/log`                                   |
| `FLINK_CONF_DIR`             | Flink configuration directory.                                                                                              | `${FLINK_BASE_DIR}/conf`                                  |
| `FLINK_CONF_FILE`            | Flink configuration file name.                                                                                              | `flink-conf.yaml`                                         |
| `FLINK_CONF_FILE_PATH`       | Flink configuration file path.                                                                                              | `${FLINK_CONF_DIR}/${FLINK_CONF_FILE}`                    |
| `FLINK_VOLUME_DIR`           | Flink directory for mounted configuration files.                                                                            | `${BITNAMI_VOLUME_DIR}/flink`                             |
| `FLINK_DATA_TO_PERSIST`      | Files to persist relative to the Flink installation directory. To provide multiple values, separate them with a whitespace. | `conf plugins`                                            |
| `FLINK_DAEMON_USER`          | Flink daemon system user.                                                                                                   | `flink`                                                   |
| `FLINK_DAEMON_GROUP`         | Flink daemon system group.                                                                                                  | `flink`                                                   |
| `FLINK_PID_DIR`              | Default location for PID files                                                                                              | `${FLINK_BASE_DIR}/pid`                                   |
| `FLINK_JOBMANAGER_PID_FILE`  | PID file for flink-jobmanager service.                                                                                      | `${FLINK_PID_DIR}/flink-jobmanager-standalonesession.pid` |
| `FLINK_TASKMANAGER_PID_FILE` | PID file for flink-jobmanager service.                                                                                      | `${FLINK_PID_DIR}/flink-taskmanager-taskexecutor.pid`     |

### Running commands

To run commands inside this container you can use `docker run`. The default endpoint runs a Flink JobManager instance (jobmanager mode), while you can use the environment variable FLINK_MODE for run the image in a different mode:

Also, you can use the `help` Flink Mode in order to obtain an updated list of modes to run of different components instances

```console
docker run --rm -e FLINK_MODE=help --name flink registry.drycc.cc/drycc-addons/flink:latest
```

```console
$ Usage: FLINK_MODE=(jobmanager|standalone-job|taskmanager|history-server)

  By default, the Apache Flink Packaged by Bitnami  image will run in jobmanager mode.
  Also, by default, Apache Flink Packaged by Drycc image adopts jemalloc as default memory allocator. This behavior can be disabled by setting the 'DISABLE_JEMALLOC' environment variable to 'true'.
```

Check the [official Apache Flink documentation](https://flink.apache.org//docs) for more information.

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues), or submit a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)
