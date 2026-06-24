with date_bounds as (
    select
        least(
            min(match_started_at),
            min(match_ended_at),
            min(lobby_created_at)
        ) as min_date,
        greatest(
            max(match_started_at),
            max(match_ended_at),
            max(lobby_created_at)
        ) as max_date
    from {{ ref('fct_lobby_outcomes') }}
)
select
    toDate(arrayJoin(range(toUInt32(toDate(min_date)), toUInt32(toDate(max_date)) + 1))) as date_day,
    cityHash64(toString(toDate(arrayJoin(range(toUInt32(toDate(min_date)), toUInt32(toDate(max_date)) + 1))))) as time_spine_key
from date_bounds
