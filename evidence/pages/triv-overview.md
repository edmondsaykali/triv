# TRIV Overview

> A high-level pulse of matches and player performance.

```sql kpis
select
    sum(completed_matches_played) as total_matches,
    sum(match_wins) as total_wins,
    sum(match_losses) as total_losses
from platinur_analytics.mart_player_performance
```

<BigValue data={kpis} value=total_matches title="Total Matches" />
<BigValue data={kpis} value=total_wins title="Total Wins" />
<BigValue data={kpis} value=total_losses title="Total Losses" />
