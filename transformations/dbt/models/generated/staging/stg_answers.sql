select
    answer_id,
    round_question_id,
    user_id,
    answer_text,
    answer_int,
    submitted_at,
    is_correct,
    distance
from {{ source('int_20260622144856211900_9c8e639e', 'answers') }}
