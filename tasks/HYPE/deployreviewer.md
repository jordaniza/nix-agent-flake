# Deploy Reviewer: HYPE Framework Deployment

Your job is to verify the build and deployment succeeded.

## Verify

1. Check the GitHub fork and `hype` branch exist with the latest changes
2. Verify that `tokens.json` and `metrics.json` in the repo contain the HYPE entries (merged into the existing files, not separate)
3. Clone the repo, install dependencies, run the build — it must succeed
4. Verify the Vercel deployment URL loads
5. Verify HYPE appears on the deployed site with correct data
6. Spot-check a few metrics on the site against the JSON files

## Do NOT approve if

- Build fails
- HYPE doesn't appear on the deployed site
- Data on the site doesn't match the JSON
- GitHub branch is missing or out of date
