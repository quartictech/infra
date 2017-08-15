#! /bin/bash
set -euo pipefail

# TODO - secure credentials?
# TODO - test query or something

DUMP_FILE="/db.sql.gz"
RESTORE_FILE="/restore.sql.gz"

GCS_URL="gs://${GCS_BUCKET}/postgres/db.$(date -u +"%Y-%m-%dT%H:%M:%SZ").sql.gz"

#----------------------------------------#
# Backup
#----------------------------------------#

echo "Running pg_dumpall ..."
pg_dumpall -h ${SOURCE_PG_HOST} -U ${SOURCE_PG_USER} | gzip > ${DUMP_FILE}

echo "Uploading to ${GCS_URL} ..."
gsutil cp ${DUMP_FILE} ${GCS_URL}

#----------------------------------------#
# Test restore
#----------------------------------------#

echo "Downloading from ${GCS_URL} ..."
gsutil cp ${GCS_URL} ${RESTORE_FILE}

echo "Restoring to temp Postgres instance ..."
gunzip < ${RESTORE_FILE} | psql -h localhost -U postgres -d postgres -q
