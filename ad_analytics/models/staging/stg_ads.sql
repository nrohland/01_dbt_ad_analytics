with source as (
    select * from {{ source('raw', 'raw_ads') }}
),

renamed as (
    select
        ad_id,
        campaign_id,
        ad_platform                 as platform,
        ad_type,
        target_gender,
        target_age_group,
        target_interests
    from source
)

select * from renamed