#! /bin/bash
set -eu

PROJECT="quartictech"
NAME=${1}
ZONE="europe-west1-b"
NUM_NODES=${2}
# devstorage.read.write required for Howl, datastore required for Catalogue persistence, everything else default
SCOPES="https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_write","https://www.googleapis.com/auth/datastore","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"

#----------------------------------------------------#
# Create the cluster
#----------------------------------------------------#
gcloud container --project "${PROJECT}" clusters create "${NAME}" \
  --zone "${ZONE}" \
  --machine-type "n1-standard-4" \
  --image-type "GCI" \
  --disk-size "100" \
  --scopes "${SCOPES}" \
  --num-nodes "${NUM_NODES}" \
  --network "default" \
  --no-enable-cloud-monitoring          # Stacktrace is stupid (but we'll leave logging enabled, becaus that might be useful)

# TODO: perhaps we can do gcloud container clusters update --update-addons HttpLoadBalancing=DISABLED

#----------------------------------------------------#
# Create the Postgres disk (TODO: don't we want this to be persistent? Should do a check)
#----------------------------------------------------#
gcloud compute --project "${PROJECT}" disks create "${NAME}-postgres" \
  --zone "${ZONE}" \
  --size "200" \
  --type "pd-standard"

# TODO: Open HTTP port

# TODO: Attach external IP

# TODO: Label primary node with ingressNode=true
