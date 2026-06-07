# Memory Index

Short notes for every major change. One line = one change. Detail lives in linked file.

Format: `[date] short description — files affected — [detail-file](./detail-file.md)`

---

## How to use this memory system

On startup, read this file (`memory.md`) for a one-line brief of every task. For full detail, open the linked detail file or the matching dated entry in [`worklog.md`](./worklog.md). When a task is done: append the detail to `worklog.md`, then add/refresh the one-line brief here. Every code change bumps the EA `#define VERSION` and is committed + pushed to GitHub (`SupremeDevProsanta/ai_eamt4`).

---

## 2026-06-07

- **Python backtesting: trend rejected, mean-reversion validated on NZDCAD.** Built fast Python harness over 20y NZDCAD HST bars (`research/`). Trend-following has NO edge on NZDCAD (PF<0.9 even zero-spread); EURUSD trend edge thin and cost-killed. Mean-reversion (fade 4*ATR extremes + RSI, hard stop, no martingale) SURVIVES out-of-sample: train PF 1.26 / test PF 1.07, DD<6%. Key insight: martingale only "worked" on NZDCAD because it mean-reverts — MR captures that edge with bounded risk. Modest but robust. Pushed (0652bb9).
  - Files: `research/hst.py`, `research/trendrider_bt.py`, `research/meanrev_bt.py`, `research/FINDINGS.md`
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

- **New EA: TrendRider v1.0.** Fresh standalone trend-following EA (`Experts/Sale/TrendRider.mq4`), no martingale, no Trend_Math dependency. EMA-stack(20/50/100 H1)+ADX>22 trend filter; pullback-OR-Donchian-breakout entry; ATR-based stop + true %-risk sizing; add-to-winners pyramiding (max 4, +1 ATR steps) with 3*ATR chandelier trail; never averages losers; multi-symbol. Static-checked, not yet compiled. Pushed (25ad1b9).
  - Files: `Sale/TrendRider.mq4`
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

- **MavericProPlus v3.4: fix logger blind spot (blowup basket).** Logger previously only logged on basket CLOSE, so an end-of-run blowup basket (never closes) was invisible — making crashing runs look "all recovered". Added mid-run root-cause dump on breach + `Flush()` from `deinit()` to capture still-open baskets (`close_time=OPEN_AT_END`). EA **v3.4**, pushed (4ec9097). NOTE: earlier "direction isn't the cause / volatility is" finding is provisional — it was computed on data that excluded the blowup; must re-confirm with a v3.4 run of the crashing case.
  - Files: `Include/Sale/EntryLogger.mqh`, `Sale/MavericProPlus.mq4`
  - Detail: [worklog.md](./worklog.md) → 2026-06-07

- **MavericProPlus v3.3: root-cause replay logger.** Added symbol + entry-reason columns and a third CSV `MPP_rootcause_<tag>.csv` that, when a basket breaches acceptable drawdown (money OR grid depth), dumps a per-bar look-back(50)/entry/look-forward(to close) reconstruction of OHLC+MAs+SAR+H1/H4 trend — the tool to find the exact root cause of a wrong entry. EA at **v3.3**, pushed (commit b673a9c).
  - Files: `Include/Sale/Ent