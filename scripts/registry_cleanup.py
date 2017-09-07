#!/usr/bin/env python

import argparse
import logging
import requests
import sys
from concurrent.futures import ThreadPoolExecutor

from datetime import datetime, timedelta
from oauth2client.client import GoogleCredentials
from pprint import pprint

DEFAULT_AGE_THRESHOLD = 7
DEFAULT_COUNT_THRESHOLD = 50
API_ROOT = "https://eu.gcr.io/v2"

logging.basicConfig(level=logging.INFO, format='%(levelname)s [%(asctime)s] %(name)s: %(message)s')


class Api:
    def __init__(self):
        self.session = requests.session()
        self.session.auth = ("_token", GoogleCredentials.get_application_default().get_access_token().access_token)

    def get_repositories(self):
        return self._get("/_catalog")["repositories"]

    def get_manifest(self, repository):
        return self._get("/{}/tags/list".format(repository))["manifest"]

    def delete_image(self, repository, reference):
        self._delete("/{}/manifests/{}".format(repository, reference))

    def _get(self, path):
        r = self.session.get("{}{}".format(API_ROOT, path))
        r.raise_for_status()
        return r.json()

    def _delete(self, path):
        r = self.session.delete("{}{}".format(API_ROOT, path))
        r.raise_for_status()


def get_timestamp(info):
    return datetime.fromtimestamp(int(info["timeCreatedMs"]) / 1000)

def is_too_old(info, age_threshold):
    delta = datetime.now() - get_timestamp(info)
    return (delta.days >= age_threshold)

def sort_manifest(manifest):
    return [(k, manifest[k]) for k in sorted(manifest, key=lambda k: get_timestamp(manifest.get(k)), reverse=True)]

def filter_manifest(manifest, age_threshold):
    return [(k, v) for (k, v) in manifest if is_too_old(v, age_threshold)]

def delete_item(digest, info, repo, args, api):
    logging.info("Deleting [%s...] (%s) (%d days old)",
                 digest[7:13],
                 info["tag"][0] if (info["tag"]) else "<no tag>",
                 (datetime.now() - get_timestamp(info)).days
                )

    if (not args.dry_run):
        # Need to delete all the tags first
        for tag in info["tag"]:
            api.delete_image(repo, tag)
        api.delete_image(repo, digest)


def process_repo(repo, args, api):
    logging.info("--- Processing repository: %s ---", repo)

    manifest = api.get_manifest(repo)

    sorted_manifest = sort_manifest(manifest)
    logging.info("Found %d items", len(sorted_manifest))

    sliced_manifest = sorted_manifest[args.count_threshold:]
    logging.info("Considering %d items", len(sliced_manifest))

    filtered_manifest = filter_manifest(sliced_manifest, args.age_threshold)
    logging.info("Identified %d items for deletion", len(filtered_manifest))

    executor = ThreadPoolExecutor(max_workers=8)
    for digest, info in filtered_manifest:
        executor.submit(delete_item, digest, info, repo, args, api)
    executor.shutdown()


def run():
    parser = argparse.ArgumentParser(description="Delete old images from Docker registry.")
    parser.add_argument("-a", "--age-threshold", default=DEFAULT_AGE_THRESHOLD, help="Age threshold (days)")
    parser.add_argument("-c", "--count-threshold", default=DEFAULT_COUNT_THRESHOLD, help="Count threshold")
    parser.add_argument("-d", "--dry-run", action="store_true", help="Dry-run mode")
    args = parser.parse_args()

    logging.info("Age threshold   = %s", args.age_threshold)
    logging.info("Count threshold = %s", args.count_threshold)

    api = Api()
    for repo in api.get_repositories():
        process_repo(repo, args, api)

if __name__ == "__main__":
    run()
