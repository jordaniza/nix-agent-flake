# Task: Apply Aragon Ownership Token Framework to ZRO (LayerZero)

## Background

Aragon has an Ownership Token Framework that evaluates governance tokens across standardised categories. The framework answers three core questions:

1. **What do I own?** — When I buy the ZRO token, what do I have unilateral, unalienable control over as a tokenholder?
2. **Why should it have value?** — What gives the ZRO token economic value?
3. **What threatens that value?** — Are there conflicts between key stakeholders that might undermine token value in the future?

The framework repository: https://github.com/aragon/ownership-token-framework

Key data files:
- **Framework categories**: `src/data/framework.json` — defines categories, criteria, and metrics
- **Detailed metrics per protocol**: `src/data/metrics.json` — per-token evidence and scoring
- **Token metadata**: `src/data/tokens.json` — token-level summaries and scores
- **README**: Framework methodology and context

Existing token analyses: AAVE, LDO, CRV, UNI, AERO — use these as references for depth, format, and evidence standards.

## Deliverables

### 1. Research Plan (`output/zro-research-plan.md`)

A structured plan mapping each framework criteria and metric to specific LayerZero resources and investigation approach. This is the blueprint for the research phase.

### 2. Research Report (`output/zro-research.md`)

An exhaustive, fully-sourced research document covering ZRO across every framework category. Every claim must have a direct, verifiable source — GitHub line numbers, contract addresses, view function outputs, or documentation links.

### 3. Framework Data (`output/zro-tokens.json`, `output/zro-metrics.json`)

JSON entries for ZRO matching the exact schema of existing entries in `tokens.json` and `metrics.json`. Must be traceable to the research report.

### 4. Deployed Site

The branch with new ZRO data merged and deployed to Vercel. Build must succeed, site must render correctly with the new token.

## Git Workflow

All work is saved to a fork of the ownership-token-framework repo:

1. Fork `aragon/ownership-token-framework` to the authenticated GitHub account
2. Create a `zro` branch from `development`
3. Save research plan and research report to the `research/` directory in the repo
4. Add tokens.json and metrics.json entries
5. Deploy the branch to Vercel

## Critical Distinction

This analysis is about the **ZRO token**, not LayerZero Labs or the LayerZero protocol in general. The question is not "is LayerZero a good protocol?" but "does the ZRO token give its holder meaningful, enforceable control and economic value?"

- Governance power only counts if it's enforced on-chain and cannot be circumvented by the team
- Revenue only counts if there's a binding mechanism directing it to token holders
- Claims about future plans, roadmap items, or "intended" governance are not evidence of current token value

## Special considerations for ZRO

LayerZero is a cross-chain messaging protocol. The ZRO token has unique characteristics:

- **Fee switch referendum**: ZRO holders vote every six months in an onchain referendum on whether to activate a protocol fee switch. If activated, fees would be used to buy back and burn ZRO. Investigate the exact mechanism — is the vote binding? Can it be overridden? What are the parameters?
- **Protocol immutability**: LayerZero's core messaging contracts (EndpointV2) are described as immutable. Verify this — who deployed them? Can they be upgraded? Are there proxy patterns? What does "immutable" actually mean for governance scope?
- **LayerZero Foundation vs LayerZero Labs**: The Foundation governs ZRO, Labs builds the protocol. Investigate this separation — is it meaningful onchain or just a legal structure? Who controls the token treasury? Who controls protocol parameters?
- **Multi-chain deployment**: ZRO exists on Ethereum, Arbitrum, Base, Optimism, and other chains. The token contract is `0x6985884c4392d348587b19cb9eaaf157f13271cd`. Verify ownership, minting authority, and governance scope across chains.
- **Zero network (announced Feb 10, 2026)**: LayerZero announced a new Layer-1 blockchain called "Zero" targeting fall 2026 launch. ZRO is designated as the native asset. Key details:
  - Backed by Citadel Securities (strategic investment in ZRO), DTCC, ICE, ARK Invest, Google Cloud
  - Architecture: permissionless "zones" (EVM, privacy-focused payments, trading) with claimed 2M TPS via ZK proofs and Jolt
  - ZRO would anchor network governance and security on Zero
  - This is a forward-looking announcement — it significantly changes ZRO's utility thesis but is not yet live. Treat the announcement as context but do NOT score based on unrealised plans. Focus on what exists today. Note the announcement and its implications in the research report.
- **Token supply**: 1 billion fixed max supply. Investigate vesting schedules, unlock timelines, and current circulating supply. Who holds the largest allocations? Are there lockups?
- **DVN/Executor economics**: LayerZero's security model involves Decentralized Verifier Networks (DVNs) and Executors. Does ZRO play a role in these economics, or is it purely governance?
