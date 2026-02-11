# Delegate Voting Indexer for ve-governance

## Overview

Build an indexing service that computes delegate voting breakdowns for Aragon's ve-governance system. The system reads votes from the `GaugeVoterPlugin` (referred to as the Gauge Voter / AddressGaugeVoter) and decomposes each vote into the underlying delegate contributions.

The source contracts are in the public repo `Aragon/ve-governance` on GitHub. The deployment target is the **Katana** network (use a public Katana RPC).

## Core problem

When a voter casts a vote on a gauge, their voting power may include delegated power from other users. The system must attribute voting power back to the original token holders:

**Example:**

- Alice holds 50 voting power, delegates to Bob
- Bob holds 100 voting power, delegates to himself (self-delegation)
- Charlie holds 200 voting power, delegates to himself

Bob votes with 150 total power (his 100 + Alice's 50). The output should record:

- Alice: 50 (voted via delegation to Bob)
- Bob: 100 (voted directly, self-delegated)
- Charlie: 200 (voted directly, self-delegated)

## Contract addresses (Katana)

| Contract              | Address                                      |
| --------------------- | -------------------------------------------- |
| DAO                   | `0x545A4657eefb4E5e3C3D016e5b4ff2E18b17C042` |
| Token                 | `0xC194b4424123275745547B1b7D7203C29A886733` |
| Gauge Voter Plugin    | `0x454318a35bCC04496CC206dc66C735f488067ca3` |
| Voting Escrow         | `0x33fb4429d67b2d022B9d40751d44A9DA9A84d02b` |
| Clock                 | `0x3A2c796c7Fca5EB0eB182D575Fe5645c5A08ad00` |
| NFT Lock              | `0x0Cd7A09151FA46dAd895102654e8879375d1D647` |
| Escrow IVotes Adapter | `0x156eA9a93cDE71a62FA929Ebeff656064e3C8D69` |
| Curve                 | `0xDD94d7D4B3c2771e00C6d700B755405a7Aa91B68` |
| Multisig Plugin       | `0xB23aC6a3Ca52d0bbEA395dBEFd42bFF0C458ac2E` |
| Vault                 | `0xb2cAF0EA4134B771f019a563056921c547fC9c73` |

### Gauges

- `0x0000000000000000000000000000000000000001`
- `0x0000000000000000000000000000000000000002`
- `0x0000000000000000000000000000000000000003`

### Reference

Contract details, delegation scenarios, and expected conditions:
https://gist.github.com/giorgilagidze/56a7d548516e3132d96c28ed2fdec155

## Key mechanisms to understand (from the contracts)

Study these contracts in `Aragon/ve-governance` carefully:

1. **Clock (`Clock_v1_2_0`)** — Defines epochs and voting windows. The relevant timestamp for snapshotting is the **end of the voting window** for a given epoch.

2. **GaugeVoterPlugin / AddressGaugeVoter** — Where votes are cast. Emits `Voted` and `Reset` events. Votes persist between epochs. A `Reset` without a subsequent re-vote means the user has not voted.

3. **VotingEscrow / veNFT** — Source of voting power. Users lock tokens to get veNFTs with decaying voting power.

4. **Delegation** — Users delegate their veNFT voting power to a delegate (can be themselves). Delegation status persists. Undelegation means the user's power is no longer counted in the delegate's vote.

5. **Late delegation edge case** — It may be possible for someone to delegate AFTER the delegate has already voted. Verify in the contracts whether this increments the delegate's vote count retroactively. If it does NOT, the late delegator must be recorded as not having voted, and the delegate would need to re-vote to include that power.

## Deliverables by stage

### Stage 1: Specification (`spec`)

Write a detailed specification document: `../output/spec.md`

The document should:

- Start with a clear, non-technical overview of how delegation and voting work
- Include diagrams (mermaid or ASCII) showing the delegation → voting → attribution flow
- Explain epoch timing via Clock, voting windows, and what "snapshot at end of voting window" means
- Detail the exact logic for decomposing a delegate's vote into per-delegator contributions
- Cover every edge case: undelegation, partial delegation, re-delegation, voting once, voting multiple times, resetting, late delegation
- Define discrete processing stages with invariants that must hold at each stage
- Lower sections should get progressively more technical: data model, event parsing logic, API shape

**Invariants** (must be explicitly defined and verified in the spec):

- Sum of latest `Voted` event power (after removing users whose latest event is `Reset`) must equal the total votes in the voter contract at that timestamp. Same per gauge.
- Sum of latest delegation status at a timestamp must equal the delegate's voting power at that timestamp.
- Sum of all attributed delegator contributions for a delegate must equal the delegate's total vote.

Also upload the spec to a public GitHub repo as a standalone markdown file.

### Stage 2: Polish (`polish`)

Editorial pass on `spec.md` — see editor instructions.

### Stage 3: Backend (`backend`)

Build the indexing backend in `../output/backend/`. Requirements:

- **Runtime**: Node.js/TypeScript
- **Database**: Supabase (Postgres) for caching computed results
- **Deployment**: Vercel serverless functions
- **REST API** exposing:
  - Results per epoch (cached after first computation — no re-run needed)
  - Row-level detail: by delegate, by voter, by gauge, by epoch
  - Aggregations: totals per gauge, totals per epoch, delegate rankings
- **Processing pipeline** matching the spec's discrete stages, with invariant checks at each stage
- **Caching**: Once an epoch's results are computed and cached, repeat queries hit the DB only. Must be fast.
- **Testing**: Unit tests for each processing stage. Invariant tests that run against live on-chain data at a fixed timestamp (end of voting window). Tests must pass.

The backend should live in the same repo as the spec. Push to GitHub when ready. Deploy to Vercel.

### Stage 4: Frontend (`frontend`)

Build an interactive site in `../output/frontend/` deployed alongside the backend on Vercel. Requirements:

- Display the spec content with interactive data visualizations inline
- Drilldown navigation: epoch → gauge → delegate → individual voter
- Aggregate views: top delegates (by attributed power), top voters, top gauges
- Ranking tables with sortable columns
- Epoch selector to browse historical data
- All data fetched from the backend REST API
- Responsive, loads fast, works on desktop and mobile

### Stage 5: Design (`design`)

Designer polishes the frontend — see designer instructions.

## Technical notes

- Use a public Katana RPC endpoint for on-chain reads
- The `Aragon/ve-governance` repo is public on GitHub — clone it or read contracts directly
- Service credentials (GitHub token, Vercel token, Supabase keys) are available via `../.env` if present
- All output goes in `../output/`
