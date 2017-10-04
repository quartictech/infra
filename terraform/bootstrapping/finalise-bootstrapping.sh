#! /bin/sh
set -eu
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd ${DIR}

CIRCLECI_URL_ROOT="https://circleci.com/api/v1.1/project/github/quartictech/infra"

CIRCLECI_API_TOKEN=${1}

ORG_ID=$(terraform output org_id)
PROJECT_ID=$(terraform output project_id)
SERVICE_ACCOUNT_EMAIL=$(terraform output service_account_email)


#-----------------------------------------------------------#
# Configure organization IAM policies for the service account
#-----------------------------------------------------------#
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:${SERVICE_ACCOUNT_EMAIL} \
  --role roles/resourcemanager.projectCreator
gcloud organizations add-iam-policy-binding ${ORG_ID} \
  --member serviceAccount:${SERVICE_ACCOUNT_EMAIL} \
  --role roles/billing.user


#-----------------------------------------------------------#
# Provide service account creds to CircleCI
#-----------------------------------------------------------#
CREDS_FILE=service-account-creds.json

gcloud iam service-accounts keys create ${CREDS_FILE} --iam-account ${SERVICE_ACCOUNT_EMAIL}

function set_env_var() {
  curl -XPOST -H "Content-Type: application/json" \
    "${CIRCLECI_URL_ROOT}/envvar?circle-token=${CIRCLECI_API_TOKEN}" \
    -d '{"name": "'"${1}"'", "value": "'"${2}"'"}'
}
set_env_var GOOGLE_PROJECT            "${PROJECT_ID}"
set_env_var GOOGLE_CREDENTIALS        "$(cat ${CREDS_FILE})"

rm ${CREDS_FILE}