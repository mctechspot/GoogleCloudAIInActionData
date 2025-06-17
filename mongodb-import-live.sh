#!/bin/bash

# Load environment variables
set -o allexport
source .env
set +o allexport

# Import orbit class data into mongo database
mongoimport --uri=$LIVE_MONGODB_CONNECTION_STRING \
  --collection $COLLECTION_ORBIT_CLASS_TYPES \
  --type json \
  --file ./Data/orbit_class_types.json
  
# Import asteroid data into mongodb database
mongoimport --uri=$LIVE_MONGODB_CONNECTION_STRING \
  --collection $COLLECTION_ASTEROIDS \
  --type json \
  --file ./Data/asteroids.json