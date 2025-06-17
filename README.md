# Google Cloud AI In Action Data
This repository hosts the source code to prepare asteroid data for the MongoDB challenge of the Google Cloud AI in Action Hackathon of June 2025. This project focuses on using MongoDB to store asteroid data for powerful search which is later used in the [application part of this project](https://github.com/mctechspot/GoogleCloudAIInActionApp) to generate detailed PDF reports using Google Gemini.
 
This repository provides the instructions to set up MongoDB, prepare the asteroid data and import the data into the database.

## A Huge Thank You to our Data Contributors
Immense gratitude is extened to the contributors of this rich [asteroid dataset](https://www.kaggle.com/datasets/gauravkumar2525/asteroids-dataset) that we use in this source code. The data is valid as it comes from NASA’s databases, including the Jet Propulsion Laboratory (JPL) and the Minor Planet Center (MPC).

Download the zip file and extract the file called **asteroid_data.csv**.

## Environment Set-up
Ensure that [git](https://git-scm.com/downloads) is installed on your device.

Ensure that [Python (version 3.9.0 or above)](https://www.python.org/downloads/) is installed on your device.

Enter a safe directory on your device.
```
cd <PATH-TO-SAFE-DIRECTORY>
```

Clone this repository in the safe directory.
```
git clone https://github.com/mctechspot/GoogleCloudAIInActionData
```

Enter root directory of repository.
```
cd <PATH-TO-SAFE-DIRECTORY>/GoogleCloudAIInActionData
```

Create a Python virtual environment.
```
python3 -m venv .venv
```

Activate virtual environment.
```
source .venv/bin/activate
```

Install requisite libraries.
```
pip3 install -r requirements.txt
```

## Establish MongoDB database
Pull MongoDB community server docker image.
```
docker pull mongodb/mongodb-community-server:latest
```

Confirm that MongoDB Community Server docker image was successfully pulled. 
```
docker image ls | grep mongodb
```

The output should list the image as follows.
```
mongodb/mongodb-community-server   latest    <IMAGE_ID>   <CREATED>   1.74GB
``` 

Run mongodb as a container. The internal port used by the MongoDB container is 27017. However, you may choose to map any local port to the container if the local port 27017 is in use for something else.

Establish authentication variables for the database. You determine the values fo the following variables
```
DB_USER="Choose_an_appropriate_database_username"
DB_PASSWORD="Choose_an_appropriate_database_password"
DB_PORT=Choose_an_appropriate_database_local_port_number
```

Run the MongoDB container with the appropriate credentials that you have chosen.
```
docker run --name mongodb -p <DB_PORT>:27017 \
-e MONGODB_INITDB_ROOT_USERNAME=<DB_USER> \
-e MONGODB_INITDB_ROOT_PASSWORD=<DB_PASSWORD> \
-d mongodb/mongodb-community-server:latest
```

Alternatively, there is a single shell script called build-mongo-db-container.sh, that you may execute to pull the MongoDB image as well as to build the container so long as you have specified the environment variables in a .env file.
```
bash build-mongodb-container.sh
```

Ensure that the MongoDB container is running.
```
docker ps | grep mongodb
```

The output should look like this. Pay close attention to the status. It should say **Up**.
```
<CONTAINER_ID>   mongodb/mongodb-community-server:latest   "python3 /usr/local/…"   <CREATED_AT>      Up <UP_TIME>    0.0.0.0:<DB_PORT>->27017/tcp   mongodb-container
```

Enter the container to interact with the MongoDB command line.
```
docker exec -it mongodb bash
```

Inside the container, connect to the database.
```
mongosh --port <DB_PORT> -u <DB_USER> -p <DB_PASSWORD> --authenticationDatabase admin
```

You should by default be logged into the admin database. Create a new database called asteroids.
```
use asteroids
```

You will be switched to the database called asteroids. If you type the command ``show dbs`` to see the existing dbs, the  asteroids database will not be listed. A database is only listed when it is populated. We are about to do that now.

## Prepare Data
Download the requisite data at this [link](https://www.kaggle.com/datasets/gauravkumar2525/asteroids-dataset). Extract the **asteroid_data.csv** file and store it in a safe directory on your device.

Create a .env file to store secrets.
```
touch .env

chmod 744 .env
```

Add relevant variables to .env file. Check the .env.example file to see the relevant variables that need to be added
```
DATA_PATH=<path_to_aseroids_data_csv_file>
DB_HOST=0.0.0.0
DB_USER=<Database_user> # DB_USER defined when running MongoDB container
DB_PASSWORD=<Database_password> # DB_PASSWORD defined when running MongoDB container
DB_NAME=<Database_name> # asteroids
DB_PORT=<Database_port> # DB_PORT defined when running MongoDB container
COLLECTION_ORBIT_CLASS_TYPES="orbit_class_types"
COLLECTION_ASTEROIDS="asteroids"
```

Execute the bash script that runs the data_preparation.ipynb file to generate the data.
```
bash data_generation.sh
```

Two JSON files should be generated in a directory called data.
```
- \data
    - aseroids.json
    - orbit_class_types.json
```

## Run Database Locally
Once the JSON files have been generated, it is time to import them to the local database with the mongodb-import-local.sh script.
```
bash mongodb-import-local.sh
```

The output should show that data was imported into the orbit_class_types and asteroids collection of the asteroids database.
```
connected to: mongodb://[**REDACTED**]@0.0.0.0:<DB_PORT>/asteroids?authSource=admin
<TIMESTAMP>    4 document(s) imported successfully. 0 document(s) failed to import.
<TIMESTAMP>    connected to: mongodb://[**REDACTED**]@0.0.0.0:<DB_PORT>/asteroids?authSource=admin
<TIMESTAMP>    7100 document(s) imported successfully. 0 document(s) failed to import.
```

## Deploy Live Database
Create a [MongoDB account](https://mongodb.com) as you will need to utilise MongoDB Atlas to save data in the cloud.

Create a free cluster, selecting the Google Cloud provider.

Upon creating a cluster, you will be provided with a URI connection string to access the database. In the .env file of this repository, save this string in a variable called **LIVE_MONGODB_CONNECTION_STRING**.

Execute the following script to load all the data to your live MongoDB cluster. This command will execute the mongodb-import-live.sh script to import the data to the live cluster.
```
bash mongodb-import-live.sh
```

Remember to save this connection string as you will need to reuse it as an environment variable called **MONGO_DB_CONNECTION_URI** in the Cloud Run deployment for the application part of this project. You may find the source code accompanied with a README file containing detailed instructions to execute the application at the [GoogleCloudAIInActionApp repository](https://github.com/mctechspot/GoogleCloudAIInActionApp).