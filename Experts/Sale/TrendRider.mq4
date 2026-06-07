//+------------------------------------------------------------------+
//|                                                   TrendRider.mq4  |
//|        Fresh trend-following EA (no martingale, no grid).        |
//|        Trend  : MA stack (fast>mid>slow) + ADX strength filter    |
//|        Entry  : pullback to fast MA  OR  Donchian breakout,       |
//|                 both only in the higher-timeframe trend direction |
//|        Risk   : ATR-based stop, lot sized to % balance risk       |
//|        Manage : add-to-winners pyramiding (never average losers)  |
//|                 with a chandelier (ATR) trailing stop on all legs |
//|        Multi-symbol: uses Symbol()/Point of the attached chart    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Prosanta"
#property version   "1.0"
#property strict

//==================== INPUTS ====================
input string  _gen        = "==== General ====";
input int     MagicNumber  = 22000;
input string  TradeComment  = "TrendRider";
input bool    TradeBuys     = true;
input bool    TradeSells    = true;

input string  _trend      = "==== Trend / Filter ====";
input ENUM_TIMEFRAMES TrendTF = PERIOD_H1;   // higher-timeframe trend filter
input ENUM_TIMEFRAMES EntryTF = PERIOD_M30;  // entry/working timeframe
input int     MaFast       = 20;
input int     MaMid        = 50;
input int     MaSlow       = 100;
input int     AdxPeriod    = 14;
input double  AdxMin        = 22.0;          // require ADX above this = real trend

input string  _entry      = "==== Entry ====";
input bool    UsePullback  = true;           // enter on pullback to fast MA
input double  PullbackAtr   = 0.5;           // within this many ATR of fast MA
input bool    UseBreakout   = true;          // enter on Donchian breakout
input int     DonchianN     = 20;            // breakout lookback (bars)

input string  _risk       = "==== Risk / Sizing ====";
input int     AtrPeriod    = 14;
input double  RiskPercent   = 1.0;           // % of balance risked to the stop
input double  AtrSlMult     = 2.0;           // stop = entry -/+ AtrSlMult * ATR
input double  FixedLotFallback = 0.01;       // used if risk calc fails
input double  MaxLot        = 5.0;

input string  _pyr        = "==== Pyramiding (add to winners) ====";
input bool    UsePyramid    = true;
input int     MaxUnits      = 4;             // max legs incl. first
input double  AddEveryAtr    = 1.0;          // add when price advanced this many ATR
input double  TrailAtrMult   = 3.0;          // chandelier trailing-stop distance (ATR)

input string  _time       = "==== Session ====";
input bool    UseSession    = false;
input int     StartHour     = 0;             // server hour
input int     EndHour       = 24;

//==================== STATE ====================
datetime g_lastBar = 0;
double   g_pip;          // pip size in price (adjusts for 5/3-digit)
double   g_pointFactor;  // 10 for 5/3-digit, else 1

//==================== HELPERS ====================
double ATR(int shift=1) { return iATR(NULL, EntryTF, AtrPeriod, shift); }
double MAf(int tf,int per,int sh){ return iMA(NULL,tf,per,0,MODE_EMA,PRICE_CLOSE,sh); }
double ADXv(int tf,int sh){ return iADX(NULL,tf,AdxPeriod,PRICE_CLOSE,MODE_MAIN,sh); }

// +1 up, -1 down, 0 none. Trend = MA stack on TrendTF AND ADX>min.
int TrendDir()
{
   double f = MAf(TrendTF, MaFast, 1);
   double m = MAf(TrendTF, MaMid , 1);
   double s = MAf(TrendTF, MaSlow, 1);
   double adx = ADXv(TrendTF, 1);
   if(adx < AdxMin) return 0;
   if(f > m && m > s) return  1;
   if(f < m && m < s) return -1;
   return 0;
}

bool NewBar()
{
   datetime t = iTime(NULL, EntryTF, 0);
   if(t != g_lastBar) { g_lastBar = t; return true; }
   return false;
}

bool InSession()
{
   if(!UseSession) return true;
   int h = TimeHour(TimeCurrent());
   if(EndHour > StartHour) return (h >= StartHour && h < EndHour);
   return (h >= StartHour || h < EndHour);
}

void InitPip()
{
   int digits = (int)MarketInfo(Symbol(), MODE_DIGITS);
   if(digits == 3 || digits == 5) { g_pip = 10*Point; g_pointFactor = 10; }
   else                           { g_pip = Point;    g_pointFactor = 1;  }
}

// lot sized so that (stopDistPrice) loss == RiskPercent of balance
double CalcLot(double stopDistPrice)
{
   double tickVal = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tickSz  = MarketInfo(Symbol(), MODE_TICKSIZE);
   if(tickSz <= 0 || tickVal <= 0 || stopDistPrice <= 0) return FixedLotFallback;

   double riskMoney = AccountBalance() * RiskPercent / 100.0;
   double lossPerLot = (stopDistPrice / tickSz) * tickVal;  // money lost per 1.0 lot at stop
   if(lossPerLot <= 0) return FixedLotFallback;

   double lot = riskMoney / lossPerLot;

   double minLot = MarketInfo(Symbol(), MODE_MINLOT);
   double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double step   = MarketInfo(Symbol(), MODE_LOTSTEP);
   if(step <= 0) step = 0.01;
   lot = MathFloor(lot/step)*step;
   if(lot < minLot) lot = minLot;
   if(lot > maxLot) lot = maxLot;
   if(lot > MaxLot) lot = MaxLot;
   return NormalizeDouble(lot, 2);
}

