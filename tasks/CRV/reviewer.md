# CRV Task — Review Instructions

## Verify the data

- Spot-check at least 3 data points on each chart against CoinGecko / DeFi Llama manually (use curl)
- Confirm the date range is at least 1 year
- Check that the cvxCRV/CRV peg ratio line is mathematically correct (cvxCRV price / CRV price)
- Verify yield data sources are real and the values are plausible (veCRV APR typically 5-30%, cvxCRV varies)

## Verify the charts

- Confirm both charts render with real data (not placeholder/mock data)
- Axes must be labeled with units (USD for prices, % for yields)
- Tooltips must show exact values and dates
- Charts must be interactive (zoom/pan or at minimum hover)

## Verify hosting

- Confirm caddy or the fallback server is running and serving on port 80
- `curl -s http://localhost/` must return the dashboard HTML
- The page must load without errors (no 404s for JS/CSS/data files)

## Verify build.sh

- `../output/build.sh` must exist and be executable
- It should re-fetch data and rebuild without manual intervention

## Do not approve if

- Any chart uses mock/hardcoded data instead of fetched data
- The site is not accessible on port 80
- Price or yield data is stale or clearly wrong
- build.sh is missing or broken
