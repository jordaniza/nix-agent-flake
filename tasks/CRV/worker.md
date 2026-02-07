# Task: CRV / cvxCRV / veCRV Comparison Dashboard

Build a static dashboard comparing CRV, veCRV, and cvxCRV. The site must be publicly accessible from this server.

## Deliverables

All output goes in `../output/site/`. The site must be self-contained static HTML/JS/CSS.

### 1. CRV vs cvxCRV price chart

- Fetch historical price data for CRV and cvxCRV (at least 1 year, ideally since cvxCRV launch)
- Use CoinGecko API (no key required for public endpoints) or DeFi Llama
- Plot both on the same time-series chart with shared x-axis
- Include the cvxCRV/CRV peg ratio as a secondary line or separate panel
- Interactive chart (zoom, hover tooltips) — use a JS charting library (e.g. Chart.js, Plotly.js, Lightweight Charts)

### 2. veCRV yield vs cvxCRV yield chart

- Fetch historical yield/APR data for veCRV holders and cvxCRV stakers
- Sources: DeFi Llama yields API (`https://yields.llama.fi/pools`), Convex Finance API, or on-chain data
- Plot both yields on the same time-series chart
- Annotate any major protocol events if data supports it (e.g. gauge votes, fee changes)

### 3. Host publicly

- Install and configure caddy as a reverse proxy / file server
- Serve the static site from `../output/site/` on port 80
- Verify the site is accessible at `http://<server-ip>/`
- If caddy is unavailable, use python's http.server behind a simple systemd unit as a fallback

## Technical notes

- You have: python3, nodejs 22, bun, curl, jq, git
- For data fetching, prefer python scripts in `../output/scripts/` that write JSON to `../output/data/`
- For the frontend, write static HTML/JS that reads the JSON data files
- Keep it simple — no build step, no frameworks, just vanilla HTML + a charting library from CDN
- Write a `../output/build.sh` script that re-fetches data and rebuilds the site, so it can be re-run later
