-- Step 1: Define a source CTE (Common Table Expression) that pulls data from the 'green_tripdata' table in the 'staging' schema.
with 

source as (

    -- Selecting all columns from the 'green_tripdata' table.
    select * from {{ source('staging', 'green_tripdata') }}

),

-- Step 2: Define a renamed CTE that selects and renames (if necessary) the columns from the source CTE.
renamed as (

    select
        vendorid,
        lpep_pickup_datetime,
        lpep_dropoff_datetime,
        store_and_fwd_flag,
        ratecodeid,
        passenger_count,
        trip_distance,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        ehail_fee,
        airport_fee,
        total_amount,
        payment_type,
        {{ get_payment_type_description('payment_type') }} as payment_type_description,
        distance_between_service,
        time_between_service,
        trip_type,
        improvement_surcharge,
        pulocationid,
        dolocationid,
        data_file_year,
        data_file_month

    from source

)

-- Step 3: Final selection of all columns from the renamed CTE.
select * from renamed