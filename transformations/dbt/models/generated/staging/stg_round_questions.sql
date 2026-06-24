select
    round_question_id,
    round_id,
    step as question_step,
    question_id,
    starts_at as round_question_starts_at,
    ends_at as round_question_ends_at,
    resolved_at as round_question_resolved_at,
    winner_user_id as round_question_winner_user_id
from {{ source('int_20260622144856211900_9c8e639e', 'round_questions') }}
