# Memory Index

Short notes for every major change. One line = one change. Detail lives in linked file.

Format: `[date] short description — files affected — [detail-file](./detail-file.md)`

---

## 2026-06-01

- **MavericProPlus refactor — Phase 0: dead code removal.** Removed `Open_Pos_1()`, `DrawObjects()`, 5 commented-out trend blocks, 8 commented `GetLinearRegressionSlope` calls. File 1454 → 1376 lines. Zero behavior change.
  - Files: `Sale/MavericProPlus.mq4`
  - Detail: [2026-06-01-mavericproplus-phase0-deadcode.md](./2026-06-01-mavericproplus-phase0-deadcode.md)

- **MavericProPlus refactor — Phase 1: extract small helpers.** Added `CanBuy()`, `CanSell()`, `IsNewM30Bar()`, `ApplyComment()`. Replaced 4+4 `TradeDirn` checks, 2 NewBarTime reset patterns, 56 SetTradeComment+bIsTestMode patterns. File 1376 → 1156 lines. Zero behavior change.
  - Files: `Sale/MavericProPlus.mq4`
  - Detail: [2026-06-01-mavericproplus-phase1-helpers.md](./2026-06-01-mavericproplus-phase1-helpers.md)

- **MavericProPlus full logic analysis (read-only).** Connected `Experts/Sale` + `Include/Sale`; read main EA and the 3 includes (Trend_Math_Terex2, ProsantTradeManagerLight, ProsantaConst). Confirmed: trend-pullback martingale scalper, 4 baskets (Buy/Sal/TurboBuy/TurboSal, magic 14000+), M30 signals / M15 entry gate, ~30+ `CheckTrend_NN` MA+SAR rules, 35-pip grid w/ ×1.5–2 lot adds, ~10-pip basket TP, balance-step lot sizing. No code changed.
  - Files: (read-only) `Sale/MavericProPlus.mq4`, `Include/Sale/*.mqh`
  - Detail: [2026-06-01-mavericproplus-logic-analysis.md](./2026-06-01-mavericproplus-logic-analysis.md)

- **MavericProPlus Phase 3: entry/outcome condition logger.** Added `Include/Sale/EntryLogger.mqh` + wired into EA (include, globals, `ApplyComment` label capture, init register, 4× per-tick `Track`). Logs per-entry & per-add condition snapshots (MA stack, SAR, ma-cross, slopes, stoch/CCI, H1/H4 trend) and per-basket outcomes (max grid depth, peak floating drawdown, final P/L) to two CSVs. Behaviour-neutral. Backup `MavericProPlus.mq4.prelogger.bak`. Not yet compiled in MetaEditor.
  - Files: `Sale/MavericProPlus.mq4`, `Include/Sale/EntryLogger.mqh`
  - Detail: [2026-06-01-entry-logger-phase3.md](./2026-06-01-entry-logger-phase3.md)

- **MavericProPlus CheckTrend correctness audit (read-only).** Reviewed all ~57 `CheckTrend_NN`/`Turbo` functions + return-value census vs caller usage. Found: inverted/dead direction usage (e.g. BuySystem uses `_15`/`_8` which are DOWN-only), 3 provably-impossible conditions (`_2`,`_19`,`_29`), mislabeled UP/DOWN trees (`_21`,`_23`,`Turbo_2`), heavy curve-fit/over-fitting, nested non-overlapping range tests. Conclusion: signal layer is largely noise; profitability (if any) comes from the martingale, not predictive edge. No code changed.
  - Files: (read-only) `Include/Sale/Trend_Math_Terex2.mqh`
  - Detail: [document/AUDIT_CheckTrend_correctness.md](../document/AUDIT_CheckTrend_correctness.md)
