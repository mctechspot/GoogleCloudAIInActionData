#!/bin/bash

# Export .env variables
set -o allexport
source .env
set +o allexport

# Set variables for docker image and container
IMAGE=mongodb/mongodb-community-server
IMAGE_TAG=latest
CONTAINER_NAME=mongodb-container

# Check and pull for MongoDB community image if it does not exist
IMAGE_LISTED=$(docker image ls | grep $IMAGE)
if [ -z "$IMAGE_LISTED" ]; then
    echo Image $IMAGE does not exist on device. Pulling now...
    docker pull $IMAGE:$IMAGE_TAG
else
    echo Image $IMAGE already exists on device
fi

# Build container
docker run --name $CONTAINER_NAME -p $DB_PORT:27017 \
-e MONGODB_INITDB_ROOT_USERNAME=$DB_USER \
-e MONGODB_INITDB_ROOT_PASSWORD=$DB_PASSWORD \
-d $IMAGE:$IMAGE_TAG