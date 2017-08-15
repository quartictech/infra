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

SOURCE_PG_HOST = "dummy-postgres"
SOURCE_PG_USER = "postgres"
SOURCE_PG_DATABASE = "postgres"

DUMP_FILE = "/db.sql"

TEMP_NAMESPACE = "backups"    # TODO - this should be randomised and then logged
TEMP_PG_HOST = "postgres"
TEMP_PG_USER = "postgres"
TEMP_PG_DATABASE = "postgres"


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
    rc = run_command(["pg_dump", "-h", SOURCE_PG_HOST, "-U", SOURCE_PG_USER, "-f", DUMP_FILE, SOURCE_PG_DATABASE])
    if (rc != 0):
        logging.error("pg_dump failed with exit status %d", rc)
        sys.exit(1)


def cleanup():
    api = client.CoreV1Api()

    logging.info("Deleting namespace")
    try:
        body = client.V1DeleteOptions()
        api.delete_namespace(TEMP_NAMESPACE, body)
    except ApiException:
        logging.exception("Couldn't delete namespace")


def create_namespace_if_non_existent():
    api = client.CoreV1Api()

    try:
        api.read_namespace(TEMP_NAMESPACE)
        logging.info("Namespace already exists")
        return
    except ApiException:
        pass

    logging.info("Creating namespace")
    body = client.V1Namespace()
    body.metadata = client.V1ObjectMeta(name=TEMP_NAMESPACE)
    try:
        api.create_namespace(body)
    except ApiException:
        logging.exception("Couldn't create namespace")
        sys.exit(1)


def do_something_with_file(filename, action, description):
    logging.info(description)
    api = client.CoreV1Api()
    with open(path.join(path.dirname(__file__), filename)) as f:
        body = yaml.load(f)
        try:
            action(api, body)
        except ApiException:
            logging.exception("%s failed", description)
            sys.exit(1)


def create_postgres_service():
    do_something_with_file(
        "pg_service.yml",
        lambda api, body: api.create_namespaced_service(TEMP_NAMESPACE, body),
        "Creating Postgres service")


def create_postgres_deployment():
    do_something_with_file(
        "pg_deployment.yml",
        lambda api, body: api.create_namespaced_deployment(TEMP_NAMESPACE, body),
        "Creating Postgres deployment")


def load_api_config():
    try:
        config.load_incluster_config()
    except:
        config.load_kube_config()


def backup():
    # TODO - S3 rotation

    dump_postgres()

    # TODO - upload to S3


def test_restore():
    # Create namespace to perform test restoration in
    create_namespace_if_non_existent()
    atexit.register(cleanup)

    create_postgres_service()
    create_postgres_deployment()

    # TODO - wait until ready

    # TODO - download from S3

    # TODO - pg_restore into temp PG

    # TODO - do some dummy operation against temp PG


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(levelname)s [%(asctime)s] %(name)s: %(message)s')
    load_api_config()
    backup()
    test_restore()

