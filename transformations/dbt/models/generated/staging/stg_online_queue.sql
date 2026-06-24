select
    user_id,
    queued_at,
    match_id,
    matched_at
from {{ source('int_20260622144856211900_9c8e639e', 'online_queue') }}
