#!/bin/bash
hello:
	echo "Deploy Golang TO Server"

hello:
	echo "See you"
# build:
# 	GOOS=linux GOARCH=amd64 go build .
# to-server:
# 	ssh root@178.128.58.60
# 	rm dimodo
# 	kill -9 $(sudo lsof -t -i:80)
# 	exit .
# copy-toserver:
# 	scp dimodo root@178.128.58.60:~/
# NOTE: Be sure to replace all instances of 139.180.131.81
# with your own domain or IP address.

# Change to the directory with our code that we plan to work from
cd "/Users/root/Development/Projects/Dimodo/dimodo_backend"

echo "==== Releasing dimodo_backend ===="
echo "  Deleting the local binary if it exists (so it isn't uploaded)..."
rm dimodo
echo "  Done!"

echo "  Building the code locally"
env GOOS=linux GOARCH=amd64 go build -o dimodo
echo "  Code built successfully!"

echo "  Deleting existing code..."
ssh root@139.180.131.81 "rm -rf go/src/dimodo_backend"
echo "  Code deleted successfully!"


echo "  Uploading code..."
rsync -avr --exclude '.git/*' --exclude 'tmp/*' --exclude 'images/*' ./ root@139.180.131.81:/root/go/src/dimodo_backend/
echo "  Code uploaded successfully!"

# echo "  Moving Caddyfile..."
# ssh root@139.180.131.81 "cd /root/app; \
#   cp /root/go/src/dimodo_backend/Caddyfile ."
# echo "  Caddyfile moved successfully!"

echo "  Restarting the server..."
ssh root@139.180.131.81 "sudo service dimodo restart"
echo "  Server restarted successfully!"

# echo "  Restarting Caddy server..."
# ssh root@139.180.131.81 "sudo service caddy restart"
# echo "  Caddy restarted successfully!"

echo "==== Done releasing dimodo_backend ===="
