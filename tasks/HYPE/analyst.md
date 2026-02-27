# Analyst: HYPE Token Framework Entry

Your job is to take the exhaustive research report and condense it into framework-compliant JSON entries: `hype-tokens.json` and `hype-metrics.json`.

## Step 1: Load the schema

Read the existing `tokens.json` and `metrics.json` from the forked ownership-token-framework repo (check the `hype` branch). Study:

- The exact JSON schema and field structure
- How existing tokens (AAVE, LDO, CRV, UNI, AERO) structure their entries
- The information hierarchy: summaries → evidence groups → evidence links
- How scores are assigned and justified

## Step 2: Read the research report

Read `../output/hype-research.md` thoroughly. Map every finding to its corresponding framework criteria and metric.

## Step 3: Create the JSON entries

For `hype-tokens.json`:
- Token metadata and overall summary
- Category-level summaries
- Criteria-level summaries with scores

For `hype-metrics.json`:
- Metric-level detail with summaries, evidence groups, and evidence links
- Each evidence group should be a coherent cluster of related findings
- Evidence links must carry over from the research report

## Information hierarchy

1. **Summaries** (criteria and metric level): Human-readable, scannable. Use **bold** for key terms. Use `\n` for newlines. These are what a reader sees first — they should tell the story.
2. **Evidence groups**: Cluster related evidence with a descriptive title. Provide technical detail here.
3. **Evidence links**: Direct links to sources (GitHub lines, Etherscan, docs). These are the proof.

## Quality standards

- Every substantive finding in the research report must appear somewhere in the JSON. If condensing forces you to drop something, note what and why in your summary.md.
- Summaries should cascade: token summary → category summary → criteria summary → metric summary → evidence. Each level adds detail.
- Be precise but not verbose. Cut redundancy, not information.
- Scores must be justified by the evidence presented.
- JSON must be valid and parseable.

## Step 4: Save to GitHub

Write the JSON files to `../output/` and commit to the `hype` branch.

## Readability standards

- Summaries: plain language, lead with conclusion, minimise jargon
- Evidence: minimum sufficient set to make the case. Curate, don't dump.
- Links: verify every URL works before including. Check Etherscan function selectors.
- Formatting: build the site and verify rendering. If bold/newlines don't render, adapt.
- No speculation: unverifiable claims get "Aragon has not been able to verify..." treatment
- Use links instead of hex addresses in description text
- Write prose, not bullet point lists
- Say "Aragon developers" not "Aragon research agent"
