#! /bin/bash
set -eu

# TODO - image requires "apt-get install postgresql-client" (what about version mismatch?)
# TODO - also requires gsutil - https://cloud.google.com/storage/docs/gsutil_install#deb
# TODO - parameterise all of this
# TODO - secure credentials?

GCS_BUCKET="backups.quartic.io"

SOURCE_PG_HOST="dummy-postgres"
SOURCE_PG_USER="postgres"
SOURCE_PG_DATABASE="postgres"

TEMP_NAMESPACE="backups"    # TODO - this should be randomised and then logged
TEMP_PG_HOST="postgres"
TEMP_PG_USER="postgres"
TEMP_PG_DATABASE="postgres"

DUMP_FILE="/db.sql"
RESTORE_FILE="/restore.sql"

GCS_URL="gs://${GCS_BUCKET}/postgres/db.$(date -u +"%Y-%m-%dT%H:%M:%SZ").sql"

function dump_to_local() {
    echo "Running pg_dump ..."
    pg_dump -h ${SOURCE_PG_HOST} -U ${SOURCE_PG_USER} -f ${DUMP_FILE} ${SOURCE_PG_DATABASE}
}

function upload_to_gcs() { 
    echo "Uploading to ${gcs_url} ..."
    gsutil -m rsync ${DUMP_FILE} ${gcs_url}
}

function download_from_gcs() { 
    echo "Downloading from ${gcs_url} ..."
    gsutil -m rsync ${gcs_url} ${RESTORE_FILE}
}

# Backup
dump_to_local
upload_to_gcs

# Test restore
download_from_gcs
# TODO - PG restore
# TODO - test query or something

