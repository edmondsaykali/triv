select
    question_id,
    question_type,
    question_category,
    question_language,
    question_prompt,
    question_image_url,
    question_options,
    correct_text,
    correct_int,
    min_int,
    max_int,
    is_active_question,
    question_created_at,
    question_difficulty
from {{ ref('stg_questions') }}
