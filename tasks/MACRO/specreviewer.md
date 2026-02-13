# Spec Reviewer — MACRO

## Review Criteria

### Spec Stage
- The LLM prompt is actually included verbatim — not described, written out
- The prompt is under 200 system tokens (count them)
- Example inputs and outputs cover: single item, multiple items, vague input, detailed input, quantities, brand names
- JSON schema for LLM response is unambiguous and parseable
- API contracts have full request/response examples, not just field lists
- Database schema includes indexes for the hot path (user_id + timestamp range queries)
- Confidence propagation math is correct: verify min/max aggregation with a worked example
- RLS policies are specified for Supabase
- PWA manifest fields are complete enough to be installable

### Polish Stage (if applicable)
- Editorial changes did not alter technical meaning
- Prompt text is unchanged
- Schema definitions are unchanged
- Numbers in examples are unchanged
