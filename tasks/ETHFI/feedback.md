## Feedback

### Research Report

1. **RoleRegistry ownership — WRONG, redo this**: The research report claims the RoleRegistry is owned by the multisig. This is incorrect — you may be looking at an old version of the RoleRegistry. The correct RoleRegistry is at https://etherscan.io/address/0x62247D29B4B9BECf4BB73E0c722cf6445cfC7cE9#readProxyContract (follow the ownership chain from the Liquidity Pool contract to find it). The owner of this RoleRegistry is the **timelock**, not the multisig. This changes the entire ownership analysis. Re-trace the full permission chain from the RoleRegistry through to whoever controls the timelock. Update all downstream claims that depend on "multisig controls roles."

2. **Remove competitor mentions**: Do not mention Agora or Snapshot by name. We are Aragon — they are direct competitors. Offchain governance is just "offchain governance." If it's nonbinding and not onchain, we don't care about the specific platform.

3. **Decentralisation roadmap in overview**: Mention in the overview that Ether.fi is undergoing a multi-stage plan to decentralise the protocol. Keep it factual and brief.

4. **Timelock links needed**: Add both the source code link and Etherscan link for the EtherFi Timelock contract.

5. **Timelock scope — what does it control?**: Research and document exactly what the timelock controls. What functions go through it? What doesn't?

6. **Timelock PROPOSER_ROLE — check event logs**: Query the event logs to determine who holds PROPOSER_ROLE on the timelock. Do not assume — verify from onchain data.

7. **Role matrix**: Create a matrix of all roles in the system — who holds each role, what it can do, and how it can be changed.

8. **Link to ETHFI token code**: Include a link to the EtherFi token source code.

9. **Remove eETH censorship**: eETH censorship is irrelevant to this analysis. Drop it.

10. **Remove irrelevant balance data**: The ETHFI balance in the foundation wallet and the sETHFI total supply — what is the relevance? If there isn't a clear one for token ownership analysis, remove.

11. **Buyback evidence**: Is there a Dune dashboard or other data source showing the buybacks? Find and link it, or mark as unverifiable.

12. **Timelock proposer contradiction**: The report indicates the timelock proposers are the multisig, which contradicts earlier research in the same report. Resolve this contradiction.

13. **Link all addresses to Etherscan**: Every address mentioned in the report should be hyperlinked to its Etherscan page. Don't make the reader copy-paste addresses.

14. **Fee split documentation**: Where is the documentation for the fee split? Find and link the source, or note its absence.

15. **Token source code visibility — TBD**: The token is verified on Etherscan but the GitHub source is not publicly visible. This is a TBD finding, not a green check. Score accordingly.

16. **Vesting and unlocks — reframe**: Vesting and unlocks are noteworthy but give the team credit — they aren't hiding it, it's clear in the docs. Reframe as transparent rather than adversarial.

17. **Remove cryptorank link**: The CryptoRank link requires sign-up. Remove it and find an open alternative, or drop the claim.

18. **Licensing — check non-smart-contract IP**: Is there anything on intellectual property that is not smart contracts? Check for licensing of the protocol brand, documentation, SDKs, or other non-contract assets.

### Dashboard

**The synthesis/review process has not done a good job with information and evidence cascading. This needs significant rework. Use the research report as the source of truth and do not diverge from it.**

#### General editorial rules (apply to ALL metrics)

- Don't go overly technical for the sake of it, but provide sufficient evidence
- Bullet points don't translate well to this dashboard — use prose that summarises the points. Write readable English, not lists
- Don't lose important info, but don't include random stuff unless it's sourced and contributes to the information hierarchy
- Include L2 information IF NECESSARY for the metric, not by default
- Avoid inflammatory language
- Use links instead of hex addresses in text. If a contract is already linked, don't also specify the function call and address
- Don't say "Aragon research agent" — say "Aragon developers"
- Make sure every claim traces back to the research report. Do not fabricate or diverge

#### Specific fixes

19. **Remove "CRITICAL" from onchain control and protocol upgrade authority**: Tone it down. State the facts without inflammatory labels.

20. **RoleRegistry owner — simplify**: It's already linked to. No need to specify the function call or the address in the description text.

