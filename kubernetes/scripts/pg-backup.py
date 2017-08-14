#!/usr/bin/env python
# pylint: disable=C0111

# TODO - image requires "apt-get install postgresql-client" (what about version mismatch?)

import atexit
import logging
import subprocess
import sys
from os import path
from pprint import pprint

from kubernetes import client, config
from kubernetes.client.rest import ApiException
import yaml

PG_HOST = "dummy-postgres"
PG_USER = "postgres"
PG_DATABASE = "postgres"

DUMP_FILE = "/db.sql"

SOURCE_SERVICE = "postgres"
TARGET_NAMESPACE = "backups"    # TODO - this should be randomised and then logged


# Modified http://blog.endpoint.com/2015/01/getting-realtime-output-using-python.html for Python3 and stdin
def run_command(command, stdin=""):
    process = subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    process.stdin.write(str.encode(stdin))
    process.stdin.close()
    while True:
        output = process.stdout.readline().decode()
        if output == "" and process.poll() is not None:
            break
        if output:
            logging.info(output, end="")
    rc = process.poll()
    return rc


def dump_postgres():
    rc = run_command(["pg_dump", "-h", PG_HOST, "-U", PG_USER, "-f", PG_DATABASE, DUMP_FILE])
    if (rc != 0):
        logging.error("pg_dump failed with exit status {}", rc)


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


# def create_service():
#     api = client.CoreV1Api()

#     logging.info("Creating service")
#     with open(path.join(path.dirname(__file__), "service.yml")) as f:
#         body = yaml.load(f)
#         try:
#             api.create_namespaced_service(TARGET_NAMESPACE, body)
#         except ApiException:
#             logging.exception("Couldn't create service")
#             sys.exit(1)


# def create_stateful_set():
#     api = client.AppsV1beta1Api()

#     logging.info("Creating stateful set")
#     with open(path.join(path.dirname(__file__), "stateful-set.yml")) as f:
#         body = yaml.load(f)
#         try:
#             api.create_namespaced_stateful_set(TARGET_NAMESPACE, body)
#         except ApiException:
#             logging.exception("Couldn't create stateful set")
#             sys.exit(1)


def load_api_config():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()


def run():
    logging.basicConfig(level=logging.INFO, format='%(levelname)s [%(asctime)s] %(name)s: %(message)s')

    load_api_config()

    # TODO - S3 rotation

    dump_postgres()

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