//==================== POSITION INFO ====================
int CountPositions(int type) // type=OP_BUY/OP_SELL, -1 = any
{
   int c=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
            if(type<0 || OrderType()==type) c++;
   return c;
}

double LastEntryPrice(int type) // open price of most recent leg of this side
{
   datetime newest=0; double price=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderType()==type)
            if(OrderOpenTime()>=newest){ newest=OrderOpenTime(); price=OrderOpenPrice(); }
   return price;
}

//==================== ENTRY LOGIC ====================
// pullback: price dipped back near fast MA (long) within PullbackAtr*ATR
bool PullbackLong()
{
   double f = MAf(EntryTF, MaFast, 1);
   double atr = ATR(1);
   return (Low[1] <= f + PullbackAtr*atr && Close[1] > f); // touched/near fast MA, closed above
}
bool PullbackShort()
{
   double f = MAf(EntryTF, MaFast, 1);
   double atr = ATR(1);
   return (High[1] >= f - PullbackAtr*atr && Close[1] < f);
}
// breakout: close beyond N-bar Donchian channel (excluding current bar)
bool BreakoutLong()
{
   int idx = iHighest(NULL,EntryTF,MODE_HIGH,DonchianN,2);
   double hh = iHigh(NULL,EntryTF,idx);
   return (Close[1] > hh);
}
bool BreakoutShort()
{
   int idx = iLowest(NULL,EntryTF,MODE_LOW,DonchianN,2);
   double ll = iLow(NULL,EntryTF,idx);
   return (Close[1] < ll);
}

void OpenTrade(int type, double lot, double stopDist)
{
   double price = (type==OP_BUY) ? Ask : Bid;
   double sl    = (type==OP_BUY) ? price - stopDist : price + stopDist;
   int ticket = OrderSend(Symbol(), type, lot, price, 5, sl, 0, TradeComment, MagicNumber, 0, clrNONE);
   if(ticket < 0) Print("OrderSend failed ", GetLastError());
}

//==================== TRAILING (chandelier on all legs) ====================
void ManageTrailing()
{
   double atr = ATR(1);
   for(int i=0;i<OrdersTotal();i++)
   {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber) continue;

      if(OrderType()==OP_BUY)
      {
         double newSl = High[1] - TrailAtrMult*atr;
         if(newSl > OrderStopLoss() && newSl < Bid)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(newSl,Digits),OrderTakeProfit(),0,clrNONE);
      }
      else if(OrderType()==OP_SELL)
      {
         double newSl = Low[1] + TrailAtrMult*atr;
         if((newSl < OrderStopLoss() || OrderStopLoss()==0) && newSl > Ask)
            OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(newSl,Digits),OrderTakeProfit(),0,clrNONE);
      }
   }
}

//==================== MQL4 EVENTS ====================
int OnInit()
{
   InitPip();
   g_lastBar = 0;
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {}

void OnTick()
{
   // trailing runs every tick for responsiveness
   ManageTrailing();

   if(!NewBar()) return;           // decisions once per EntryTF bar
   if(!IsTradeAllowed()) return;
   if(!InSession()) return;
   if(Bars < MathMax(MaSlow, DonchianN)+5) return;

   int dir = TrendDir();
   if(dir == 0) return;            // no confirmed trend -> stand aside

   double atr = ATR(1);
   if(atr <= 0) return;
   double stopDist = AtrSlMult * atr;

   int nBuy  = CountPositions(OP_BUY);
   int nSell = CountPositions(OP_SELL);

   //---------- LONG side ----------
   if(dir==1 && TradeBuys)
   {
      if(nBuy==0)
      {
         bool sig = (UsePullback && PullbackLong()) || (UseBreakout && BreakoutLong());
         if(sig) OpenTrade(OP_BUY, CalcLot(stopDist), stopDist);
      }
      else if(UsePyramid && nBuy < MaxUnits)
      {
         // add to winners only: price advanced AddEveryAtr*ATR beyond last leg
         double last = LastEntryPrice(OP_BUY);
         if(last>0 && (Bid - last) >= AddEveryAtr*atr)
            OpenTrade(OP_BUY, CalcLot(stopDist), stopDist);
      }
   }

   //---------- SHORT side ----------
   if(dir==-1 && TradeSells)
   {
      if(nSell==0)
      {
         bool sig = (UsePullback && PullbackShort()) || (UseBreakout && BreakoutShort());
         if(sig) OpenTrade(OP_SELL, CalcLot(stopDist), stopDist);
      }
      else if(UsePyramid && nSell < MaxUnits)
      {
         double last = LastEntryPrice(OP_SELL);
         if(last>0 && (last - Ask) >= AddEveryAtr*atr)
            OpenTrade(OP_SELL, CalcLot(stopDist), stopDist);
      }
   }

   // optional: if trend flips against an open side, the chandelier trail will
   // close it out; we simply stop adding. (No averaging down, ever.)
}
//+------------------------------------------------------------------+
