with events as (
    select * from {{ ref('stg_ad_events') }}
),

ads as (
    select * from {{ ref('stg_ads') }}
),

campaigns as (
    select * from {{ ref('stg_campaigns') }}
),

funnel as (
    select
        c.campaign_id,
        c.campaign_name,
        count(case when e.event_type = 'Impression' then 1 end)  as impressions,
        count(case when e.event_type = 'Click'      then 1 end)  as clicks,
        count(case when e.event_type = 'Purchase'   then 1 end)  as purchases,
        round(count(case when e.event_type = 'Click' then 1 end)::double
            / nullif(count(case when e.event_type = 'Impression' then 1 end), 0) * 100, 2) as impression_to_click_rate,
        round(count(case when e.event_type = 'Purchase' then 1 end)::double
            / nullif(count(case when e.event_type = 'Click' then 1 end), 0) * 100, 2)      as click_to_purchase_rate,
        round(count(case when e.event_type = 'Purchase' then 1 end)::double
            / nullif(count(case when e.event_type = 'Impression' then 1 end), 0) * 100, 2) as overall_conversion_rate
    from events e
    left join ads a on e.ad_id = a.ad_id
    left join campaigns c on a.campaign_id = c.campaign_id
    group by c.campaign_id, c.campaign_name
)

select * from funnel