21. **Timelock scope — rewrite**: The bullet point list describing what the timelock controls needs to be rewritten as readable English prose, not a raw list.

22. **Upgrade Path Analysis — rewrite**: Not wrong, just overtly technical. Rewrite as readable prose that a non-technical reader can follow.

23. **Token upgrade authority — simplify**: No need for any of the technicals. It's non-upgradeable — just share the mainnet code link. **However, the L2 tokens ARE upgradeable — mention that!**

24. **Supply control — same treatment**: Simplify. Remove unnecessary technical detail while keeping the key facts.

25. **Buyback history data**: Is there a Dune dashboard or other data source showing buyback history? If yes, link it. If not, just remove the Dune dashboard comment entirely. Do NOT put "unverified" — either link the data or drop the mention.

26. **Treasury contract 0 balance — remove unverified tag**: Remove the "unverified" qualifier on the treasury contract 0 balance. Either state it as fact with a link or remove the claim.

27. **Onchain Control — add newlines**: Break up the Onchain Control summary text with newlines. It's a wall of text right now.

28. **Governance roadmap is 0-indexed**: The governance roadmap is 0-indexed, so we are still in phase 0. Fix this.

29. **"Bypass the timelock entirely" — deduplicate**: This phrase appears ~3 times in Protocol Upgrade Authority. Mention it once. Remove the duplicate mentions from the upgrade path evidence and the timelock scope sections.

30. **Token Upgrade Authority = TBD**: The L2 tokens are upgradeable. Need to check who owns the L2 proxy. This makes Token Upgrade Authority TBD, not green.

31. **Remove current circulating supply number**: It will change. Don't include stale figures.

32. **L2 upgradeability = censorship vector**: The L2 token upgradeability should be mentioned as a potential censorship vector. The L1 token is not upgradeable so L1 censorship is not possible. Be precise about which chain has the risk.

33. **Accrual active = green check**: Mark accrual active as green.

### Deploy Stage

34. **Vercel rate limiting**: At the deploy stage, check if the Vercel deployment failed due to rate limiting. If it was rate limited, reattempt the deployment. If it was not rate limited, do nothing.

### Research Scope Expansion

35. **EtherFi is more than an LST protocol**: EtherFi's recent moves are in the neobank direction. Summaries should reflect this broader positioning, not just characterise them as an LST protocol.

