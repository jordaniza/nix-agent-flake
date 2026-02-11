# Spec Writer: Delegate Voting Indexer

## Your job

Write `../output/spec.md` — a specification document for an indexing service that decomposes delegate voting in Aragon's ve-governance system.

## Where to start

1. Clone `Aragon/ve-governance` from GitHub
2. Read these contracts in detail:
   - `Clock_v1_2_0` — epoch timing, voting windows
   - `GaugeVoterPlugin` / `SimpleGaugeVoter` / `AddressGaugeVoter` — vote casting, `Voted` and `Reset` events, vote persistence
   - `VotingEscrow` — veNFT creation, voting power calculation, decay curves
   - Delegation contracts — how delegation is recorded, how delegated power is tracked, how undelegation works
3. Check the reference gist for contract addresses and expected conditions: https://gist.github.com/giorgilagidze/56a7d548516e3132d96c28ed2fdec155
4. Cross-reference on-chain state on Katana to verify your understanding

## What the spec must cover

1. **Overview** (non-technical) — what this system does and why, in one paragraph
2. **Delegation and voting flow** — how tokens → veNFTs → delegation → voting works, with diagrams
3. **Epoch and timing** — how Clock defines epochs, voting windows, and what "end of voting window" means as a snapshot point
4. **Vote decomposition algorithm** — the exact steps to take a delegate's total vote and split it into per-delegator contributions
5. **Edge cases** — each one with a concrete numeric example:
   - Self-delegation
   - Undelegation (power should NOT count)
   - Re-delegation (changing delegate)
   - Late delegation (after delegate voted — check if it retroactively increments the vote)
   - Reset without re-vote (not a voter)
   - Reset then re-vote
   - Multiple votes in one epoch (which counts?)
   - Delegation and votes persisting across epochs
6. **Processing stages** — discrete steps an indexer runs, with inputs and outputs for each
7. **Invariants** — formal statements that must hold, with verification procedures
8. **Data model** — tables/fields for caching results
9. **API shape** — endpoints, query parameters, response format

## Invariants to define

At minimum:
- Sum of latest `Voted` power (after removing Reset users) = total votes in the voter contract at that timestamp. Same per gauge.
- Sum of delegation status at a timestamp = delegate's voting power at that timestamp.
- Sum of attributed delegator contributions for a delegate = delegate's total vote.

## When done

Upload the spec to a public GitHub repo as a standalone markdown file using `gh`.
