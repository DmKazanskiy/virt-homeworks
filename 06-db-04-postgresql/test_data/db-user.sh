#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE DATABASE test_database ENCODING "UTF-8";
	\c test_database;

EOSQL
#test_database < dump.sql;