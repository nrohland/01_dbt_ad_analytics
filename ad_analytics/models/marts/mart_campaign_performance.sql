with campaigns as (
    select * from {{ ref('stg_campaigns') }}
),

ads as (
    select * from {{ ref('stg_ads') }}
),

events as (
    select * from {{ ref('stg_ad_events') }}
),

ads_per_campaign as (
    select
        campaign_id,
        count(distinct ad_id) as total_ads
    from ads
    group by campaign_id
),

events_per_campaign as (
    select
        a.campaign_id,
        count(case when e.event_type = 'Impression' then 1 end)  as impressions,
        count(case when e.event_type = 'Click'      then 1 end)  as clicks,
        count(case when e.event_type = 'Purchase'   then 1 end)  as purchases,
        count(case when e.event_type in ('Like', 'Share', 'Comment') then 1 end) as engagements
    from events e
    left join ads a on e.ad_id = a.ad_id
    group by a.campaign_id
),

final as (
    select
        c.campaign_id,
        c.campaign_name,
        c.start_date,
        c.end_date,
        c.duration_days,
        c.total_budget,
        a.total_ads,
        e.impressions,
        e.clicks,
        e.purchases,
        e.engagements,
        round(e.clicks::double / nullif(e.impressions, 0) * 100, 2)    as ctr,
        round(e.purchases::double / nullif(e.clicks, 0) * 100, 2)      as conversion_rate,
        round(e.engagements::double / nullif(e.impressions, 0) * 100, 2) as engagement_rate
    from campaigns c
    left join ads_per_campaign a on c.campaign_id = a.campaign_id
    left join events_per_campaign e on c.campaign_id = e.campaign_id
)

select * from final