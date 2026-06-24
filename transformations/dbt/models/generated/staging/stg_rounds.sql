select
    round_id,
    match_id,
    round_number,
    winner_user_id as round_winner_user_id,
    step2_used as is_step2_used,
    summary_ends_at as round_summary_ends_at,
    created_at as round_created_at
from {{ source('int_20260622144856211900_9c8e639e', 'rounds') }}
