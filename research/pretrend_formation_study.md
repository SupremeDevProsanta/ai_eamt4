# Pre-Trend Formation Study — NZDCAD M30 (2006–2026)

**Question:** Is there a recognizable formation that appears *before* a trend starts, so we can detect it and trade it?

**Method (honest, no look-ahead):**
- Labeled every bar with a triple-barrier trend label at 3 scales: small (2.5·ATR / 12 bars), medium (4·ATR / 24 bars), big (6·ATR / 48 bars). Label = which barrier (+K·ATR up vs −K·ATR down) is hit first within the horizon; 0 = neither (no trend). Features use only data up to the bar; the label uses the future (it is the target).
- 10 candidate features, all measurable in real time: Bollinger-width percentile (squeeze), ATR compression, range-compression percentile, ADX, RSI level+slope, Donchian position, ROC momentum, inside-bar streak.
- Discovered on in-sample (2006–2016), **confirmed on out-of-sample (2016–2026).** A formation only counts as real if its lift survives OOS.
- Lift = P(trend | formation) ÷ base rate. Then a P&L backtest to see if statistical edge converts to money.

## Base rates (how often a "trend" even happens)
| scale | up (IN/OOS) | down (IN/OOS) | none (IN/OOS) |
|---|---|---|---|
| small | 18% / 23% | 19% / 27% | 63% / 51% |
| medium | 14% / 20% | 14% / 22% | 72% / 59% |
| big | 12% / 18% | 12% / 20% | 76% / 62% |

NZDCAD trended **down** more than up in 2016–2026 (down-events outnumber up). Most bars (60–76%) start no trend at all.

## What's REAL (robust in-sample AND out-of-sample)
**Volatility compression precedes trends.** This is the headline, confirmed at every scale and in both halves:

| formation | predicts | IN lift | OOS lift |
|---|---|---|---|
| ATR compress <0.7 | up-trend (medium) | 2.48× | 1.62× |
| ATR compress <0.7 | down-trend (big) | 2.10× | 1.76× |
| Bollinger squeeze <10% | up & down | ~1.4× | ~1.3× |
| Range tight <15% | trend (medium/big) | ~1.3× | ~1.2× |
| Squeeze + breakout (directional) | breakout direction | 1.4–1.9× | 1.2–1.5× |

## What FAILED (no edge or anti-edge)
- **Momentum/strength signals anti-predict continuation:** high ADX (>30), fresh Donchian highs, RSI extremes all had lift **< 1.0** for predicting more trend. "Buy strength" is worse than random here.
- This is the same mean-reverting force that makes the MeanReverter EA profitable.

## The catch — statistical edge ≠ profit
The squeeze formation is real but **does not trade profitably as a breakout**:

| approach | IN PF | OOS PF | verdict |
|---|---|---|---|
| Squeeze → trade breakout direction | 0.86–1.05 | **0.86** | loses |
| Squeeze → fade the breakout | 0.72–0.75 | **0.72–0.78** | loses worse |

Why: (1) compression predicts *volatility*, not *direction* — a squeeze raises odds of both up AND down trends; (2) the ~1.4× directional edge is modest and gets eaten by spread; (3) entering at the channel edge is a poor price; (4) 600–1000 trades = heavy cost drag.

## Verdict
The hypothesis is **half-confirmed**: a formation (volatility compression) genuinely precedes trends and the signal holds out-of-sample. But it answers "*when* a move is likely," not "*which direction*." Direction stays near-random, so recognizing the formation does not by itself produce a profitable trend-following system on NZDCAD.

The only profitable entry style found on this pair remains **mean-reversion** (fade ≥3σ extremes back to the mean — the MeanReverter EA), because it enters at good prices with a definable, present-moment trigger. Squeeze timing could *complement* it (trade only when a move is statistically likely) but cannot replace direction.

**Files:** `research/pretrend.py` (labels), `research/feats.py` (features), `research/lift.py` (lift tables), `research/squeeze_pnl.py` + `research/squeeze_fade.py` (P&L tests).
