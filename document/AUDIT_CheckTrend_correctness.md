# MavericProPlus — CheckTrend Signal Correctness Audit

**Date:** 2026-06-01
**Scope:** All ~57 `CheckTrend_NN` + `CheckTrend_Turbo*` signal functions in `Trend_Math_Terex2.mqh`, cross-referenced against how `BuySystem` / `SellSystem` / `BuyTurbo` / `SellTurbo` consume their return values in `MavericProPlus.mq4`.
**Method:** Read every function; automated return-value census; manual logic verification. No code modified.

---

## TL;DR

The strategy is a large hand-tuned **curve-fit pattern bank**, not a coherent trading model. Each `CheckTrend_NN` is an independent stack of hard-coded SMA-alignment / SAR / Stochastic / CCI / slope thresholds that returns `TREND_UP`, `TREND_DOWN`, or `TREND_SIDEWAY`. Functionally it "works" (it compiles and will fire trades), but correctness is undermined by **four systemic problems** plus several **provable logic bugs**. The edge such a system shows in a backtest is almost certainly fitted to history and unlikely to generalize.

---

## Finding 1 — CRITICAL: return value is interpreted backwards / inconsistently

`BuySystem` opens a BUY when a check returns the value the caller tests for; `SellSystem` opens a SELL on `TREND_DOWN`. But the direction baked into each `CheckTrend` does **not** consistently match the direction the caller trades. The whole entry layer relies on the *caller* asking for the "right" constant, and in many places it asks for the wrong one.

Concrete examples:

- **`BuySystem` calls `CheckTrend_15()==TREND_DOWN` to BUY.** `CheckTrend_15` only ever returns `TREND_DOWN` (a bearish engulfing-through-MAs pattern). So the EA opens a **BUY on a bearish breakdown signal**. Either the label is wrong or the usage is — they contradict.
- **`CheckTrend_8` only ever returns `TREND_DOWN`** (census: UP=0, DOWN=1). Yet `BuySystem` calls `CheckTrend_8()==TREND_UP` — a branch that can **never be true**. That buy path is dead.
- Conversely `BuySystem` calls `CheckTrend_8()` again? No — but it does call `CheckTrend_25/26/14/46/48` expecting `TREND_UP`. Several of those (e.g. `26_1`, many DOWN-only checks) can never return UP, so those branches are dead too.

**Impact:** A meaningful fraction of the entry cascade is either dead (condition can never be met) or inverted (buys on bearish logic). This is the single biggest correctness problem.

## Finding 2 — CRITICAL: provably impossible conditions (always false → dead code)

Three conditions are logically unsatisfiable; the guarded block can never execute:

| Location | Condition | Why it's always false |
|---|---|---|
| `CheckTrend_2` line ~1413 | `dSar1<Close[1] && dSar1>Close[1]` | A value cannot be both `<` and `>` the same number. The first `if` of CheckTrend_2 can never fire. |
| `CheckTrend_19` line ~1839 | `m_MA_20_1>m_MA_100_1 && m_MA_100_1>m_MA_20_1` | Mutually exclusive ordering. CheckTrend_19's only return is therefore dead — it always falls through to SIDEWAY. Note: `CheckTrend_19` is the one `SellSystem` tags as `" Mavericks "`; it can **never produce a signal**. |
| `CheckTrend_29` line ~2246 | `m_MA_8_1>m_MA_8_1` | A value is never greater than itself. (Harmless here — it's a SIDEWAY guard — but shows copy-paste error.) |

## Finding 3 — HIGH: semantic mislabeling of UP/DOWN inside the trees

Even where branches *can* execute, the returned constant frequently contradicts the MA structure being tested. Examples found:

- **`CheckTrend_21`**: when the 20>30>50 / 100<200 pullback-up pattern matches it returns `TREND_SIDEWAY` (comment "Trade 3000U" = "up"), but a deeper nested bullish stack returns `TREND_DOWN` ("Trade 3000D"). The naming ("U"/"D") and the returned enum are routinely swapped.
- **`CheckTrend_23`**: bearish 14-period MA stack (10_14>14_14>...>100_14, all sloping down) with comment "DN 2"/"DN 3" **returns `TREND_UP`**, and the fallthrough "DN 1" returns `TREND_DOWN`. So a clearly bearish structure yields a BUY in two of three branches.
- **`CheckTrend_Turbo_2`**: branch commented "T2 DN2" returns `TREND_UP`.

These aren't necessarily *bugs* if the author intended contrarian/mean-reversion entries — but there is no comment or structure indicating that intent, and they coexist with trend-following branches in the same function. The result is internally inconsistent and unmaintainable.

## Finding 4 — HIGH: massively branchy, curve-fit logic with magic numbers

- `CheckTrend_52` alone has 22 distinct return points; `CheckTrend_60` has 30; `CheckTrend_Turbo` has 21. Many are 6–8 levels of nesting deep.
- Thresholds are bespoke literals with no derivation: `>80*Point*10`, `m_Current_7_150<-0.7`, `m_ma_cross_50_100>100 && <80` (note: also see Finding 5), stochastic `(50,30,30)`, CCI `<-100`. Comments like `"Trade 3000U2"`, `"Trade 10927"`, `"Trade 1099"` are bookkeeping labels for individually hand-tuned cases.
- This is the signature of **over-fitting**: dozens of narrow rules each carved to catch specific historical setups. Such systems typically show strong in-sample backtests and weak out-of-sample/live performance.

## Finding 5 — MEDIUM: contradictory range tests (branch can't fire)

Some compound conditions specify ranges that don't overlap, e.g. within `CheckTrend_8`: the outer guard requires `m_ma_cross_50_100>100`, then an inner branch requires `m_ma_cross_50_100<80`. Since the inner is nested under the outer, the inner (`>100` AND `<80`) is unsatisfiable → dead inner branch. Similar non-overlapping `>X && <Y` (with X>Y) patterns appear in several checks. (Distinct from Finding 2 because here it's a nested narrowing, not a single expression.)

## Finding 6 — MEDIUM: commented-out "working" logic left in place

Multiple functions (`CheckTrend_49`, `_50`, `_53`, `_54`) carry blocks labelled `/* working ... */` that were disabled, with replacement logic below. The live logic differs from the "working" version. This indicates iterative manual tuning where previously-validated rules were swapped for newer untested ones — a maintenance/￼provenance red flag.

## Finding 7 — LOW: redundant / duplicate indicator computation

Every Stochastic-based check recomputes 6–8 `iStochastic(...)` calls with identical parameters; `iSAR` is recomputed in dozens of functions each bar. Correctness is fine but it's wasteful and makes the cascade slow when many checks run per M30 bar.

---

## Per-function return census (what each CAN return)

UP/DOWN/SIDE = number of reachable return statements of each type (SIDE includes the trailing default). Functions with **DOWN=0** can never sell-signal; **UP=0** can never buy-signal — important when cross-checked with caller expectations.

```
_1  UP2 DN0 SD1     _21 UP2 DN1 SD2    _42 UP4 DN2 SD6
_2  UP1 DN1 SD1*    _22 UP0 DN1 SD2    _43 UP0 DN1 SD3
_3  UP0 DN1 SD1     _23 UP2 DN1 SD3!   _44 UP0 DN1 SD3
_4  UP1 DN1 SD3     _24 UP1 DN0 SD1    _45 UP0 DN1 SD1
_5  UP1 DN0 SD1     _25 UP1 DN0 SD2    _46 UP1 DN0 SD1
_6  UP0 DN1 SD1     _26 UP1 DN0 SD1    _47 UP0 DN1 SD9
_7  UP0 DN1 SD1     _26_1 UP0 DN1 SD1  _48 UP1 DN0 SD1
_8  UP0 DN1 SD1**   _27 UP0 DN1 SD2    _49 UP1 DN1 SD1
_9  UP2 DN0 SD1     _28 UP0 DN1 SD3    _50 UP5 DN2 SD6
_10 UP0 DN1 SD1     _29 UP0 DN1 SD3*   _51 UP1 DN3 SD2
_11 UP0 DN1 SD1     _31 UP0 DN1 SD1    _52 UP7 DN8 SD22
_12 UP0 DN1 SD1     _32 UP1 DN0 SD1    _54 UP3 DN3 SD8
_13 UP0 DN1 SD1     _33 UP0 DN1 SD1    _55 UP1 DN1 SD1
_14 UP0 DN1 SD1     _34 UP0 DN1 SD2    _58 UP4 DN8 SD7
_15 UP0 DN1 SD1***  _35 UP0 DN2 SD1    _60 UP15 DN9 SD6
_16 UP1 DN0 SD1     _36 UP0 DN1 SD1    Turbo   UP10 DN7 SD4
_17 UP0 DN1 SD2     _38 UP0 DN2 SD3    Turbo_1 UP3  DN4 SD2
_18 UP0 DN1 SD1     _39 UP1 DN1 SD2    Turbo_2 UP1  DN3 SD1
_19 UP1 DN0 SD1!    _40 UP1 DN1 SD2
_20 UP1 DN1 SD1     _41 UP2 DN5 SD9
```

\*  `_2` first branch impossible (Finding 2); \** `_8` is DOWN-only yet BuySystem asks for UP (Finding 1, dead branch); \*** `_15` DOWN-only yet used to BUY (Finding 1, inverted); ! `_19` only return is dead (Finding 2) and `_23` mostly returns UP on bearish structure (Finding 3).

---

## Overall correctness assessment

1. **Mechanically:** It compiles and trades. The cascade will produce entries, and the martingale layer will manage them. In that narrow sense it "works."
2. **Logically:** It is **not internally consistent.** There are dead branches (Findings 1, 2, 5), inverted direction usage (Findings 1, 3), and impossible conditions (Finding 2). A non-trivial share of the ~57 checks cannot contribute, and a few actively trade against their own stated direction.
3. **Statistically:** The design is a textbook **over-fit** (Finding 4). Hundreds of bespoke thresholds tuned to historical EURUSD M30 price. Expect good in-sample numbers, poor robustness.
4. **Risk interaction:** The weak/curve-fit entries feed a **35-pip martingale** with a near-disabled stop (`MaxStoplost=8000`). Even if entries are coin-flips, martingale produces a smooth rising equity curve until a sustained adverse trend triggers cascading larger lots — the classic martingale ruin profile. Entry quality matters less than the survival of the grid.

**Bottom line:** The signal layer is best understood as a noise generator that the martingale money-management rides. Its apparent profitability (if any in backtests) comes from the grid recovering small adverse moves, not from genuine predictive edge in the `CheckTrend` rules — several of which are provably dead or inverted.

## Recommended next steps (if improving rather than just understanding)
- Remove provably-dead checks (`_19`, `_2` first branch, `_8` UP usage, etc.) and the inverted BUY-on-DOWN usages — or confirm intent and rename.
- Replace the hand-tuned cascade with a small number of parameterized, walk-forward-validated rules.
- Backtest with the martingale **disabled** to measure the true edge of the entry signals in isolation. If flat-to-negative without martingale, the signals add no value.
- Stress-test the martingale on a trending out-of-sample period (e.g. a sustained EURUSD decline) to size worst-case drawdown.
