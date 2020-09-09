#!/bin/bash
cd "/Users/present/Development/Projects/Dimodo/dimodo_app/dimodo_backend"

echo "==== Updating local dimodo db ===="

echo "  Deleting previous dumped db file on the server..."
ssh root@dimodo.app "rm dimodo.pgsql.gz"
echo "  deleted previous dumped file successfully!"

echo "  Dumping the latest db on the local..."
pg_dump -U postgres -d dimodo | gzip > dimodo.pgsql.gz
echo "  db dumped successfully!"

echo "  Sending the dumped db file to server..."
scp dimodo.pgsql.gz root@dimodo.app:~/
echo "  dumped db file sent successfully!"

echo "  Killing remote db connections"
ssh root@dimodo.app  "psql -U postgres -c 'SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '\''dimodo'\'';'"

echo "  killed all db connections successfully..."

echo "  Deleting the production dimodo db..."
ssh root@dimodo.app "psql -U postgres -c 'DROP DATABASE dimodo'"
echo "  deleted the production dimodo db successfully..."

echo "  Creating the production dimodo db..."
ssh root@dimodo.app "psql -U postgres -c 'CREATE DATABASE dimodo'"
echo "  created the production dimodo db successfully..."

echo "  Restoring the latest dimodo db on local..."
ssh root@dimodo.app "gunzip -c dimodo.pgsql.gz | psql dimodo -U postgres"
echo "  restored the lastest dimodo db on local..."

echo "==== Done updating production dimodo db ===="