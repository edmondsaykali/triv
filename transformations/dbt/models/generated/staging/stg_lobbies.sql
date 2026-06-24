select
    lobby_id,
    code as lobby_code,
    host_user_id,
    status as lobby_status,
    created_at as lobby_created_at,
    expires_at as lobby_expires_at,
    difficulty as lobby_difficulty,
    categories as lobby_categories,
    language as lobby_language
from {{ source('int_20260622144856211900_9c8e639e', 'lobbies') }}
