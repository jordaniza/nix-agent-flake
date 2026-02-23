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
