#!/bin/bash
set -Eeu
if [[ ( -n "$DATABASE_USER") &&  ( -n "$DATABASE_PASSWORD") && ( -n "$DATABASE_NAME")]]; then
    echo "Creating user ${DATABASE_USER}"
    export 
    psql "$1" -w -c "create user ${DATABASE_USER} WITH LOGIN ENCRYPTED PASSWORD '${DATABASE_PASSWORD}'"
    echo "Creating database ${DATABASE_NAME}
    psql "$1" -w -c "CREATE DATABASE ${DATABASE_NAME} OWNER ${DATABASE_USER} CONNECTION LIMIT 1000"
    psql "$1" -w -d ${DATABASE_NAME} -c "create extension postgis"
else
    echo "Skipping user creation" 
    echo "Skipping database creation"
fi