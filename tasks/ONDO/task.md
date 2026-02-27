# Task: Apply Aragon Ownership Token Framework to ONDO (Ondo Finance)

## Background

Aragon has an Ownership Token Framework that evaluates governance tokens across standardised categories. The framework answers three core questions:

1. **What do I own?** — When I buy the ONDO token, what do I have unilateral, unalienable control over as a tokenholder?
2. **Why should it have value?** — What gives the ONDO token economic value?
3. **What threatens that value?** — Are there conflicts between key stakeholders that might undermine token value in the future?

The framework repository: https://github.com/aragon/ownership-token-framework

Key data files:
- **Framework categories**: `src/data/framework.json` — defines categories, criteria, and metrics
- **Detailed metrics per protocol**: `src/data/metrics.json` — per-token evidence and scoring
- **Token metadata**: `src/data/tokens.json` — token-level summaries and scores
- **README**: Framework methodology and context

Existing token analyses: AAVE, LDO, CRV, UNI, AERO — use these as references for depth, format, and evidence standards.

## Deliverables

### 1. Research Plan (`output/ondo-research-plan.md`)

A structured plan mapping each framework criteria and metric to specific Ondo Finance resources and investigation approach. This is the blueprint for the research phase.

### 2. Research Report (`output/ondo-research.md`)

An exhaustive, fully-sourced research document covering ONDO across every framework category. Every claim must have a direct, verifiable source — GitHub line numbers, contract addresses, view function outputs, or documentation links.

### 3. Framework Data (`output/ondo-tokens.json`, `output/ondo-metrics.json`)

JSON entries for ONDO matching the exact schema of existing entries in `tokens.json` and `metrics.json`. Must be traceable to the research report.

### 4. Deployed Site

The branch with new ONDO data merged and deployed to Vercel. Build must succeed, site must render correctly with the new token.

## Git Workflow

All work is saved to a fork of the ownership-token-framework repo:

1. Fork `aragon/ownership-token-framework` to the authenticated GitHub account
2. Create an `ondo` branch from `development`
3. Save research plan and research report to the `research/` directory in the repo
4. Add tokens.json and metrics.json entries
5. Deploy the branch to Vercel

## Critical Distinction

This analysis is about the **ONDO token**, not the Ondo Finance protocol or company. The question is not "is Ondo Finance a good protocol?" but "does the ONDO token give its holder meaningful, enforceable control and economic value?"

- Governance power only counts if it's enforced on-chain and cannot be circumvented by the team
- Revenue only counts if there's a binding mechanism directing it to token holders
- Claims about future plans, roadmap items, or "intended" governance are not evidence of current token value

## Special considerations for Ondo

Ondo Finance is a tokenised real-world asset (RWA) protocol. This means:
- The ONDO token is a governance token, but the protocol's core products (OUSG, USDY) are tokenised securities/yield products — the relationship between ONDO governance and these products is the key question
- Regulatory constraints may limit what onchain governance can actually control — distinguish between what governance theoretically could do and what it's legally permitted to do
- The token may have significant transfer restrictions, blocklists, or KYC requirements given the RWA context — investigate these thoroughly
- Ondo has deployed across multiple chains — check governance scope on each
- The separation between Ondo Finance (the company) and Ondo DAO (if it exists) is critical — who actually controls protocol parameters?
