#!/usr/bin/env python
# pylint: disable=C0111

import atexit
import logging
import sys
from os import path
from pprint import pprint

from kubernetes import client, config
from kubernetes.client.rest import ApiException
import yaml

# TODO - this should be randomised and then logged
SOURCE_SERVICE = "postgres"
TARGET_NAMESPACE = "backups"


def cleanup():
    api = client.CoreV1Api()

    logging.info("Deleting namespace")
    try:
        body = client.V1DeleteOptions()
        api.delete_namespace(TARGET_NAMESPACE, body)
    except ApiException:
        logging.exception("Couldn't delete namespace")


def create_namespace_if_non_existent():
    api = client.CoreV1Api()

    try:
        api.read_namespace(TARGET_NAMESPACE)
        logging.info("Namespace already exists")
        return
    except ApiException:
        pass

    logging.info("Creating namespace")
    try:
        body = client.V1Namespace()
        body.metadata = client.V1ObjectMeta(name=TARGET_NAMESPACE)
        api.create_namespace(body)
    except ApiException:
        logging.exception("Couldn't create namespace")
        sys.exit(1)


def create_service():
    api = client.CoreV1Api()

    logging.info("Creating service")
    with open(path.join(path.dirname(__file__), "service.yml")) as f:
        body = yaml.load(f)
        try:
            api.create_namespaced_service(NAMESPACE, body)
        except ApiException:
            logging.exception("Couldn't create service")
            sys.exit(1)


def create_stateful_set():
    api = client.AppsV1beta1Api()

    logging.info("Creating stateful set")
    with open(path.join(path.dirname(__file__), "stateful-set.yml")) as f:
        body = yaml.load(f)
        try:
            api.create_namespaced_stateful_set(NAMESPACE, body)
        except ApiException:
            logging.exception("Couldn't create stateful set")
            sys.exit(1)


def run():
    logging.basicConfig(level=logging.INFO, format='%(levelname)s [%(asctime)s] %(name)s: %(message)s')

    config.load_kube_config()

    # TODO - S3 rotation

    # TODO - pg_dump

    # TODO - upload to S3

    # Create namespace to perform test restoration in
    create_namespace_if_non_existent()
    atexit.register(cleanup)

    # TODO - create PG service

    # TODO - pg_restore into temp PG

    # TODO - do some dummy operation against temp PG



    create_service()
    create_stateful_set()


if __name__ == "__main__":
    run()

