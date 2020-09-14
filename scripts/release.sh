#!/bin/bash
# release.sh will merge the new commits back to master
# push the develop and master to the remote
# and checkout back to the develop branch

# Change to the directory with our code that we plan to work from
cd "/Users/present/Development/Projects/Glowvy/glowvy_app"

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
echo "  pushed master to remote successfully!"


echo "  Checking out Develop..."
git co develop
echo "  checked out develop successfully!"

echo "==== Done Merging Develop to Master ===="
