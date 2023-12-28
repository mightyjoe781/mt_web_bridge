#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER smk WITH PASSWORD 'smkpass';
  CREATE DATABASE smk_mc2 WITH OWNER smk;
  GRANT ALL PRIVILEGES ON DATABASE smk_mc2 TO smk;
EOSQL