{{ config(materialized='table') }}

select 
    locationid, 
    borough, 
    zone, 
    -- everything that is boro is for green taxis so we clean it already
    replace(service_zone,'Boro','Green') as service_zone 
from {{ ref('taxi_zone_lookup') }}