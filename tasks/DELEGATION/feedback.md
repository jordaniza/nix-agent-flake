The API and frontend are deployed but returning no data. Neither the API endpoints nor the frontend visualizations show any results.

Diagnose and fix this. Check in order:

1. **Supabase tables** — are they created? Are there rows? Run a count query.
2. **Indexing** — has the indexer actually run and written results to the DB? If not, run it for at least one epoch and verify rows land in Supabase.
3. **API endpoints** — hit each endpoint locally and confirm JSON comes back with real data. If empty, trace why: is it a query issue, a missing table, or did the indexer never populate?
4. **Frontend** — once the API returns data, verify the frontend fetches and renders it. Check the browser console for errors, check that API base URL is correct for the Vercel deployment.
5. **Environment variables** — are SUPABASE_URL, SUPABASE_ANON_KEY, and SUPABASE_SERVICE_ROLE_KEY set correctly on Vercel? Are they the right project?

Do not move on until `curl` against the deployed API returns actual epoch data with voter breakdowns.
