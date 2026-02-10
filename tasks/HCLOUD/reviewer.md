# HCLOUD — Review Instructions

Public codebase managing infrastructure credentials. Single user (the developer) with potentially a couple of Hetzner accounts. Focus on functional correctness and basic secret hygiene, not multi-tenant hardening.

## Security review

### Secrets in public code
- No API keys, tokens, or passwords anywhere in source
- `ENCRYPTION_KEY`, Supabase keys, and all credentials are in env vars only
- `.env` files are gitignored
- Check `next.config.js` for accidental env exposure to the client bundle

### Token storage
- Hetzner token must not be stored as plaintext in Supabase
- Verify server-side encryption with `ENCRYPTION_KEY` before writing to database
- Verify the plaintext token is never logged in API routes
- Verify decryption failures are handled gracefully (clear error, not a crash)

### XSS
- Server names come from the Hetzner API and render in the UI — verify they are escaped properly

## Functional review

### Tests
- Run the full test suite
- Check coverage of: auth flow, token encrypt/store/retrieve/decrypt roundtrip, Hetzner API mocking, server action UI
- Identify any missing test cases around: network failure, invalid/expired Hetzner token, empty server list

### Features
- All server actions work against mocked responses (delete, power off/on, reboot)
- Confirmation dialog prevents accidental deletes
- Cost display handles servers with no pricing data
- Session persists across browser restart (user stays logged in)
- PWA manifest and service worker are correctly configured for Android

### Build & deploy — STRICT, BLOCKING requirements

Do NOT write `APPROVED` to `review-log.md` unless ALL of the following are verified. These are hard gates, not suggestions.

#### GitHub
- Code is pushed to a public GitHub repo via `gh repo create`
- Verify with `gh repo view` — the repo must exist and contain the latest commit
- `.github/workflows/test.yml` is present and runs tests on push

#### Vercel
- App is deployed to Vercel via `npx vercel --prod`
- Verify by curling the production URL — it must return a 200 status
- The deployed URL is recorded in the README

#### Supabase
- A Supabase project is created and linked (check with `npx supabase projects list` or equivalent)
- Auth is configured (email/password provider enabled)
- Database has the required table for encrypted token storage
- Supabase URL and anon key are set as environment variables in Vercel

#### General
- `npm run build` succeeds with no errors
- No TypeScript errors
- All tests pass
