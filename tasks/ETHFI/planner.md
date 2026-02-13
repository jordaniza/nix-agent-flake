# Planner: ETHFI Token Analysis

Your job is to produce `../output/ethfi-research-plan.md` — a structured research plan for analysing the ETHFI token against the Aragon Ownership Token Framework.

## Step 1: Set up the repo

1. Fork `aragon/ownership-token-framework` to the authenticated GitHub account
2. Create an `ethfi` branch from `development`

## Step 2: Study the framework

1. Read `src/data/framework.json` — understand every category, criteria, and metric
2. Read the README for methodology context
3. Understand the three core questions the framework answers:
   - What does the tokenholder unilaterally control?
   - Why should the token have value?
   - What conflicts threaten that value?

## Step 3: Study existing entries

Read `src/data/metrics.json` and `src/data/tokens.json`. Study all existing token entries (AAVE, LDO, CRV, UNI, AERO):

- What evidence was collected for each metric?
- What level of detail and verification was applied?
- How are summaries, evidence groups, and links structured?
- What patterns repeat across tokens?

## Step 4: Build the research plan

For each criteria and metric in the framework:

1. State what you're looking for — what question does this metric answer for ETHFI?
2. Create a longlist of Ether.fi resources (contracts, repos, docs, governance forums, dashboards)
3. Collapse the longlist to the most relevant sources per criteria
4. Note what kind of evidence you expect to find (code, on-chain data, documentation)
5. Flag any criteria where you anticipate difficulty or gaps

## Step 5: Save to GitHub

Commit the research plan to the `ethfi` branch in the forked repo. Also write it to `../output/ethfi-research-plan.md`.

## What the plan must contain

- **Resource inventory**: every Ether.fi source you've identified (repos, contracts, docs, forums, dashboards) with URLs. Confirm each URL is accessible.
- **Criteria-by-criteria breakdown**: each metric mapped to specific sources and investigation approach
- **Evidence sufficiency**: explicit statements about what constitutes sufficient evidence for each metric — what would you need to see to score it?
- **Gaps and concerns**: a section noting potential gaps, areas of difficulty, or criteria where evidence may be weak or absent
