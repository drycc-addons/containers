# Apache Spark packaged by Bitnami

## What is Apache Spark?

> Apache Spark is a high-performance engine for large-scale computing tasks, such as data processing, machine learning and real-time data streaming. It includes APIs for Java, Python, Scala and R.

[Overview of Apache Spark](https://spark.apache.org/)

This project has been forked from [bitnami-docker-redis-sentinel](https://github.com/bitnami/containers),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Trademarks: This software listing is packaged by Bitnami. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Docker Compose

```console
curl -LO https://raw.githubusercontent.com/drycc-addons/containers/main/containers/spark/docker-compose.yml
docker-compose up
```

You can find the available configuration options in the [Environment Variables](#environment-variables) section.

## How to deploy Apache Spark in Kubernetes?

Deploying Drycc applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Drycc Apache Spark Chart GitHub repository](https://github.com/drycc-addons/addons/tree/main/addons/spark).

Bitnami containers can be used with [Kubeapps](https://kubeapps.dev/) for deployment and management of Helm Charts in clusters.

## Why use a non-root container?

Non-root container images add an extra layer of security and are generally recommended for production environments. However, because they run as a non-root user, privileged tasks are typically off-limits. Learn more about non-root containers [in our docs](https://docs.bitnami.com/tutorials/work-with-non-root-containers/).

## Get this image

The recommended way to get the Bitnami Apache Spark Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/drycc).

```console
docker pull registry.drycc.cc/drycc-addons/spark:latest
```

To use a specific version, you can pull a versioned tag. You can view the(https://quay.io/repository/drycc-addons/zookeeper?tab=tags) in the Container Image Registry.

in the Docker Hub Registry.

```console
docker pull registry.drycc.cc/drycc-addons/spark:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc-addons/containers.git
cd containers/APP/VERSION
docker build -t drycc-addons/APP:latest .
```

## Configuration

### Environment variables

When you start the spark image, you can adjust the configuration of the instance by passing one or more environment variables either on the docker-compose file or on the `docker run` command line. If you want to add a new environment variable:

* For docker-compose add the variable name and value under the application section in the [`docker-compose.yml`](https://github.com/drycc-addons/containers/blob/main/drycc-addons/spark/docker-compose.yml) file present in this repository:

```yaml
spark:
  ...
  environment:
    - SPARK_MODE=master
  ...
```

* For manual execution add a -e option with each variable and value:

```console
docker run -d --name spark \
  --network=spark_network \
  -e SPARK_MODE=master \
  registry.drycc.cc/drycc-addons/spark
```

Available variables:

* SPARK_MODE: Cluster mode starting Apache Spark. Valid values: *master*, *worker*. Default: **master**
* SPARK_MASTER_URL: Url where the worker can find the master. Only needed when spark mode is *worker*. Default: **spark://spark-master:7077**
* SPARK_RPC_AUTHENTICATION_ENABLED: Enable RPC authentication. Default: **no**
* SPARK_RPC_AUTHENTICATION_SECRET: The secret key used for RPC authentication. No defaults.
* SPARK_RPC_ENCRYPTION_ENABLED: Enable RPC encryption. Default: **no**
* SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED: Enable local storage encryption: Default **no**
* SPARK_SSL_ENABLED: Enable SSL configuration. Default: **no**
* SPARK_SSL_KEY_PASSWORD: The password to the private key in the key store. No defaults.
* SPARK_SSL_KEYSTORE_FILE: Location of the key store. Default: **/opt/drycc/spark/conf/certs/spark-keystore.jks**.
* SPARK_SSL_KEYSTORE_PASSWORD: The password for the key store. No defaults.
* SPARK_SSL_TRUSTSTORE_PASSWORD: The password for the trust store. No defaults.
* SPARK_SSL_TRUSTSTORE_FILE: Location of the key store. Default: **/opt/drycc/spark/conf/certs/spark-truststore.jks**.
* SPARK_SSL_NEED_CLIENT_AUTH: Whether to require client authentication. Default: **yes**
* SPARK_SSL_PROTOCOL: TLS protocol to use. Default: **TLSv1.2**
* SPARK_DAEMON_USER: Apache Spark system user when the container is started as root. Default: **spark**
* SPARK_DAEMON_GROUP: Apache Spark system group when the container is started as root. Default: **spark**

More environment variables natively supported by Apache Spark can be found [at the official documentation](https://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts).
For example, you could still use `SPARK_WORKER_CORES` or `SPARK_WORKER_MEMORY` to configure the number of cores and the amount of memory to be used by a worker machine.

### Security

The Bitnani Apache Spark docker image supports enabling RPC authentication, RPC encryption and local storage encryption easily using the following env vars in all the nodes of the cluster.

```diff
+ SPARK_RPC_AUTHENTICATION_ENABLED=yes
+ SPARK_RPC_AUTHENTICATION_SECRET=RPC_AUTHENTICATION_SECRET
+ SPARK_RPC_ENCRYPTION=yes
+ SPARK_LOCAL_STORAGE_ENCRYPTION=yes
```

> Please note that `RPC_AUTHENTICATION_SECRET` is a placeholder that needs to be updated with a correct value.
> Be also aware that currently is not possible to submit an application to a standalone cluster if RPC authentication is configured. More info about the issue [here](https://issues.apache.org/jira/browse/SPARK-25078).

Additionally, SSL configuration can be easily activated following the next steps:

1. Enable SSL configuration by setting the following env vars:

    ```diff
    + SPARK_SSL_ENABLED=yes
    + SPARK_SSL_KEY_PASSWORD=KEY_PASSWORD
    + SPARK_SSL_KEYSTORE_PASSWORD=KEYSTORE_PASSWORD
    + SPARK_SSL_TRUSTSTORE_PASSWORD=TRUSTSTORE_PASSWORD
    + SPARK_SSL_NEED_CLIENT_AUTH=yes
    + SPARK_SSL_PROTOCOL=TLSv1.2
    ```

    > Please note that `KEY_PASSWORD`, `KEYSTORE_PASSWORD`, and `TRUSTSTORE_PASSWORD` are placeholders that needs to be updated with a correct value.

2. You need to mount your spark keystore and truststore files to `/opt/drycc/spark/conf/certs`. Please note they should be called `spark-keystore.jks` and `spark-truststore.jks` and they should be in JKS format.

### Setting up an Apache Spark Cluster

A Apache Spark cluster can easily be setup with the default docker-compose.yml file from the root of this repo. The docker-compose includes two different services, `spark-master` and `spark-worker.`

By default, when you deploy the docker-compose file you will get an Apache Spark cluster with 1 master and 1 worker.

If you want N workers, all you need to do is start the docker-compose deployment with the following command:

```console
docker-compose up --scale spark-worker=3
```

### Mount a custom configuration file

The image looks for configuration in the `conf/` directory of `/opt/drycc/spark`.

#### Using docker-compose

```yaml
...
volumes:
  - /path/to/spark-defaults.conf:/opt/drycc/spark/conf/spark-defaults.conf
...
```

#### Using the command line

```console
docker run --name spark -v /path/to/spark-defaults.conf:/opt/drycc/spark/conf/spark-defaults.conf registry.drycc.cc/drycc-addons/spark:latest
```

After that, your changes will be taken into account in the server's behaviour.

### Installing additional jars

By default, this container bundles a generic set of jar files but the default image can be extended to add as many jars as needed for your specific use case. For instance, the following Dockerfile adds [`aws-java-sdk-bundle-1.11.704.jar`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-bundle/1.11.704):

```Dockerfile
FROM registry.drycc.cc/drycc-addons/spark
USER 1001
RUN curl https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.704/aws-java-sdk-bundle-1.11.704.jar --output /opt/drycc/spark/jars/aws-java-sdk-bundle-1.11.704.jar
```

#### Using a different version of Hadoop jars

In a similar way that in the previous section, you may want to use a different version of Hadoop jars.

Go to <https://spark.apache.org/downloads.html> and copy the download url bundling the Hadoop version you want and matching the Apache Spark version of the container. Extend the Bitnami container image as below:

```Dockerfile
FROM FROM registry.drycc.cc/drycc-addons/spark:3.0.0

USER 1001
RUN rm -r /opt/drycc/spark/jars && \
    curl --location http://mirror.cc.columbia.edu/pub/software/apache/spark/spark-3.0.0/spark-3.0.0-bin-hadoop2.7.tgz | \
    tar --extract --gzip --strip=1 --directory /opt/drycc/spark/ spark-3.0.0-bin-hadoop2.7/jars/
```

You can check the Hadoop version by running the following commands in the new container image:

```console
$ pyspark
>>> sc._gateway.jvm.org.apache.hadoop.util.VersionInfo.getVersion()
'2.7.4'
```

## Logging

The Bitnami Apache Spark Docker image sends the container logs to the `stdout`. To view the logs:

```console
docker logs spark
```

or using Docker Compose:

```console
docker-compose logs spark
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Backing up your container

To backup your data, configuration and logs, follow these simple steps:

#### Step 1: Stop the currently running container

```console
docker stop spark
```

or using Docker Compose:

```console
docker-compose stop spark
```

#### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```console
docker run --rm -v /path/to/spark-backups:/backups --volumes-from spark busybox \
  cp -a /bitnami/drycc /backups/latest
```

or using Docker Compose:

```console
docker run --rm -v /path/to/spark-backups:/backups --volumes-from `docker-compose ps -q spark` busybox \
  cp -a /bitnami/drycc /backups/latest
```

### Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```console
docker run -v /path/to/spark-backups/latest:/drycc/drycc registry.drycc.cc/drycc-addons/spark:latest
```

or by modifying the [`docker-compose.yml`](https://github.com/drycc-addons/containers/blob/main/containers/spark/docker-compose.yml) file present in this repository:

```yaml
services:
  spark:
  ...
    volumes:
      - /path/to/spark-backups/latest:/drycc/drycc
  ...
```

### Upgrade this image

Bitnami provides up-to-date versions of spark, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
docker pull registry.drycc.cc/drycc-addons/spark:latest
```

or if you're using Docker Compose, update the value of the image property to
`registry.drycc.cc/drycc-addons/spark:latest`.

#### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's data, configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

#### Step 3: Remove the currently running container

```console
docker rm -v spark
```

or using Docker Compose:

```console
docker-compose rm -v spark
```

#### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```console
docker run --name spark registry.drycc.cc/drycc-addons/spark:latest
```

or using Docker Compose:

```console
docker-compose up spark
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
