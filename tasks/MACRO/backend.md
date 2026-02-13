# Backend Developer — MACRO

## Stack
- Next.js 14+ App Router with TypeScript
- API routes in `app/api/`
- Supabase JS client for Postgres
- Anthropic SDK (`@anthropic-ai/sdk`) for Claude API calls
- bcryptjs for password hashing, jsonwebtoken for JWT
- Deploy to Vercel

## Implementation Notes

### Project Setup
- Initialize Next.js project in `../output/` with TypeScript, App Router, Tailwind
- Install dependencies: `@anthropic-ai/sdk`, `@supabase/supabase-js`, `bcryptjs`, `jsonwebtoken`
- Set up environment variables: ANTHROPIC_API_KEY, SUPABASE_URL, SUPABASE_SERVICE_KEY, JWT_SECRET

### LLM Integration
- Use the exact prompt from the spec — do not improvise
- Model: `claude-haiku-4-5-20251001`
- Set max_tokens low (512 should be plenty for a meal's JSON)
- Use response prefill with `{` to force JSON output
- Parse response, validate against expected schema, store structured items
- If parsing fails, return the raw text entry with a flag so the user can retry

### Auth
- Signup: hash password with bcrypt, insert user, return JWT
- Login: verify password, return JWT
- Middleware: verify JWT on protected routes, attach user_id to request
- JWT expiry: 30 days (it's a personal tracker, not a bank)

### Database
- Run the schema SQL from the spec against Supabase
- Use Supabase client with service role key in API routes
- RLS can be off since all access goes through authenticated API routes — but follow spec if it mandates RLS

### Key Endpoints
Follow the spec's API contracts exactly. The critical path is:
1. POST /api/entries — parse text → call Claude → store items → return structured data
2. GET /api/dashboard/today — aggregate today's entries for the logged-in user
3. GET /api/dashboard/history — daily aggregates over N days

### Testing
- Write a test for the LLM parsing: mock the Anthropic response, verify JSON parsing and storage
- Write a test for auth flow: signup → login → access protected route
- Write a test for aggregation: given known entries, verify dashboard math

### Deployment
- Ensure `vercel.json` or `next.config.js` is ready for Vercel deployment
- All secrets go in Vercel env vars (document which ones are needed)
- Verify the app builds with `npm run build` before considering the stage done

## Deliverables
All code in `../output/`. The app must build cleanly and all API routes must work against Supabase.
