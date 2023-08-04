# Redis&trade; Cluster packaged by Bitnami

## What is Redis&trade; Cluster?

> Redis&trade; is an open source, scalable, distributed in-memory cache for applications. It can be used to store and serve data in the form of strings, hashes, lists, sets and sorted sets.

[Overview of Redis&trade; Cluster](http://redis.io)

This project has been forked from [bitnami-docker-redis-cluster](https://github.com/bitnami/bitnami-docker-redis-cluster),  We mainly modified the dockerfile in order to build the images of amd64 and arm64 architectures. 


Disclaimer: Redis is a registered trademark of Redis Labs Ltd. Any rights therein are reserved to Redis Labs Ltd. Any use by Bitnami is for referential purposes only and does not indicate any sponsorship, endorsement, or affiliation between Redis Labs Ltd.

## TL;DR

```console
$ docker run --name redis-cluster -e ALLOW_EMPTY_PASSWORD=yes quay.io/drycc-addons/redis-cluster:[TAG]
```

### Docker Compose

```console
$ curl -sSL https://raw.githubusercontent.com/drycc-addons/containers/main/containers/redis-cluster/docker-compose.yml > docker-compose.yml
$ docker-compose up -d
```

## How to deploy Redis(TM) Cluster in Kubernetes?

Deploying Bitnami applications as Helm Charts is the easiest way to get started with our applications on Kubernetes. Read more about the installation in the [Bitnami Redis(TM) Cluster Chart GitHub repository](https://github.com/drycc-addons/charts/tree/main/drycc-addons/redis-cluster).

Bitnami containers can be used with [Kubeapps](https://kubeapps.com/) for deployment and management of Helm Charts in clusters.

## Get this image

The recommended way to get the Bitnami Redis(TM) Docker Image is to pull the prebuilt image from the [Container Image Registry](https://quay.io/repository/drycc-addons/redis-cluster).

```console
$ docker pull quay.io/drycc-addons/redis-cluster:[TAG]
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://quay.io/repository/drycc-addons/redis-cluster?tab=tags) in the Container Image Registry.

```console
$ docker pull quay.io/drycc-addons/redis-cluster:[TAG]
```

If you wish, you can also build the image yourself.

```console

```

## Persisting your application

If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For persistence you should mount a directory at the `/drycc` path. If the mounted directory is empty, it will be initialized on the first run.

```console
$ docker run \
    -e ALLOW_EMPTY_PASSWORD=yes
    -v /path/to/redis-cluster-persistence:/drycc \
    quay.io/drycc-addons/redis-cluster:[TAG]
```

You can also do this with a minor change to the [`docker-compose.yml`](https://github.com/drycc-addons/containers/tree/main/containers/redis-cluster/docker-compose.yml) file present in this repository:

```yaml
redis-cluster:
  ...
  volumes:
    - /path/to/redis-cluster-persistence:/drycc
  ...
```

## Connecting to other containers

Using [Docker container networking](https://docs.docker.com/engine/userguide/networking/), a different server running inside a container can easily be accessed by your application containers and vice-versa.

Containers attached to the same network can communicate with each other using the container name as the hostname.

### Using the Command Line

#### Step 1: Create a network

```console
$ docker network create redis-cluster-network --driver bridge
```

#### Step 2: Launch the Redis(TM) Cluster container within your network

Use the `--network <NETWORK>` argument to the `docker run` command to attach the container to the `redis-cluster-network` network.

```console
$ docker run -e ALLOW_EMPTY_PASSWORD=yes --name redis-cluster-node1 --network redis-cluster-network quay.io/drycc-addons/redis-cluster:[TAG]
```

#### Step 3: Run another containers

We can launch another containers using the same flag (`--network NETWORK`) in the `docker run` command. If you also set a name to your container, you will be able to use it as hostname in your network.

## Configuration

### Configuration file

The image looks for configurations in `/opt/drycc/redis/mounted-etc/redis.conf`. You can overwrite the `redis.conf` file using your own custom configuration file.

```console
$ docker run --name redis \
    -e ALLOW_EMPTY_PASSWORD=yes \
    -v /path/to/your_redis.conf:/opt/drycc/redis/mounted-etc/redis.conf \
    -v /path/to/redis-data-persistence:/drycc/redis/data \
    quay.io/drycc-addons/redis-cluster:[TAG]
```

Alternatively, modify the [`docker-compose.yml`](https://github.com/drycc-addons/containers/tree/main/containers/redis/docker-compose.yml) file present in this repository:

```yaml
services:
  redis-node-0:
  ...
    volumes:
      - /path/to/your_redis.conf:/opt/drycc/redis/mounted-etc/redis.conf
      - /path/to/redis-persistence:/drycc/redis/data
  ...
```

Refer to the [Redis(TM) configuration](http://redis.io/topics/config) manual for the complete list of configuration options.

The following env vars are supported for this container:

| Name                                    | Description                                                                                                                                                                            |
|-----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `REDIS_DISABLE_COMMANDS`                | Disables the specified Redis(TM) commands                                                                                                                                              |
| `REDIS_PORT_NUMBER`                     | Set the Redis(TM) port. Default=: `6379`                                                                                                                                               |
| `REDIS_PASSWORD`                        | Set the Redis(TM) password. Default: `drycc`                                                                                                                                         |
| `ALLOW_EMPTY_PASSWORD`                  | Enables access without password                                                                                                                                                        |
| `REDIS_DNS_RETRIES`                     | Number of retries to get the IPs of the provided `REDIS_NODES`. It will wait 5 seconds between retries                                                                                 |
| `REDISCLI_AUTH`                         | Provide the same value as the configured `REDIS_PASSWORD` for the redis-cli tool to authenticate                                                                                       |
| `REDIS_CLUSTER_CREATOR`                 | Set to `yes` if the container will be the one on charge of initialize the cluster. This node will also be part of the cluster.                                                         |
| `REDIS_CLUSTER_REPLICAS`                | Number of replicas for every master that the cluster will have.                                                                                                                        |
| `REDIS_NODES`                           | String delimited by spaces containing the hostnames of all of the nodes that will be part of the cluster                                                                               |
| `REDIS_CLUSTER_ANNOUNCE_IP`             | IP that the node should announce, used for non dynamic ip environents                                                                                                                  |
| `REDIS_CLUSTER_DYNAMIC_IPS`             | Set to `no` if your Redis(TM) cluster will be created with statical IPs. Default: `yes`                                                                                                |
| `REDIS_TLS_ENABLED`                     | Whether to enable TLS for traffic or not. Defaults to `no`.                                                                                                                            |
| `REDIS_TLS_PORT`                        | Port used for TLS secure traffic. Defaults to `6379`.                                                                                                                                  |
| `REDIS_TLS_CERT_FILE`                   | File containing the certificate file for the TLS traffic. No defaults.                                                                                                                 |
| `REDIS_TLS_KEY_FILE`                    | File containing the key for certificate. No defaults.                                                                                                                                  |
| `REDIS_TLS_CA_FILE`                     | File containing the CA of the certificate. No defaults.                                                                                                                                |
| `REDIS_TLS_DH_PARAMS_FILE`              | File containing DH params (in order to support DH based ciphers). No defaults.                                                                                                         |
| `REDIS_TLS_AUTH_CLIENTS`                | Whether to require clients to authenticate or not. Defaults to `yes`.                                                                                                                  |
| `REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` | Number of seconds to wait before initializing the cluster. Set this to a higher value if you sometimes have issues with initial cluster creation. Defaults to `0`.                     |
| `REDIS_CLUSTER_DNS_LOOKUP_RETRIES`      | Number of retries for the node's DNS lookup during the initial cluster creation. Defaults to `5`.                                                                                      |
| `REDIS_CLUSTER_DNS_LOOKUP_SLEEP`        | Number of seconds to wait between each node's DNS lookup during the initial cluster creation. Defaults to `1`.                                                                         |

Once all the Redis(TM) nodes are running you need to execute command like the following to initiate the cluster:

```console
redis-cli --cluster create node1:port node2:port --cluster-replicas 1 --cluster-yes
```

Where you can add all the `node:port` that you want. The `--cluster-replicas` parameters indicates how many replicas you want to have for every master.

### Cluster Initialization Troubleshooting

Depending on the environment you're deploying into, you might run into issues where the cluster initialization
is not completing successfully. One of the issue is related to the DNS lookup of the redis nodes performed during
cluster initialization. By default, this DNS lookup is performed as soon as all the redis nodes reply to
a successful ping. However, in some environments such as Kubernetes, it can help to wait some time before
performing this DNS lookup in order to prevent getting stale records. To this end, you can increase
`REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` to a value around `30` which has been found to be good in most cases. You can
check the discussion regarding this [here](https://github.com/bitnami/bitnami-docker-redis-cluster/pull/16#pullrequestreview-540706903).

### Securing Redis(TM) Cluster traffic

Starting with version 6, Redis(TM) adds the support for SSL/TLS connections. Should you desire to enable this optional feature, you may use the aforementioned `REDIS_TLS_*` environment variables to configure the application.

When enabling TLS, conventional standard traffic is disabled by default. However this new feature is not mutually exclusive, which means it is possible to listen to both TLS and non-TLS connection simultaneously. To enable non-TLS traffic, set `REDIS_TLS_PORT` to another port different than `0`.

1. Using `docker run`

    ```console
    $ docker run --name redis-cluster \
        -v /path/to/certs:/opt/drycc/redis/certs \
        -v /path/to/redis-cluster-persistence:/drycc \
        -e ALLOW_EMPTY_PASSWORD=yes \
        -e REDIS_TLS_ENABLED=yes \
        -e REDIS_TLS_CERT_FILE=/opt/drycc/redis/certs/redis.crt \
        -e REDIS_TLS_KEY_FILE=/opt/drycc/redis/certs/redis.key \
        -e REDIS_TLS_CA_FILE=/opt/drycc/redis/certs/redisCA.crt \
        quay.io/drycc-addons/redis-cluster:[TAG]
    ```

2. Modifying the `docker-compose.yml` file present in this repository:

    ```yaml
      redis-cluster:
      ...
        environment:
          ...
          - REDIS_TLS_ENABLED=yes
          - REDIS_TLS_CERT_FILE=/opt/drycc/redis/certs/redis.crt
          - REDIS_TLS_KEY_FILE=/opt/drycc/redis/certs/redis.key
          - REDIS_TLS_CA_FILE=/opt/drycc/redis/certs/redisCA.crt
        ...
        volumes:
          - /path/to/certs:/opt/drycc/redis/certs
        ...
      ...
    ```
Alternatively, you may also provide with this configuration in your [custom](https://github.com/drycc-addons/containers/tree/main/containers/redis-cluster#configuration-file) configuration file.

## Logging

The Bitnami Redis(TM) Cluster Docker image sends the container logs to `stdout`. To view the logs:

```console
$ docker logs redis-cluster
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

## Maintenance

### Upgrade this image

Bitnami provides up-to-date versions of Redis(TM) Cluster, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull quay.io/drycc-addons/redis-cluster:[TAG]
```

#### Step 2: Stop the running container

Stop the currently running container using the command

```console
$ docker stop redis-cluster
```

#### Step 3: Remove the currently running container

```console
$ docker rm -v redis-cluster
```

#### Step 4: Run the new image

Re-create your container from the new image.

```console
$ docker run --name redis-cluster quay.io/drycc-addons/redis-cluster:[TAG]
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
