# MavericProPlus — Phase 1: Extract Small Helpers

**Date:** 2026-06-01
**File:** `MQL4/Experts/Sale/MavericProPlus.mq4`
**Backup:** `MavericProPlus.mq4.phase0.bak` (state after Phase 0, before Phase 1)
**Lines:** 1376 → 1156 (−220)
**Risk:** Low — pure code motion, behaviour preserved.

## Goal
Eliminate the four most repeated patterns by introducing tiny helper functions. No new logic; each helper is a faithful rewrite of an inline pattern that was repeated dozens of times.

## Helpers Added
Inserted just before `int init()`:

```cpp
bool CanBuy()  { return (TradeDirn==TradeLong  || TradeDirn==TradeBoth); }
bool CanSell() { return (TradeDirn==TradeShort || TradeDirn==TradeBoth); }

bool IsNewM30Bar(datetime &lastTime)
{
   datetime now = iTime(NULL, PERIOD_M30, 0);
   if(lastTime == 0 || lastTime < now)
   {
      lastTime = now;
      return(true);
   }
   return(false);
}

void ApplyComment(TradeManager *tm, string testLabel)
{
   if(bIsTestMode) tm.SetTradeComment(testLabel);
   else            tm.SetTradeComment(TradeComment);
}
```

## Substitutions

| Old pattern | New | Sites |
|---|---|---|
| `TradeDirn==TradeLong\|\|TradeDirn==TradeBoth` | `CanBuy()` | 4 |
| `TradeDirn==TradeShort\|\|TradeDirn==TradeBoth` | `CanSell()` | 4 |
| `if(NewBarTime_1==0){...} else if(NewBarTime_1<iTime(...)){...}` (with bIsTestMode + DisplayGUI guards and history loads) | `if(IsNewM30Bar(NewBarTime_1)) { if(bIsTestMode==false && DisplayGUI) {...loads...} }` | 1 block |
| `if(NewBarTime==0){...} else if(NewBarTime<iTime(...)){...}` (with DisplayGUI guard) | `if(IsNewM30Bar(NewBarTime)) { if(DisplayGUI) m_TradeInfo.GetInformation(); }` | 1 block |
| `string str=" CheckNN "+m_MaTrend.m_TradeComment; SetTradeComment(str); if(bIsTestMode==false) SetTradeComment(TradeComment);` | `ApplyComment(tm, " CheckNN "+m_MaTrend.m_TradeComment);` | 48 |
| `SetTradeComment("CheckNN"); if(bIsTestMode==false) SetTradeComment(TradeComment);` | `ApplyComment(tm, "CheckNN");` | 8 |

Total: **64 sites** consolidated.

## Edge Case Left Alone
One block in `SellSystem` (the `CheckTrend_19` branch) does NOT follow the standard pattern — its non-test branch sets `str = " Mavericks "` instead of `TradeComment`. Left untouched to preserve exact behavior.

## Method
Single Python script using ordered regex substitutions. Each substitution reported its match count; a final sanity sweep confirmed zero leftover instances of the old patterns:
- `TradeDirn==TradeLong||` count: 0
- `TradeDirn==TradeShort||` count: 0
- `if(bIsTestMode==false) m_TradeManager.SetTradeComment(TradeComment)` count: 0
- `NewBarTime==0` / `NewBarTime_1==0` count: 0

## Validation
- `file` confirmed encoding preserved (UTF-16 LE).
- Spot-checked `BuySystem` first 10 branches, both `NewBarTime` consolidations, and direction-check call sites.
- Line count drop matches expectation (~220 lines = roughly 4 lines saved per of 56 ApplyComment sites = 224, minus +17 lines of new helpers).

## Next Phase
Phase 2: Consolidate the 4 TradeManager init/setup duplications via a `CreateManager(int magicOffset)` helper plus a `TradeManager* managers[4]` array loop for `UpdatePointFactor` / `RiskManagedLotCalculation` / `m_nProfitTargetInPips`.
