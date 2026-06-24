select
    match_id,
    user_id,
    seat,
    score as final_score,
    connected as is_connected,
    joined_at as match_joined_at,
    misses
from {{ source('int_20260622144856211900_9c8e639e', 'match_players') }}
