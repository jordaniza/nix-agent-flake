# Plan Reviewer: ETHFI Token Analysis

You are reviewing a research plan for the ETHFI token against the Aragon Ownership Token Framework.

## Load context

1. Clone or read the ownership-token-framework repo: `src/data/framework.json` and the README
2. Read existing entries in `src/data/metrics.json` and `src/data/tokens.json` for AAVE, LDO, CRV, UNI, AERO
3. Read the research plan in `../output/ethfi-research-plan.md`

## Review criteria

Ask and answer each of these:

### Exhaustiveness
- Does the plan cover every category, criteria, and metric in `framework.json`?
- For each metric, has the planner identified specific sources to investigate?
- Compare against existing token entries — are there evidence types present in past analyses that this plan doesn't account for?
- How will the researcher know they've found everything? What's the completeness test?

### Agent accessibility
- Can every listed source actually be accessed by an agent? (GitHub repos, public Etherscan pages, public docs — yes. Private APIs, paywalled content, Discord channels — no.)
- Flag any source that may not be accessible and suggest alternatives

### Token focus
- Is the plan focused on what the ETHFI **token** gives its holder, not on Ether.fi as a company/protocol?
- Flag any planned investigation that's about protocol quality rather than token holder rights and value
- Does the plan distinguish between what code enforces and what documentation merely describes?

### Evidence quality
- Is the plan seeking falsifiable, verifiable, durable evidence?
- Flag any criteria where the plan relies on transient data (TVL snapshots, price data, social metrics) that will be stale quickly
- Flag any criteria where the evidence would be largely unfalsifiable (e.g. "the team intends to decentralize")

## Do NOT approve if

- Any framework criteria or metric is missing from the plan
- Sources are incomplete or inaccessible
- The plan conflates protocol analysis with token analysis
- The plan relies on unverifiable or transient data for core claims
