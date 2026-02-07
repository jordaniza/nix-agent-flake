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

### Build & deploy
- `npm run build` succeeds with no errors
- No TypeScript errors
- GitHub Actions workflow runs tests on push
