# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

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
**Key discovery while analysing the crash chart (equity 15,895 -> 3,285 at end).** The earlier NZDCAD analysis kept showing "all baskets recovered, 265/3 wins" — wrong conclusion caused by a logging bug, NOT by the strategy being safe. Root cause: the logger only wrote an outcome row + root-cause dump when a basket CLOSES (count->0). A blowup basket keeps adding lots and NEVER closes before the test/account ends, so it produced no outcome and no root-cause => invisible. The fatal end-of-run basket was structurally excluded from every stat.
Also corrected understanding: `float_profit` logged at ADD time is ~0 (logged the instant price hits the add level); only `peak_floating_dd` (tracked per tick, written at close) is meaningful — and for the killer it was never written.
**Fix (v3.4):**
- `Track()` now also dumps root-cause MID-RUN the moment a live basket breaches DD-money OR grid-depth (guarded by `m_dumped[slot]`, once per basket).
- New `Flush(trend,tm0..tm3)` called from EA `deinit()` BEFORE managers are deleted: for any still-open basket it finalizes peak DD, writes an outcome row with `close_time=OPEN_AT_END`, and dumps the root-cause replay. This captures the end-of-test blowup.
- VERSION 3.3 -> 3.4. Pushed (commit 4ec9097).
**Analysis caveats recorded:** (1) Original "wrong direction causes blowup" hypothesis was NOT supported by the (incomplete) NZDCAD data — with-trend entries actually drew down worse, deep baskets clustered in COVID-Mar2020 volatility, and a few checks dominated (`Turbo2 T2 DN3`, `Check58*`). BUT this was on data missing the blowup, so it's provisional. (2) Real risk signal so far points to VOLATILITY REGIME + specific weak checks, not trend direction. Must re-confirm once v3.4 captures an actual blowup. (3) The crash chart x-axis is trade-number, not date.
**Next:** re-run the crashing case with v3.4 so the OPEN_AT_END basket + its root-cause appear; then diagnose the true account-killer.

### v3.3 — root-cause replay + symbol/entry-reason columns
Extended `EntryLogger.mqh` per user request: log the FX pair, entry time, and entry reason explicitly, and auto-produce a root-cause reconstruction for 