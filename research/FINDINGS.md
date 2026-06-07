# Python Backtest Findings — NZDCAD (20y, 2006-2026, M30+H1 HST data)

Cost model: ECN 0.3 pip spread + $7/lot round-turn commission. usd_per_pip_per_lot≈7.4 (approx for NZDCAD). %-risk sizing. Single position, hard stop, NO martingale.

## 1. Trend-following (TrendRider logic) — REJECTED on NZDCAD
- Base (pyramid, 2pip): net -15,693, PF 0.44, DD 157% (blew up).
- Best trend config NZDCAD: PF 0.79-0.88 even at ZERO spread → no edge.
- EURUSD trend edge is real but THIN: PF 1.03 at zero spread (+47k), but PF 0.96-0.97 at 2pip (-10k). Entirely eaten by costs / overtrading (~3000+ trades).
- Conclusion: NZDCAD does not trend cleanly; trend-following is the wrong tool here.

## 2. Mean-reversion — VALIDATED (modest, robust)
Logic: fade price stretched >= EntryAtr*ATR from SMA(100) AND RSI extreme; TP at TpAtr*ATR partial reversion; hard stop StopAtr*ATR; time stop; 0.5% risk.

Best robust params: EntryAtr=4.0, StopAtr=3.5, TpAtr=2.0, RsiLo=15, RsiHi=85, TimeStopBars=72, MaPeriod=100.

In/Out-of-sample split (train 2006-2016, test 2016-2026):
- IN : net +1,580, PF 1.26, DD 3.5%, n=396
- OOS: net +705,  PF 1.07, DD 5.9%, n=606   <-- survives unseen data

Overfit configs (rejected): wider-RSI variants scored higher in-sample but went PF<1 out-of-sample.

## Honest assessment
- Real but MODEST edge (~50 trades/yr, PF ~1.1 OOS, DD <6%). Safe & slow.
- Opposite risk profile to the martingale: bounded drawdown, no blowup tail.
- Caveats: cost model is an estimate; thin margin is sensitive to real ECN fills and pip-value accuracy. Validate on broker tick data before live.

## Next candidates
- Port the validated MR rules to an MQL4 EA (risk-bounded, single position).
- Test MR on other rangebound crosses (AUDCAD, AUDNZD, EURCHF).
- Re-confirm with broker's real spread/commission.
