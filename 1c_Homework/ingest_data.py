import pandas as pd
import os
from sqlalchemy import create_engine

os.system(f'wget -O green_taxi.parquet https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-09.parquet')
os.system(f'wget -O zones.csv https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv')

df = pd.read_parquet('green_taxi.parquet')
df_zones = pd.read_csv('zones.csv')

engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')

# load data to postgres in chunks and then its done i guess
df.to_sql('green_taxi', engine, if_exists='replace')
df_zones.to_sql('zones', engine, if_exists='replace')

