with match_stats as (
    select
        user_id,
        countDistinct(match_id) as completed_matches_played,
        sum(final_score) as total_score,
        avg(final_score) as avg_score,
        sum(is_winner) as match_wins,
        count() - sum(is_winner) as match_losses
    from {{ ref('fct_completed_matches') }}
    group by user_id
),
answer_stats as (
    select
        user_id,
        count() as questions_answered,
        sum(case when is_correct then 1 else 0 end) as correct_answers
    from {{ ref('fct_answers') }}
    group by user_id
),
served_stats as (
    select
        user_id,
        count() as questions_served
    from {{ ref('fct_question_served') }}
    group by user_id
)
select
    p.user_id as user_id,
    p.display_name as display_name,
    p.avatar_name as avatar_name,
    p.profile_created_at as profile_created_at,
    p.wins as profile_wins,
    p.losses as profile_losses,
    coalesce(ms.completed_matches_played, 0) as completed_matches_played,
    coalesce(ms.total_score, 0) as total_score,
    ms.avg_score as avg_score,
    coalesce(ms.match_wins, 0) as match_wins,
    coalesce(ms.match_losses, 0) as match_losses,
    coalesce(ans.questions_answered, 0) as questions_answered,
    coalesce(ans.correct_answers, 0) as correct_answers,
    coalesce(ss.questions_served, 0) as questions_served
from {{ ref('dim_players') }} p
left join match_stats ms on p.user_id = ms.user_id
left join answer_stats ans on p.user_id = ans.user_id
left join served_stats ss on p.user_id = ss.user_id
