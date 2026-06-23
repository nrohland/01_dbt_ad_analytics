with events as (
    select * from {{ ref('stg_ad_events') }}
),

ads as (
    select * from {{ ref('stg_ads') }}
),

campaigns as (
    select * from {{ ref('stg_campaigns') }}
),

users as (
    select * from {{ ref('stg_users') }}
),

final as (
    select
        c.campaign_id,
        c.campaign_name,
        c.total_budget,
        a.ad_id,
        a.platform          as ad_platform,
        a.ad_type,
        u.user_id,
        u.gender            as user_gender,
        u.age_group         as user_age_group,
        u.country           as user_country,
        e.event_id,
        e.event_type
    from events e
    left join ads a         on e.ad_id = a.ad_id
    left join campaigns c   on a.campaign_id = c.campaign_id
    left join users u       on e.user_id = u.user_id
)

select * from final