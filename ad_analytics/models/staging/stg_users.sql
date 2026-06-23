with source as (
    select * from {{ source('raw', 'raw_users') }}
),

renamed as (
    select
        user_id,
        user_gender                 as gender,
        user_age                    as age,
        age_group,
        country,
        location,
        interests
    from source
)

select * from renamed