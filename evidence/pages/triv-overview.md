# TRIV Overview

> A comprehensive pulse of matches, players, and daily activity.

```sql kpis
select
    (select count(distinct user_id) from platinur_analytics.mart_player_performance) as total_players,
    (select sum(completed_matches_played)::int from platinur_analytics.mart_daily_player_engagement) as total_matches,
    (select sum(correct_answers)::float / nullif(sum(questions_answered), 0)
     from platinur_analytics.mart_player_performance
     where questions_answered > 0) as overall_accuracy_rate
```

<BigValue data={kpis} value=total_players title="Total Players" />
<BigValue data={kpis} value=total_matches title="Total Matches" />
<BigValue data={kpis} value=overall_accuracy_rate title="Overall Accuracy Rate" fmt="0.0%" />
