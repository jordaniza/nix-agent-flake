# HCLOUD — Hetzner Server Manager PWA

Build a progressive web app for managing Hetzner Cloud servers from a phone. The app is public code deployed on Vercel with Supabase for auth and encrypted token storage.

## Tech stack

- Next.js (App Router) deployed on Vercel
- Supabase for auth (email/password) and database (encrypted token storage)
- Hetzner Cloud API (https://docs.hetzner.cloud)
- TypeScript throughout
- PWA manifest + service worker for installability

## Auth flow

1. User signs up / logs in with email + password via Supabase Auth
2. Sessions should be long-lived — the user stays logged in until they explicitly log out. Configure Supabase session expiry to the maximum and persist refresh tokens.
3. After login, user enters their Hetzner API bearer token (obtained from https://console.hetzner.cloud)
4. Token is sent to a Next.js API route which encrypts it server-side and stores the ciphertext in Supabase

### Token storage

The Hetzner token must not be stored as plaintext in Supabase. Use a server-side `ENCRYPTION_KEY` environment variable (set in Vercel) to encrypt with AES-256-GCM before writing to the database. API routes decrypt when making Hetzner calls. The flow:

1. User submits token → Next.js API route encrypts with `ENCRYPTION_KEY` → stores ciphertext + IV in Supabase
2. Hetzner API calls go through Next.js API routes → route retrieves ciphertext from Supabase → decrypts → calls Hetzner API → returns results to client
3. The plaintext token is only ever in memory on the Vercel serverless function, never in the database

## Features

### Server list (home screen)

- List all servers: name, status (running/off/initializing), IPv4 address, server type
- Auto-refresh on pull-down or configurable interval
- Color-coded status indicators

### Server actions

- **Delete** — `DELETE /servers/{id}` — with confirmation dialog
- **Power off** — `POST /servers/{id}/actions/poweroff`
- **Power on** — `POST /servers/{id}/actions/poweron`
- **Reboot** — `POST /servers/{id}/actions/reboot`

### Cost overview

- Current billing period costs from `GET /servers/{id}` (pricing info is per-server)
- Or aggregate from pricing API if available
- Display hourly and monthly projected costs

### PWA

- `manifest.json` with app name, icons, theme color
- Service worker for offline shell (show cached server list when offline, indicate stale data)
- Target Android — ensure installability and home screen behavior works well on Chrome/Android

## Testing

Write tests covering:

- Auth flow: signup, login, logout, session persistence across browser restart
- Token storage: encrypt → store → retrieve → decrypt roundtrip
- Hetzner API integration: mock API responses for server list, actions, error handling
- UI: server list renders, actions trigger correct API calls, confirmation dialogs work
- Edge cases: expired token, network failure, invalid credentials

Use Vitest for unit/integration tests. Use Playwright for E2E if time permits.

## Deliverables

All output goes in `../output/`:

- Working Next.js app (full source tree)
- `README.md` with setup instructions (env vars, Supabase project setup, Vercel deployment)
- Test suite that passes
- `.github/workflows/test.yml` for CI

## Environment

The following are available via environment variables (check `.env` in the task root):

- `GH_TOKEN` — GitHub access for pushing code
- `VERCEL_TOKEN` — for deployment via `npx vercel`
- `SUPABASE_ACCESS_TOKEN` — for Supabase CLI project management

## Deployment

1. Initialize a git repo in the output directory
2. Push to GitHub using `gh repo create` (public repo)
3. Deploy to Vercel using `npx vercel --prod`
4. Ensure the deployed URL is noted in the README
