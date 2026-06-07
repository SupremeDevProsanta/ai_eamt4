# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

### v3.4 — fix logger blind spot: capture the blowup basket
**Key discovery while analysing the crash chart (equity 15,895 -> 3,285 at end).** The earlier NZDCAD analysis kept showing "all baskets recovered, 265/3 wins" — wrong conclusion caused by a logging bug, NOT by the strategy being safe. Root cause: the logger only wrote an outcome row + root-cause dump when a basket CLOSES (count->0). A blowup basket keeps adding lots and NEVER closes before the test/account ends, so it produced no outcome and no root-cause => invisible. The fatal end-of-run basket was structurally excluded from every stat.
Also corrected understanding: `float_profit` logged at ADD time is ~0 (logged the instant price hits the add level); only `peak_floating_dd` (tracked per tick, written at close) is meaningful — and for the killer it was never written.
**Fix (v3.4):**
- `Track()` now also dumps root-cause MID-RUN the moment a live basket breaches DD-money OR grid-depth (guarded by `m_dumped[slot]`, once per basket).
- New `Flush(trend,tm0..tm3)` called from EA `deinit()` BEFORE managers are deleted: for any still-open basket it finalizes peak DD, writes an outcome row with `close_time=OPEN_AT_END`, and dumps the root-cause replay. This captures the end-of-test blowup.
- VERSION 3.3 -> 3.4. Pushed (commit 4ec9097).
**Analysis caveats recorded:** (1) Original "wrong direction causes blowup" hypothesis was NOT supported by the (incomplete) NZDCAD data — with-trend entries actually drew down worse, deep baskets clustered in COVID-Mar2020 volatility, and a few checks dominated (`Turbo2 T2 DN3`, `Check58*`). BUT this was on data missing the blowup, so it's provisional. (2) Real risk signal so far points to VOLATILITY REGIME + specific weak checks, not trend direction. Must re-confirm once v3.4 captures an actual blowup. (3) The crash chart x-axis is trade-number, not date.
**Next:** re-run the crashing case with v3.4 so the OPEN_AT_END basket + its root-cause appear; then diagnose the true account-killer.

### v3.3 — root-cause replay + symbol/entry-reason columns
Extended `EntryLogger.mqh` per user request: log the FX pair, entry time, and entry reason explicitly, and auto-produce a root-cause reconstruction for any basket that ends beyond acceptable drawdown.
- entries/outcomes CSVs now carry `symbol`; direction written as BUY/SELL/NA; firing check kept as `reason_check`. Outcome rows add `breached_dd`/`breached_depth` flags.
- New third file `MPP_rootcause_<tag>.csv`: when a basket breaches **DD money OR grid depth** at close, dump a per-bar replay — 50-bar **look-back** before entry, the **ENTRY** bar, then full **look-forward** to close — each row with OHLC + MA8/20/50/100/200/300 + SAR + H1/H4 trend. This is the look-back/look-forward root-cause tool to find where the entry went wrong.
- `Init(tag, ddMoneyTrigger=50, depthTrigger=5, lookBack=50)`; EA `init()` wired with (50,5,50). User can tune later.
- Implementation uses `iBarShift` to map entry/close times to M30 bar indices, then replays via iOpen/iHigh/iLow/iClose/iMA/iSAR by shift.
- VERSION 3.2 → 3.3. Compiled clean earlier at 3.2; 3.3 adds only logging code (same patterns) — user to recompile. Pushed to GitHub (commit b673a9c). Note: workspace mount read-back lagged during this edit; host file verified correct via direct read before commit.

### Git version control set up + pushed to GitHub
Established the versioning workflow the user requested: every change bumps `#define VERSION` and is committed so any state can be reverted.
- Discovered the MT4 folders (`Experts/Sale`, `Include/Sale`) are on a fuseblk mount that blocks git's lock/unlink ops → cannot `git init` in place.
- Solution: maintain a real git working copy and push to remote `https://github.com/SupremeDevProsanta/ai_eamt4`.
-