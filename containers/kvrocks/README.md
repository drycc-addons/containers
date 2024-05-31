# Etcd packaged by Drycc

## What is etcd?

> etcd is a distributed key-value store designed to securely store data across a cluster. etcd is widely used in production on account of its reliability, fault-tolerance and ease of use.

[Overview of Etcd](https://etcd.io/)
Trademarks: This software listing is packaged by Drycc. The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## Get this image

The recommended way to get the drycc-addons etcd Docker Image is to pull the prebuilt image from the [Drycc Registry](https://registry.drycc.cc).

```console
docker pull registry.drycc.cc/drycc-addons/etcd:canary
```

To use a specific version, you can pull a versioned tag.

```console
docker pull registry.drycc.cc/drycc-addons/etcd:[TAG]
```

If you wish, you can also build the image yourself by cloning the repository, changing to the directory containing the Dockerfile and executing the `docker build` command. Remember to replace the `APP`, `VERSION` and `OPERATING-SYSTEM` path placeholders in the example command below with the correct values.

```console
git clone https://github.com/drycc-addons/containers
cd containers/APP/VERSION/OPERATING-SYSTEM
docker build -t registry.drycc.cc/drycc-addons
```

## Configuration

The configuration can easily be setup by mounting your own configuration file on the directory `/opt/drycc/etcd/conf`:

```console
docker run --name etcd -v /path/to/etcd.conf.yml:/opt/drycc/etcd/conf/etcd.conf.yml drycc-addons/etcd:latest
```

After that, your configuration will be taken into account in the server's behaviour.

You can also do this by changing the [`docker-compose.yml`](https://github.com/drycc-addons/containers/blob/main/drycc/etcd/docker-compose.yml) file present in this repository:

```yaml
etcd:
  ...
  volumes:
    - /path/to/etcd.conf.yml:/opt/drycc/etcd/conf/etcd.conf.yml
  ...
```

You can find a sample configuration file on this [link](https://github.com/coreos/etcd/blob/master/etcd.conf.yml.sample)

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/drycc-addons/containers/issues) or submitting a [pull request](https://github.com/drycc-addons/containers/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/drycc-addons/containers/issues/new/choose). For us to provide better support, be sure to fill the issue template.
