# Researcher: ETHFI Token Analysis

A previous research report already exists on the `ethfi` branch in the forked repo. Your job is to apply feedback and improve the existing report — NOT to start from scratch.

## How to start

1. Check out the `ethfi` branch in the forked ownership-token-framework repo
2. The existing research report is in `output/ethfi-research.md` on the branch. Copy it to `research/ethfi-research.md` in the repo, then delete the `output/` folder from the repo. The canonical location going forward is `research/ethfi-research.md`.
3. Also copy the report to `../output/ethfi-research.md` for the pipeline
4. Read the research plan in `research/ethfi-research-plan.md` (or `../output/ethfi-research-plan.md`)
5. Read `../log.md` for feedback — there is significant feedback to address
6. Read any reviewer feedback in `review.md`
7. Apply all feedback to the existing report. Do not rewrite from scratch.

## Verification standards

This is the hardest and most important part. For every claim:

- **Code verification**: Point to the exact file and line number in a GitHub repository. Use `gh` to clone repos and read the actual code. Don't reference a file — reference the specific line.
- **On-chain verification**: For deployed contracts, provide the Etherscan link AND call relevant view functions using `cast call` to verify current state (addresses, roles, parameters).
- **Governance verification**: Trace the permission chain. Who can call this function? Is it a multisig? Who controls the multisig? Can the multisig be changed? By whom? Follow the chain to its terminus.
- **Ownership vs. operational**: Distinguish between powers that threaten tokenholder sovereignty (e.g. multisig can upgrade core contracts, change fee splits, mint tokens) and operational functions (e.g. admin can pause in emergency, but tokenholders can replace the admin).

## What "ownership" means here

You are looking for mechanisms where ETHFI tokenholders have **enforceable, on-chain control** that cannot be unilaterally overridden:

- Tokenholders can vote to change X → **ownership** (if the vote is binding and can't be vetoed)
- Tokenholders can vote but a multisig executes → **partial ownership** (depends on multisig composition and constraints)
- Team says tokenholders will eventually control X → **not ownership** (plans are not code)
- Multisig can change X without tokenholder approval → **no ownership**

The nuance: if tokenholders can set/replace the multisig members, they're still ultimately in control. Trace the full chain.

## What to include that's relevant

- Governance flows where tokenholders have final say
- Fee switches or revenue mechanisms that could direct value to tokenholders
- Staking mechanisms that give tokenholders economic rights
- Veto or override powers held by non-tokenholder parties

## What to exclude

- Operational admin functions where tokenholders retain the power to replace the admin
- General protocol quality metrics that don't relate to token holder rights
- Future plans or roadmap items without on-chain implementation

## Key research note

The correct RoleRegistry contract is at https://etherscan.io/address/0x62247D29B4B9BECf4BB73E0c722cf6445cfC7cE9#readProxyContract — follow the ownership chain from the Liquidity Pool contract to find it. The owner is the timelock, NOT the multisig. The previous research got this wrong. Re-trace the full permission chain from the RoleRegistry through to whoever controls the timelock. Update all downstream claims that depend on role ownership.

## Save progress

After each round, commit your updated research report to `research/ethfi-research.md` on the `ethfi` branch. Also copy to `../output/ethfi-research.md` for the pipeline.

## What the report must contain

- Every framework category and metric addressed
- Direct source for every claim (GitHub line number is the gold standard)
- Contract addresses with Etherscan links for all referenced contracts
- View function call results for key on-chain parameters
- Mermaid diagrams for governance flows and permission chains
- Explicit section on conflicts of interest and threats to token value
- Clear distinction between what code enforces vs. what documentation claims

## RPC and verification

- Use `https://eth.llamarpc.com` for all `cast call` onchain verification
- HTTP request every URL before including it. Broken link = don't include it
- Commit research report to GitHub branch after each round
