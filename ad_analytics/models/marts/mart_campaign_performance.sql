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
        coalesce(e.impressions, 0)                                      as impressions,
        coalesce(e.clicks, 0)                                           as clicks,
        coalesce(e.purchases, 0)                                        as purchases,
        coalesce(e.engagements, 0)                                      as engagements,
        round(coalesce(e.clicks, 0)::double / nullif(coalesce(e.impressions, 0), 0) * 100, 2)      as ctr,
        round(coalesce(e.purchases, 0)::double / nullif(coalesce(e.clicks, 0), 0) * 100, 2)        as conversion_rate,
        round(coalesce(e.engagements, 0)::double / nullif(coalesce(e.impressions, 0), 0) * 100, 2) as engagement_rate,
        case
            when coalesce(e.impressions, 0) = 0 then 'No Events'
            else 'Active'
        end                                                             as campaign_status
    from campaigns c
    left join ads_per_campaign a on c.campaign_id = a.campaign_id
    left join events_per_campaign e on c.campaign_id = e.campaign_id
)

select * from final