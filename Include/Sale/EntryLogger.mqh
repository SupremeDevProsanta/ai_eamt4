//+------------------------------------------------------------------+
//|                                                  EntryLogger.mqh  |
//|        Behaviour-neutral trade-condition logger for analysis     |
//|        Logs: per-entry & per-fill condition snapshots,           |
//|              per-basket outcomes (drawdown / grid depth).         |
//|        No trading logic. Safe to include and remove.             |
//+------------------------------------------------------------------+
#property strict

//--- Helper: classify trend on a timeframe by 20/50/100 SMA stack
int EL_TrendLabel(int tf)
{
   double f = iMA(NULL, tf, 20,  0, MODE_SMA, PRICE_CLOSE, 1);
   double m = iMA(NULL, tf, 50,  0, MODE_SMA, PRICE_CLOSE, 1);
   double s = iMA(NULL, tf, 100, 0, MODE_SMA, PRICE_CLOSE, 1);
   if(f > m && m > s) return  1;   // up
   if(f < m && m < s) return -1;   // down
   return 0;                       // mixed / ranging
}

class EntryLogger
{
private:
   string m_entryFile;
   string m_outcomeFile;
   bool   m_enabled;

   // per-slot tracking state (index = slot, max 8 baskets)
   int      m_prevCount[8];
   int      m_maxDepth[8];
   double   m_peakDD[8];        // most negative floating profit seen
   double   m_lastProfit[8];
   datetime m_openTime[8];
   int      m_openDir[8];
   string   m_openLabel[8];
   int      m_slotMagic[8];
   int      m_nSlots;

   void WriteHeaderIfNew(string fname, string header)
   {
      int h = FileOpen(fname, FILE_READ|FILE_WRITE|FILE_CSV, ',');
      if(h < 0) return;
      if(FileSize(h) == 0) FileWrite(h, header);
      FileClose(h);
   }

public:
   void EntryLogger() { m_enabled = false; m_nSlots = 0; }

   //--- Call once in init(). tag distinguishes runs/symbols.
   void Init(string tag)
   {
      m_entryFile   = "MPP_entries_"  + tag + ".csv";
      m_outcomeFile = "MPP_outcomes_" + tag + ".csv";
      m_enabled     = true;
      m_nSlots      = 0;

      for(int i=0;i<8;i++)
      {
         m_prevCount[i]=0; m_maxDepth[i]=0; m_peakDD[i]=0; m_lastProfit[i]=0;
         m_openTime[i]=0;  m_openDir[i]=-1; m_openLabel[i]=""; m_slotMagic[i]=0;
      }

      WriteHeaderIfNew(m_entryFile,
        "time,event,magic,slot,dir,lots,price,grid_depth,check,"
        "MA8,MA20,MA50,MA100,MA200,MA300,"
        "cr8_20,cr20_50,cr50_100,cr100_200,"
        "slope8,slope20,slope50,slope100,"
        "sar0,close1,stochMain,stochSig,cci,"
        "h1trend,h4trend,float_profit");

      WriteHeaderIfNew(m_outcomeFile,
        "open_time,close_time,magic,dir,max_grid_depth,peak_floating_dd,final_profit,check_at_open");
   }

   //--- Register a basket slot to a magic number (call in init for each manager)
   void Register(int magic)
   {
      if(m_nSlots < 8) { m_slotMagic[m_nSlots] = magic; m_nSlots++; }
   }

