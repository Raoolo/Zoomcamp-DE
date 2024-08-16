-- a quick way to write this is writing double underscore __ which opens many Jinja blocks
-- by default everything is a view if you dont write this
{{ config(materialized="view") }} 

-- Create a CTE (Common Table Expression) named `tripdata` which selects all columns from the source table `green_tripdata` 
-- and assigns a row number (`rn`) to each row, partitioned by `vendorid` and `lpep_pickup_datetime`.
with tripdata as (
    select *, row_number() over (partition by vendorid, lpep_pickup_datetime) as rn
    from {{ source("staging", "green_tripdata") }}
    where vendorid is not null
)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    {{ dbt.safe_cast("vendorid", api.Column.translate_type("integer")) }} as vendorid,
    {{ dbt.safe_cast("ratecodeid", api.Column.translate_type("integer")) }} as ratecodeid,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,

    -- timestamps
    cast(lpep_pickup_datetime as timestamp) as pickup_datetime,
    cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    store_and_fwd_flag,     -- means no conversion
    {{ dbt.safe_cast("passenger_count", api.Column.translate_type("integer")) }} as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    {{ dbt.safe_cast("trip_type", api.Column.translate_type("integer")) }} as trip_type,


    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(ehail_fee as numeric) as ehail_fee,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    -- Convert `payment_type` to an integer, replacing null values with 0, and alias it as `payment_type`
    coalesce({{ dbt.safe_cast("payment_type", api.Column.translate_type("integer")) }},0) as payment_type,
    -- Get a human-readable description for `payment_type` and alias it as `payment_type_description`
    {{ get_payment_type_description("payment_type") }} as payment_type_description

from tripdata

-- Only select rows where the row number (`rn`) is 1, ensuring unique rows per `vendorid` and `lpep_pickup_datetime` (take out duplicates)
where rn = 1

-- If the model is being run as a test, limit the number of rows returned to 100.
-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var("is_test_run", default=true) %} 
-- call the variable is_test_run and it's adding a default value=true if nothing is passed
    limit 100 
{% endif %}
