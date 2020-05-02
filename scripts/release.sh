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
cd "/Users/present/Development/Projects/Dimodo/dimodo_app"

echo "==== Merging Develop to Master ===="
echo "  Checkout master"
git co master
echo "  Done!"

echo "  Merge Develop to Master"
git merge develop
echo "  merged successfully!"

echo "  Pushing Develop to remote"
git push origin develop
echo "  pushed develop to remote successfully!"

echo "  Pushing Master to remote"
git push origin master
echo "  pushed develop to remote successfully!"


echo "  Checking out Develop..."
git co develop
echo "  checked out develop successfully!"

echo "==== Done Merging Develop to Master ===="
