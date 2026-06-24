select
    match_id,
    mode as match_mode,
    lobby_id,
    status as match_status,
    winner_user_id,
    ended_reason,
    started_at as match_started_at,
    ended_at as match_ended_at
from {{ source('int_20260622144856211900_9c8e639e', 'matches') }}
