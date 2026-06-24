select
    a.answer_id,
    a.round_question_id,
    rq.round_id,
    r.match_id,
    a.user_id,
    rq.question_id,
    a.answer_text,
    a.answer_int,
    a.submitted_at,
    a.is_correct,
    a.distance,
    rq.question_step,
    rq.round_question_starts_at,
    rq.round_question_ends_at,
    rq.round_question_resolved_at,
    m.match_status,
    case when m.match_status = 'ended' then 1 else 0 end as is_completed_match
from {{ ref('stg_answers') }} a
inner join {{ ref('stg_round_questions') }} rq on a.round_question_id = rq.round_question_id
inner join {{ ref('stg_rounds') }} r on rq.round_id = r.round_id
left join {{ ref('stg_matches') }} m on r.match_id = m.match_id
