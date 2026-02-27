# Planner: YB Token Analysis

The fork and `yb` branch already exist with previous work — a research plan, research report, and JSON entries. Your job is NOT to start from scratch. Your job is to review the existing research plan and update it if needed based on feedback.

## Step 1: Set up the repo

1. Fork `aragon/ownership-token-framework` to the authenticated GitHub account (use the existing fork)
2. Check out the existing `yb` branch — it contains all previous work
3. Read the existing research plan in the repo

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

## Step 4: Review and update the research plan

The existing plan has been through a full research cycle. Read the feedback in `../log.md` and any reviewer comments. Update the plan to address gaps or areas that need deeper investigation.

For each criteria and metric in the framework:

1. State what you're looking for — what question does this metric answer for YB?
2. Create a longlist of YieldBasis resources (contracts, repos, docs, governance forums, dashboards)
3. Collapse the longlist to the most relevant sources per criteria
4. Note what kind of evidence you expect to find (code, on-chain data, documentation)
5. Flag any criteria where you anticipate difficulty or gaps

## Step 5: Save to GitHub

Commit the research plan to the `research/` directory in the repo (`research/yb-research-plan.md`). Also write it to `../output/yb-research-plan.md`.

## What the plan must contain

- **Resource inventory**: every YieldBasis source you've identified (repos, contracts, docs, forums, dashboards) with URLs. Confirm each URL is accessible.
- **Criteria-by-criteria breakdown**: each metric mapped to specific sources and investigation approach
- **Evidence sufficiency**: explicit statements about what constitutes sufficient evidence for each metric — what would you need to see to score it?
- **Gaps and concerns**: a section noting potential gaps, areas of difficulty, or criteria where evidence may be weak or absent
