select
    user_id,
    question_id,
    match_id,
    served_at
from {{ source('int_20260622144856211900_9c8e639e', 'question_served') }}
