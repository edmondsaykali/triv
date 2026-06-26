# Match & Player Activity Overview

## Key Metrics

```sql kpis
select
    (select count(distinct user_id) from platinur_analytics.mart_player_performance) as total_players,
    (select sum(completed_matches_played) from platinur_analytics.mart_player_performance) as total_matches,
    (select sum(questions_answered) from platinur_analytics.mart_player_performance) as total_questions_answered,
    (select sum(correct_answers)::float / nullif(sum(questions_answered), 0)
     from platinur_analytics.mart_player_performance
     where questions_answered > 0) as overall_accuracy_rate
from platinur_analytics.mart_player_performance
limit 1
```

<Grid cols="3">
    <BigValue data={kpis} value=total_players title="Total Players" />
    <BigValue data={kpis} value=total_matches title="Total Matches" />
    <BigValue data={kpis} value=total_questions_answered title="Questions Answered" />
    <BigValue data={kpis} value=overall_accuracy_rate title="Overall Accuracy Rate" fmt="0.0%" />
</Grid>

## Players Over Time

```sql players_over_time
select
    date_trunc('day', profile_created_at) as profile_date,
    count(distinct user_id) as new_players
from platinur_analytics.mart_player_performance
where profile_created_at is not null
group by 1
order by 1
```

<LineChart data={players_over_time} x=profile_date y=new_players />

## Daily Activity

```sql daily_activity
select
    activity_date,
    sum(completed_matches_played) as matches_played,
    sum(questions_answered) as questions_answered,
    sum(correct_answers) as correct_answers
from platinur_analytics.mart_daily_player_engagement
group by 1
order by 1
```

<LineChart data={daily_activity} x=activity_date y=matches_played title="Matches Played per Day" />
<LineChart data={daily_activity} x=activity_date y=questions_answered title="Questions Answered per Day" />

## Top Players by Wins & Accuracy

```sql top_players
select
    display_name,
    cast(match_wins as integer) as wins,
    case when questions_answered > 0
        then round(cast(correct_answers as double) / cast(questions_answered as double), 4)
        else 0
    end as accuracy_rate
from platinur_analytics.mart_player_performance
where completed_matches_played > 0 and questions_answered > 0
order by wins desc, accuracy_rate desc
limit 20
```

<DataTable data={top_players}>
    <Column id=display_name title="Player" />
    <Column id=wins title="Wins" />
    <Column id=accuracy_rate title="Accuracy Rate" fmt="0.0%" />
</DataTable>
