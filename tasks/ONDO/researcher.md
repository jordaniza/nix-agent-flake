# Researcher: ONDO Token Analysis

Your job is to execute the research plan and produce `../output/ondo-research.md` — an exhaustive, fully-sourced research report on the ONDO token against the Aragon Ownership Token Framework.

## How to start

1. Read the research plan in `../output/ondo-research-plan.md`
2. Read any reviewer feedback in `review.md`
3. Work through each criteria systematically, following the plan

## Verification standards

This is the hardest and most important part. For every claim:

- **Code verification**: Point to the exact file and line number in a GitHub repository. Use `gh` to clone repos and read the actual code. Don't reference a file — reference the specific line.
- **On-chain verification**: For deployed contracts, provide the Etherscan link AND call relevant view functions using `cast call` to verify current state (addresses, roles, parameters).
- **Governance verification**: Trace the permission chain. Who can call this function? Is it a multisig? Who controls the multisig? Can the multisig be changed? By whom? Follow the chain to its terminus.
- **Ownership vs. operational**: Distinguish between powers that threaten tokenholder sovereignty (e.g. multisig can upgrade core contracts, change fee splits, mint tokens) and operational functions (e.g. admin can pause in emergency, but tokenholders can replace the admin).

## What "ownership" means here

You are looking for mechanisms where ONDO tokenholders have **enforceable, on-chain control** that cannot be unilaterally overridden:

- Tokenholders can vote to change X → **ownership** (if the vote is binding and can't be vetoed)
- Tokenholders can vote but a multisig executes → **partial ownership** (depends on multisig composition and constraints)
- Team says tokenholders will eventually control X → **not ownership** (plans are not code)
- Multisig can change X without tokenholder approval → **no ownership**

The nuance: if tokenholders can set/replace the multisig members, they're still ultimately in control. Trace the full chain.

## What to include that's relevant

- Governance flows where tokenholders have final say
- Fee switches or revenue mechanisms that could direct value to tokenholders
- The relationship between ONDO governance and OUSG/USDY product parameters — can ONDO holders influence fee rates, minting, or redemption rules?
- Transfer restrictions, blocklists, or KYC gating on the ONDO token itself
- Veto or override powers held by non-tokenholder parties
- Multi-chain deployment — does governance scope differ by chain?
- The separation between Ondo Finance (company) and any onchain DAO — who actually controls what?

## What to exclude

- Operational admin functions where tokenholders retain the power to replace the admin
- General protocol quality metrics that don't relate to token holder rights
- Future plans or roadmap items without on-chain implementation

## Save progress

After each round, commit your updated research report to `research/ondo-research.md` on the `ondo` branch. Also copy to `../output/ondo-research.md` for the pipeline.

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
