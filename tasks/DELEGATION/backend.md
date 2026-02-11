# Backend Developer: Delegate Voting Indexer

## Your job

Build the indexing backend in `../output/backend/` based on the specification at `../output/spec.md`.

## Stack

- **Runtime**: Node.js / TypeScript
- **Database**: Supabase (Postgres) for caching computed results
- **Deployment**: Vercel serverless functions
- **On-chain reads**: Public Katana RPC

## What to build

1. **Event fetcher** — pull `Voted`, `Reset`, and delegation events from the GaugeVoterPlugin and related contracts
2. **Snapshot resolver** — given an epoch, compute the end-of-voting-window timestamp via Clock, then resolve the latest state at that timestamp
3. **Vote decomposer** — implement the spec's algorithm for splitting delegate votes into per-delegator contributions
4. **Invariant checker** — runnable assertions matching the spec's invariants. These must pass as tests AND be callable at runtime
5. **Caching layer** — store computed results in Supabase. Once an epoch is computed, never recompute
6. **REST API** — Vercel serverless functions exposing:
   - `GET /api/epochs` — list available epochs
   - `GET /api/epochs/:epoch` — full results for an epoch (cached)
   - `GET /api/epochs/:epoch/gauges` — breakdown by gauge
   - `GET /api/epochs/:epoch/gauges/:gauge` — voters for a specific gauge
   - `GET /api/delegates/:address` — all epochs for a delegate
   - `GET /api/voters/:address` — all epochs for a voter (including via delegation)
   - `GET /api/rankings` — top delegates, top voters, top gauges (with epoch filter)

## Testing

- Unit tests for each processing stage (fetcher, resolver, decomposer)
- Invariant tests that run against live on-chain data at a known epoch's end-of-voting-window timestamp
- API integration tests
- `npm test` must pass cleanly

## Deployment

1. Push to the same GitHub repo as the spec
2. Deploy to Vercel via `npx vercel --prod`
3. Configure Supabase tables and set env vars on Vercel
4. Verify with curl that API endpoints return correct data
