# SKY Governance Token Research Report

## Overview

**Token Name:** SKY Governance Token
**Symbol:** SKY
**Network:** Ethereum Mainnet
**Contract Address:** [0x56072C95FAA701256059aa122697B133aDEd9279](https://etherscan.io/address/0x56072C95FAA701256059aa122697B133aDEd9279)
**Token Standard:** ERC-20 with EIP-712 permit
**Total Supply:** ~23,462,665,147 SKY
**Holders:** 11,509 addresses
**Decimals:** 18

SKY is the sole governance token for the Sky Protocol (formerly MakerDAO). The protocol rebranded from MakerDAO to Sky in August 2024, with MKR holders able to convert to SKY at a 1:24,000 ratio. As of May 2025, SKY has exclusive governance authority and MKR can no longer be used for voting.

---

## Metric 1: Onchain Control

### 1.1 Onchain Governance Workflow

**Status:** Verified

SKY token holders control the protocol through an onchain governance process using the DSChief contract. The governance system uses continuous approval voting where token holders lock SKY to vote on proposals (called "slates").

**Key Contracts:**
- **Chief Contract (DSChief):** [0x0a3f6849f78076aefaDf113F5BED87720274dDC0](https://etherscan.io/address/0x0a3f6849f78076aefaDf113F5BED87720274dDC0)
- **MCD Pause Proxy:** [0xBE8E3e3618f7474F8cB1d074A26afFef007E98FB](https://etherscan.io/address/0xBE8E3e3618f7474F8cB1d074A26afFef007E98FB)

**Governance Flow:**
1. SKY holders lock tokens in the Chief contract via `lock()`
2. Users create proposal slates via `etch()` containing addresses (spells) to authorize
3. Holders vote on slates using `vote()`
4. The address with highest approval can be elected as "hat" (authority) via `lift()`
5. Governance actions execute through DSPause with an 18-hour delay

**Evidence:**
- [Chief Contract Source Code (Verified)](https://etherscan.io/address/0x0a3f6849f78076aefaDf113F5BED87720274dDC0#code)
- [DSChief GitHub Repository](https://github.com/sky-ecosystem/ds-chief)
- [Sky Protocol Governance Documentation](https://developers.sky.money/guides/sky/token-governance-upgrade/overview/)

### 1.2 Role Accountability

**Status:** Verified with Caveats

Privileged roles exist but are accountable to governance. Key roles include:

**Emergency Shutdown Module (ESM):**
- Address: [0x09e05fF6142F2f9de8B6B65855A1d56B6cfE4c58](https://etherscan.io/address/0x09e05fF6142F2f9de8B6B65855A1d56B6cfE4c58)
- Can irreversibly shutdown the entire protocol if 100,000 MKR tokens are sent to it (verified via `min` parameter in contract)
- This is a minority protection mechanism against malicious governance or critical bugs
- Tokens sent to ESM are permanently burnt

**DSPause:**
- 18-hour delay between spell approval and execution
- Provides time for community review and potential intervention
- Emergency pause functions can bypass this delay

**Evidence:**
- [ESM GitHub Repository](https://github.com/sky-ecosystem/esm)
- [ESM Contract Source](https://github.com/sky-ecosystem/esm/blob/master/src/ESM.sol)
- [DeFiScan Analysis](https://www.defiscan.info/protocols/sky/ethereum)

### 1.3 Protocol Upgrade Authority

**Status:** Verified - Tokenholder Controlled

Core protocol contracts are upgradeable through governance. The upgrade path follows:

**Upgrade Chain:**
1. Governance proposal (spell) created
2. SKY holders vote via Chief contract
3. Winning spell becomes "hat" authority
4. Spell executes through DSPause after 18-hour delay
5. DSPause Proxy executes the upgrade

**Key Upgradeable Components:**
- USDS stablecoin (via upgradeToAndCall)
- sUSDS savings contract
- Core protocol parameters in Vat and Vow contracts

**Evidence:**
- [MCD Pause Proxy (holds $143M+ in assets)](https://etherscan.io/address/0xBE8E3e3618f7474F8cB1d074A26afFef007E98FB)
- [Vat Core Accounting Contract](https://etherscan.io/address/0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B)
- [DeFiScan Permissions Analysis](https://www.defiscan.info/protocols/sky/ethereum)

### 1.4 Token Upgrade Authority

**Status:** Verified - Tokenholder Controlled

The SKY token uses a wards-based authorization system. The token contract has mint and burn functions that are restricted to authorized addresses (wards), which are controlled by governance.

**Token Contract Features:**
- `mint()` - Creates new tokens (auth-restricted to wards)
- `burn()` - Destroys tokens from any account
- `rely()` - Grants ward authorization (auth-restricted)
- `deny()` - Revokes ward authorization (auth-restricted)

**Authorization Chain:**
SKY Token Wards -> DSPause Proxy -> Governance

**Evidence:**
- [SKY Token Contract (Verified)](https://etherscan.io/address/0x56072C95FAA701256059aa122697B133aDEd9279#code)
- Compiler: Solidity v0.8.21+commit.d9974bed

### 1.5 Supply Control

**Status:** Governance Controlled (Not Fixed Supply)

Unlike MKR's fixed 1M cap (prior to burns), SKY has no hardcoded supply cap. The supply is controlled through the mint function accessible only to authorized wards. Current supply is approximately 23.46 billion SKY.

**Supply Mechanisms:**
- MKR to SKY conversion at 1:24,000 ratio (uni-directional)
- Converter V2 Contract: [0xA1Ea1bA18E88C381C724a75F23a130420C403f9a](https://etherscan.io/address/0xA1Ea1bA18E88C381C724a75F23a130420C403f9a)
- Smart Burn Engine burns SKY through buybacks
- Staking rewards may mint new SKY

**Delayed Upgrade Penalty:**
Since September 2025, a 1% penalty applies to MKR->SKY conversion, increasing by 1% every three months until 100% in 25 years.

**Evidence:**
- [SKY Token Total Supply on Etherscan](https://etherscan.io/token/0x56072c95faa701256059aa122697b133aded9279)
- [MKR to SKY Upgrade Documentation](https://upgrademkrtosky.sky.money/)
- [Token Governance Upgrade Overview](https://developers.sky.money/guides/sky/token-governance-upgrade/overview/)

### 1.6 Privileged Access Gating

**Status:** Verified with Caveats

The protocol has multiple privileged roles that can affect operations:

**Oracle Security Module (OSM):**
- 1-hour delay on price feed updates
- Chronicle oracles used for price feeds
- Validators include: Bitcoin Suisse, ETHGlobal, Gitcoin, Etherscan
- High centralization score noted by DeFiScan

**Emergency Functions:**
- DSPause can halt governance execution
- Emergency Shutdown Module can irreversibly shutdown protocol
- LitePSM halt function can stop USDC swaps

**USDC Dependency:**
- Protocol relies heavily on Circle's USDC for USDS peg
- Dynamic debt ceiling can reach 10 billion USDS
- This represents significant counterparty risk

**Evidence:**
- [DeFiScan Stage 0 Analysis](https://www.defiscan.info/protocols/sky/ethereum)
- [Chronicle Oracle Documentation](https://chroniclelabs.org/)

### 1.7 Token Censorship

**Status:** Verified - No Censorship Capabilities

The SKY token contract contains no blacklist, freeze, or seizure functions. Token transfers are permissionless once tokens are held.

**Contract Analysis:**
- No `freeze()` or `blacklist()` functions in bytecode
- No pause mechanism on transfers
- Standard ERC-20 transfer functions without restrictions
- EIP-712 permit for gasless approvals

**Evidence:**
- [SKY Token Implementation Code](https://etherscan.io/address/0x56072C95FAA701256059aa122697B133aDEd9279#code)

---

## Metric 2: Value Accrual

### 2.1 Accrual Active

**Status:** Verified - Active

Value actively accrues to SKY holders through multiple mechanisms:

**Smart Burn Engine:**
- Automatically buys back and burns SKY using protocol surplus
- Current daily allocation: up to 300,000 USDS for buybacks
- Over $102 million deployed since February 2025
- Approximately 5.55% of circulating supply repurchased

**Staking Engine:**
- Replaced the Seal Engine
- Users supply SKY to generate/borrow USDS
- Earn staking rewards
- Delegate voting power
- No exit fee (unlike previous Seal Engine)

**Evidence:**
- [Sky Protocol Buyback Analysis (CryptoRank)](https://cryptorank.io/news/feed/ccf8c-sky-protocol-buyback-tokens)
- [Smart Burn Engine Initialization Proposal (Sept 2024)](https://vote.makerdao.com/executive/template-executive-vote-out-of-schedule-executive-vote-usds-susds-and-sky-tokens-initialization-sbe-upgrade-sky-dssvestmintable-setup-usds-sky-farming-setup-usds-01-farming-setup-miscellaneous-actions-september-13-2024)
- [Staking Engine Documentation](https://developers.sky.money/)
- [Sky Protocol Research (Messari)](https://messari.io/project/sky-protocol)

### 2.2 Treasury Ownership

**Status:** Verified - Tokenholder Controlled

Protocol treasury is programmatically controlled by SKY governance through the Vow contract and DSPause Proxy.

**Treasury Components:**
- **Vow Contract:** Tracks system surplus and debt, initiates auctions
- **Surplus Buffer:** Must be exceeded before surplus auctions/distributions
- **MCD Pause Proxy Holdings:** $143.1M+ in assets including:
  - SPK (Spark): $115.8M (80.9%)
  - SKY: $27.3M (19.05%)
  - MKR: $68.6K (0.05%)

**Value Sources:**
- Stability fees from vault positions
- Liquidation penalties
- Protocol surplus from lending operations

**Evidence:**
- [Vow Detailed Documentation](https://docs.makerdao.com/smart-contract-modules/system-stabilizer-module/vow-detailed-documentation)
- [MCD Pause Proxy Holdings](https://etherscan.io/address/0xBE8E3e3618f7474F8cB1d074A26afFef007E98FB)

### 2.3 Accrual Mechanism Control

**Status:** Verified - Tokenholder Controlled

SKY holders control all value accrual parameters through governance:

**Controllable Parameters:**
- Stability fees per collateral type
- Savings rate (formerly DAI Savings Rate, now Sky Savings Rate)
- Liquidation ratios and penalties
- Smart Burn Engine allocation percentages
- Staking reward APY and allocation

**Evidence:**
- [Pot Contract (Savings Rate)](https://docs.makerdao.com/smart-contract-modules/rates-module/pot-detailed-documentation)
- [Smart Burn Engine Parameter Update Proposal (Apr 2025)](https://vote.makerdao.com/executive/template-executive-vote-allocator-bloom-a-initialization-smart-burn-engine-parameter-update-spark-tokenization-grand-prix-dao-resolution-spark-proxy-spell-april-3-2025)

### 2.4 Offchain Value Accrual

**Status:** Not Verified

No verified offchain value accrual flows to SKY holders have been identified. The protocol operates primarily through onchain mechanisms.

---

## Metric 3: Verifiability

### 3.1 Token Contract Source Verification

**Status:** Verified

The SKY token contract source code is publicly available and verified on Etherscan with exact bytecode match.

**Verification Details:**
- Contract Address: [0x56072C95FAA701256059aa122697B133aDEd9279](https://etherscan.io/address/0x56072C95FAA701256059aa122697B133aDEd9279)
- Verification Status: Verified (Exact Match)
- Compiler: Solidity v0.8.21+commit.d9974bed
- License: AGPL-3.0

**Evidence:**
- [Etherscan Verified Source](https://etherscan.io/address/0x56072C95FAA701256059aa122697B133aDEd9279#code)

### 3.2 Protocol Component Source Verification

**Status:** Verified

All core Sky Protocol contracts are open source and verified on Etherscan.

**Key Verified Contracts:**
| Contract | Address | Verified |
|----------|---------|----------|
| SKY Token | 0x56072C95FAA701256059aa122697B133aDEd9279 | Yes |
| DSChief (Governance) | 0x0a3f6849f78076aefaDf113F5BED87720274dDC0 | Yes |
| MCD Pause Proxy | 0xBE8E3e3618f7474F8cB1d074A26afFef007E98FB | Yes |
| Vat (Core) | 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B | Yes |
| USDS Proxy | 0xdC035D45d973E3EC169d2276DDab16f1e407384F | Yes |
| ESM | 0x09e05fF6142F2f9de8B6B65855A1d56B6cfE4c58 | Yes |
| MKR-SKY Converter V2 | 0xA1Ea1bA18E88C381C724a75F23a130420C403f9a | Yes |

**GitHub Repositories:**
- [DSS (Dai Stablecoin System)](https://github.com/sky-ecosystem/dss) - 812 stars, 441 forks, AGPL-3.0
- [DSS Deploy](https://github.com/makerdao/dss-deploy)
- [ESM](https://github.com/sky-ecosystem/esm)
- [Developer Guides](https://github.com/sky-ecosystem/developerguides)

**Evidence:**
- [Sky Ecosystem GitHub Organization](https://github.com/sky-ecosystem)
- [DSS Repository](https://github.com/makerdao/dss)

---

## Metric 4: Token Distribution

### 4.1 Ownership Concentration

**Status:** Partially Verified

**Current Distribution:**
- Total Holders: 11,509 addresses
- Circulating Supply: ~23B SKY
- Migration Status: ~26% of MKR converted to SKY as of May 2025

**Known Large Holders:**
- MCD Pause Proxy (Treasury): $27.3M in SKY
- Chief Contract: 3,651 MKR locked (~$5M)
- Converter contracts hold unconverted supply

**Concentration Concerns:**
- Large portion of supply still exists as MKR (not yet converted)
- Original MKR distribution was concentrated among early participants and Maker Foundation
- Specific whale concentration data not independently verified

**Evidence:**
- [SKY Token Holders on Etherscan](https://etherscan.io/token/0x56072c95faa701256059aa122697b133aded9279#balances)

### 4.2 Future Token Unlocks

**Status:** Partially Verified

**MKR to SKY Migration:**
- Conversion ratio: 1 MKR = 24,000 SKY
- ~74% of MKR still unconverted as of May 2025
- Delayed Upgrade Penalty reduces conversion rate over time (1% penalty increasing quarterly)

**Potential Supply Events:**
- Continued MKR migration will increase SKY supply
- Staking rewards may mint new SKY
- Smart Burn Engine reduces supply through buybacks

**Evidence:**
- [Token Governance Upgrade Overview](https://developers.sky.money/guides/sky/token-governance-upgrade/overview/)
- [MKR to SKY Upgrade Page](https://upgrademkrtosky.sky.money/)

---

## Offchain Dependencies

### Trademark

**Status:** Held by Independent Foundation

The Maker and Dai trademarks were transferred to the Dai Foundation in early 2020 for perpetual safekeeping.

**Dai Foundation:**
- Location: Denmark
- Type: Independent non-profit foundation
- Purpose: Safeguard MakerDAO/Sky community intellectual property
- Website: [daifoundation.org](https://daifoundation.org/)

**Key Points:**
- Foundation operates on objective, rigid statutes
- Not operationally controlled by Sky governance
- Board initially included Maker Foundation members, transitioning to independent members
- Holds Maker/Dai trademark portfolios

**Note:** The "Sky" trademark status and whether it has been transferred to the Dai Foundation is not explicitly confirmed in available documentation.

**Evidence:**
- [Dai Foundation Website](https://daifoundation.org/)
- [Trademark Transfer Announcement (The Block)](https://www.theblock.co/linked/51816/maker-foundation-transfers-trademarks-and-ip-to-independent-foundation)
- [MakerDAO Trademark Registration (Justia)](https://trademarks.justia.com/878/77/makerdao-87877844.html)

### Distribution

**Status:** Operated by Separate Entity

The primary interface (sky.money) is operated by Skybase International, a separate legal entity from Sky governance.

**Skybase International:**
- Operates sky.money interface
- Retains all rights to the Services per legal terms
- Not the issuer of tokens
- Does not control protocol smart contracts

**Key Interfaces:**
- sky.money - Primary user interface
- vote.sky.money - Governance voting portal
- developers.sky.money - Developer documentation

**Evidence:**
- [Sky.money Website](https://sky.money/)
- [Sky Protocol Profile (Messari)](https://messari.io/project/sky-protocol/profile)

### Licensing

**Status:** Open Source (AGPL-3.0)

Core protocol smart contracts are licensed under GNU Affero General Public License v3 (AGPL-3.0).

**License Terms:**
- Source code must be disclosed
- Modifications must be shared under same license if distributed
- Network use triggers distribution requirements

**Repositories:**
- DSS (core contracts): AGPL-3.0
- ESM: Open source
- Developer guides: Open source

**Evidence:**
- [DSS Repository License](https://github.com/makerdao/dss)
- [Sky Ecosystem GitHub](https://github.com/sky-ecosystem)

---

## Security Considerations

### DeFiScan Assessment

Sky Protocol is rated **Stage 0** by DeFiScan, indicating significant centralization risks:

**Stage 1 Failures (2 of 3):**
- Upgrades enabling fund loss lack 7-day Exit Window
- Chronicle oracle dependency has high centralization score

**Stage 2 Failures (2 of 3):**
- Exit Window (18 hours) below 30-day requirement
- Oracle provider centralization

### Audits

Multiple security audits conducted by ChainSecurity for:
- Sky smart contracts
- MakerDAO Lockstake smart contracts
- Core DSS contracts

**Evidence:**
- [Security Measures Overview](https://developers.sky.money/security/security-measures/overview/)

---

## Summary

SKY is a legitimate governance token with strong onchain control mechanisms. Key strengths include:

1. **Full onchain governance** with verified voting and execution contracts
2. **No token censorship** capabilities (freeze, blacklist)
3. **Active value accrual** through buybacks and staking
4. **Complete source code verification** on Etherscan
5. **Open source** under AGPL-3.0

Key concerns include:

1. **Governance-controlled supply** with no fixed cap
2. **Relatively short exit window** (18 hours)
3. **Oracle centralization** risk
4. **USDC dependency** for USDS peg
5. **Offchain entity separation** - interface and trademarks controlled by separate entities

The protocol represents a mature DeFi governance system evolved from MakerDAO, with most critical functions under tokenholder control, though with some centralization vectors that prevent higher DeFiScan stage ratings.
