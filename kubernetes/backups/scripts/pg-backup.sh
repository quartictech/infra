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

echo "Running pg_dumpall ..."
export PGPASSWORD=${SOURCE_POSTGRES_PASSWORD}
pg_dumpall -h ${SOURCE_POSTGRES_HOST} -U ${SOURCE_POSTGRES_USER} --clean | gzip > ${DUMP_FILE}

echo "Uploading to ${GCS_URL} ..."
gsutil cp ${DUMP_FILE} ${GCS_URL}

#----------------------------------------#
# Test restore
#----------------------------------------#

echo "Downloading from ${GCS_URL} ..."
gsutil cp ${GCS_URL} ${RESTORE_FILE}

echo "Restoring to temp Postgres instance ..."
gunzip < ${RESTORE_FILE} | psql -h ${TEMP_POSTGRES_HOST} -U ${TEMP_POSTGRES_USER} -d postgres -q

echo "Complete!"
