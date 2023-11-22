#!/bin/bash
is_rec=$(psql -Atq -c "select pg_is_in_recovery();")
if [ $is_rec == 'f' ]; then
    wal-g wal-push $1
fi