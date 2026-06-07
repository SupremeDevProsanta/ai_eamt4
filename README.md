# ai_eamt4 — MavericProPlus EA

MetaTrader 4 expert advisor (trend-pullback martingale scalper) plus analysis tooling.

## Layout
- `Experts/Sale/MavericProPlus.mq4` — the EA (+ `.bak` snapshots of prior states)
- `Include/Sale/` — dependencies: `EntryLogger.mqh` (analysis logger), `Trend_Math_Terex2.mqh` (signals), `ProsantTradeManagerLight.mqh` (order/martingale engine), `ProsantaConst.mqh`
- `document/` — audits (e.g. CheckTrend correctness)
- `memory/` — change log / worklog / per-change detail notes

## Versioning
EA `#define VERSION` is bumped on each functional change; each change is a commit so any state can be restored.

`.ex4` build artifacts are gitignored.
