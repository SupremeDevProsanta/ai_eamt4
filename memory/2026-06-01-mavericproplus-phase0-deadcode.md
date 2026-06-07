# MavericProPlus — Phase 0: Dead Code Removal

**Date:** 2026-06-01
**File:** `MQL4/Experts/Sale/MavericProPlus.mq4`
**Backup:** `MavericProPlus.mq4.bak` (original, pre-Phase 0)
**Lines:** 1454 → 1376 (−78)
**Risk:** None — all removed code was unreachable.

## Goal
Remove obviously dead code before structural refactoring. This phase touches nothing that ever executed.

## Changes

### 1. Removed empty `Open_Pos_1()` stub
```cpp
void Open_Pos_1() {}    // deleted
```

### 2. Removed dead `DrawObjects()` function
Function existed but entire body was wrapped in `/* ... */`. Net effect was a no-op call.
```cpp
void DrawObjects(string ObjName, int shft_bgn, double Price_Bgn, ...) {
    /* ObjectDelete(...);  ObjectCreate(...);  ... */
}
```

### 3. Removed 5 fully-commented `else if` trend blocks
Inside `BuySystem()` / `SellSystem()`, four trend checks were entirely commented out:
- `CheckTrend_18()` (in SellSystem)
- `CheckTrend_20()` (in BuySystem)
- `CheckTrend_20()` (in SellSystem)
- `CheckTrend_33()` (in SellSystem)
- `CheckTrend_45()` (in SellSystem)

Each was a `/* else if (...) { ... } */` block that the compiler ignored.

### 4. Removed 8 commented `m_MaTrend.GetLinearRegressionSlope(...)` lines
Old experimental slope-calculation calls that had been commented out. Locations: inside the `NewBarTime`/`NewBarTime_1` reset blocks.

## Method
Python script using regex `re.subn()` on UTF-16 file content, with explicit count assertions to fail loudly if any expected match was missing.

## Validation
- `file` confirmed encoding preserved (UTF-16 LE, CRLF).
- Line count dropped exactly as expected.
- No live code paths touched.

## Next Phase
Phase 1: extract `CanBuy`, `CanSell`, `IsNewM30Bar`, `ApplyComment` helpers.