36. **Additional contracts to research** (from https://etherfi.gitbook.io/etherfi/staking):
    - **eUSD**: Boring vault, non-upgradeable. These are Veda vaults per the etherfi.gitbook.io docs. No owner but has a `RolesAuthority` contract with owner 0xCE (4/6 msig).
    - **beHYPE**
    - **eBTC**
    - **weETHs**
    - **weETHk**
    - EtherFi also has a number of other multichain liquid vaults.

37. **Research reviewer priority at this stage**: Review the full set of contracts (including the additional vaults above) and check if there are substantial deviations from the ownership model and how that maps back to ETHFI as a token. We don't need a full breakdown of the whole product suite, but for completeness it's worth listing these to have a baseline as things change.
    - Notable that most if not all of EtherFi is ultimately controlled via multisig. If we see examples where there truly is an onchain, fully tokenholder-owned flow, that's interesting, but it's extremely unlikely to change the whole picture.
    - Also, as sETHFI is a discretionary buyback system, unless one of these products has an unknown value flow component, it's also unlikely to change the value accrual piece.

### Research Report — Round 2 Feedback

38. **Treasury**: Treasury is a SafeProxy but doesn't appear to be upgradeable. It's a 3/8 sig (confirmed via `threshold` and enumerating `getOwners`).

39. **sETHFI is a Boring Vault**: Confirmed via code on Etherscan and cross-referenced with the gitbook docs that say EtherFi vaults are Veda Boring Vaults. They are non-upgradeable.

40. **Role matrix missing 1/6 multisig on sETHFI**: The role matrix doesn't list the 1/6 multisig on the sETHFI contract anywhere. Add it.

41. **What does the EtherFi Admin do?**: It seems to play an important role. Research and document its functions and permissions.

42. **List key contracts with one-liner descriptions**: To provide a better understanding, list the key contracts of the protocol with a very short one-liner regarding what exactly they do, and whether they are relevant for ownership or value accrual.

43. **Nit in Key Findings**: '**Value Accrual:** Active buyback program distributing to **_sETHFI stakers_**, but Foundation-discretionary via 1-of-5 wallet.' — should say "sETHFI holders" or "ETHFI stakers", not "sETHFI stakers".

44. **Treasury upgradeability = No**: In Governance and Ownership Model → Contract Architecture → Treasury, change [UNVERIFIED] to No.

45. **sETHFI upgradeability = No**: In Governance and Ownership Model → Contract Architecture → sETHFI, change [UNVERIFIED] to No.

46. **L2 token bypass of timelock**: In 'What Bypasses Timelock (role-based, instant)', add the ability of owners of ETHFI L2 tokens on Base and Arbitrum to call `setMinter()` and `upgradeToAndCall()` on the token contracts without a timelock.

47. **Specify which timelock**: You don't always specify which timelock is used. Clarify — is it always the Upgrade timelock? When is the Operating timelock used?

48. **LiquidityPool role holders — enumerate them**: LiquidityPool has Liquidity Pool Admin Role managed by the RoleRegistry. The RoleRegistry (the one that owns the LiquidityPool) exposes enumerable role holders. There are 2 for `LIQUIDITY_POOL_ADMIN_ROLE` (`0x0e8d94...`):
    - `0x0EF8fa4760Db8f5Cd4d993f3e3416f30f942D705` — EtherFi Admin
    - `0xcD425f44758a08BaAB3C4908f3e3dE5776e45d7a` — Operating Timelock
    - The analysis is good but check this where you can for all roles. No reason not to.

49. **Role system is convoluted — be pragmatic**: The RoleRegistry defines system roles but the hashes are defined on the relevant contracts. `RoleRegistry::owner` can manage roles unilaterally IF they are registered there and the contract proxy calls the registry. However, some contracts use AccessControl independently (e.g. timelocks maintain their own `hasRole` not managed by the registry, Safes have their own access pattern). The roles authority section is therefore incomplete. Be pragmatic: this is a very complex system and it's hard to trace every role. The important points people should know are the timelocks, the role registry, and the fact that many key roles are held by the Operating multisig and the EtherFi Admin. As all of these are ultimately malleable and tough to fully trace, the call is with the tokenholder on whether they trust EtherFi — but we've seen no evidence of bad faith. You mention this later but section 1.2 specifically is light on this.

50. **Section 1.3 — integrate vault contracts**: 1.3 suffers from not having all the contracts listed. The vaults section below explains the authority element to the boring vaults. Ensure that data is integrated with section 1.3, not siloed.

51. **Section 1.5 — 1B minted to a Safe**: Mention that the 1B minted tokens went to a Safe.

52. **Section 1.6 — privileged access beyond pause**: What you write is correct but privileged access extends beyond pause. Is pause the only role worth concerning ourselves over? What we care about is whether ETHFI holders have ultimate, meaningful control over protocol actions that aren't rote operational work. Pausing is a good example but there may be others like moving funds. In the ETHFI case, token holders have basically no role or access gating — say that.

53. **Section 2.1 — "stakers" is ambiguous**: EtherFi is a staking system so "stakers" can mean several things. The Protocol Fee Split to Stakers — is this eETH stakers, not ETHFI stakers? Be specific.
    - The rest of the info is good. Check if all signers on the 1/5 msig are EOAs, as 1-of-5 seems very low. Alternatively, is buyback execution a simple execution call and does that msig have no other power in the system?

54. **Integrate boring vaults into the wider overview**: Include them in the roles overview. Note: the vaults do accrue value in theory. The Dune dashboard shows liquid vault revenue, and the buyback docs state some protocol revenue is used (Stake, Liquid, and Cash).

55. **Cross-section integration**: Overall the research is good. The main change is to ensure sections accurately integrate new information. Right now it's all correct but spread across many places. If someone reads only some sections, the info feels incomplete. Consolidate and cross-reference so each section stands on its own while pointing to detail elsewhere.
