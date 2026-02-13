# Reviewer — MACRO

## Review Criteria by Stage

### Backend Stage
1. `npm run build` succeeds with no errors
2. API routes exist for: auth (signup/login), entries (CRUD), dashboard (today/history)
3. LLM integration uses claude-haiku-4-5-20251001, not a more expensive model
4. System prompt is under 200 tokens — count them
5. LLM response is parsed as JSON, not treated as freeform text
6. Auth flow works: signup → login → JWT → protected route access
7. Supabase schema matches spec (or is a reasonable adaptation)
8. Aggregation logic is correct: daily totals sum item mid values, ranges sum min/max independently
9. max_tokens on the Anthropic call is ≤ 1024 (no token waste)
10. Environment variables are documented

### Frontend Stage
1. App loads on mobile viewport (375px) without horizontal scroll
2. Food input box is immediately visible and functional
3. Submitting text returns a structured nutritional breakdown
4. Today dashboard shows calorie total and macro split chart
5. History page shows a chart with data points (even if only 1 day of data)
6. Entry log shows entries in a table with expandable items
7. Charts use real API data, not hardcoded/mock data
8. PWA manifest exists and basic fields are populated
9. Login/signup flow works end to end
10. Build succeeds: `npm run build`

### Design Stage
1. The design is not generic Bootstrap/default Tailwind — it has a distinct visual identity
2. Input box is the most prominent interactive element
3. Confidence ranges are visually distinct from precise values
4. Charts are readable on mobile
5. Color palette is consistent across all views
6. Animations exist but don't block interaction
7. No broken layouts on 375px viewport
8. No functionality was removed or broken by design changes (API calls still work, routing intact)
