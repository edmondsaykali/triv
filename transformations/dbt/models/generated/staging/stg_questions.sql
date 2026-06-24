select
    question_id,
    type as question_type,
    category as question_category,
    language as question_language,
    prompt as question_prompt,
    image_url as question_image_url,
    options as question_options,
    correct_text,
    correct_int,
    min_int,
    max_int,
    active as is_active_question,
    created_at as question_created_at,
    difficulty as question_difficulty
from {{ source('int_20260622144856211900_9c8e639e', 'questions') }}
