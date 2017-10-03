#! /bin/bash
set -euo pipefail

# TODO - secure credentials?
# TODO - test query or something
# TODO - we should record the platform version in the filename or something

DUMP_FILE="/db.sql.gz"
RESTORE_FILE="/restore.sql.gz"
declare -a DATABASES=("eval" "qube" "catalogue")

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

# This ensures that the DROP statements in the output of pg_dumpall will succeed
echo "Creating databases"
set +e
for db in "${DATABASES[@]}"
do
  createdb -h ${TEMP_POSTGRES_HOST} -U ${TEMP_POSTGRES_USER} "$db"
done
set -e

# This is an unpleasant hack. See here: https://dba.stackexchange.com/questions/75033/how-to-restore-everything-including-postgres-role-from-pg-dumpall-backup
# and https://www.postgresql.org/message-id/200804241637.m3OGbAOe071623@wwwmaster.postgresql.org
echo "Restoring to temp Postgres instance ..."
gunzip < ${RESTORE_FILE} | egrep -v '^(CREATE|DROP) ROLE postgres;' | psql -v ON_ERROR_STOP=on -h ${TEMP_POSTGRES_HOST} -U ${TEMP_POSTGRES_USER} -d postgres -q

echo "Complete!"
