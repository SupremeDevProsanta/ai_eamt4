# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

### Git version control set up + pushed to GitHub
Established the versioning workflow the user requested: every change bumps `#define VERSION` and is committed so any state can be reverted.
- Discovered the MT4 folders (`Experts/Sale`, `Include/Sale`) are on a fuseblk mount that blocks git's lock/unlink ops → cannot `git init` in place.
- Solution: maintain a real git working copy and push to remote `https://github.com/SupremeDevProsanta/ai_eamt4`.
- Credential read from `E:\project\github\git_token.txt` (PAT). Token used only transiently in the remote URL for the push, then scrubbed from the remote config. **Token is still valid — rotate if desired.**
- Repo layout: `Experts/Sale/` (EA + `.bak` snapshots), `Include/Sale/` (EntryLogger + Trend_Math_Terex2 + ProsantTradeManagerLight + ProsantaConst), `document/` (audit), `memory/` (these notes). `.ex4` gitignored. `.gitattributes` keeps `.mqh/.md` as text, `.mq4` binary-safe (UTF-16).
- Commits pushed to `main`:
  1. `Baseline: MavericProPlus v3.1 (post Phase 0/1 refactor, pre-logger)`
  2. `v3.2: add behaviour-neutral entry/outcome condition logger`
  3. `Add .gitattributes`
- Bumped EA `#define VERSION` 3.1 → 3.2 (the logger change).

### Workflow convention established (per user)
On startup: read `memory/memory.md` for the brief of all tasks; follow the linked detail/worklog references for depth. Each task done each day → append to `memory/worklog.md`, then update the one-line brief in `memory/memory.md`. Every code change → bump VERSION + commit + push.

## 2026-06-01 (Monday)

### 06:50 UTC — MavericProPlus Phase 3: entry/outcome logger (behaviour-neutral)
Implemented the user's learn-and-rectify plan step 1. New `Include/Sale/EntryLogger.mqh` logs, per basket: ENTRY + each martingale ADD with a full condition snapshot (MA 8/20/50/100/200/300, ma-cross ages, slopes, SAR, stoch, CCI, and H1/H4 trend labels), plus a per-basket outcome row (max grid depth, peak floating drawdown, final P/L, check-at-open). Wired into `MavericProPlus.mq4` via 5 verified edits on the UTF-16 file: include, globals (`m_Logger`, `g_LastSignalLabel`), label capture in `ApplyComment`, `Init`+`Register` in init(), and 4× per-tick `Track` calls in start(). Verified brace/paren balance and that all referenced members exist; encodings preserved. Backup `MavericProPlus.mq4.prelogger.bak`. Still needs MetaEditor compile + a backtest to produce the CSVs. Detail: [2026-06-01-entry-logger-phase3.md](./2026-06-01-entry-logger-phase3.md).

### 03:55 UTC — MavericProPlus CheckTrend correctness audit (read-only)
Read all ~57 `CheckTrend_NN` + `CheckTrend_Turbo*` signal functions in `Trend_Math_Terex2.mqh` and ran a return-value census cross-checked against `BuySystem`/`SellSystem`/`Turbo` callers. Documented 7 findings incl. 2 critical: (1) inverted/dead direction usage — BuySystem calls DOWN-only checks like `_15` and `_8==TREND_UP` (dead/inverted); (2) provably-impossible conditions in `_2`, `_19`, `_29`. Plus mislabeled UP/DOWN trees, curve-fit over-fitting, non-overlapping nested range tests, leftover commented "working" logic. Conclusion: signal layer is largely noise; any profitability comes from the martingale grid, not entry edge. No code modified. Report: `document/AUDIT_CheckTrend_correctness.md`.

### 03:31 UTC — MavericProPlus full logic analysis (read-only)
Connected `MQL4/Experts/Sale` and `MQL4/Include/Sale`. Read the main EA plus its three core includes (`Trend_Math_Terex2.mqh` signals, `ProsantTradeManagerLight.mqh` order/martingale engine, `ProsantaConst.mqh` enums). Mapped the complete strategy end-to-end: 4 parallel baskets, M30 trend signals + M15 entry gating, ~30+ `CheckTrend_NN` MA/SAR rules, flat-only/pullback entries, 35-pip martingale grid (×1.5–2 lot adds), ~10-pip basket TP, b