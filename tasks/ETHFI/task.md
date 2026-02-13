# Task: Apply Aragon Ownership Token Framework to ETHFI (Ether.fi)

## Background

Aragon has an Ownership Token Framework that evaluates governance tokens across standardised categories. The framework answers three core questions:

1. **What do I own?** — When I buy the ETHFI token, what do I have unilateral, unalienable control over as a tokenholder?
2. **Why should it have value?** — What gives the ETHFI token economic value?
3. **What threatens that value?** — Are there conflicts between key stakeholders that might undermine token value in the future?

The framework repository: https://github.com/aragon/ownership-token-framework

Key data files:
- **Framework categories**: `src/data/framework.json` — defines categories, criteria, and metrics
- **Detailed metrics per protocol**: `src/data/metrics.json` — per-token evidence and scoring
- **Token metadata**: `src/data/tokens.json` — token-level summaries and scores
- **README**: Framework methodology and context

Existing token analyses: AAVE, LDO, CRV, UNI, AERO — use these as references for depth, format, and evidence standards.

## Deliverables

### 1. Research Plan (`output/ethfi-research-plan.md`)

A structured plan mapping each framework criteria and metric to specific Ether.fi resources and investigation approach. This is the blueprint for the research phase.

### 2. Research Report (`output/ethfi-research.md`)

An exhaustive, fully-sourced research document covering ETHFI across every framework category. Every claim must have a direct, verifiable source — GitHub line numbers, contract addresses, view function outputs, or documentation links.

### 3. Framework Data (`output/ethfi-tokens.json`, `output/ethfi-metrics.json`)

JSON entries for ETHFI matching the exact schema of existing entries in `tokens.json` and `metrics.json`. Must be traceable to the research report.

### 4. Deployed Site

The branch with new ETHFI data merged and deployed to Vercel. Build must succeed, site must render correctly with the new token.

## Git Workflow

All work is saved to a fork of the ownership-token-framework repo:

1. Fork `aragon/ownership-token-framework` to the authenticated GitHub account
2. Create an `ethfi` branch from `development`
3. Save research plan and research report as markdown in the repo
4. Add tokens.json and metrics.json entries
5. Deploy the branch to Vercel

## Critical Distinction

This analysis is about the **ETHFI token**, not the Ether.fi protocol or company. The question is not "is Ether.fi a good protocol?" but "does the ETHFI token give its holder meaningful, enforceable control and economic value?"

- Governance power only counts if it's enforced on-chain and cannot be circumvented by the team
- Revenue only counts if there's a binding mechanism directing it to token holders
- Claims about future plans, roadmap items, or "intended" governance are not evidence of current token value
