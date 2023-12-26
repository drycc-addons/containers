#!/usr/bin/env python3

import os
import yaml
import time
import click
import logging
from kubernetes import client, watch
from kubernetes.client.rest import ApiException


logger = logging.getLogger(__name__)


def load_kube_config():
    with open('/var/run/secrets/kubernetes.io/serviceaccount/token') as token_file:
        token = token_file.read()
    ""
    host = "https://%s:%s" % (
        os.environ.get("KUBERNETES_SERVICE_HOST", "127.0.0.1"),
        os.environ.get("KUBERNETES_SERVICE_PORT", "443"),
    )
    config = client.Configuration(host=host)
    config.api_key = {"authorization": "Bearer " + token}
    config.verify_ssl = True
    if config.verify_ssl:
        config.ssl_ca_cert = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
    client.Configuration.set_default(config)


def load_daemon_set(daemonset_file):
    if os.path.exists(daemonset_file):
        with open(daemonset_file) as f:
            return yaml.safe_load(f)
    else:
        raise FileNotFoundError(
            "daemonset template path %s not found" % daemonset_file)


def create_daemon_set(namespace, daemonset, node_names):
    apps_v1_api = client.AppsV1Api()
    daemonset["spec"]["template"]["spec"]["affinity"] = {
        "nodeAffinity": {
            "requiredDuringSchedulingIgnoredDuringExecution": {
                "nodeSelectorTerms": [{
                    "matchExpressions": [{
                        "key": "kubernetes.io/hostname",
                        "operator": "In",
                        "values": node_names,
                    }]
                }],
            }
        }
    }
    apps_v1_api.create_namespaced_daemon_set(namespace, body=daemonset)


def refresh_daemon_set(namespace, daemonset):
    kwargs = {
        "namespace": namespace,
        "label_selector": ",".join(
            [f"{key}!={value}" for key, value in daemonset["spec"]["selector"]["matchLabels"].items()]
        ),
    }
    apps_v1_api = client.AppsV1Api()
    core_v1_api = client.CoreV1Api()
    new_node_names = list({
        item.spec.node_name for item in core_v1_api.list_namespaced_pod(**kwargs).items
    })
    daemon_set_name = daemonset["metadata"]["name"]
    try:
        daemonset = apps_v1_api.read_namespaced_daemon_set(daemon_set_name, namespace)
        old_node_names = daemonset.spec.template.spec.affinity.node_affinity.\
            required_during_scheduling_ignored_during_execution.\
                node_selector_terms[0].match_expressions[0].values
        if len(new_node_names) == 0:
            apps_v1_api.delete_namespaced_daemon_set(daemon_set_name, namespace)
        else:
            old_node_names.sort()
            new_node_names.sort()
            if old_node_names != new_node_names:
                old_node_names.clear()
                old_node_names.extend(new_node_names)
            apps_v1_api.patch_namespaced_daemon_set(daemon_set_name, namespace, body=daemonset)
    except ApiException as e:
        if e.status == 404:
            create_daemon_set(namespace, daemonset, new_node_names)
        else:
            raise e


@click.command()
@click.option("--namespace", "namespace", required=True, help="k8s namespace.")
@click.option("--daemonset-file", "daemonset_file", required=True, help="k8s daemonset template path.")
@click.option("--retry-interval", "retry_interval", show_default=True, default=60, type=int, help="k8s watch retry interval.")
def main(namespace, daemonset_file, retry_interval):
    daemonset = load_daemon_set(daemonset_file)
    kwargs = {
        "namespace": namespace,
        "watch": True,
        "timeout_seconds": retry_interval,
        "label_selector": ",".join(
            [f"{key}!={value}" for key, value in daemonset["spec"]["selector"]["matchLabels"].items()]
        ),
    }
    load_kube_config()
    deleted_timestamp = 0
    refresh_daemon_set(namespace, daemonset)
    core_v1_api = client.CoreV1Api()
    while True:
        w = watch.Watch()
        try:
            for event in w.stream(core_v1_api.list_namespaced_pod, **kwargs):
                node_name = event['object'].spec.node_name
                if node_name:
                    if event['type'] in ("ADDED", "MODIFIED", "DELETED"):
                        deleted_timestamp = int(time.time())
            interval = int(time.time()) - deleted_timestamp
            if deleted_timestamp > 0 and interval > retry_interval:
                refresh_daemon_set(namespace, daemonset)
                deleted_timestamp = 0
        except Exception as ex:
            logger.exception(ex)
            w.stop()


if __name__ == "__main__":
    main()
