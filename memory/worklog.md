# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

### Iterative strategy search + final EA: MeanReverter v1.0
Ran an OOS-ranked iterative loop (~40 variants, train 2006-2016 / test 2016-2026) over strategy families: Bollinger fade, RSI2 (Connors), RSI2+trend, ATR-stretch. Engine in `research/engine.py`, rounds in `round1-3.py`.
- RSI2 families blew up OOS (DD 60-100%) → rejected. ATR-stretch marginal (OOS ~0.95).
- **Winner: Bollinger(20,k3) fade + RSI(14) 20/80 confirmation.** SL 4*ATR, TP 2.5*ATR, exit at BB mid, time stop 96, 0.5% risk.
  - Caught + fixed a std-dev convention bug: pandas .std() is sample(ddof1), MT4 iBands uses population(ddof0). With MT4-matching std: **OOS PF 1.142, DD 3.1%, n495** (the realistic number; sample-std gave a rosier 1.26).
- **Walk-forward (4y blocks) caveat (recorded honestly):** edge is REGIME-DEPENDENT — flat/slightly negative 2006-2018, profitable 2018+ (PF 1.41, 1.17). Parameter sensitivity is benign (nearby params stay OOS PF>1), so it's a positive *region* not a fragile spike, but it is NOT all-weather. Modest + bounded, not a money machine.
- **Decision (user): lock in, build EA, stop optimizing** to avoid overfitting the single NZDCAD path.
- Built `Experts/Sale/MeanReverter.mq4` v1.0 — uses real iBands/iRSI/iATR, single position, hard SL+TP broker-side, exit-at-mid + time stop, %-risk sizing, NO martingale. Static-checked (balanced, handlers/sigs correct). Not yet compiled. Pushed (9ef8ee1).
**Next:** compile + forward/visual backtest in MT4 to confirm the Python edge replicates on broker data; optionally validate same rules on AUDCAD/AUDNZD/EURCHF for cross-pair robustness.

### Python backtesting — strategy validated from data (NZDCAD 20y)
Built a fast Python backtest harness using the broker HST bar data (`history/ICMarketsSC-Demo01/NZDCAD30.hst`=M30 254k bars, `NZDCAD60.hst`=H1, 2006-2026). FXT tick files were 18.9GB sparse-padded, impractical; HST bars are clean and sufficient. Files in repo `research/`: `hst.py` (MT4 .hst v401/400 parser), `trendrider_bt.py`, `meanrev_bt.py`, `FINDINGS.md`.
Cost model: ECN 0.3 pip + $7/lot commission, %-risk sizing, single position, hard stop, no martingale.
**Findings:**
- **Trend-following REJECTED on NZDCAD** — PF 0.44 base (blew up); even at ZERO spread only PF 0.79-0.88 → no real edge. NZDCAD does not trend cleanly. (EURUSD trend edge is real but thin: PF 1.03 zero-spread, ~0.97 at 2pip — killed by costs + overtrading. Confirms TrendRider needs a trending pair + ECN costs, not NZDCAD.)
- **Mean-reversion VALIDATED on NZDCAD** — fade price >=4*ATR from SMA100 + RSI<=15/>=85, TP 2*ATR, hard stop 3.5*ATR, time stop 72 bars, 0.5% risk. **Survives out-of-sample**: train 2006-2016 PF 1.26 DD 3.5%; test 2016-2026 PF 1.07 DD 5.9%. Overfit variants (looser RSI) correctly went PF<1 OOS and were rejected.
**Why this matters:** This is the user's "huge loss" insight playing out — the martingale only "worked" on NZDCAD *because NZDCAD mean-reverts*; it had a hidden blowup tail. A proper risk-bounded MR system captures the same reversion edge with bounded <6% drawdown instead of 80% ruin. Modest (~50 trades/yr, small net) but real and robust.
**Caveats recorded:** cost model is an estimate; usd_per_pip for NZDCAD approximate; thin margin sensitive to real fills — validate on broker tick data before live.
**Next:** port validated MR rules to a clean MQL4 EA; test MR on other rangebound crosses (AUDCAD/AUDNZD/EURCHF); re-confirm with real broker spread.

### New EA: TrendRider v1.0 (fresh trend-following, no martingale)
Built a clean-room standalone EA `Experts/Sale/TrendRider.mq4` per user request — a genuine trend-following system, not a patch on MavericProPlus, and with NO dependency on the tangled Trend_Math includes.
Design (all four user choices folded in: multi-symbol, trend+pyramiding, AT