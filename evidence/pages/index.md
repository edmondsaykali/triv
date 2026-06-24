# Match & Player Activity Overview

## Key Metrics

```sql kpis
select
    (select count(distinct match_id) from platinur_analytics.mart_matches_summary) as total_matches,
    (select count(distinct user_id) from platinur_analytics.mart_match_players_summary) as total_players,
    (select count(distinct match_id) from platinur_analytics.mart_matches_summary where cast(match_started_at as date) = current_date) as matches_today,
    (select count(distinct match_id) from platinur_analytics.mart_matches_summary where match_started_at >= date_trunc('week', current_date)) as matches_this_week,
    (select sum(correct_count)::float / nullif(sum(answer_count), 0)
     from platinur_analytics.mart_match_players_summary
     where answer_count > 0) as overall_accuracy_rate,
    (select count(*)::float / nullif((select count(*) from platinur_analytics.mart_matches_summary), 0)
     from platinur_analytics.mart_matches_summary
     where ended_reason = 'normal') as normal_finish_rate
from platinur_analytics.mart_matches_summary
limit 1
```

<Grid cols="3">
    <BigValue data={kpis} value=total_matches title="Total Matches" />
    <BigValue data={kpis} value=total_players title="Total Players" />
    <BigValue data={kpis} value=matches_today title="Matches Today" />
    <BigValue data={kpis} value=matches_this_week title="Matches This Week" />
    <BigValue data={kpis} value=overall_accuracy_rate title="Overall Accuracy Rate" fmt="0.0%" />
    <BigValue data={kpis} value=normal_finish_rate title="Normal Finish Rate" fmt="0.0%" />
</Grid>

## Matches Over Time

```sql matches_over_time
select
    date_trunc('day', match_started_at) as match_date,
    count(distinct match_id) as matches
from platinur_analytics.mart_matches_summary
group by 1
order by 1
```

<LineChart data={matches_over_time} x=match_date y=matches />

## Matches by Mode

```sql matches_by_mode
select
    match_mode,
    count(distinct match_id) as matches
from platinur_analytics.mart_matches_summary
group by 1
order by 2 desc
```

<BarChart data={matches_by_mode} x=match_mode y=matches />

## End-Reason Breakdown

```sql end_reason_breakdown
select
    ended_reason,
    count(distinct match_id) as matches
from platinur_analytics.mart_matches_summary
group by 1
order by 2 desc
```

<ECharts
    config={{
        tooltip: { trigger: 'item' },
        series: [{
            type: 'pie',
            radius: ['40%', '70%'],
            data: end_reason_breakdown.map(row => ({ name: row.ended_reason, value: row.matches }))
        }]
    }}
/>

## Top Players by Wins & Accuracy

```sql top_players
select
    display_name,
    derived_wins as wins,
    accuracy_rate
from platinur_analytics.mart_profiles_summary
where completed_match_count > 0 and accuracy_rate is not null
order by derived_wins desc, accuracy_rate desc
limit 20
```

<DataTable data={top_players}>
    <Column id=display_name title="Player" />
    <Column id=wins title="Wins" />
    <Column id=accuracy_rate title="Accuracy Rate" fmt="0.0%" />
</DataTable>

## Player Accuracy Distribution

```sql accuracy_distribution
select
    accuracy_rate
from platinur_analytics.mart_profiles_summary
where completed_match_count > 0 and accuracy_rate is not null
```

<Histogram data={accuracy_distribution} x=accuracy_rate title="Distribution of Player Accuracy Rates" />
