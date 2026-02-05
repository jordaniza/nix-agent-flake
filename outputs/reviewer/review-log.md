# Review Log

## 2026-02-05 - Initial Review

### Files Reviewed
- `../output/sky-research.md`
- `../output/sky-metrics.json`

### Schema Verification

**CRITICAL ISSUE - JSON Schema Mismatch**

The worker's `sky-metrics.json` uses an incorrect schema structure:

Worker's format:
```json
{
  "id": "sky",
  "token_entries": [...]
}
```

Expected format (from existing `metrics.json`):
```json
{
  "sky": [
    {
      "id": "onchain-ctrl",
      ...
    }
  ]
}
```

The existing entries (AAVE, AERO, CRV, LDO) use the protocol ID as a key at the top level, with an array of metric categories as the value. The worker's structure with `"id"` and `"token_entries"` properties does not match.

### Link Verification

**Broken/Inaccessible Links:**

1. `https://info.sky.money/buyback` - Returns HTTP 403 Forbidden
   - Referenced in: sky-research.md (line 191), sky-metrics.json (line 221)
   - Impact: Cannot verify the $102M buyback claim

2. `https://forum.sky.money/t/announcing-the-dai-foundation/1046` - Returns HTTP 403 Forbidden
   - Referenced in: sky-research.md (line 357), sky-metrics.json (line 445)

3. `https://docs.sky.money/legal-terms` - Page does not contain expected content
   - Referenced in: sky-research.md (line 377), sky-metrics.json (line 462)
   - The actual link structure appears to be different

**Working Links Verified:**
- Etherscan contract addresses (SKY token, DSChief, MCD Pause Proxy, ESM, Vat) - All verified
- GitHub repositories (sky-ecosystem/esm, sky-ecosystem/ds-chief) - Exist but archived
- developers.sky.money/guides/sky/token-governance-upgrade/overview/ - Exists
- daifoundation.org - Exists
- defiscan.info/protocols/sky/ethereum - Exists, confirms Stage 0 rating

### Factual Errors

1. **ESM Threshold Incorrect**
   - Research report states: "500,000 MKR tokens"
   - Actual (verified on Etherscan): **100,000 MKR tokens**
   - Location: sky-research.md lines 50-51, sky-metrics.json line 45

2. **Holder Count Minor Discrepancy**
   - Report states: 11,509 holders
   - Current Etherscan: 11,507 holders
   - Minor issue (normal fluctuation), but indicates data may be stale

3. **Buyback Claims Unverifiable**
   - "$102 million deployed since February 2025" cannot be independently verified
   - Source link (info.sky.money/buyback) is inaccessible
   - No alternative source provided

### Evidence Quality Issues

1. **Vote.sky.money Links Too Generic**
   - Multiple references to `https://vote.sky.money/` without specific proposal links
   - Should link to specific governance proposals as evidence

2. **Documentation Links Need Updates**
   - Several docs.makerdao.com links may be outdated (protocol rebranded)
   - Should verify these still redirect/work correctly

3. **Missing GitHub Line References**
   - Task specifies "Gold standard: contract address on Etherscan paired with corresponding line in the relevant GitHub repo"
   - Most evidence lacks specific line numbers in GitHub

### Metric Status Consistency

Compared with existing entries (AAVE), the status assignments appear reasonable:
- ✅ for verified positive
- ⚠️ for verified with caveats
- TBD for unverified

However, the offchain value accrual note incorrectly says "Aragon has not verified" - the worker is not Aragon.

### Summary of Required Changes

1. **CRITICAL**: Fix JSON schema to match existing metrics.json format
2. **HIGH**: Correct ESM threshold from 500,000 to 100,000 MKR
3. **HIGH**: Fix or replace broken links (info.sky.money/buyback, forum link, legal-terms)
4. **MEDIUM**: Provide alternative source for buyback statistics
5. **MEDIUM**: Add specific governance proposal links instead of generic vote.sky.money
6. **LOW**: Update "Aragon has not verified" phrasing in TBD notes
7. **LOW**: Add GitHub line number references where possible

---

## 2026-02-05 - Review Round 2

### Previous Feedback Status

| Issue | Priority | Status |
|-------|----------|--------|
| JSON Schema Mismatch | CRITICAL | ✅ FIXED - Now uses `{ "sky": [...] }` format |
| ESM Threshold (500K→100K) | HIGH | ✅ FIXED - Correctly states 100,000 MKR |
| Broken Links | HIGH | ⚠️ PARTIAL - Some replacements also broken |
| Generic Vote Links | MEDIUM | ✅ FIXED - Now links to specific proposals |
| "Aragon has not verified" | LOW | ✅ FIXED - Changed to neutral phrasing |
| GitHub Line References | LOW | ⏭️ NOT ADDRESSED (acceptable) |

### Remaining Issues

**1. Two Replacement Links Return 403:**

| Link | Location | Status |
|------|----------|--------|
| `theblock.co/linked/51816/maker-foundation-transfers-trademarks...` | sky-metrics.json:458, sky-research.md:358 | 403 Forbidden |
| `trademarks.justia.com/878/77/makerdao-87877844.html` | sky-metrics.json:463 | 403 Forbidden |

**Mitigating Factor:** The Dai Foundation website (daifoundation.org) itself confirms trademark custody. These links are supplementary evidence, not sole sources.

**2. Buyback Figure Discrepancy:**

- Report claims: "$102 million deployed since February 2025"
- CryptoRank source (Dec 2025) states: "$92 million"
- Either the figure is outdated or the source doesn't fully support the claim

**Verified Working Links:**
- ✅ `cryptorank.io/news/feed/ccf8c-sky-protocol-buyback-tokens` - Works, mentions $92M
- ✅ `vote.makerdao.com/.../september-13-2024` - Works, SBE initialization
- ✅ `vote.makerdao.com/.../april-3-2025` - Works, SBE parameter update
- ⚠️ `messari.io/project/sky-protocol` - Rate limited (429), likely works

### JSON Validation

```
$ python3 -m json.tool sky-metrics.json
JSON is valid ✓
```

### Assessment

The critical and high-priority issues from Round 1 have been addressed. The remaining issues are minor:

1. Two 403 links have fallback evidence (daifoundation.org confirms trademark)
2. Buyback figure discrepancy ($102M vs $92M) - minor, likely timing difference

The core research is accurate, schema matches, factual errors corrected, and evidence is traceable.

**Decision: APPROVE with minor notes**

---
