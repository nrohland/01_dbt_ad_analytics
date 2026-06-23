with source as (
    select * from {{ source('raw', 'raw_ad_events') }}
),

renamed as (
    select
        event_id,
        ad_id,
        user_id,
        timestamp                   as event_timestamp,
        day_of_week,
        time_of_day,
        event_type
    from source
)

select * from renamed