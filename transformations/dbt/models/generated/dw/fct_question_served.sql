select
    cityHash64(concat(toString(user_id), '|', toString(question_id), '|', toString(match_id), '|', toString(served_at))) as served_event_id,
    user_id,
    question_id,
    match_id,
    served_at
from {{ ref('stg_question_served') }}
