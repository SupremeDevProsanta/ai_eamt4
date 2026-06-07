# MavericProPlus — Full Logic Analysis (read-only)

**Date:** 2026-06-01
**Type:** Investigation / understanding. No code changed.
**Files read:**
- `MQL4/Experts/Sale/MavericProPlus.mq4` (1156 lines, post Phase-1)
- `MQL4/Include/Sale/Trend_Math_Terex2.mqh` (~4759 lines — signals)
- `MQL4/Include/Sale/ProsantTradeManagerLight.mqh` (~12732 lines — order/martingale engine)
- `MQL4/Include/Sale/ProsantaConst.mqh` (enums/constants)

## Access gained this session
Connected two new folders for reading the includes:
- `MQL4/Experts/Sale`
- `MQL4/Include/Sale`

## Architecture confirmed
- **Symbol/timeframe:** built for EURUSD; decisions on **M30**, new-entry gating on **M15** (`NewBar()`).
- **Four parallel baskets**, magic base 14000: Buy(14000), Sal/sell(14001), Turbo Buy(14002), Turbo Sal(14003). Each `TradeManager` runs its own grid independently.
- **Main loop (`start`)**: runs per tick, real work gated by `NewBar()` (M15). Requires `iBars(M30)>200` (doubles as the license/data check). Computes 80-bar M30 swing high (`val`), loads MAs via `m_MaTrend.LoadDataParam(M30)`.
- **Entry gating:** new baskets opened only when flat (`SELLPosCnt==0 && BUYPosCnt==0`), or top-up of whichever basket is empty. Buy requires price ≥30 pips below swing high (`val-Ask>30 pips`) → buys pullbacks only. Direction gated by `CanBuy()/CanSell()` (`TradeDirn`).

## Entry signals
- `BuySystem`/`SellSystem` = long if/else-if cascades over ~30–40 `CheckTrend_NN()` rules in priority order; first match opens trade and tags it.
- Each `CheckTrend_NN` is a hard-coded multi-MA alignment + SAR + MA-crossover-age (`m_ma_cross_*`) rule returning TREND_UP/DOWN/SIDEWAY. Examples: `CheckTrend_21` (20/30/50/100/125/150/200 SMA stacking + crossover-age windows), `CheckTrend_8` (SAR vs close + MA stack).
- Turbo baskets use shorter `CheckTrend_Turbo/_1/_2` set for extra aggressive entries.

## Execution
- `TradeBuy()`/`TradeSell()`: market order at `m_LotsSize`, retry ≤10×, then `OrderModify` to attach SL/TP. SL = `MaxStoplost`=8000 (effectively off), TP = `MaxTakeProfit`=10 pips → tight scalp TP, very wide safety stop.

## Position management = martingale grid
- Per-bar `ManageRunningTrade_Scalpping_Martingle_1` (matched symbol) or `_2018` (suffixed symbol).
- Grid distance **35 pips** (`m_MargtingFirstlevel`/`m_Margtinglevel`; Turbo uses `TurboGridDistance1/2`=35).
- On adverse move of one grid step, **adds larger lot** (×1.5, first add ×2 — `MultiFactor`/`MultiFactor_1`), gated by SAR/MA confirmation, then resets shared basket profit target (`SetStopLostForMultiTrade_Ext`, ~10 pips). Basket closes as a group on small averaged pip profit. `_2018` adds deep-recovery rungs at 120/150-pip excursions.

## Lot sizing
- `RiskManagedLotCalculation(Risk=10)` is **balance-step sizing**, not true risk %: `lots = 0.01 × (AccountEquity / LostSizeIncrementAt)`, `LostSizeIncrementAt`=500 → ~0.01 lot per $500 equity, capped at 10. Fixed-lot fallback via `IsFixLotsSize`/`FixlotSize`=0.01.

## Other controls
- `TradeTime()` (StartHour GMT_1 → EndHour GMT_22, Mon/Fri toggles) is **defined but NOT called** in the live `start()` path.
- `MaxSpread`=2. GUI panel (equity/spread/timezone) only when `bIsTestMode==false`.

## Bottom line
A **trend-pullback martingale scalper**: waits for one of many MA/SAR M30 trend patterns, enters from flat into a pullback, targets ~10-pip basket profit, recovers losers by adding progressively larger lots on a 35-pip grid with a near-disabled stop. Classic martingale risk profile — many small wins, rare but severe drawdowns.

## Notes for later
- Decoded UTF-8 copies of all four files were placed in the scratch outputs folder during analysis (not in the project tree).
- Phase 2 (planned) still pending: consolidate the 4 TradeManager setups via `CreateManager()` + `managers[4]` array loop.
