#!/bin/bash
# build:
# 	GOOS=linux GOARCH=amd64 go build .
# to-server:
# 	ssh root@178.128.58.60
# 	rm dimodo
# 	kill -9 $(sudo lsof -t -i:80)
# 	exit .
# copy-toserver:
# 	scp dimodo root@178.128.58.60:~/
# NOTE: Be sure to replace all instances of dimodo.app
# with your own domain or IP address.

# Change to the directory with our code that we plan to work from
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

echo "  Restarting the server..."
ssh root@dimodo.app "sudo service dimodo restart"
echo "  Server restarted successfully!"

# echo "  Restarting Caddy server..."
# ssh root@dimodo.app "sudo service caddy restart"
# echo "  Caddy restarted successfully!"

echo "==== Done releasing dimodo_backend ===="
