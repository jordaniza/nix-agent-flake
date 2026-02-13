# Spec Writer — MACRO

## Focus Areas

### LLM Prompt Engineering
This is the core of the product. Define the exact system prompt and user message format for food parsing. The prompt must:
- Be under 200 system tokens — every word earns its place
- Return JSON only, no commentary — specify the exact schema
- Parse multiple items from a single input ("eggs and toast" → 2 items)
- Return min/mid/max for each macro, plus a confidence level
- Handle vague inputs gracefully ("some snacks" → wide ranges, low confidence)
- Handle quantities, cooking methods, brand names when provided

Write the actual prompt text in the spec. Test it mentally with 10+ example inputs ranging from "a banana" to "homemade chicken tikka masala with basmati rice, roughly 400g total with raita on the side". Show expected outputs for each.

### Data Model
- Define the full schema for Users, Entries, and EntryItems
- Supabase/Postgres types
- Indexes needed for dashboard queries (user_id + timestamp range queries are the hot path)
- Row-level security policies for Supabase

### API Design
- POST /api/auth/signup, POST /api/auth/login — JWT flow
- POST /api/entries — accepts raw text, calls LLM, stores structured result, returns it
- GET /api/entries?from=&to= — date-filtered entries with items
- GET /api/dashboard/today — aggregated today view
- GET /api/dashboard/history?days=30 — daily aggregates for charting
- DELETE /api/entries/:id
- PUT /api/entries/:id — re-parse with edited text

Define request/response shapes for every endpoint. Include the aggregation logic for rolling up EntryItems into daily totals (sum mid values, combine ranges).

### Confidence Range Logic
Define how min/mid/max propagate:
- Single item: LLM provides ranges directly
- Entry total: sum of item ranges (min=sum of mins, max=sum of maxes, mid=sum of mids)
- Daily total: same aggregation across entries
- Weekly average: mean of daily mids, ranges from daily min/max spread

### PWA Requirements
- manifest.json fields
- Service worker caching strategy (cache shell, network-first for API)
- Icons needed (sizes)

## Deliverables
Write the spec to `../output/spec.md`. Include the actual LLM prompt, full API contracts with example payloads, database schema as SQL, and confidence propagation formulas.
