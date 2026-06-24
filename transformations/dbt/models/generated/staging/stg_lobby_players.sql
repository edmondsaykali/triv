select
    lobby_id,
    user_id,
    joined_at as lobby_joined_at
from {{ source('int_20260622144856211900_9c8e639e', 'lobby_players') }}
