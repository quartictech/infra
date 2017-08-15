#! /bin/bash
set -euo pipefail

# TODO - secure credentials?
# TODO - test query or something
# TODO - we should record the platform version in the filename or something

DUMP_FILE="/db.sql.gz"
RESTORE_FILE="/restore.sql.gz"

GCS_URL="gs://${GCS_BUCKET}/postgres/postgres.$(date -u +"%Y-%m-%dT%H:%M:%SZ").${VERSION}.sql.gz"

#----------------------------------------#
# Backup
#----------------------------------------#

# If we don't use --data-only, then we end up trying to restore e.g. "postgres" role, which causes errors on restore
# We assume that users, etc. are created programmatically
echo "Running pg_dumpall ..."
pg_dumpall -h ${POSTGRES_HOST} -U ${POSTGRES_USER} --data-only | gzip > ${DUMP_FILE}

echo "Uploading to ${GCS_URL} ..."
gsutil cp ${DUMP_FILE} ${GCS_URL}

#----------------------------------------#
# Test restore
#----------------------------------------#

echo "Downloading from ${GCS_URL} ..."
gsutil cp ${GCS_URL} ${RESTORE_FILE}

echo "Waiting for local Postgres to become ready ..."
until pg_isready -h localhost; do
    sleep 1
done

echo "Restoring to temp Postgres instance ..."
gunzip < ${RESTORE_FILE} | psql -h localhost -U postgres -d postgres -q

echo "Complete!"
