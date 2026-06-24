select
    user_id,
    display_name,
    avatar_id,
    wins,
    losses,
    created_at as profile_created_at,
    updated_at as profile_updated_at
from {{ source('int_20260622144856211900_9c8e639e', 'profiles') }}
