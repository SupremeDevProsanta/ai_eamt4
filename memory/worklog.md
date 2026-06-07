# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

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
Design (all four user choices folded in: multi-symbol, trend+pyramiding, ATR sizing, "all" signal types combined):
- **Trend filter:** EMA stack 20>50>100 on H1 (TrendTF) AND ADX>22 → only trade a confirmed real trend, else stand aside.
- **Entry (EntryTF M30):** pullback to fast EMA (within 0.5*ATR) OR Donchian(20) breakout, in the trend direction only.
- **Risk:** ATR(14) stop = 2*ATR; lot sized so the stop = RiskPercent(1%) of balance (true risk sizing, unlike MPP's balance-step). Fallback fixed lot + MaxLot cap.
- **Pyramiding:** adds to WINNERS only — new leg every +1*ATR advance beyond last leg, max 4 units. NEVER averages losers (the anti-martingale).
- **Trailing:** chandelier stop at 3*ATR on every leg, runs each tick; a trend flip just stops adds and lets the trail close the position.
- Inputs fully exposed for optimization (MA periods, ADX min, ATR mults, risk %, pyramid params, optional session filter).
Static-verified: braces/parens balanced, OnInit/OnTick/OnDeinit signatures correct, all iMA/iATR/iADX/iHighest/iLowest usages valid. Not yet compiled in MetaEditor (user to compile). Pushed (commit 25ad1b9).
**Next:** compile, then backtest on NZDCAD/EURUSD; compare vs MavericProPlus — expect far smaller drawdown, lower win-rate, but bounded risk (no blowup tail).

### v3.4 — fix logger blind spot: capture the blowup basket
**Key discovery while analysing the crash chart (equity 15,895 -> 3,285 at end).** The earlier NZDCAD analysis kept showing "all baskets recovered, 265/3 wins" — wrong conclusion caused by a logging bug, NOT by the strategy being safe. Root cause: the logger only wrote an outcome row + root-cause dump when a ba