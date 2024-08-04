# POSTGRES CONTAINER ON NETWORK
docker run -it -d \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
postgres:13

# To interact with the database through pgcli, run the following command:
pgcli -h localhost -u root -d ny_taxi
# pw: root
# if there are no tables (\dt), run the notebook yellow_taxis.ipynb to create the tables