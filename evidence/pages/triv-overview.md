# TRIV Overview

> A comprehensive, real-time pulse of matches, players, questions and lobbies.

```sql kpis
select
    count(distinct match_id) as total_matches,
    count(distinct case when ended_reason = 'normal' then match_id end) as normal_finished_matches
from platinur_analytics.mart_matches_summary
```

<BigValue data={kpis} value=total_matches title="Total Matches" />
<BigValue data={kpis} value=normal_finished_matches title="Finished Normally" />