   //--- internal: write one condition row
   void WriteRow(string ev, int slot, int magic, int dir, double lots, double price,
                 int gridDepth, string checkLabel, MA_Trend *trend, double floatProfit)
   {
      int h = FileOpen(m_entryFile, FILE_READ|FILE_WRITE|FILE_CSV, ',');
      if(h < 0) return;
      FileSeek(h, 0, SEEK_END);

      double sar0   = iSAR(NULL, 0, 0.02, 0.2, 0);
      double close1 = iClose(NULL, PERIOD_M30, 1);
      double stMain = iStochastic(NULL, PERIOD_M30, 50,30,30, MODE_SMA, 0, MODE_MAIN, 0);
      double stSig  = iStochastic(NULL, PERIOD_M30, 50,30,30, MODE_SMA, 0, MODE_SIGNAL, 0);
      double cci    = iCCI(Symbol(), PERIOD_M30, 14, PRICE_TYPICAL, 1);

      FileWrite(h,
         TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS),
         ev, magic, slot, dir,
         DoubleToStr(lots,2), DoubleToStr(price,5), gridDepth, checkLabel,
         DoubleToStr(trend.m_TradeParam.m_MA_8_1,5),
         DoubleToStr(trend.m_TradeParam.m_MA_20_1,5),
         DoubleToStr(trend.m_TradeParam.m_MA_50_1,5),
         DoubleToStr(trend.m_TradeParam.m_MA_100_1,5),
         DoubleToStr(trend.m_TradeParam.m_MA_200_1,5),
         DoubleToStr(trend.m_TradeParam.m_MA_300_1,5),
         trend.m_TradeParam.m_ma_cross_8_20,
         trend.m_TradeParam.m_ma_cross_20_50,
         trend.m_TradeParam.m_ma_cross_50_100,
         trend.m_TradeParam.m_ma_cross_100_200,
         DoubleToStr(trend.m_TradeParam.m_dSlope8[0],3),
         DoubleToStr(trend.m_TradeParam.m_dSlope20[0],3),
         DoubleToStr(trend.m_TradeParam.m_dSlope50[0],3),
         DoubleToStr(trend.m_TradeParam.m_dSlope100[0],3),
         DoubleToStr(sar0,5), DoubleToStr(close1,5),
         DoubleToStr(stMain,2), DoubleToStr(stSig,2), DoubleToStr(cci,1),
         EL_TrendLabel(PERIOD_H1), EL_TrendLabel(PERIOD_H4),
         DoubleToStr(floatProfit,2));
      FileClose(h);
   }

   //--- internal: write one outcome row
   void WriteOutcome(int slot, int magic)
   {
      int h = FileOpen(m_outcomeFile, FILE_READ|FILE_WRITE|FILE_CSV, ',');
      if(h < 0) return;
      FileSeek(h, 0, SEEK_END);
      FileWrite(h,
         TimeToStr(m_openTime[slot], TIME_DATE|TIME_SECONDS),
         TimeToStr(TimeCurrent(),    TIME_DATE|TIME_SECONDS),
         magic, m_openDir[slot], m_maxDepth[slot],
         DoubleToStr(m_peakDD[slot],2), DoubleToStr(m_lastProfit[slot],2),
         m_openLabel[slot]);
      FileClose(h);
   }

   //--- Call every tick, once per basket. Detects entries, adds, closes.
   //    lastSignalLabel = the global label captured by ApplyComment at fire time.
   void Track(int slot, MA_Trend *trend, TradeManager *tm, string lastSignalLabel)
   {
      if(!m_enabled) return;
      if(tm == NULL) return;

      int    cnt  = tm.GetTradeCount();
      double prof = tm.GetCurrentProfit();
      int    dir  = tm.GetCurrentOrderType();
      double price= tm.GetCurrTradeOrderPrice();
      int    magic= tm.m_MagicNumber;

      if(cnt > m_prevCount[slot])
      {
         if(m_prevCount[slot] == 0)
         {
            // new basket opened
            m_openTime[slot]  = TimeCurrent();
            m_maxDepth[slot]  = cnt;
            m_peakDD[slot]    = prof;
            m_openDir[slot]   = dir;
            m_openLabel[slot] = lastSignalLabel;
            WriteRow("ENTRY", slot, magic, dir, tm.GetLotSize(), price, cnt, lastSignalLabel, trend, prof);
         }
         else
         {
            // martingale add (execution layer)
            if(cnt > m_maxDepth[slot]) m_maxDepth[slot] = cnt;
            WriteRow("ADD", slot, magic, dir, tm.GetLotSize(), price, cnt, lastSignalLabel, trend, prof);
         }
      }

      if(cnt > 0)
      {
         if(prof < m_peakDD[slot]) m_peakDD[slot] = prof;
         if(cnt  > m_maxDepth[slot]) m_maxDepth[slot] = cnt;
         m_lastProfit[slot] = prof;
      }

      if(cnt == 0 && m_prevCount[slot] > 0)
      {
         // basket fully closed -> log outcome
         WriteOutcome(slot, magic);
      }

      m_prevCount[slot] = cnt;
   }
};
