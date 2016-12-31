#!/usr/bin/env python

import argparse
import logging
import requests
import sys

from datetime import datetime, timedelta
from pprint import pprint

DEFAULT_AGE_THRESHOLD = 14
API_ROOT = "https://eu.gcr.io/v2"


class Api:
    def __init__(self, token):
        self.token = token
        self.session = requests.session()

    def get_repositories(self):
        return self._get("/_catalog")["repositories"]

    def get_manifest(self, repository):
        return self._get("/{}/tags/list".format(repository))["manifest"]

    def delete_image(self, repository, reference):
        self._delete("/{}/manifests/{}".format(repository, reference))

    def _get(self, path):
        r = requests.get("{}{}".format(API_ROOT, path), auth=("_token", self.token))
        r.raise_for_status()
        return r.json()

    def _delete(self, path):
        r = requests.delete("{}{}".format(API_ROOT, path), auth=("_token", self.token))
        r.raise_for_status()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, format='%(levelname)s [%(asctime)s] %(name)s: %(message)s')

    parser = argparse.ArgumentParser(description="Delete old images from Docker registry.")
    parser.add_argument("-t", "--token", required=True, help="Access token (acquired via \"gcloud auth print-access-token\")")
    parser.add_argument("-a", "--age-threshold", default=DEFAULT_AGE_THRESHOLD, help="Age threshold (days)")
    args = parser.parse_args()

    api = Api(args.token)

    logging.info("Age threshold = {}".format(args.age_threshold))

    for repo in api.get_repositories():
        logging.info("Processing repository: {}".format(repo))

        for digest, info in api.get_manifest(repo).items():
            short_digest = digest[7:13]
            tag = info["tag"][0] if (len(info["tag"]) > 0) else "<no tag>"
            delta = datetime.now() - datetime.fromtimestamp(int(info["timeCreatedMs"]) / 1000)
            delete = (delta.days >= args.age_threshold)

            logging.info("[{}...] ({}) ({} days old) - {}".format(short_digest, tag, delta.days, "DELETE" if delete else "preserve"))

            if (delete):
                # Need to delete all the tags first
                for tag in info["tag"]:
                    api.delete_image(repo, tag)
                api.delete_image(repo, digest)
