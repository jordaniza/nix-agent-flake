# Task: Apply Aragon Ownership Token Framework to SKY (ex-MakerDAO)

## Background

Aragon has an Ownership Token Framework that evaluates governance tokens across standardised categories. The framework data lives in three files:

- **Framework categories**: https://github.com/aragon/ownership-token-framework/tree/development/src/data/framework.json
- **Detailed metrics per protocol**: https://github.com/aragon/ownership-token-framework/tree/development/src/data/metrics.json
- **Token metadata**: https://github.com/aragon/ownership-token-framework/tree/development/src/data/tokens.json
- **README with context**: https://github.com/aragon/ownership-token-framework/blob/development/README.md

## Deliverables

### 1. Research Report (`output/sky-research.md`)

A detailed markdown report covering SKY governance token across all categories defined in `framework.json`. Requirements:

- Every claim must have a source (link to contract, GitHub line, forum post, or documentation)
- Gold standard: contract address on Etherscan paired with corresponding line in the relevant GitHub repo
- Cover all framework categories, even if a category is not applicable (state why)
- Can be exhaustive — this is the basis for the condensed metrics

Sources to use:

- MakerDAO / Sky GitHub repositories
- Etherscan contract verification
- MakerDAO / Sky governance forums
- Official documentation

### 2. Metrics JSON (`output/sky-metrics.json`)

A JSON file for SKY in the style of existing entries in `metrics.json`. Must:

- Follow the exact schema of existing entries
- Be traceable back to the research report
- Include all required fields

## Quality Criteria

- Links must resolve and point to the correct content
- Contract addresses must be valid and verifiable on Etherscan
- Claims must be backed by cited evidence
- JSON must be valid and match the existing schema
