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

The recommended way to get the Drycc OpenSearch Dashboards Docker Image is to pull the prebuilt image from the [Container Registry](https://quay.io/repository/drycc-addons).

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

### Environment variables

#### Customizable environment variables

| Name                                                     | Description                                                                                     | Default Value                                                   |
|----------------------------------------------------------|-------------------------------------------------------------------------------------------------|-----------------------------------------------------------------|
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_URL`                   | Opensearch URL. Provide Client node url in the case of a cluster                                | `opensearch`                                                    |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_PORT_NUMBER`           | Elasticsearch port                                                                              | `9200`                                                          |
| `OPENSEARCH_DASHBOARDS_HOST`                             | Opensearch Dashboards host                                                                      | `0.0.0.0`                                                       |
| `OPENSEARCH_DASHBOARDS_PORT_NUMBER`                      | Opensearch Dashboards port                                                                      | `5601`                                                          |
| `OPENSEARCH_DASHBOARDS_WAIT_READY_MAX_RETRIES`           | Max retries to wait for Opensearch Dashboards to be ready                                       | `30`                                                            |
| `OPENSEARCH_DASHBOARDS_INITSCRIPTS_START_SERVER`         | Whether to start the Opensearch Dashboards server before executing the init scripts             | `yes`                                                           |
| `OPENSEARCH_DASHBOARDS_FORCE_INITSCRIPTS`                | Whether to force the execution of the init scripts                                              | `no`                                                            |
| `OPENSEARCH_DASHBOARDS_DISABLE_STRICT_CSP`               | Disable strict Content Security Policy (CSP) for Opensearch Dashboards                          | `no`                                                            |
| `OPENSEARCH_DASHBOARDS_CERTS_DIR`                        | Path to certificates folder.                                                                    | `${SERVER_CONF_DIR}/certs`                                      |
| `OPENSEARCH_DASHBOARDS_SERVER_ENABLE_TLS`                | Enable TLS for inbound connections via HTTPS.                                                   | `false`                                                         |
| `OPENSEARCH_DASHBOARDS_SERVER_KEYSTORE_LOCATION`         | Path to Keystore                                                                                | `${SERVER_CERTS_DIR}/server/opensearch-dashboards.keystore.p12` |
| `OPENSEARCH_DASHBOARDS_SERVER_KEYSTORE_PASSWORD`         | Password for the Opensearch keystore containing the certificates or password-protected PEM key. | `nil`                                                           |
| `OPENSEARCH_DASHBOARDS_SERVER_TLS_USE_PEM`               | Configure Opensearch Dashboards server TLS settings using PEM certificates.                     | `false`                                                         |
| `OPENSEARCH_DASHBOARDS_SERVER_CERT_LOCATION`             | Path to PEM node certificate.                                                                   | `${SERVER_CERTS_DIR}/server/tls.crt`                            |
| `OPENSEARCH_DASHBOARDS_SERVER_KEY_LOCATION`              | Path to PEM node key.                                                                           | `${SERVER_CERTS_DIR}/server/tls.key`                            |
| `OPENSEARCH_DASHBOARDS_SERVER_KEY_PASSWORD`              | Password for the Opensearch node PEM key.                                                       | `nil`                                                           |
| `OPENSEARCH_DASHBOARDS_PASSWORD`                         | Opensearch Dashboards password.                                                                 | `nil`                                                           |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_ENABLE_TLS`            | Enable TLS for Opensearch communications.                                                       | `false`                                                         |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_TLS_VERIFICATION_MODE` | Opensearch TLS verification mode.                                                               | `full`                                                          |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_TRUSTSTORE_LOCATION`   | Path to Opensearch Truststore.                                                                  | `${SERVER_CERTS_DIR}/opensearch/opensearch.truststore.p12`      |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_TRUSTSTORE_PASSWORD`   | Password for the Opensearch truststore.                                                         | `nil`                                                           |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_TLS_USE_PEM`           | Configure Opensearch TLS settings using PEM certificates.                                       | `false`                                                         |
| `OPENSEARCH_DASHBOARDS_OPENSEARCH_CA_CERT_LOCATION`      | Path to Opensearch CA certificate.                                                              | `${SERVER_CERTS_DIR}/opensearch/ca.crt`                         |

#### Read-only environment variables

| Name                                        | Description                                                                                   | Value                                          |
|---------------------------------------------|-----------------------------------------------------------------------------------------------|------------------------------------------------|
| `SERVER_FLAVOR`                             | Server flavor. Valid values: `kibana` or `opensearch-dashboards`.                             | `opensearch-dashboards`                        |
| `DRYCC_VOLUME_DIR`                        | Directory where to mount volumes                                                              | `/drycc`                                     |
| `OPENSEARCH_DASHBOARDS_VOLUME_DIR`          | Opensearch Dashboards persistence directory                                                   | `${DRYCC_VOLUME_DIR}/opensearch-dashboards`  |
| `OPENSEARCH_DASHBOARDS_BASE_DIR`            | Opensearch Dashboards installation directory                                                  | `${DRYCC_ROOT_DIR}/opensearch-dashboards`    |
| `OPENSEARCH_DASHBOARDS_CONF_DIR`            | Opensearch Dashboards configuration directory                                                 | `${SERVER_BASE_DIR}/config`                    |
| `OPENSEARCH_DASHBOARDS_DEFAULT_CONF_DIR`    | Opensearch Dashboards default configuration directory                                         | `${SERVER_BASE_DIR}/config.default`            |
| `OPENSEARCH_DASHBOARDS_LOGS_DIR`            | Opensearch Dashboards logs directory                                                          | `${SERVER_BASE_DIR}/logs`                      |
| `OPENSEARCH_DASHBOARDS_TMP_DIR`             | Opensearch Dashboards temporary directory                                                     | `${SERVER_BASE_DIR}/tmp`                       |
| `OPENSEARCH_DASHBOARDS_BIN_DIR`             | Opensearch Dashboards executable directory                                                    | `${SERVER_BASE_DIR}/bin`                       |
| `OPENSEARCH_DASHBOARDS_PLUGINS_DIR`         | Opensearch Dashboards plugins directory                                                       | `${SERVER_BASE_DIR}/plugins`                   |
| `OPENSEARCH_DASHBOARDS_DEFAULT_PLUGINS_DIR` | Opensearch Dashboards default plugins directory                                               | `${SERVER_BASE_DIR}/plugins.default`           |
| `OPENSEARCH_DASHBOARDS_DATA_DIR`            | Opensearch Dashboards data directory                                                          | `${SERVER_VOLUME_DIR}/data`                    |
| `OPENSEARCH_DASHBOARDS_MOUNTED_CONF_DIR`    | Directory for including custom configuration files (that override the default generated ones) | `${SERVER_VOLUME_DIR}/conf`                    |
| `OPENSEARCH_DASHBOARDS_CONF_FILE`           | Path to Opensearch Dashboards configuration file                                              | `${SERVER_CONF_DIR}/opensearch_dashboards.yml` |
| `OPENSEARCH_DASHBOARDS_LOG_FILE`            | Path to the Opensearch Dashboards log file                                                    | `${SERVER_LOGS_DIR}/opensearch-dashboards.log` |
| `OPENSEARCH_DASHBOARDS_PID_FILE`            | Path to the Opensearch Dashboards pid file                                                    | `${SERVER_TMP_DIR}/opensearch-dashboards.pid`  |
| `OPENSEARCH_DASHBOARDS_INITSCRIPTS_DIR`     | Path to the Opensearch Dashboards container init scripts directory                            | `/docker-entrypoint-initdb.d`                  |
| `OPENSEARCH_DASHBOARDS_DAEMON_USER`         | Opensearch Dashboards system user                                                             | `opensearch-dashboards`                        |
| `OPENSEARCH_DASHBOARDS_DAEMON_GROUP`        | Opensearch Dashboards system group                                                            | `opensearch-dashboards`                        |

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
