# Memory Index

Short notes for every major change. One line = one change. Detail lives in linked file.

Format: `[date] short description — files affected — [detail-file](./detail-file.md)`

---

## How to use this memory system

On startup, read this file (`memory.md`) for a one-line brief of every task. For full detail, open the linked detail file or the matching dated entry in [`worklog.md`](./worklog.md). When a task is done: append the detail to `worklog.md`, then add/refresh the one-line brief here. Every code change bumps the EA `#define VERSION` and is committed + pushed to GitHub (`SupremeDevProsanta/ai_eamt4`).

---

## 2026-06-07

- **Git version control + GitHub push.** Set up versioning workflow (VERSION bump + commit per change). MT4 folders are on a mount that blocks in-place git, so a working copy is pushed to `github.com/SupremeDevProsanta/ai_eamt4` (token at `E:\project\github\git_token.txt`). Pushed baseline v3.1, v3.2 (logger), and `.gitattributes`. EA now at **v3.2**.
  - Files: repo `ai_eamt4` (Experts/Sale, Include/Sale, document, memory)
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

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

- **MavericProPlus Phase 3: entry/outcome condition logger.** Added `Include/Sale/EntryLogger.mqh` + wired into EA (include, globals, `ApplyComment` label capture, init register, 4× per-tick `Track`). Logs per-entry & per-add condition snapshots (MA stack, SAR, ma-cross, slopes, stoch/CCI, H1/H4 trend) and per-basket outcomes (max grid depth, peak floating drawdown, final P/L) to two CSVs. Behaviour-n