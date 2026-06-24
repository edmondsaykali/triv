with answer_stats as (
    select
        question_id,
        count() as times_answered,
        sum(case when is_correct then 1 else 0 end) as correct_answers,
        avg(distance) as avg_distance
    from {{ ref('fct_answers') }}
    group by question_id
),
served_stats as (
    select
        question_id,
        count() as times_served
    from {{ ref('fct_question_served') }}
    group by question_id
)
select
    q.question_id as question_id,
    q.question_type as question_type,
    q.question_category as question_category,
    q.question_language as question_language,
    q.question_difficulty as question_difficulty,
    q.question_created_at as question_created_at,
    coalesce(s.times_served, 0) as times_served,
    coalesce(a.times_answered, 0) as times_answered,
    coalesce(a.correct_answers, 0) as correct_answers,
    case when a.times_answered > 0 then a.correct_answers / a.times_answered else null end as accuracy_rate,
    a.avg_distance as avg_distance
from {{ ref('dim_questions') }} q
left join answer_stats a on q.question_id = a.question_id
left join served_stats s on q.question_id = s.question_id
