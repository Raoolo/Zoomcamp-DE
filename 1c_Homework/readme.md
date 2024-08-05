# Answer document
Original question document https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2024/01-docker-terraform/homework.md
## Question 1. Knowing docker tags: --rm

## Question 2. Understanding docker first run

In the dockerfile put the right commands to run
docker build -t temp_image:v1
docker run -it temp_image:v1
pip list
23.0.1

## Question 3. Count records

Create a postgre container from the existing image 'postgres:13':
docker run -it -d --name postgre_container \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
postgres:13

Then create an ingest_data.py script to download data and push it to postgre container

Then: pgcli -h localhost -u root -d ny_taxi

Finally: 
SELECT COUNT(*) 
FROM green_taxi
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
AND DATE(lpep_dropoff_datetime) = '2019-09-18';

Second option:
Run the docker-compose file instead, with postgreqsl and pgadmin 
docker-compose up -d

if it does not work it's because you have to give permissions to the folders: sudo chmod -R 777 folder_name

Run the ingest_data.py if you havent already pushed the data to postgresql

go to localhost:8080 and login with admin@admin.com and pw password
Register the server with the local database and run the sql prompts

SELECT COUNT(*) 
FROM green_taxi
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
AND DATE(lpep_dropoff_datetime) = '2019-09-18';

Solution: 15612


## Question 4. Longest trip for each day

This is a bad solution btw because if you have more than one trip with the same distance it fucks up
SELECT DATE(t1.lpep_pickup_datetime) 
FROM green_taxi t1
WHERE t1.trip_distance = (SELECT MAX(t2.trip_distance)
						FROM green_taxi t2)

OR

SELECT 
	CAST(lpep_pickup_datetime AS date) as pu_date,
	trip_distance
	
FROM 
	green_taxi_trips
ORDER BY trip_distance DESC
LIMIT(10);

OR

SELECT 
	CAST(lpep_pickup_datetime AS date) as pu_date,
	MAX(trip_distance) as max_trip_dist
	
FROM 
	green_taxi_trips
GROUP BY CAST(lpep_pickup_datetime AS date)	
ORDER BY max_trip_dist DESC
LIMIT(10);

but i think this is overengineered tbh lol

Answer
"date"	"trip_distance"
"2019-09-26"	341.64

## Question 5. The number of passengers

SELECT gt.lpep_pickup_datetime::date, z."Borough", SUM(total_amount)
FROM green_taxi gt JOIN zones z ON gt."PULocationID" = z."LocationID"
WHERE lpep_pickup_datetime::date = '2019-09-18'
AND z."Borough" IS NOT NULL
GROUP BY z."Borough", gt.lpep_pickup_datetime::date
HAVING SUM(total_amount) > 50000
ORDER BY SUM(total_amount) DESC
LIMIT 3

"lpep_pickup_datetime"	"Borough"	"sum"
"2019-09-18"	"Brooklyn"	96333.23999999936
"2019-09-18"	"Manhattan"	92271.29999999845
"2019-09-18"	"Queens"	78671.709999999

## Question 6. Largest tip

SELECT z."Zone", gt."DOLocationID", gt.tip_amount
FROM green_taxi gt
JOIN zones z ON gt."DOLocationID" = z."LocationID"
JOIN zones z1 ON gt."PULocationID" = z1."LocationID"
WHERE z1."Zone" = 'Astoria'
AND EXTRACT(MONTH FROM gt.lpep_pickup_datetime) = 9
ORDER BY gt.tip_amount DESC
LIMIT 1;

"Zone"	"DOLocationID"	"tip_amount"
"JFK Airport"	132	62.31