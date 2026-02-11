# Reviewer: Delegate Voting Indexer

Your review criteria shift depending on which stage you're in. Read `../log.md` to determine the current stage, then apply the relevant section below.

## Stage: backend (Backend review)

### Build and test

1. `cd ../output/backend && npm install && npm run build` — must succeed with no errors
2. `npm test` — all tests must pass
3. Check test coverage: each processing stage should have dedicated tests
4. Run invariant tests against live on-chain data

### Correctness

1. Compare the implementation against the spec (`../output/spec.md`), stage by stage. Does the code match?
2. Verify event parsing: are `Voted`, `Reset`, delegation events parsed correctly?
3. Verify snapshot logic: does it correctly use the end-of-voting-window timestamp?
4. Verify attribution: does the delegate decomposition match the spec's algorithm?
5. Spot-check: pick an epoch, manually trace a few voters through the code path, confirm the output matches what you'd compute by hand from the events

### Invariants

Run the invariant checks. They must pass. If any fail, this is a blocking issue.

### API and caching

1. Query each API endpoint. Verify response shape matches the spec's data model
2. Query the same endpoint twice — second call should be fast (cached)
3. Verify row-level queries work: filter by delegate, by voter, by gauge, by epoch
4. Verify aggregations are correct (spot-check totals)

### Deployment

1. Code must be in a public GitHub repo (verify with `gh repo view`)
2. Backend must be deployed to Vercel (verify with curl)
3. Supabase must be configured with the right tables
4. Environment variables must not be in source code

### Do NOT approve if

- Build fails or tests fail
- Any invariant check fails
- Attribution logic doesn't match the spec
- API returns incorrect data for spot-checked cases
- Not deployed to Vercel
- Not pushed to GitHub

## Stage: frontend (Frontend review)

1. Site loads on Vercel (verify with curl, then visually)
2. All visualizations render with real data (not mock/placeholder)
3. Drilldown works: epoch → gauge → delegate → voter
4. Rankings display correctly and are sortable
5. Epoch selector works and shows different data per epoch
6. Data matches what the backend API returns (spot-check a few values)
7. Responsive layout works on mobile widths
8. No console errors, no broken links, no missing assets

### Do NOT approve if

- Site doesn't load on Vercel
- Any visualization uses mock data
- Drilldown navigation is broken
- Data doesn't match the backend

## Stage: design (Design review)

1. Visual hierarchy is clear — most important information is most prominent
2. Data visualizations are readable and not misleading
3. Color usage is accessible (sufficient contrast, not relying on color alone)
4. Typography is consistent and readable
5. Responsive design works without breaking layouts
6. Interactions feel natural (hover states, transitions, loading states)
7. The site feels like a coherent product, not a dashboard template
