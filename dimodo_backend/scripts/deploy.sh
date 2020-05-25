#!/bin/bash
# releaseBackend.sh upload the dimodo_backend directory to
# the remote server, builds the source codes, and run the service

cd "/Users/present/Development/Projects/Dimodo/dimodo_app/dimodo_backend"

echo "==== Releasing dimodo_backend ===="
echo "  Deleting the local binary if it exists (so it isn't uploaded)..."
rm dimodo
echo "  Done!"

echo "  Building the code locally"
env GOOS=linux GOARCH=amd64 go build -o dimodo
echo "  Code built successfully!"

echo "  Deleting existing code..."
ssh root@dimodo.app "rm -rf go/src/dimodo_backend"
echo "  Code deleted successfully!"


echo "  Uploading code..."
rsync -avr --exclude '.git/*' --exclude 'tmp/*' --exclude 'images/*' ./ root@dimodo.app:/root/go/src/dimodo_backend/
echo "  Code uploaded successfully!"

echo "  Applying migrations..."

ssh root@dimodo.app "migrate -database postgres://postgres:wC9s6AnUumt62C@localhost:5432/dimodo?sslmode=disable -path /root/go/src/dimodo_backend/db/migrations up"
echo "  Migrations done successfully..."

echo "  Restarting the server..."
ssh root@dimodo.app "sudo service dimodo restart"
echo "  Server restarted successfully!"

# echo "  Restarting Caddy server..."
# ssh root@dimodo.app "sudo service caddy restart"
# echo "  Caddy restarted successfully!"

echo "==== Done releasing dimodo_backend ===="

