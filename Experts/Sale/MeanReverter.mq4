//+------------------------------------------------------------------+
//|                                                 MeanReverter.mq4  |
//|   Risk-bounded mean-reversion EA (no martingale, no grid).        |
//|   Validated in Python on 20y NZDCAD M30 with ECN cost model:      |
//|     in-sample (2006-2016)  PF 1.26  maxDD 3.5%                     |
//|     out-of-sample (2016-26) PF 1.07-1.26  maxDD < 6%              |
//|   NOTE: edge is regime-dependent (strong 2018+, flat 2006-2018).  |
//|         Modest but bounded. Forward-test before live use.         |
//|                                                                   |
//|   Model:                                                          |
//|     Entry  : price closes beyond Bollinger(20, k=3.0) band AND    |
//|              RSI(14) <= 20 (long)  or  >= 80 (short)              |
//|     Exit   : take-profit at TpAtr*ATR, OR price returns to the    |
//|              Bollinger mid (SMA20), OR hard stop SlAtr*ATR,        |
//|              OR time stop after TimeStopBars bars.                 |
//|     Risk   : lot sized so the hard stop = RiskPercent of balance. |
//|     One position at a time. Never averages losers.                |
//+------------------------------------------------------------------+
#property copyright "Copyright 2026, Prosanta"
#property version   "1.1"
#property strict

//==================== INPUTS ====================
input string  _gen      = "==== General ====";
input int     MagicNumber = 33000;
input string  TradeComment = "MeanReverter";
input bool    TradeLongs   = true;
input bool    TradeShorts   = true;

input string  _sig      = "==== Signal (NZDCAD fine-tuned v1.1) ====";
input int     BbPeriod    = 20;        // Bollinger period (= SMA mid)
input double  BbK          = 3.2;      // band width in std-devs
input int     RsiPeriod    = 14;
input double  RsiLong      = 20.0;     // long when RSI <= this
input double  RsiShort     = 80.0;     // short when RSI >= this

input string  _exit     = "==== Exit ====";
input int     AtrPeriod    = 14;
input double  SlAtr        = 4.5;      // hard stop = SlAtr * ATR
input double  TpAtr        = 3.0;      // take profit = TpAtr * ATR
input bool    ExitAtMid     = true;    // also exit when price returns to BB mid
input int     TimeStopBars  = 96;      // close after N bars if still open

input string  _risk     = "==== Risk / Sizing ====";
input double  RiskPercent   = 0.5;     // % balance risked to the hard stop
input double  FixedLotFallback = 0.01;
input double  MaxLot        = 5.0;
input int     SlippagePts    = 5;

input string  _time     = "==== Session (optional) ====";
input bool    UseSession    = false;
input int     StartHour     = 0;
input int     EndHour       = 24;

//==================== STATE ====================
datetime g_lastBar = 0;

//==================== HELPERS ====================
double BBupper(int sh){ return iBands(NULL,0,BbPeriod,BbK,0,PRICE_CLOSE,MODE_UPPER,sh); }
double BBlower(int sh){ return iBands(NULL,0,BbPeriod,BbK,0,PRICE_CLOSE,MODE_LOWER,sh); }
double BBmid (int sh){ return iBands(NULL,0,BbPeriod,BbK,0,PRICE_CLOSE,MODE_MAIN ,sh); }
double RSIv  (int sh){ return iRSI (NULL,0,RsiPeriod,PRICE_CLOSE,sh); }
double ATRv  (int sh){ return iATR (NULL,0,AtrPeriod,sh); }

bool NewBar()
{
   datetime t = iTime(NULL,0,0);
   if(t != g_lastBar){ g_lastBar = t; return true; }
   return false;
}

bool InSession()
{
   if(!UseSession) return true;
   int h = TimeHour(TimeCurrent());
   if(EndHour > StartHour) return (h>=StartHour && h<EndHour);
   return (h>=StartHour || h<EndHour);
}

