#!/bin/bash
echo "  Dumping dimodo_dev database..."
pg_dump -U present -d dimodo | gzip > dimodo.pgsql.gz
echo "  dimodo_dev dumped successfully!"


#need to delete the db in the remote
#need to recreate the db in the remote

echo "  Restoring dimodo_prod..."
ssh root@139.180.131.81 "gunzip -c dimodo.pgsql.gz | psql dimodo -U postgres"
echo "  dimodo_prod restored successfully"