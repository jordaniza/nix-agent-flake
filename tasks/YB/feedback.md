## Feedback

### Research Report

1. **veYB owner EOA identity**: The EOA that owns veYB has the ENS `deployer._yb.eth`. Note this in the report.

2. **Remove vesting concerns**: The vesting contract's administrative power is noise for the average investor. Remove vesting-related concerns from the final dashboard output, though they can remain in the research report for completeness.

3. **veYB transfer restrictions — reframe correctly**: veYB censorship should be noted since YB is not yield-bearing unless locked into veYB. YB holders should know that the _transfer clearance checker_ contract (currently set to the gauge controller, only checking `self.vote_user_power[user] == 0`) could be changed by the veYB EOA to restrict transfers of veNFTs. However, be precise about what this means:
   - A transfer restriction is NOT necessarily censorship. It restricts the ability to move the veNFT or toggle infinite locks, but the user still remains custodian of the assets.
   - Overall conclusion: YB and veYB, although they have privileged roles outside of governance, are **not materially exposed to censorship**.

4. **Protocol upgrade authority = ownership, not TBD**: The DAO (token voters) controlling protocol upgrades definitively counts as ownership. Indirection through the governance process is irrelevant. Remove any "TBD" qualification.

5. **Remove access gating for vesting**: Not relevant for this analysis. Drop it.

6. **Fee mechanism — clarify the source of admin fees**: Want to understand in more detail where admin fees come from. The weekly distribution appears to be mandated in code as part of the `fill_epochs` logic. Trace this and explain clearly.

7. **FeeDistributor vs Treasury — separate these**: The FeeDistributor is a programmatic fee flow. The treasury is discretionary control. These are fundamentally different things and should not be conflated.

8. **Gauge weight voting = fee control by veYB**: Voting for gauge weights gives fees in YB as incentives. This is about fees to YB holders, and it's controlled by the DAO (veYB). Frame it this way.

9. **Remove vesting from final dashboard**: Even if vesting details remain in the research report, strip them from the dashboard JSON output entirely.

### Dashboard

10. **Protocol upgrade authority = green check**: This is ownership. Mark it accordingly.

11. **Token censorship — reframe**: Mention that the deployer can hypothetically prevent veYB transfers, but this doesn't censor the YB token itself. Therefore **Role Accountability should be green check**.

12. **Minting rate link is wrong**: The link shown for minting rate doesn't point to the code showing the % of max YB dependent on the ybBTC stake rate. Find and link the correct code.

13. **Ecosystem Reserve — missing from research**: Is the ecosystem reserve controlled by the DAO? This isn't in the research document. Research finding needed: the Ecosystem Reserve is a VestingEscrow controlled by an EOA. Add this to the research report first, then cascade properly to metrics.json.

14. **Vote execution timing — be precise**: Votes don't "immediately execute." Instead, votes can be executed immediately under certain preconditions. These are different things. Update the language to reflect this nuance.

15. **Remove treasury amount from dashboard**: The dashboard states 125M YB in the treasury which is double the actual amount. Remove the specific number — it can change at any time and a stale figure is worse than no figure.

16. **Treasury section restructure — this is critical, get it right**:
    - Move the current "Discretionary Control" content and its evidence block into the **Accrual Mechanism Control** section. The direction of automated value flows (fees, gauge rewards) is part of a value accrual mechanism, not treasury control.
    - **Treasury Ownership** is specifically about non-automated revenues that require discrete transactions (multisig or DAO txs) to distribute. Research and determine which of these applies:
      - If there is a discretionary treasury owned by veYB (DAO) → **green check**
      - If no discretionary treasury exists → **neutral**
      - If the Ecosystem Reserve (VestingEscrow) is controlled by an EOA/multisig rather than the DAO → **TBD**, and note this as a finding
    - The Ecosystem Reserve being a VestingEscrow controlled by an EOA (item 13) is relevant here. This needs to be researched first and then the treasury section scored accordingly.
