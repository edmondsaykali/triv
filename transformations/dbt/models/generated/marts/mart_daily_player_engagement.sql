with all_events as (
    select
        user_id,
        toDate(match_started_at) as activity_date,
        countDistinct(match_id) as completed_matches_played,
        sum(final_score) as score_earned,
        sum(is_winner) as wins,
        count() - sum(is_winner) as losses,
        0 as questions_answered,
        0 as correct_answers,
        0 as questions_served
    from {{ ref('fct_completed_matches') }}
    group by user_id, toDate(match_started_at)

    union all

    select
        user_id,
        toDate(submitted_at) as activity_date,
        0 as completed_matches_played,
        0 as score_earned,
        0 as wins,
        0 as losses,
        count() as questions_answered,
        sum(case when is_correct then 1 else 0 end) as correct_answers,
        0 as questions_served
    from {{ ref('fct_answers') }}
    group by user_id, toDate(submitted_at)

    union all

    select
        user_id,
        toDate(served_at) as activity_date,
        0 as completed_matches_played,
        0 as score_earned,
        0 as wins,
        0 as losses,
        0 as questions_answered,
        0 as correct_answers,
        count() as questions_served
    from {{ ref('fct_question_served') }}
    group by user_id, toDate(served_at)
)
select
    cityHash64(concat(toString(user_id), '|', toString(activity_date))) as player_day_key,
    user_id,
    activity_date,
    sum(completed_matches_played) as completed_matches_played,
    sum(score_earned) as score_earned,
    sum(wins) as wins,
    sum(losses) as losses,
    sum(questions_answered) as questions_answered,
    sum(correct_answers) as correct_answers,
    sum(questions_served) as questions_served
from all_events
group by user_id, activity_date
