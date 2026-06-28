# By Player View New

Select a player to see their personal match history, accuracy, wins, and key performance trends.

```sql player_opts
select distinct display_name
from platinur_analytics.mart_player_performance
order by 1
```

<Dropdown data={player_opts} name=selected_player value=display_name title="Player"/>

## Selected Player Stats

```sql selected_player_stats
select
    display_name,
    completed_matches_played::int as completed_matches_played,
    match_wins::int as match_wins,
    match_losses::int as match_losses,
    questions_answered::int as questions_answered,
    correct_answers::int as correct_answers,
    questions_served::int as questions_served,
    total_score::float as total_score,
    avg_score::float as avg_score,
    case
        when (match_wins::float + match_losses::float) > 0
        then match_wins::float / (match_wins::float + match_losses::float)
        else null
    end as win_rate,
    case
        when questions_answered::float > 0
        then correct_answers::float / questions_answered::float
        else null
    end as accuracy_rate
from platinur_analytics.mart_player_performance
where display_name = '${inputs.selected_player.value}'
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

## Match Results Breakdown

```sql player_results
select
    player_result,
    count(distinct match_id) as matches
from platinur_analytics.mart_match_players_summary
where display_name = '${inputs.selected_player.value}'
group by 1
order by 2 desc
```

<BarChart data={player_results} x=player_result y=matches/>

## Matches Over Time

```sql player_matches_over_time
select
    date_trunc('month', match_started_at) as match_month,
    count(distinct match_id) as matches
from platinur_analytics.mart_match_players_summary
where display_name = '${inputs.selected_player.value}'
group by 1
order by 1
```

<LineChart data={player_matches_over_time} x=match_month y=matches/>

## Accuracy Trend

```sql player_accuracy_over_time
select
    date_trunc('month', match_started_at) as match_month,
    avg(try_cast(accuracy_rate as float)) as avg_accuracy
from platinur_analytics.mart_match_players_summary
where display_name = '${inputs.selected_player.value}'
    and try_cast(accuracy_rate as float) is not null
group by 1
order by 1
```

<LineChart data={player_accuracy_over_time} x=match_month y=avg_accuracy fmt="0.0%"/>

## Performance by Match Mode

```sql player_mode_stats
select
    match_mode,
    count(distinct match_id) as matches,
    avg(try_cast(score as float)) as avg_score,
    sum(try_cast(win_flag as int))::int as wins
from platinur_analytics.mart_match_players_summary
where display_name = '${inputs.selected_player.value}'
group by 1
order by 2 desc
```

<BarChart data={player_mode_stats} x=match_mode y=matches/>

## Recent Match History

```sql player_match_history
select
    match_started_at,
    match_mode,
    player_result,
    score::int as score,
    misses::int as misses,
    accuracy_rate
from platinur_analytics.mart_match_players_summary
where display_name = '${inputs.selected_player.value}'
order by match_started_at desc
limit 50
```

<DataTable data={player_match_history}>
    <Column id=match_started_at title="Match Started"/>
    <Column id=match_mode title="Mode"/>
    <Column id=player_result title="Result"/>
    <Column id=score title="Score"/>
    <Column id=misses title="Misses"/>
    <Column id=accuracy_rate title="Accuracy" fmt="0.0%"/>
</DataTable>
