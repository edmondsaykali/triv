# By Player View New

Select a player to see their personal match history, accuracy, wins, and key performance trends, or choose **All** to see aggregated results across every player.

```sql player_opts
select 'All' as display_name
union all
select distinct display_name
from platinur_analytics.mart_player_performance
order by 1
```

<Dropdown data={player_opts} name=selected_player value=display_name title="Player"/>

## Selected Player Stats

```sql selected_player_stats
select
    case
        when '${inputs.selected_player.value}' = 'All' then 'All Players'
        else max(display_name)
    end as display_name,
    sum(completed_matches_played)::int as completed_matches_played,
    sum(match_wins)::int as match_wins,
    sum(match_losses)::int as match_losses,
    sum(questions_answered)::int as questions_answered,
    sum(correct_answers)::int as correct_answers,
    sum(questions_served)::int as questions_served,
    sum(total_score)::float as total_score,
    avg(avg_score)::float as avg_score,
    case
        when sum(match_wins::float + match_losses::float) > 0
        then sum(match_wins::float) / sum(match_wins::float + match_losses::float)
        else null
    end as win_rate,
    case
        when sum(questions_answered::float) > 0
        then sum(correct_answers::float) / sum(questions_answered::float)
        else null
    end as accuracy_rate
from platinur_analytics.mart_player_performance
where '${inputs.selected_player.value}' = 'All'
    or display_name = '${inputs.selected_player.value}'
```

<Grid cols="3">
    <BigValue data={selected_player_stats} value=completed_matches_played title="Matches Played"/>
    <BigValue data={selected_player_stats} value=match_wins title="Wins"/>
    <BigValue data={selected_player_stats} value=match_losses title="Losses"/>
    <BigValue data={selected_player_stats} value=win_rate title="Win Rate" fmt="0.0%"/>
    <BigValue data={selected_player_stats} value=accuracy_rate title="Accuracy Rate" fmt="0.0%"/>
    <BigValue data={selected_player_stats} value=total_score title="Total Score"/>
    <BigValue data={selected_player_stats} value=avg_score title="Avg Score" fmt="0.00"/>
    <BigValue data={selected_player_stats} value=questions_answered title="Questions Answered"/>
    <BigValue data={selected_player_stats} value=questions_served title="Questions Served"/>
</Grid>

## Activity Over Time

```sql player_activity_over_time
select
    e.activity_date,
    sum(e.completed_matches_played)::int as matches,
    sum(e.score_earned)::int as score,
    sum(e.wins)::int as wins,
    sum(e.losses)::int as losses
from platinur_analytics.mart_daily_player_engagement as e
inner join platinur_analytics.mart_player_performance as p
    on e.user_id = p.user_id
where '${inputs.selected_player.value}' = 'All'
    or p.display_name = '${inputs.selected_player.value}'
group by 1
order by 1
```

<LineChart data={player_activity_over_time} x=activity_date y=matches title="Matches per Day"/>

## Accuracy Trend

```sql player_accuracy_over_time
select
    e.activity_date,
    case
        when sum(e.questions_answered::float) > 0
        then sum(e.correct_answers::float) / sum(e.questions_answered::float)
        else null
    end as accuracy_rate
from platinur_analytics.mart_daily_player_engagement as e
inner join platinur_analytics.mart_player_performance as p
    on e.user_id = p.user_id
where ('${inputs.selected_player.value}' = 'All'
    or p.display_name = '${inputs.selected_player.value}')
    and e.questions_answered > 0
group by 1
order by 1
```

<LineChart data={player_accuracy_over_time} x=activity_date y=accuracy_rate fmt="0.0%"/>

## Player Leaderboard

```sql player_leaderboard
select
    display_name,
    completed_matches_played::int as completed_matches_played,
    match_wins::int as match_wins,
    match_losses::int as match_losses,
    case
        when (match_wins::float + match_losses::float) > 0
        then match_wins::float / (match_wins::float + match_losses::float)
        else null
    end as win_rate,
    case
        when questions_answered::float > 0
        then correct_answers::float / questions_answered::float
        else null
    end as accuracy_rate,
    total_score::float as total_score,
    avg_score::float as avg_score
from platinur_analytics.mart_player_performance
where '${inputs.selected_player.value}' = 'All'
    or display_name = '${inputs.selected_player.value}'
order by total_score desc
limit 50
```

<DataTable data={player_leaderboard}>
    <Column id=display_name title="Player"/>
    <Column id=completed_matches_played title="Matches"/>
    <Column id=match_wins title="Wins"/>
    <Column id=match_losses title="Losses"/>
    <Column id=win_rate title="Win Rate" fmt="0.0%"/>
    <Column id=accuracy_rate title="Accuracy" fmt="0.0%"/>
    <Column id=total_score title="Total Score"/>
    <Column id=avg_score title="Avg Score" fmt="0.00"/>
</DataTable>
