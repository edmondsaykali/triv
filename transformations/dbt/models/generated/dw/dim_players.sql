select
    p.user_id,
    p.display_name,
    p.avatar_id,
    a.avatar_name,
    p.wins,
    p.losses,
    p.profile_created_at,
    p.profile_updated_at
from {{ ref('stg_profiles') }} p
left join {{ ref('stg_avatars') }} a on p.avatar_id = a.avatar_id
