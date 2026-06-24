with dates as (
    select distinct toDate(lobby_created_at) as activity_date
    from {{ ref('fct_lobby_outcomes') }}
    union distinct
    select distinct toDate(match_started_at)
    from {{ ref('fct_lobby_outcomes') }}
    where linked_match_id is not null
    union distinct
    select distinct toDate(match_ended_at)
    from {{ ref('fct_lobby_outcomes') }}
    where has_completed_match = 1
),
created as (
    select toDate(lobby_created_at) as activity_date, count() as lobbies_created
    from {{ ref('fct_lobby_outcomes') }}
    group by toDate(lobby_created_at)
),
started as (
    select toDate(match_started_at) as activity_date, countDistinct(linked_match_id) as matches_started
    from {{ ref('fct_lobby_outcomes') }}
    where linked_match_id is not null
    group by toDate(match_started_at)
),
finished as (
    select toDate(match_ended_at) as activity_date, countDistinct(linked_match_id) as matches_finished
    from {{ ref('fct_lobby_outcomes') }}
    where has_completed_match = 1
    group by toDate(match_ended_at)
)
select
    cityHash64(toString(d.activity_date)) as activity_date_key,
    d.activity_date as activity_date,
    coalesce(c.lobbies_created, 0) as lobbies_created,
    coalesce(s.matches_started, 0) as matches_started,
    coalesce(f.matches_finished, 0) as matches_finished
from dates d
left join created c on d.activity_date = c.activity_date
left join started s on d.activity_date = s.activity_date
left join finished f on d.activity_date = f.activity_date
