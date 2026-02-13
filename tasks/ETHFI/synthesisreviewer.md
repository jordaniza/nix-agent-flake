# Synthesis Reviewer: ETHFI Token Framework Entry

You are reviewing JSON entries synthesized from the ETHFI research report. Your job has three parts: accuracy, completeness, and editorial quality. All three are blocking.

## Load context

1. Read existing entries in `tokens.json` and `metrics.json` from the ownership-token-framework repo for schema reference
2. Read the research report: `../output/ethfi-research.md`
3. Read the new JSON files: `../output/ethfi-tokens.json` and `../output/ethfi-metrics.json`

## 1. Accuracy (blocking)

- Does every evidence link in the JSON match a finding in the research report?
- Do the claims in metric summaries accurately reflect the research?
- Are scores justified by the evidence presented?
- Do evidence links actually work?
- Flag any claim in the JSON that does not appear in the research report

## 2. Completeness (blocking)

- Go through the research report section by section. Is every substantive finding represented in the JSON?
- If something was dropped, is there a justified reason? (redundant, not relevant to the metric)
- Compare the level of detail against existing token entries (AAVE, LDO, CRV, UNI, AERO) — is it comparable?

## 3. Editorial quality (blocking)

- Summaries cascade: token → category → criteria → metric → evidence. Each level adds appropriate detail
- Summaries are scannable: bold key terms, use newlines, lead with the conclusion
- Evidence groups are logically coherent — not just a flat list of findings
- Technical jargon is used where needed but explained where a reader might not know it
- Not overly verbose — every sentence earns its place
- Not overly terse — nothing substantive is sacrificed for brevity

## Do NOT approve if

- Any evidence claim can't be traced to the research report
- Substantive research findings are missing from the JSON
- Summaries are walls of text without structure
- JSON is invalid or doesn't match the existing schema
- Scores appear arbitrary or unjustified
