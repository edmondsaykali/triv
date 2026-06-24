select
    l.lobby_id,
    l.lobby_code,
    l.host_user_id,
    l.lobby_status,
    l.lobby_created_at,
    l.lobby_expires_at,
    l.lobby_difficulty,
    l.lobby_categories,
    l.lobby_language,
    m.match_id as linked_match_id,
    m.match_status as linked_match_status,
    m.match_started_at,
    m.match_ended_at,
    case when m.match_id is not null then 1 else 0 end as has_match,
    case when m.match_status = 'ended' then 1 else 0 end as has_completed_match
from {{ ref('stg_lobbies') }} l
left join {{ ref('stg_matches') }} m on l.lobby_id = m.lobby_id
