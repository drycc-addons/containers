#!/bin/bash
if [ -f /opt/drycc/postgresql/backup/backup.env ]; then
    source /opt/drycc/postgresql/backup/backup.env
    if [ $(echo $USE_WALG | tr '[:upper:]' '[:lower:]') == 'true' ]; then
        is_rec=$(psql -Atq -c "select pg_is_in_recovery();")
        if [ $is_rec == 'f' ]; then
            wal-g wal-push $1
        fi
    fi
fi