# Builder: ONDO Framework Deployment

Your job is to merge the ONDO data into the ownership-token-framework fork, verify the build, and deploy to Vercel.

## Step 1: Understand the repo

Read the ownership-token-framework repository structure on the `ondo` branch. Understand:

- Where `tokens.json` and `metrics.json` live (`src/data/`)
- How the build works (Next.js — check `package.json`)
- How existing tokens are rendered

## Step 2: Merge the data

1. Read the new JSON files from `../output/` (`ondo-tokens.json`, `ondo-metrics.json`)
2. Merge the ONDO entries into the existing `tokens.json` and `metrics.json` in the repo
3. Ensure the merged files are valid JSON and the ONDO entries match the schema of existing entries

## Step 3: Build and verify

1. Install dependencies and run the build locally
2. Fix any build errors
3. Verify the ONDO token appears correctly in the built site
4. Run any existing tests

## Step 4: Deploy

1. Commit all changes to the `ondo` branch
2. Push to the fork
3. Deploy the branch to Vercel using the Vercel CLI
4. Verify the deployed URL loads and ONDO data renders correctly

## Step 5: Report

Include in your log.md entry:
- GitHub repo URL and branch
- Vercel deployment URL
- Confirmation that build succeeds and site renders correctly
