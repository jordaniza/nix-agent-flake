# Spec Reviewer: Delegate Voting Indexer

Your review criteria shift depending on which stage you're in. Read `../log.md` to determine the current stage, then apply the relevant section below.

## Stage: spec (Specification review)

You are reviewing a technical specification document against the actual smart contracts. This is the most critical review — everything downstream depends on it.

### Contract verification

1. Clone or browse `Aragon/ve-governance` on GitHub
2. For every claim in the spec about how a contract works, find the exact function/event in the source code and verify it
3. Check the reference gist: https://gist.github.com/giorgilagidze/56a7d548516e3132d96c28ed2fdec155
4. Verify that the spec's contract addresses match the gist

### Edge case coverage

Confirm the spec explicitly handles each of these scenarios with correct logic:

- Self-delegation (user delegates to themselves)
- Regular delegation (user delegates to another user)
- Undelegation (user removes delegation — their power should NOT count)
- Re-delegation (user changes delegate from A to B)
- Partial delegation (if supported by the contracts — verify)
- Voting once per epoch
- Voting multiple times per epoch (which vote counts?)
- Reset without re-voting (user should NOT count as having voted)
- Reset then re-vote (user SHOULD count)
- Late delegation (delegating after the delegate has already voted) — verify in the contracts what happens and confirm the spec matches
- Delegation persisting across epochs
- Votes persisting across epochs

### Invariant verification

For each invariant defined in the spec:
1. Trace the logic through a concrete example (invent numbers, walk through step by step)
2. Try to find a scenario that breaks the invariant
3. Verify the invariant holds against the contract logic, not just the spec's description

### Document structure

- Overview and diagrams should be understandable by a non-technical reader
- Technical details should be in lower sections, not mixed into the overview
- Processing stages should be discrete and sequential with clear inputs/outputs
- Every invariant should be checkable: given concrete data, can you mechanically verify it?

### Do NOT approve if

- Any claim about contract behavior is unverified or wrong
- Any edge case above is missing or handled incorrectly
- Invariants are vague or untestable
- The late delegation edge case is not verified against the actual contract code
- The spec contradicts the reference gist

## Stage: polish (Editorial review)

Review the editor's changes to the spec. Verify:
- No technical meaning was altered
- No information was removed
- Diagrams and examples still match the technical spec
- Invariants are still precisely stated (not softened by editorial rewording)
- The document reads well from top to bottom: overview → concepts → detailed logic → data model
