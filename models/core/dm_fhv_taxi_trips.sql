{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *,
        'FHV' as service_type
    from {{ ref('stg_fhv_tripdata') }}
), 
green_tripdata as (
    select *, 
        'Green' as service_type,
        NULL AS dispatching_base_num,
        NULL AS affiliated_base_number,
        NULL AS sr_flag
    from {{ ref('stg_green_tripdata') }}
), 
yellow_tripdata as (
    select *, 
        'Yellow' as service_type,
        NULL AS dispatching_base_num,
        NULL AS affiliated_base_number,
        NULL AS sr_flag
    from {{ ref('stg_yellow_tripdata') }}
), 
trips_unioned as (
    select * from green_tripdata
    UNION ALL 
    select * from yellow_tripdata
    UNION ALL
    (
        SELECT fhv_id AS tripid
            ,NULL AS vendorID
            ,NULL AS ratecodeid
            ,pickup_locationid
            ,dropoff_locationid
            ,pickup_datetime
            ,dropoff_datetime
            ,NULL AS store_and_fwd_flag
            ,NULL AS passenger_count
            ,NULL AS trip_distance
            ,NULL AS trip_type
            ,NULL AS fare_amount
            ,NULL AS extra
            ,NULL AS mta_tax
            ,NULL AS tip_amount
            ,NULL AS tolls_amount
            ,NULL AS ehail_fee
            ,NULL AS improvement_surcharge
            ,NULL AS total_amount
            ,NULL AS payment_type
            ,NULL AS payment_type_description
            ,service_type
            ,dispatching_base_num
            ,affiliated_base_number
            ,sr_flag
        FROM fhv_tripdata
    )
), 
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)
select trips_unioned.tripid, 
    trips_unioned.vendorid, 
    trips_unioned.service_type,
    trips_unioned.ratecodeid, 
    trips_unioned.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    trips_unioned.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    trips_unioned.pickup_datetime, 
    trips_unioned.dropoff_datetime, 
    trips_unioned.store_and_fwd_flag, 
    trips_unioned.passenger_count, 
    trips_unioned.trip_distance, 
    trips_unioned.trip_type, 
    trips_unioned.fare_amount, 
    trips_unioned.extra, 
    trips_unioned.mta_tax, 
    trips_unioned.tip_amount, 
    trips_unioned.tolls_amount, 
    trips_unioned.ehail_fee, 
    trips_unioned.improvement_surcharge, 
    trips_unioned.total_amount, 
    trips_unioned.payment_type, 
    trips_unioned.payment_type_description,
    trips_unioned.dispatching_base_num,
    trips_unioned.affiliated_base_number,
    trips_unioned.sr_flag

from trips_unioned
inner join dim_zones as pickup_zone
on trips_unioned.pickup_locationid = pickup_zone.locationid
inner join dim_zones as dropoff_zone
on trips_unioned.dropoff_locationid = dropoff_zone.locationid