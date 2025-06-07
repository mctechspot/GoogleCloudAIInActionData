# Load environment variables
set -o allexport
source .env set
+o allexport

# Import orbit class data into mongo database
mongoimport --uri="mongodb://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?authSource=admin" \
  --collection $COLLECTION_ORBIT_CLASS_TYPES \
  --type json \
  --file ./Data/orbit_class_types.json
  
# Import asteroid data into mongodb database
mongoimport --uri="mongodb://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME?authSource=admin" \
  --collection $COLLECTION_ASTEROIDS \
  --type json \
  --file ./Data/asteroids.json