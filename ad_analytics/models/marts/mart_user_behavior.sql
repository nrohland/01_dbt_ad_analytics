with users as (
    select * from {{ ref('stg_users') }}
),

events as (
    select * from {{ ref('stg_ad_events') }}
),

purchases as (
    select * from events
    where event_type = 'Purchase'
),

final as (
    select
        u.country,
        u.gender,
        u.age_group,
        u.interests,
        e.day_of_week,
        e.time_of_day,
        count(e.event_id)               as total_purchases
    from purchases e
    left join users u on e.user_id = u.user_id
    group by
        u.country,
        u.gender,
        u.age_group,
        u.interests,
        e.day_of_week,
        e.time_of_day
)

select * from final