int CountPos()
{
   int c=0;
   for(int i=0;i<OrdersTotal();i++)
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber) c++;
   return c;
}

double CalcLot(double stopDistPrice)
{
   double tickVal = MarketInfo(Symbol(), MODE_TICKVALUE);
   double tickSz  = MarketInfo(Symbol(), MODE_TICKSIZE);
   if(tickSz<=0 || tickVal<=0 || stopDistPrice<=0) return FixedLotFallback;
   double riskMoney  = AccountBalance()*RiskPercent/100.0;
   double lossPerLot = (stopDistPrice/tickSz)*tickVal;
   if(lossPerLot<=0) return FixedLotFallback;
   double lot = riskMoney/lossPerLot;
   double minLot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxLot=MarketInfo(Symbol(),MODE_MAXLOT);
   double step  =MarketInfo(Symbol(),MODE_LOTSTEP); if(step<=0) step=0.01;
   lot=MathFloor(lot/step)*step;
   if(lot<minLot) lot=minLot;
   if(lot>maxLot) lot=maxLot;
   if(lot>MaxLot) lot=MaxLot;
   return NormalizeDouble(lot,2);
}

void OpenTrade(int type,double lot,double stopDist,double tpDist)
{
   double price = (type==OP_BUY)?Ask:Bid;
   double sl    = (type==OP_BUY)?price-stopDist:price+stopDist;
   double tp    = (type==OP_BUY)?price+tpDist  :price-tpDist;
   int tk=OrderSend(Symbol(),type,lot,price,SlippagePts,
                    NormalizeDouble(sl,Digits),NormalizeDouble(tp,Digits),
                    TradeComment,MagicNumber,0,clrNONE);
   if(tk<0) Print("OrderSend failed ",GetLastError());
}

// exit-at-mid / time-stop management for the single open position
void ManageOpen()
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      if(OrderSymbol()!=Symbol() || OrderMagicNumber()!=MagicNumber) continue;

      bool doClose=false;
      double mid=BBmid(0);
      if(ExitAtMid)
      {
         if(OrderType()==OP_BUY  && Bid>=mid) doClose=true;
         if(OrderType()==OP_SELL && Ask<=mid) doClose=true;
      }
      if(TimeStopBars>0)
      {
         int barsHeld = iBarShift(NULL,0,OrderOpenTime(),false);
         if(barsHeld>=TimeStopBars) doClose=true;
      }
      if(doClose)
      {
         double px = (OrderType()==OP_BUY)?Bid:Ask;
         if(!OrderClose(OrderTicket(),OrderLots(),px,SlippagePts,clrNONE))
            Print("OrderClose failed ",GetLastError());
      }
   }
}

//==================== EVENTS ====================
int OnInit(){ g_lastBar=0; return(INIT_SUCCEEDED); }
void OnDeinit(const int reason){}

void OnTick()
{
   ManageOpen();                       // exit logic every tick (TP/SL are broker-side)

   if(!NewBar()) return;               // entries once per bar
   if(!IsTradeAllowed()) return;
   if(!InSession()) return;
   if(Bars < MathMax(BbPeriod,AtrPeriod)+5) return;
   if(CountPos()>0) return;            // single position only

   double atr = ATRv(1);
   if(atr<=0) return;

   double c1   = iClose(NULL,0,1);
   double up1  = BBupper(1);
   double lo1  = BBlower(1);
   double rsi1 = RSIv(1);

   double stopDist = SlAtr*atr;
   double tpDist   = TpAtr*atr;

   // LONG: closed below lower band AND RSI oversold
   if(TradeLongs && c1 < lo1 && rsi1 <= RsiLong)
      OpenTrade(OP_BUY, CalcLot(stopDist), stopDist, tpDist);

   // SHORT: closed above upper band AND RSI overbought
   else if(TradeShorts && c1 > up1 && rsi1 >= RsiShort)
      OpenTrade(OP_SELL, CalcLot(stopDist), stopDist, tpDist);
}
//+----------------------------------------------------------------