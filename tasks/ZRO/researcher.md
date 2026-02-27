# Researcher: ZRO Token Analysis

Your job is to execute the research plan and produce `../output/zro-research.md` — an exhaustive, fully-sourced research report on the ZRO token against the Aragon Ownership Token Framework.

## How to start

1. Read the research plan in `../output/zro-research-plan.md`
2. Read any reviewer feedback in `review.md`
3. Work through each criteria systematically, following the plan

## Verification standards

This is the hardest and most important part. For every claim:

- **Code verification**: Point to the exact file and line number in a GitHub repository. Use `gh` to clone repos and read the actual code. Don't reference a file — reference the specific line.
- **On-chain verification**: For deployed contracts, provide the Etherscan link AND call relevant view functions using `cast call` to verify current state (addresses, roles, parameters).
- **Governance verification**: Trace the permission chain. Who can call this function? Is it a multisig? Who controls the multisig? Can the multisig be changed? By whom? Follow the chain to its terminus.
- **Ownership vs. operational**: Distinguish between powers that threaten tokenholder sovereignty (e.g. multisig can upgrade core contracts, change fee splits, mint tokens) and operational functions (e.g. admin can pause in emergency, but tokenholders can replace the admin).

## What "ownership" means here

You are looking for mechanisms where ZRO tokenholders have **enforceable, on-chain control** that cannot be unilaterally overridden:

- Tokenholders can vote to change X → **ownership** (if the vote is binding and can't be vetoed)
- Tokenholders can vote but a multisig executes → **partial ownership** (depends on multisig composition and constraints)
- Team says tokenholders will eventually control X → **not ownership** (plans are not code)
- Multisig can change X without tokenholder approval → **no ownership**

The nuance: if tokenholders can set/replace the multisig members, they're still ultimately in control. Trace the full chain.

## What to include that's relevant

- The fee switch referendum mechanism — how does the onchain vote work? What contract implements it? What parameters are set? Has a vote occurred? What was the result?
- Protocol fee collection — where do fees accumulate today? Who controls them? Is there a treasury?
- LayerZero Foundation vs LayerZero Labs — what does each control onchain? Who holds admin keys on core contracts?
- EndpointV2 immutability claims — are the core messaging contracts truly immutable? Check for proxy patterns, upgrade functions, owner roles
- DVN and Executor configuration — who sets the default DVN/Executor? Can this be changed? By whom? Does ZRO have a role in DVN economics?
- Token contract analysis — minting authority, burn mechanisms, pausing, blocklists, transfer restrictions
- Multi-chain presence — governance scope across Ethereum, Arbitrum, Base, Optimism, etc. Same admin on all chains?
- Token distribution — vesting schedules, Foundation allocation, Labs allocation, community allocation, unlock timeline
- Zero network announcement (Feb 10, 2026) — document the announcement and stated plans (ZRO as native asset, institutional backing from Citadel Securities/DTCC/ICE/ARK/Google Cloud, "zones" architecture) but clearly label this as forward-looking. It is NOT evidence of current token value. Include it as context in a dedicated section.

## What to exclude

- Operational admin functions where tokenholders retain the power to replace the admin
- General protocol quality metrics that don't relate to token holder rights
- Future plans or roadmap items without on-chain implementation — specifically, do not score based on the Zero network since it does not exist yet

## Save progress

After each round, commit your updated research report to `research/zro-research.md` on the `zro` branch. Also copy to `../output/zro-research.md` for the pipeline.

## What the report must contain

- Every framework category and metric addressed
- Direct source for every claim (GitHub line number is the gold standard)
- Contract addresses with Etherscan links for all referenced contracts
- View function call results for key on-chain parameters
- Mermaid diagrams for governance flows and permission chains
- Explicit section on conflicts of interest and threats to token value
- Clear distinction between what code enforces vs. what documentation claims
- Dedicated section on the Zero network announcement — clearly labelled as forward-looking context, not scored evidence

## RPC and verification

- Use `https://eth.llamarpc.com` for all `cast call` onchain verification
- HTTP request every URL before including it. Broken link = don't include it
- Commit research report to GitHub branch after each round
