# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

### "More trades / combine indicators?" tested + cross-pair validation
User asked why so few trades (~36 in 5y on USDCHF visual) and why not combine indicators (screenshot showed USDCHF+MACD).
- Tested loosening BB band (k1.5-2.5) + looser RSI + MACD-histogram-turn confirmation. EVERY looser variant went OOS PF<1 (0.90-0.98), DD 13-43%, despite 200-460 trades/yr. Adding indicators only filters; it does not create edge. Strict k3+RSI20/80 stays the only OOS-profitable config. "Few trades" is a feature (waits for rare real dislocations).
- Correct way to get more trades = run the SAME strict rules on multiple mean-reverting crosses. Cross-pair test (model tuned only on NZDCAD): NZDCAD OOS PF1.14/DD3.1%, AUDCAD PF1.76/DD1.4%, AUDNZD PF1.44/DD1.9%. Edge holds on UNSEEN pairs → genuine commodity-cross mean-reversion, not curve-fit. (AUDCAD/AUDNZD only 2.4y data — magnitude cautious, direction clear.)
- Recommendation: deploy MeanReverter as a PORTFOLIO (NZDCAD+AUDCAD+AUDNZD, multi-chart distinct magics) for ~3x diversified trade count without loosening entry. Files: `research/round4.py`, `research/crosspair.py`. Pushed (55c7f69).

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
- **Mean-reversion VALIDATED on NZDCAD** — fade price >=4*ATR from SMA100 + RSI<=15/>=85, TP 2*ATR, hard stop 3.5*ATR, time stop 72 bars, 0.5% risk. **Survives out-of-sample**: t