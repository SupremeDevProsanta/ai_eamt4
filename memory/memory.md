# Memory Index

Short notes for every major change. One line = one change. Detail lives in linked file.

Format: `[date] short description — files affected — [detail-file](./detail-file.md)`

---

## How to use this memory system

On startup, read this file (`memory.md`) for a one-line brief of every task. For full detail, open the linked detail file or the matching dated entry in [`worklog.md`](./worklog.md). When a task is done: append the detail to `worklog.md`, then add/refresh the one-line brief here. Every code change bumps the EA `#define VERSION` and is committed + pushed to GitHub (`SupremeDevProsanta/ai_eamt4`).

---

## 2026-06-07

- **MavericProPlus v3.4: fix logger blind spot (blowup basket).** Logger previously only logged on basket CLOSE, so an end-of-run blowup basket (never closes) was invisible — making crashing runs look "all recovered". Added mid-run root-cause dump on breach + `Flush()` from `deinit()` to capture still-open baskets (`close_time=OPEN_AT_END`). EA **v3.4**, pushed (4ec9097). NOTE: earlier "direction isn't the cause / volatility is" finding is provisional — it was computed on data that excluded the blowup; must re-confirm with a v3.4 run of the crashing case.
  - Files: `Include/Sale/EntryLogger.mqh`, `Sale/MavericProPlus.mq4`
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

- **MavericProPlus v3.3: root-cause replay logger.** Added symbol + entry-reason columns and a third CSV `MPP_rootcause_<tag>.csv` that, when a basket breaches acceptable drawdown (money OR grid depth), dumps a per-bar look-back(50)/entry/look-forward(to close) reconstruction of OHLC+MAs+SAR+H1/H4 trend — the tool to find the exact root cause of a wrong entry. EA at **v3.3**, pushed (commit b673a9c).
  - Files: `Include/Sale/EntryLogger.mqh`, `Sale/MavericProPlus.mq4`
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

- **Git version control + GitHub push.** Set up versioning workflow (VERSION bump + commit per change). MT4 folders are on a mount that blocks in-place git, so a working copy is pushed to `github.com/SupremeDevProsanta/ai_eamt4` (token at `E:\project\github\git_token.txt`). Pushed baseline v3.1, v3.2 (logger), and `.gitattributes`. EA now at **v3.2**.
  - Files: repo `ai_eamt4` (Experts/Sale, Include/Sale, document, memory)
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

---

## 2026-06-01

- **MavericProPlus refactor — Phase 0: dead code removal.** Removed `Open_Pos_1()`, `DrawObjects()`, 5 commented-out trend blocks, 8 commented `GetLinearRegressionSlope` calls. File 1454 → 1376 lines. Zero behavior change.
  - Files: `Sale/MavericProPlus.mq4`
  - Detail: [2026-06-01-mavericproplus-phase0-deadcode.md](./2026-06-01-mavericproplus-phase0-deadcode.md)

- **MavericProPlus refactor — Phase 1: extract small helpers.** Added `CanBuy()`, `CanSell()`, `IsNewM30Bar()`, `ApplyComment()`. Replaced 4+4 `TradeDirn` checks, 2 NewBarTime reset patterns, 56 SetTradeComment+bIsTestMode patterns. File