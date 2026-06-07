# Worklog

Day-by-day timeline of all work. Newest entries on top within each day.

---

## 2026-06-07 (Sunday)

### v3.3 — root-cause replay + symbol/entry-reason columns
Extended `EntryLogger.mqh` per user request: log the FX pair, entry time, and entry reason explicitly, and auto-produce a root-cause reconstruction for any basket that ends beyond acceptable drawdown.
- entries/outcomes CSVs now carry `symbol`; direction written as BUY/SELL/NA; firing check kept as `reason_check`. Outcome rows add `breached_dd`/`breached_depth` flags.
- New third file `MPP_rootcause_<tag>.csv`: when a basket breaches **DD money OR grid depth** at close, dump a per-bar replay — 50-bar **look-back** before entry, the **ENTRY** bar, then full **look-forward** to close — each row with OHLC + MA8/20/50/100/200/300 + SAR + H1/H4 trend. This is the look-back/look-forward root-cause tool to find where the entry went wrong.
- `Init(tag, ddMoneyTrigger=50, depthTrigger=5, lookBack=50)`; EA `init()` wired with (50,5,50). User can tune later.
- Implementation uses `iBarShift` to map entry/close times to M30 bar indices, then replays via iOpen/iHigh/iLow/iClose/iMA/iSAR by shift.
- VERSION 3.2 → 3.3. Compiled clean earlier at 3.2; 3.3 adds only logging code (same patterns) — user to recompile. Pushed to GitHub (commit b673a9c). Note: workspace mount read-back lagged during this edit; host file verified correct via direct read before commit.

### Git version control set up + pushed to GitHub
Established the versioning workflow the user requested: every change bumps `#define VERSION` and is committed so any state can be reverted.
- Discovered the MT4 folders (`Experts/Sale`, `Include/Sale`) are on a fuseblk mount that blocks git's lock/unlink ops → cannot `git init` in place.
- Solution: maintain a real git working copy and push to remote `https://github.com/SupremeDevProsanta/ai_eamt4`.
- Credential read from `E:\project\github\git_token.txt` (PAT). Token used only transiently in the remote URL for the push, then scrubbed from the remote config. **Token is still valid — rotate if desired.**
- Repo layout: `Experts/Sale/` (EA + `.bak` snapshots), `Include/Sale/` (EntryLogger + Trend_Math_Terex2 + ProsantTradeManagerLight + ProsantaConst), `document/` (audit), `memory/` (these notes). `.ex4` gitignored. `.gitattributes` keeps `.mqh/.md` as text, `.mq4` binary-safe (UTF-16).
- Commits pushed to `main`:
  1. `Baseline: MavericProPlus v3.1 (post Phase 0/1 refactor, pre-logger)`
  2. `v3.2: add behaviour-neutral entry/outcome condition logger`
  3. `Add .gitattributes`
- Bumped EA `#define VERSION` 3.1 → 3.2 (the logger change).

### Workflow convention established (per user)
On startup: read `memory/memory.md` for the brief of all tasks; follow the linked detail/worklog references for depth. Each task done each day → append to `memory/worklog.md`, then update the one-line brief in `memory/memory.md`. Every code change → bump VERSION + commit + push.

## 2026-06-01 (Monday)

### 06:50 UTC — MavericProPlus Phase 3: entry/outcome logger (behaviour-neutral)
Implemented the user's learn-and-rectify plan step 1. New `Include/Sale/EntryLogger.mqh` logs, per basket: ENTRY + each martingale ADD with a full condition snapshot (MA 8/20/50/100/200/300, ma-cross ages, slopes, SAR, stoch, CCI, and H1/H4 trend labels), plus a per-basket outcome row (max grid depth, peak floating drawdown, final P/L, check-at-open). Wired into `MavericProPlus.mq4` via 5 verified edits on the UTF-16 file: include, globals (`m_Logger`, `g_LastSignalLabel`), label capture in `ApplyComment`, `Init`+`Register` in init(), and 4× per-tick `Track` calls in start(). Verified brace/paren balance and that all referenced members exist; encodings preserved. Backup `MavericProPlus.mq4.prelogger.bak`. Still needs MetaEditor compile + a backtest to produce the CSVs. Detail: [2026-06-01-entry-logger-phase3.md](.