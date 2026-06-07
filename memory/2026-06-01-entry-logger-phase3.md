# MavericProPlus — Phase 3: Entry/Outcome Condition Logger

**Date:** 2026-06-01
**Goal:** Behaviour-neutral instrumentation so each trade's entry conditions are recorded, and baskets that breach acceptable drawdown can be analysed and the entry logic corrected iteratively (user's learn-and-rectify loop toward a trend-following martingale with bounded drawdown).
**Risk:** Low — logging only, no trading-logic change.
**Backup:** `MavericProPlus.mq4.prelogger.bak`

## New file
`MQL4/Include/Sale/EntryLogger.mqh` (ASCII). Class `EntryLogger`:
- `Init(tag)` — opens two CSVs in the terminal `files/` dir: `MPP_entries_<tag>.csv`, `MPP_outcomes_<tag>.csv` (writes headers once).
- `Register(magic)` — maps up to 8 basket slots to magic numbers.
- `Track(slot, MA_Trend*, TradeManager*, lastSignalLabel)` — call every tick per basket. Detects:
  - ENTRY (count 0→1): logs full condition snapshot + firing check label.
  - ADD (count up): logs each martingale add (execution layer).
  - per-tick: updates peak floating drawdown + max grid depth.
  - close (count→0): writes outcome row.
- Helper `EL_TrendLabel(tf)` — H1/H4 trend via 20/50/100 SMA stack (+1/0/-1).

### entries CSV columns
time, event(ENTRY/ADD), magic, slot, dir, lots, price, grid_depth, check,
MA8/20/50/100/200/300, cr8_20/20_50/50_100/100_200, slope8/20/50/100,
sar0, close1, stochMain, stochSig, cci, h1trend, h4trend, float_profit

### outcomes CSV columns
open_time, close_time, magic, dir, max_grid_depth, peak_floating_dd, final_profit, check_at_open

## EA edits (MavericProPlus.mq4, all via verified Python on UTF-16)
1. `#include <.\Sale\EntryLogger.mqh>`
2. Globals: `EntryLogger m_Logger; string g_LastSignalLabel="";`
3. `ApplyComment()` now captures `g_LastSignalLabel=testLabel;` — this is how the firing CheckTrend label survives (in backtest bIsTestMode=false would otherwise overwrite the order comment with the generic TradeComment).
4. `init()`: `m_Logger.Init(Symbol()+"_"+MagicNum)` + `Register(MagicNum..+3)`.
5. `start()`: 4× `m_Logger.Track(slot,GetPointer(m_MaTrend),<manager>,g_LastSignalLabel)` placed before the MonitorAndTrade block so it runs every tick (captures peak DD).

## Design notes / caveats
- Managers are `TradeManager*` (pointers) so Track takes pointers; `m_MaTrend` is an object → passed via `GetPointer`.
- `g_LastSignalLabel` is the last label set by ApplyComment; for the first ENTRY of a basket it reflects the check that fired. Martingale ADDs reuse the same global (they don't go through ApplyComment) — acceptable, ADD rows are tagged event=ADD.
- One known imperfection: if two baskets fire on the same tick, both read the same g_LastSignalLabel. For EURUSD-only single-symbol use this is rare; revisit if needed.
- Verified: brace/paren balance unchanged, all referenced members exist (m_MA_*_1, m_ma_cross_*, m_dSlope*[], GetLotSize, GetCurrentProfit, GetCurrTradeOrderPrice, m_MagicNumber public), encodings preserved (EA UTF-16, include ASCII).

## Not done (next)
- Compile in MetaEditor (cannot compile from here) — user to verify, watch for warnings.
- After a backtest: collect the two CSVs from `<terminal>/tester/files/` (or `MQL4/Files/`), analyse baskets where peak_floating_dd beyond threshold, find common entry conditions (esp. h1trend/h4trend opposite dir), then rectify entry logic — aggregate fixes only, in-sample + out-of-sample guardrail.
