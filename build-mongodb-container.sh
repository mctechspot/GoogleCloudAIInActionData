#!/bin/bash

# Export .env variables
set -o allexport
source .env
set +o allexport

# Set variables for container
CONTAINER_NAME=mongodb-container
IMAGE_NAME=mongodb/mongodb-community-server
IMAGE_TAG=latest

# Build container
docker run --name $CONTAINER_NAME -p $DB_PORT:27017 \
-e MONGODB_INITDB_ROOT_USERNAME=$DB_USER \
-e MONGODB_INITDB_ROOT_PASSWORD=$DB_PASSWORD \
-d $IMAGE_NAME:$IMAGE_TAG