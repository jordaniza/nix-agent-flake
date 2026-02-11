# Frontend Developer: Delegate Voting Indexer

## Your job

Build an interactive dashboard in `../output/frontend/` that surfaces the delegate voting data from the backend API. Deploy alongside the backend on Vercel.

## Data source

The backend REST API (see `../output/backend/` or `../output/spec.md` for endpoints). All data comes from the API — do not fetch on-chain data directly from the frontend.

## What to build

1. **Epoch overview** — summary of each epoch: total votes, number of voters, number of delegates, gauge breakdown
2. **Gauge drilldown** — click a gauge to see its voters and their attributed power
3. **Delegate drilldown** — click a delegate to see who delegated to them and how much power each contributed
4. **Voter drilldown** — click a voter to see their delegation history and which delegates voted on their behalf
5. **Rankings** — top delegates (by total attributed power), top voters (by own power), top gauges (by total votes). Sortable columns
6. **Epoch selector** — browse historical epochs, see different data per epoch
7. **Spec page** — render the spec document (`spec.md`) with interactive data inline where relevant

## Technical constraints

- Fetch all data from the backend REST API
- No mock or placeholder data
- Responsive: desktop primary, mobile must work
- Fast: don't re-fetch data that hasn't changed
- Lightweight dependencies — don't pull in a heavy framework if a lighter one works
- Deploy to Vercel in the same project as the backend

## Navigation

The drilldown path should feel like zooming in:
- Epoch overview → click gauge → gauge detail → click delegate → delegate detail → click voter → voter detail
- Breadcrumbs at each level
- Back navigation should preserve context
