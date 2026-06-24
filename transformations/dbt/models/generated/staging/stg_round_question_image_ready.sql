select
    round_question_id,
    user_id,
    ready_at
from {{ source('int_20260622144856211900_9c8e639e', 'round_question_image_ready') }}
