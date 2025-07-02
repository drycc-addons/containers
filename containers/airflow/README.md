# Drycc package for Apache Airflow

## What is Apache Airflow?

> Apache Airflow is a tool to express and execute workflows as directed acyclic graphs (DAGs). It includes utilities to schedule tasks, monitor task progress and handle task dependencies.

[Overview of Apache Airflow](https://airflow.apache.org/)
Trademarks: This software listing is packaged by Drycc. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## TL;DR

### Docker Compose

```console
curl -LO https://raw.githubusercontent.com/drycc/containers/main/drycc/airflow/docker-compose.yml
docker-compose up
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Why use Drycc Images?

* Drycc closely tracks upstream source changes and promptly publishes new versions of this image using our automated systems.
* With Drycc images the latest bug fixes and features are available as soon as possible.
* Drycc containers, virtual machines and cloud images use the same components and configuration approach - making it easy to switch between formats based on your project needs.
* All our images are based on [**minideb**](https://github.com/drycc/minideb) -a minimalist Debian based container image that gives you a small base container image and the familiarity of a leading Linux distribution- or **scratch** -an explicitly empty image-.
* All Drycc images available in Docker Hub are signed with [Docker Content Trust (DCT)](https://docs.docker.com/engine/security/trust/content_trust/). You can use `DOCKER_CONTENT_TRUST=1` to verify the integrity of the images.
* Drycc container images are released on a regular basis with the latest distribution packages available.

Looking to use Apache Airflow in production? Try [VMware Tanzu Application Catalog](https://drycc.com/enterprise), the enterprise edition of Drycc Application Catalog.

## Supported tags and respective `Dockerfile` links

Learn more about the Drycc tagging policy and the difference between rolling tags and immutable tags [in our documentation page](https://docs.drycc.com/tutorials/understand-rolling-tags-containers/).

You can see the equivalence between the different tags by taking a look at the `tags-info.yaml` file present in the branch folder, i.e `drycc/ASSET/BRANCH/DISTRO/tags-info.yaml`.

Subscribe to project updates by watching the [drycc/containers GitHub repo](https://github.com/drycc/containers).

## Prerequisites

To run this application you need [Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`. [Docker Compose](https://docs.docker.com/compose/) is recommended with a version `1.6.0` or later.

## How to use this image

Airflow requires access to a PostgreSQL database to store information. We will use our very own [PostgreSQL image](https://github.com/drycc/containers/tree/main/drycc/postgresql) for the database requirements. Additionally, if you pretend to use the `CeleryExecutor`, you will also need an [Airflow Scheduler](https://github.com/drycc/containers/tree/main/drycc/airflow-scheduler), one or more [Airflow Workers](https://github.com/drycc/containers/tree/main/drycc/airflow-worker) and a [Redis(R) server](https://github.com/drycc/containers/tree/main/drycc/redis).

### Using Docker Compose

The main folder of this repository contains a functional [`docker-compose.yml`](https://github.com/drycc/containers/blob/main/drycc/airflow/docker-compose.yml) file. Run the application using it as shown below:

```console
curl -sSL https://raw.githubusercontent.com/drycc/containers/main/drycc/airflow/docker-compose.yml > docker-compose.yml
docker-compose up -d
```

### Using the Docker Command Line

If you want to run the application manually instead of using `docker-compose`, these are the basic steps you need to run:

1. Create a network

    ```console
    docker network create airflow-tier
    ```

2. Create a volume for PostgreSQL persistence and create a PostgreSQL container

    ```console
    docker volume create --name postgresql_data
    docker run -d --name postgresql \
      -e POSTGRESQL_USERNAME=bn_airflow \
      -e POSTGRESQL_PASSWORD=drycc1 \
      -e POSTGRESQL_DATABASE=drycc_airflow \
      --net airflow-tier \
      --volume postgresql_data:/drycc/postgresql \
      drycc/postgresql:latest
    ```

3. Create a volume for Redis(R) persistence and create a Redis(R) container

    ```console
    docker volume create --name redis_data
    docker run -d --name redis \
      -e ALLOW_EMPTY_PASSWORD=yes \
      --net airflow-tier \
      --volume redis_data:/drycc \
      drycc/redis:latest
    ```

4. Launch the Apache Airflow web container

    ```console
    docker run -d --name airflow -p 8080:8080 \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_PASSWORD=drycc123 \
      -e AIRFLOW_USERNAME=user \
      -e AIRFLOW_EMAIL=user@example.com \
      --net airflow-tier \
      drycc/airflow:latest
    ```

5. Launch the Apache Airflow scheduler container

    ```console
    docker run -d --name airflow-scheduler \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_WEBSERVER_HOST=airflow \
      --net airflow-tier \
      drycc/airflow-scheduler:latest
    ```

6. Launch the Apache Airflow worker container

    ```console
    docker run -d --name airflow-worker \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_WEBSERVER_HOST=airflow \
      --net airflow-tier \
      drycc/airflow-worker:latest
    ```

  Access your application at `http://your-ip:8080`

### Persisting your application

The Drycc Airflow container relies on the PostgreSQL database & Redis to persist the data. This means that Airflow does not persist anything. To avoid loss of data, you should mount volumes for persistence of [PostgreSQL data](https://github.com/drycc/containers/blob/main/drycc/mariadb#persisting-your-database) and [Redis(R) data](https://github.com/drycc/containers/blob/main/drycc/redis#persisting-your-database)

The above examples define docker volumes namely `postgresql_data`, and `redis_data`. The Airflow application state will persist as long as these volumes are not removed.

To avoid inadvertent removal of these volumes you can [mount host directories as data volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Alternatively you can make use of volume plugins to host the volume data.

#### Mount host directories as data volumes with Docker Compose

The following `docker-compose.yml` template demonstrates the use of host directories as data volumes.

```yaml
version: '2'
services:
  postgresql:
    image: 'drycc/postgresql:latest'
    environment:
      - POSTGRESQL_DATABASE=drycc_airflow
      - POSTGRESQL_USERNAME=bn_airflow
      - POSTGRESQL_PASSWORD=drycc1
    volumes:
      - /path/to/postgresql-persistence:/drycc/postgresql
  redis:
    image: 'drycc/redis:latest'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    volumes:
      - /path/to/redis-persistence:/drycc
  airflow-worker:
    image: drycc/airflow-worker:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=drycc_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=drycc1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow-scheduler:
    image: drycc/airflow-scheduler:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=drycc_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=drycc1
      - AIRFLOW_LOAD_EXAMPLES=yes
  airflow:
    image: drycc/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=drycc_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=drycc1
      - AIRFLOW_PASSWORD=drycc123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
    ports:
      - '8080:8080'
```

#### Mount host directories as data volumes using the Docker command line

1. Create a network (if it does not exist)

    ```console
    docker network create airflow-tier
    ```

2. Create the PostgreSQL container with host volumes

    ```console
    docker run -d --name postgresql \
      -e POSTGRESQL_USERNAME=bn_airflow \
      -e POSTGRESQL_PASSWORD=drycc1 \
      -e POSTGRESQL_DATABASE=drycc_airflow \
      --net airflow-tier \
      --volume /path/to/postgresql-persistence:/drycc \
      drycc/postgresql:latest
    ```

3. Create the Redis(R) container with host volumes

    ```console
    docker run -d --name redis \
      -e ALLOW_EMPTY_PASSWORD=yes \
      --net airflow-tier \
      --volume /path/to/redis-persistence:/drycc \
      drycc/redis:latest
    ```

4. Create the Airflow container

    ```console
    docker run -d --name airflow -p 8080:8080 \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_PASSWORD=drycc123 \
      -e AIRFLOW_USERNAME=user \
      -e AIRFLOW_EMAIL=user@example.com \
      --net airflow-tier \
      drycc/airflow:latest
    ```

5. Create the Airflow Scheduler container

    ```console
    docker run -d --name airflow-scheduler \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_LOAD_EXAMPLES=yes \
      -e AIRFLOW_WEBSERVER_HOST=airflow \
      --net airflow-tier \
      drycc/airflow-scheduler:latest
    ```

6. Create the Airflow Worker container

    ```console
    docker run -d --name airflow-worker \
      -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
      -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
      -e AIRFLOW_EXECUTOR=CeleryExecutor \
      -e AIRFLOW_DATABASE_NAME=drycc_airflow \
      -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
      -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
      -e AIRFLOW_WEBSERVER_HOST=airflow \
      --net airflow-tier \
      drycc/airflow-worker:latest
    ```

## Configuration

### Load DAG files

Custom DAG files can be mounted to `/opt/drycc/airflow/dags`.

### Installing additional python modules

This container supports the installation of additional python modules at start-up time. In order to do that, you can mount a `requirements.txt` file with your specific needs under the path `/drycc/python/requirements.txt`.

### Environment variables

The Airflow instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Airflow:

#### User configuration

* `AIRFLOW_USERNAME`: Airflow application username. Default: **user**
* `AIRFLOW_PASSWORD`: Airflow application password. Default: **drycc**
* `AIRFLOW_EMAIL`: Airflow application email. Default: **user@example.com**

#### Airflow configuration

* `AIRFLOW_EXECUTOR`: Airflow executor. Default: **SequentialExecutor**
* `AIRFLOW_FERNET_KEY`: Airflow Fernet key. No defaults.
* `AIRFLOW_SECRET_KEY`: Airflow Secret key. No defaults.
* `AIRFLOW_WEBSERVER_HOST`: Airflow webserver host. Default: **127.0.0.1**
* `AIRFLOW_WEBSERVER_PORT_NUMBER`: Airflow webserver port. Default: **8080**
* `AIRFLOW_LOAD_EXAMPLES`: To load example tasks into the application. Default: **yes**
* `AIRFLOW_BASE_URL`: Airflow webserver base URL. No defaults.
* `AIRFLOW_HOSTNAME_CALLABLE`: Method to obtain the hostname. No defaults.
* `AIRFLOW_POOL_NAME`: Pool name. No defaults.
* `AIRFLOW_POOL_SIZE`: Pool size, required with `AIRFLOW_POOL_NAME`. No defaults.
* `AIRFLOW_POOL_DESC`: Pool description, required with `AIRFLOW_POOL_NAME`. No defaults.

#### Use an existing database

* `AIRFLOW_DATABASE_HOST`: Hostname for PostgreSQL server. Default: **postgresql**
* `AIRFLOW_DATABASE_PORT_NUMBER`: Port used by PostgreSQL server. Default: **5432**
* `AIRFLOW_DATABASE_NAME`: Database name that Airflow will use to connect with the database. Default: **drycc_airflow**
* `AIRFLOW_DATABASE_USERNAME`: Database user that Airflow will use to connect with the database. Default: **bn_airflow**
* `AIRFLOW_DATABASE_PASSWORD`: Database password that Airflow will use to connect with the database. No defaults.
* `AIRFLOW_DATABASE_USE_SSL`: Set to yes if the database is using SSL. Default: **no**
* `AIRFLOW_CELERY_BROKER_URL`: Set to celery broker url. . No defaults.
* `AIRFLOW_CELERY_BROKER_TRANSPORT_OPTIONS`: Set to celery broker transport option. . No defaults.

#### Airflow LDAP authentication

* `AIRFLOW_LDAP_ENABLE`: Enable LDAP authentication. Default: **no**
* `AIRFLOW_LDAP_URI`: LDAP server URI. No defaults.
* `AIRFLOW_LDAP_SEARCH`: LDAP search base. No defaults.
* `AIRFLOW_LDAP_UID_FIELD`: LDAP field used for uid. No defaults.
* `AIRFLOW_LDAP_BIND_USER`: LDAP user name. No defaults.
* `AIRFLOW_LDAP_BIND_PASSWORD`: LDAP user password. No defaults.
* `AIRFLOW_USER_REGISTRATION`: User self registration. Default: **True**
* `AIRFLOW_USER_REGISTRATION_ROLE`: Role for the created user. No defaults.
* `AIRFLOW_LDAP_ROLES_MAPPING`: Mapping from LDAP DN to a list of Airflow roles. No defaults.
* `AIRFLOW_LDAP_ROLES_SYNC_AT_LOGIN`: Replace ALL the user's roles each login, or only on registration. Default: **True**
* `AIRFLOW_LDAP_USE_TLS`: Use LDAP SSL. Defaults: **False**.
* `AIRFLOW_LDAP_ALLOW_SELF_SIGNED`: Allow self signed certicates in LDAP ssl. Default: **True**
* `AIRFLOW_LDAP_TLS_CA_CERTIFICATE`: File that store the CA for LDAP ssl. No defaults.

> In addition to the previous environment variables, all the parameters from the configuration file can be overwritten by using environment variables with this format: `AIRFLOW__{SECTION}__{KEY}`. Note the double underscores.

#### Specifying Environment variables using Docker Compose

```yaml
version: '2'

services:
  airflow:
    image: drycc/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=drycc_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=drycc1
      - AIRFLOW_PASSWORD=drycc123
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@example.com
```

#### Specifying Environment variables on the Docker command line

```console
docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=drycc_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
    -e AIRFLOW_PASSWORD=drycc123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    drycc/airflow:latest
```

#### SMTP Configuration

To configure Airflow to send email using SMTP you can set the following environment variables:

* `AIRFLOW__SMTP__SMTP_HOST`: Host for outgoing SMTP email. Default: **localhost**
* `AIRFLOW__SMTP__SMTP_PORT`: Port for outgoing SMTP email. Default: **25**
* `AIRFLOW__SMTP__SMTP_STARTTLS`: To use TLS communication. Default: **True**
* `AIRFLOW__SMTP__SMTP_SSL`: To use SSL communication. Default: **False**
* `AIRFLOW__SMTP__SMTP_USER`: User of SMTP used for authentication (likely email). No defaults.
* `AIRFLOW__SMTP__SMTP_PASSWORD`: Password for SMTP. No defaults.
* `AIRFLOW__SMTP__SMTP_MAIL_FROM`: To modify the "from email address". Default: **airflow@example.com**

This would be an example of SMTP configuration using a GMail account:

* docker-compose (application part):

```yaml
  airflow:
    image: drycc/airflow:latest
    environment:
      - AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho=
      - AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08=
      - AIRFLOW_EXECUTOR=CeleryExecutor
      - AIRFLOW_DATABASE_NAME=drycc_airflow
      - AIRFLOW_DATABASE_USERNAME=bn_airflow
      - AIRFLOW_DATABASE_PASSWORD=drycc1
      - AIRFLOW_PASSWORD=drycc
      - AIRFLOW_USERNAME=user
      - AIRFLOW_EMAIL=user@email.com
      - AIRFLOW__SMTP__SMTP_HOST=smtp@gmail.com
      - AIRFLOW__SMTP__SMTP_USER=your_email@gmail.com
      - AIRFLOW__SMTP__SMTP_PASSWORD=your_password
      - AIRFLOW__SMTP__SMTP_PORT=587
    ports:
      - '8080:8080'
```

* For manual execution:

```console
docker run -d --name airflow -p 8080:8080 \
    -e AIRFLOW_FERNET_KEY=46BKJoQYlPPOexq0OhDZnIlNepKFf87WFwLbfzqDDho= \
    -e AIRFLOW_SECRET_KEY=a25mQ1FHTUh3MnFRSk5KMEIyVVU2YmN0VGRyYTVXY08= \
    -e AIRFLOW_EXECUTOR=CeleryExecutor \
    -e AIRFLOW_DATABASE_NAME=drycc_airflow \
    -e AIRFLOW_DATABASE_USERNAME=bn_airflow \
    -e AIRFLOW_DATABASE_PASSWORD=drycc1 \
    -e AIRFLOW_PASSWORD=drycc123 \
    -e AIRFLOW_USERNAME=user \
    -e AIRFLOW_EMAIL=user@example.com \
    -e AIRFLOW__SMTP__SMTP_HOST=smtp@gmail.com \
    -e AIRFLOW__SMTP__SMTP_USER=your_email@gmail.com \
    -e AIRFLOW__SMTP__SMTP_PASSWORD=your_password \
    -e AIRFLOW__SMTP__SMTP_PORT=587 \
    drycc/airflow:latest
```

## Notable Changes

### 1.10.15-debian-10-r17 and 2.0.1-debian-10-r50

* The size of the container image has been decreased.
* The configuration logic is now based on Bash scripts in the *rootfs/* folder.

## Contributing

We'd love for you to contribute to this Docker image. You can request new features by creating an [issue](https://github.com/drycc/containers/issues) or submitting a [pull request](https://github.com/drycc/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.

## License

Copyright &copy; 2023 VMware, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
