# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-01 (Monday)

### 06:50 UTC — MavericProPlus Phase 3: entry/outcome logger (behaviour-neutral)
Implemented the user's learn-and-rectify plan step 1. New `Include/Sale/EntryLogger.mqh` logs, per basket: ENTRY + each martingale ADD with a full condition snapshot (MA 8/20/50/100/200/300, ma-cross ages, slopes, SAR, stoch, CCI, and H1/H4 trend labels), plus a per-basket outcome row (max grid depth, peak floating drawdown, final P/L, check-at-open). Wired into `MavericProPlus.mq4` via 5 verified edits on the UTF-16 file: include, globals (`m_Logger`, `g_LastSignalLabel`), label capture in `ApplyComment`, `Init`+`Register` in init(), and 4× per-tick `Track` calls in start(). Verified brace/paren balance and that all referenced members exist; encodings preserved. Backup `MavericProPlus.mq4.prelogger.bak`. Still needs MetaEditor compile + a backtest to produce the CSVs. Detail: [2026-06-01-entry-logger-phase3.md](./2026-06-01-entry-logger-phase3.md).

### 03:55 UTC — MavericProPlus CheckTrend correctness audit (read-only)
Read all ~57 `CheckTrend_NN` + `CheckTrend_Turbo*` signal functions in `Trend_Math_Terex2.mqh` and ran a return-value census cross-checked against `BuySystem`/`SellSystem`/`Turbo` callers. Documented 7 findings incl. 2 critical: (1) inverted/dead direction usage — BuySystem calls DOWN-only checks like `_15` and `_8==TREND_UP` (dead/inverted); (2) provably-impossible conditions in `_2`, `_19`, `_29`. Plus mislabeled UP/DOWN trees, curve-fit over-fitting, non-overlapping nested range tests, leftover commented "working" logic. Conclusion: signal layer is largely noise; any profitability comes from the martingale grid, not entry edge. No code modified. Report: `document/AUDIT_CheckTrend_correctness.md`.

### 03:31 UTC — MavericProPlus full logic analysis (read-only)
Connected `MQL4/Experts/Sale` and `MQL4/Include/Sale`. Read the main EA plus its three core includes (`Trend_Math_Terex2.mqh` signals, `ProsantTradeManagerLight.mqh` order/martingale engine, `ProsantaConst.mqh` enums). Mapped the complete strategy end-to-end: 4 parallel baskets, M30 trend signals + M15 entry gating, ~30+ `CheckTrend_NN` MA/SAR rules, flat-only/pullback entries, 35-pip martingale grid (×1.5–2 lot adds), ~10-pip basket TP, balance-step lot sizing, near-disabled stop. Noted `TradeTime()` is defined but unused in `start()`. No code modified. See detail: [2026-06-01-mavericproplus-logic-analysis.md](./2026-06-01-mavericproplus-logic-analysis.md).

### 23:18 UTC — Memory tracking system created
Added `memory/` directory with `memory.md` (index), `worklog.md` (timeline), and per-change detail files for Phase 0 and Phase 1.

### ~22:55 UTC — MavericProPlus Phase 1: extract helpers
Added 4 helper functions (`CanBuy`, `CanSell`, `IsNewM30Bar`, `ApplyComment`) and replaced 64 repeated patterns. File reduced from 1376 → 1156 lines. Backup saved as `MavericProPlus.mq4.phase0.bak`. See detail: [2026-06-01-mavericproplus-phase1-helpers.md](./2026-06-01-mavericproplus-phase1-helpers.md).

### ~22:35 UTC — MavericProPlus Phase 0: dead code removal
Removed empty `Open_Pos_1()`, dead `DrawObjects()`, 5 fully-commented trend-check blocks, 8 commented `GetLinearRegressionSlope` lines. File reduced from 1454 → 1376 lines. Backup saved as `MavericProPlus.mq4.bak`. See detail: [2026-06-01-mavericproplus-phase0-deadcode.md](./2026-06-01-mavericproplus-phase0-deadcode.md).

### ~22:20 UTC — File access granted
Connected folder `MQL4/Experts/Sale` for reading and editing EA source files.

### ~22:15 UTC — Initial analysis of MavericProPlus.mq4
Read full 1454-line file. Identified architecture: 4 parallel TradeManagers (Buy / Sal / TurboBuy / TurboSal), MA-trend-driven entry cascade (~30 checks), 35-pip martingale grid, M15 new-bar gating. Listed 9 refactor opportunities.
