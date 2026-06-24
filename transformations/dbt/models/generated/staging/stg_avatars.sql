select
    avatar_id,
    name as avatar_name,
    image_url as avatar_image_url,
    active as is_active_avatar
from {{ source('int_20260622144856211900_9c8e639e', 'avatars') }}
