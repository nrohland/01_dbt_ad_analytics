with source as (
    select * from {{ source('raw', 'raw_campaigns') }}
),

renamed as (
    select
        campaign_id,
        name                        as campaign_name,
        start_date,
        end_date,
        duration_days,
        total_budget
    from source
)

select * from renamed