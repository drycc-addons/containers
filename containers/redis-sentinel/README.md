# Redis&trade; Sentinel packaged by Bitnami

## What is Redis&trade; Sentinel?

> Redis&trade; Sentinel provides high availability for Redis. Redis Sentinel also provides other collateral tasks such as monitoring, notifications and acts as a configuration provider for clients.

[Overview of Redis&trade; Sentinel](http://redis.io/)

This project has been forked from [bitnami-docker-redis-sentinel](https://github.com/bitnami/bitnami-docker-redis-sentinel),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 

Disclaimer: Redis is a registered trademark of Redis Labs Ltd. Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

## TL;DR

```console
$ docker run --name redis-sentinel -e REDIS_MASTER_HOST=redis quay.io/drycc-addons/redis-sentinel:[TAG]
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/drycc-addons/containers/main/containers/redis-sentinel/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

**Warning**: This quick setup is only intended for development environments. You are encouraged to change the insecure default credentials and check out the available configuration options in the [Environment Variables](#environment-variables) section for a more secure deployment.

## Get this image

The recommended way to get the Drycc Redis(TM) Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/redis-sentinel).

```console
$ docker pull quay.io/drycc-addons/redis-sentinel:[TAG]
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/redis-sentinel?tab=tags) in the Container Image Registry.

```console
$ docker pull quay.io/drycc-addons/redis-sentinel:[TAG]
```

If you wish, you can also build the image yourself.

```console

```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a Redis(TM) server running inside a container can easily be accessed by your application containers.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

In this example, we will create a Redis(TM) Sentinel instance that will monitor a Redis(TM) instance that is running on the same docker network.

#### Step 1: Create a network

```console
$ docker network create app-tier --driver bridge
```

#### Step 2: Launch the Redis(TM) instance

Use the `--network app-tier` argument to the `docker run` command to attach the Redis(TM) container to the `app-tier` network.

```console
$ docker run -d --name redis-server \
    -e ALLOW_EMPTY_PASSWORD=yes \
    --network app-tier \
    quay.io/drycc-addons/redis-sentinel:[TAG]
```

#### Step 3: Launch your Redis(TM) Sentinel instance

Finally we create a new container instance to launch the Redis(TM) client and connect to the server created in the previous step:

```console
$ docker run -it --rm \
    -e REDIS_MASTER_HOST=redis-server \
    --network app-tier \
    quay.io/drycc-addons/redis-sentinel:[TAG]
```

### Using Docker Compose

When not specified, Docker Compose automatically sets up a new network and attaches all deployed services to that network. However, we will explicitly define a new `bridge` network named `app-tier`. In this example we assume that you want to connect to the Redis(TM) server from your own custom application image which is identified in the following snippet by the service name `myapp`.

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  redis:
    image: 'quay.io/drycc-addons/redis-sentinel:[TAG]'
    environment:
      - ALLOW_EMPTY_PASSWORD=yes
    networks:
      - app-tier
  redis-sentinel:
    image: 'quay.io/drycc-addons/redis-sentinel:[TAG]'
    environment:
      - REDIS_MASTER_HOST=redis
    ports:
      - '26379:26379'
    networks:
      - app-tier
```

Launch the containers using:

```console
$ docker-compose up -d
```

#### Using Master-Slave setups

When using Sentinel in Master-Slave setup, if you want to set the passwords for Master and Slave nodes, consider having the **same** `REDIS_PASSWORD` and `REDIS_MASTER_PASSWORD` for them ([#23](https://github.com/bitnami/bitnami-docker-redis-sentinel/issues/23)).

```yaml
version: '2'

networks:
  app-tier:
    driver: bridge

services:
  redis:
    image: 'quay.io/drycc-addons/redis-sentinel:[TAG]'
    environment:
      - REDIS_REPLICATION_MODE=master
      - REDIS_PASSWORD=str0ng_passw0rd
    networks:
      - app-tier
    ports:
      - '6379'
  redis-slave:
    image: 'quay.io/drycc-addons/redis-sentinel:[TAG]'
    environment:
      - REDIS_REPLICATION_MODE=slave
      - REDIS_MASTER_HOST=redis
      - REDIS_MASTER_PASSWORD=str0ng_passw0rd
      - REDIS_PASSWORD=str0ng_passw0rd
    ports:
      - '6379'
    depends_on:
      - redis
    networks:
      - app-tier
  redis-sentinel:
    image: 'quay.io/drycc-addons/redis-sentinel:[TAG]'
    environment:
      - REDIS_MASTER_PASSWORD=str0ng_passw0rd
    depends_on:
      - redis
      - redis-slave
    ports:
      - '26379-26381:26379'
    networks:
      - app-tier
```

Launch the containers using:

```console
$ docker-compose up --scale redis-sentinel=3 -d
```

## Configuration

### Environment variables

The Redis(TM) Sentinel instance can be customized by specifying environment variables on the first run. The following environment values are provided to customize Redis(TM) Sentinel:

- `REDIS_MASTER_HOST`: Host of the Redis(TM) master to monitor. Default: **redis**.
- `REDIS_MASTER_PORT_NUMBER`: Port of the Redis(TM) master to monitor. Default: **6379**.
- `REDIS_MASTER_SET`: Name of the set of Redis(TM) instances to monitor. Default: **mymaster**.
- `REDIS_MASTER_PASSWORD`: Password to authenticate with the master. No defaults. As an alternative, you can mount a file with the password and set the `REDIS_MASTER_PASSWORD_FILE` variable.
- `REDIS_MASTER_USER`: Username to authenticate with when ACL is enabled for the master. No defaults. This is available only for Redis(TM) 6 or higher. If not specified, Redis(TM) Sentinel will try to authenticate with just the password (using `sentinel auth-pass <master-name> <password>`).
- `REDIS_SENTINEL_PORT_NUMBER`: Redis(TM) Sentinel port. Default: **26379**.
- `REDIS_SENTINEL_QUORUM`: Number of Sentinels that need to agree about the fact the master is not reachable. Default: **2**.
- `REDIS_SENTINEL_PASSWORD`: Password to authenticate with this sentinel and to authenticate to other sentinels. No defaults. Needs to be identical on all sentinels. As an alternative, you can mount a file with the password and set the `REDIS_SENTINEL_PASSWORD_FILE` variable.
- `REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS`: Number of milliseconds before master is declared down. Default: **60000**.
- `REDIS_SENTINEL_FAILOVER_TIMEOUT`: Specifies the failover timeout in milliseconds. Default: **180000**.
- `REDIS_SENTINEL_RESOLVE_HOSTNAMES`: Enables sentinel hostnames support. This is available only for Redis(TM) 6.2 or higher.  Default: **no**.
- `REDIS_SENTINEL_TLS_ENABLED`: Whether to enable TLS for traffic or not. Default: **no**.
- `REDIS_SENTINEL_TLS_PORT_NUMBER`: Port used for TLS secure traffic. Default: **26379**.
- `REDIS_SENTINEL_TLS_CERT_FILE`: File containing the certificate file for the TLS traffic. No defaults.
- `REDIS_SENTINEL_TLS_KEY_FILE`: File containing the key for certificate. No defaults.
- `REDIS_SENTINEL_TLS_CA_FILE`: File containing the CA of the certificate. No defaults.
- `REDIS_SENTINEL_TLS_DH_PARAMS_FILE`: File containing DH params (in order to support DH based ciphers). No defaults.
- `REDIS_SENTINEL_TLS_AUTH_CLIENTS`: Whether to require clients to authenticate or not. Default: **yes**.
- `REDIS_SENTINEL_ANNOUNCE_IP`: Use the specified IP address in the HELLO messages used to gossip its presence. Default: **auto-detected local address**.
- `REDIS_SENTINEL_ANNOUNCE_PORT`: Use the specified port in the HELLO messages used to gossip its presence. Default: **port specified in `REDIS_SENTINEL_PORT_NUMBER`**.

### Securing Redis(TM) Sentinel traffic

Starting with version 6, Redis(TM) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_SENTINEL_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_SENTINEL_PORT_NUMBER` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis-sentinel \
        -v /path/to/certs:/opt/drycc/redis/certs \
        -v /path/to/redis-sentinel/persistence:/drycc \
        -e REDIS_MASTER_HOST=redis \
        -e REDIS_SENTINEL_TLS_ENABLED=yes \
        -e REDIS_SENTINEL_TLS_CERT_FILE=/opt/drycc/redis/certs/redis.crt \
        -e REDIS_SENTINEL_TLS_KEY_FILE=/opt/drycc/redis/certs/redis.key \
        -e REDIS_SENTINEL_TLS_CA_FILE=/opt/drycc/redis/certs/redisCA.crt \
        quay.io/drycc-addons/redis-sentinel:[TAG]
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      redis-sentinel:
      ...
        environment:
          ...
          - REDIS_SENTINEL_TLS_ENABLED=yes
          - REDIS_SENTINEL_TLS_CERT_FILE=/opt/drycc/redis/certs/redis.crt
          - REDIS_SENTINEL_TLS_KEY_FILE=/opt/drycc/redis/certs/redis.key
          - REDIS_SENTINEL_TLS_CA_FILE=/opt/drycc/redis/certs/redisCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/drycc/redis/certs
        ...
      ...
    ```
Alternatively, you may also provide with this configuration in your [custom](https://github.com/drycc-addons/containers/tree/main/containers/redis-sentinel#configuration-file) configuration file.

### Configuration file

The image looks for configurations in `/quay.io/drycc-addons/redis-sentinel/conf/`. You can mount a volume at `/drycc` and copy/edit the configurations in the `/path/to/redis-persistence/redis-sentinel/conf/`. The default configurations will be populated to the `conf/` directory if it's empty.

#### Step 1: Run the Redis(TM) Sentinel image

Run the Redis(TM) Sentinel image, mounting a directory from your host.

```console
$ docker run --name redis-sentinel \
    -e REDIS_MASTER_HOST=redis \
    -v /path/to/redis-sentinel/persistence:/drycc \
    quay.io/drycc-addons/redis-sentinel:[TAG]
```

You can also modify the [`docker-compose.yml`](https://github.com/drycc-addons/containers/tree/main/containers/redis-sentinel/blob/main/docker-compose.yml) file present in this repository:

```yaml
services:
  redis-sentinel:
  ...
    volumes:
      - /path/to/redis-persistence:/drycc
  ...
```

#### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```console
$ vi /path/to/redis-persistence/redis-sentinel/conf/redis.conf
```

#### Step 3: Restart Redis(TM)

After changing the configuration, restart your Redis(TM) container for changes to take effect.

```console
$ docker restart redis
```

or using Docker Compose:

```console
$ docker-compose restart redis
```

Refer to the [Redis(TM) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

## Logging

The Bitnami Redis(TM) Sentinel Docker Image sends the container logs to the `stdout`. To view the logs:

```console
$ docker logs redis
```

or using Docker Compose:

```console
$ docker-compose logs redis
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Redis(TM) Sentinel, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull quay.io/drycc-addons/redis-sentinel:[TAG]
```

or if you're using Docker Compose, update the value of the image property to
`quay.io/drycc-addons/redis-sentinel:[TAG]`.

#### Step 2: Stop and backup the currently running container

Stop the currently running container using the command

```console
$ docker stop redis
```

or using Docker Compose:

```console
$ docker-compose stop redis
```

Next, take a snapshot of the persistent volume `/path/to/redis-persistence` using:

```console
$ rsync -a /path/to/redis-persistence /path/to/redis-persistence.bkp.$(date +%Y%m%d-%H.%M.%S)
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v redis
```

or using Docker Compose:

```console
$ docker-compose rm -v redis
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name redis quay.io/drycc-addons/redis-sentinel:[TAG]
```

or using Docker Compose:

```console
$ docker-compose up redis
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
