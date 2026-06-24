select
    mp.match_id as match_id,
    m.match_mode as match_mode,
    m.lobby_id as lobby_id,
    m.match_status as match_status,
    m.winner_user_id as match_winner_user_id,
    m.ended_reason as ended_reason,
    m.match_started_at as match_started_at,
    m.match_ended_at as match_ended_at,
    dateDiff('second', m.match_started_at, m.match_ended_at) as match_duration_seconds,
    mp.user_id as user_id,
    mp.seat as seat,
    mp.final_score as final_score,
    mp.is_connected as is_connected,
    mp.match_joined_at as match_joined_at,
    mp.misses as misses,
    case when mp.user_id = m.winner_user_id then 1 else 0 end as is_winner
from {{ ref('stg_matches') }} m
inner join {{ ref('stg_match_players') }} mp on m.match_id = mp.match_id
where m.match_status = 'ended'
