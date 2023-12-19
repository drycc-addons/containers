#!/usr/bin/env python3

import os
import sys
import yaml
import time
import logging
from kubernetes import client, config, watch
from kubernetes.client.rest import ApiException


usage = """
The fluentbit bootloader script calls to a k8s API.

Usage: python fluentbit.py <command> <namespace>

Valid commands for boot:

controller         start the controller to manage fluentbit
fluentbit          fluentbit is logging and metrics processor and forwarder
collection         run carbage collection to clean fluentbit

For example 'boot controller py3django' to collect logs from the py3django namespace.
"""
logger = logging.getLogger(__name__)

WATCH_RETRY_INTERVAL = os.environ.get("WATCH_RETRY_INTERVAL", 5)
FLUENTBIT_CLUSTER_ID = os.environ.get("FLUENTBIT_CLUSTER_ID", "415cceb6692")
FLUENTBIT_CREATE_TPL_PATH = os.environ.get(
    "FLUENTBIT_CREATE_TPL_PATH", "/opt/drycc/fluent-bit/templates/kube-pod-template.yaml")


def gen_agent_name(node_name):
    return f"fluentbit-agent-{node_name}-{FLUENTBIT_CLUSTER_ID}"


def get_agent_pods(v1, namespace):
    label_selector = ",".join([
        f'fluentbit.addons.drycc.cc/id={FLUENTBIT_CLUSTER_ID}',
        f'fluentbit.addons.drycc.cc/type=agent',
    ])
    return v1.list_namespaced_pod(namespace, label_selector=label_selector)


def get_node_names(v1, namespace):
    label_selector = ",".join([
        f'fluentbit.addons.drycc.cc/type!=agent',
        f'fluentbit.addons.drycc.cc/type!=controller',
    ])
    node_names = {
        item.spec.node_name 
        for item in v1.list_namespaced_pod(
            namespace,
            label_selector=label_selector,
        ).items
    }
    return node_names


def create_pod(v1, namespace, node_name):
    name = gen_agent_name(node_name)
    try:
        v1.read_namespaced_pod(name, namespace)
    except ApiException as e:
        if e.status == 404:
            if os.path.exists(FLUENTBIT_CREATE_TPL_PATH):
                with open(FLUENTBIT_CREATE_TPL_PATH) as f:
                    pod = yaml.safe_load(f)
                    pod["metadata"]["name"] = name
                    pod["metadata"]["labels"].update({
                        "fluentbit.addons.drycc.cc/id": FLUENTBIT_CLUSTER_ID,
                        "fluentbit.addons.drycc.cc/type": "agent",
                    })
                    v1.create_namespaced_pod(body=pod, namespace=namespace)
            else:
                raise e
        else:
            raise e


def delete_pod(v1, namespace, node_name):
    name = gen_agent_name(node_name)
    return v1.delete_namespaced_pod(name, namespace)


def fluentbit(*args):
    os.execvp("fluent-bit", args)


def controller(v1, namespace):
    kwargs = {
        "namespace": namespace,
        "watch": True,
        "label_selector": ",".join([
            f'fluentbit.addons.drycc.cc/type!=agent',
            f'fluentbit.addons.drycc.cc/type!=controller',
        ]),
    }
    while True:
        w = watch.Watch()
        try:
            for event in w.stream(v1.list_namespaced_pod, **kwargs):
                pod_name = event['object'].metadata.name
                node_name = event['object'].spec.node_name
                if node_name and pod_name != gen_agent_name(node_name):
                    if event['type'] in ("ADDED", "MODIFIED"):
                        create_pod(v1, namespace, node_name)
                    elif event['type'] == "DELETED":
                        delete_pod(v1, namespace, node_name)
        except Exception as ex:
            logger.info(f"re watch the {namespace} pod, the reason is: {ex}")
            w.stop()
        time.sleep(WATCH_RETRY_INTERVAL)


def collection(v1, namespace):
    node_names = get_node_names(v1, namespace)
    for pod in get_agent_pods(v1, namespace).items:
        if pod.spec.node_name not in node_names:
            delete_pod(v1, namespace, pod.spec.node_name)
    print("Complete garbage collection...")


def main():
    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command in ("controller", "fluentbit", "collection"):
            config.load_kube_config()
            v1 = client.CoreV1Api()
            eval(command)(v1, *sys.argv[2:])
            sys.exit()
    print(usage)


if __name__ == "__main__":
    main()
