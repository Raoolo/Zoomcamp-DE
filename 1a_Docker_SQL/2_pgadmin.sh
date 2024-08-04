# btw all these things are copied and pasted into the wsl terminal
# CREATE A NETWORK, without network each of the containers will be isolated and won't be able to communicate with each other
docker network create pg-network

# POSTGRES CONTAINER ON NETWORK, call it pg-database for pgadmin to connect to
docker run -it -d \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
postgres:13
# postgres:13 is the image name from Docker Hub 

# PGADMIN CONTAINER ON NETWORK, pgadmin4 is a web interface for postgres that can be accessed on localhost:8080
docker run -it -d \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="password" \
    -p 8080:80 \
    --network=pg-network \
    --name pgadmin \
dpage/pgadmin4
# dpage/admin4 is the image name from Docker Hub


# To run the ingest_data.py script, run the following command:
python ingest-data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --data_table_name=yellow_taxi_trips \
    --lookup_table_name=zones \
    --data_url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet" \
    --lookup_url="https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv"


# build the docker image called taxi_ingest:v001 
docker build -t taxi_ingest:v001 .

# in the command below the network parameter is passed to docker and the rest of the parameters are passed to the taxi_ingest script
# ingest-data.py will be executed in the taxi_ingest:v001 container and the data files will be downloaded there
docker run -it \
    --network=pg-network \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pg-database \
        --port=5432 \
        --db=ny_taxi \
        --data_table_name=yellow_taxi_trips \
        --lookup_table_name=zones \
        --data_url="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet" \
        --lookup_url="https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv"