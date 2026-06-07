# MA-Crossover Trend-Segment Study — NZDCAD M30 (2006–2026)

Tests the hypothesis: *MA crossover marks a trend; the previous segment's length/slope
predicts the next; wait a few bars to confirm before entering.*

Method: EMA(20/50). A "segment" = bars between consecutive crossovers (segments strictly
alternate up/down by construction). For each segment: direction, length, slope (price
regression / ATR), and realized return in ATR. Discover in-sample (2006–2016), confirm
out-of-sample (2016–2026). P&L includes ~1 pip roundtrip cost.

## 1. Do MA segments actually trend? — NO
- Only **31.6%** of segments move in the MA's direction; 68% revert.
- During an "up" state (fast>slow) price drifts a **median −0.86 ATR** (down); during "down" it drifts +0.87 ATR (up).
- Mean ret is slightly positive (+0.29 ATR) — a few big trends — but median is negative. Negative expectancy at the cross even before costs.

## 2. Does the previous segment predict the next? — NO
Correlation of prior segment vs next-segment directional return:

| | prevLen | prevSlope | prevRet |
|---|---|---|---|
| in-sample | +0.020 | −0.011 | +0.029 |
| out-of-sample | −0.010 | −0.017 | −0.017 |

All ≈ 0 and sign-flips IS→OOS = noise. Conditioning on a *strong* prior trend (top-tercile length AND slope) gave next-segment mean **+0.09 ATR in-sample but −0.36 OOS** — i.e., worse. No memory.

## 3. Does waiting K bars + confirmation help? — IT HELPS BUT STAYS UNPROFITABLE
Enter K bars after the cross only if price moved ≥ thr·ATR in the new direction; exit at next cross.

| K | thr | OOS win% | OOS avg ATR | OOS PF |
|---|---|---|---|---|
| 0 | 0.0 | 27.8% | −0.26 | 0.84 |
| 6 | 1.0 | 33.5% | −0.18 | 0.92 |
| 10 | 0.0 | 32.0% | −0.24 | 0.87 |

Confirmation lifts win rate **27% → ~36%** and halves the average loss — the instinct is correct — but **every** configuration stays PF < 1.0 in both halves. Waiting improves a losing system toward breakeven, not into profit. You enter later (give up move) and the median segment still reverts.

## Verdict
The confirmation idea is directionally right (measurably reduces the bleed) but cannot make MA-crossover trend-following profitable on NZDCAD, because the pair **mean-reverts** (the 68% reversion is the same edge the MeanReverter EA harvests). Trend logic fights this instrument.

**Constructive next step:** run this identical segment analysis on a genuinely trending market (equity index, gold, or a trending FX pair). If continuation rate flips above 50% there, the MA-cross + confirmation rule may be profitable on *that* instrument — the method isn't wrong, the instrument is.

Files: research/segments.py, research/seg_predict.py, research/seg_confirm.py
