//+------------------------------------------------------------------+
//|                                                ProsantaConst.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
enum CANDLE_DIRECTION  // enumeration of named constants
   {
    CANDLE_DIRECTION_NONE=0,
    CANDLE_DIRECTION_BULLISH,
    CANDLE_DIRECTION_BEARISH,
   };

enum CANDLE_TYPE  // enumeration of named constants
   {
    CANDLE_FORM_NONE=0,
    CANDLE_FORM_DOJJI,
    CANDLE_FORM_BULLISH,
    CANDLE_FORM_BEARISH,
    CANDLE_FORM_STRONG_BULLISH,
    CANDLE_FORM_STRONG_BEARISH,
    CANDLE_FORM_SHOOTING_STAR,
    CANDLE_FORM_HAMMER,
    CANDLE_FORM_BULLISH_BELTHOLD,
    CANDLE_FORM_BEARISH_BELTHOLD,    
    CANDLE_FORM_INVHAMMER,
    CANDLE_FORM_HANGING_MAN,
    CANDLE_FORM_INVHANGING_MAN
    
   };
 enum CANDLE_FORMATION  // enumeration of named constants
 {
    SYSM_FORM_NONE=0,
    SYSM_COUNTER_ATTACK_BULLISH,
    SYSM_COUNTER_ATTACK_BEARISH,
    SYSM_DARK_CLOUD_COVER,
    SYSM_BULLISH_ENGILFING,
    SYSM_BEARISH_ENGILFING,
    SYSM_BULLISH_REV_DOJJI_STAR,
    SYSM_BEARISH_REV_DOJJI_STAR,
    SYSM_EVENING_STAR,
    SYSM_MORNING_STAR,
    SYSM_EVENING_DOJJI_STAR,
    SYSM_MORNING_DOJJI_STAR,
    SYSM_SHOOTING_STAR,
    SYSM_TOP_TWIZER,
    SYSM_BOTTOM_TWIZER,
    SYSM_THREE_CROW,
    SYSM_RISING_THREE,
    SYSM_FALLING_THREE,
    SYSM_THREE_ADVANCING,
    SYSM_THREE_MOUNTAIN,
    SYSM_THREE_RIVER,
    SYSM_TOWER_TOP,
    SYSM_TOWER_BOTTOM,
    SYSM_BULLISH_HARAMIN,
    SYSM_BEARISH_HARAMIN,
    SYSM_BULLISH_HARAMIN_CROSS,
    SYSM_BEARISH_HARAMIN_CROSS,
    SYSM_PIERCING_PATTER,

 };


#define  MAGIC_NUMBER      994567
#define  TREND_NO          0
#define  TREND_UP          1
#define  TREND_DOWN        2
#define  TREND_SIDEWAY     3

#define  TRADING_MODE_Aggresive     1
#define  TRADING_MODE_Normal        2
#define  TRADING_MODE_Conservative  3


#define  ENTRY_POINT_NON   0
#define  ENTRY_POINT_BUY   5
#define  ENTRY_POINT_SELL  6

#define  DIGIT_VALUE       10
#define  DATA_LEN          150
#define  J_CANDLE_DATA_LEN 50
#define  SUPP_REST_COUNT   10
#define  SUPP_REST_HIGH    1
#define  SUPP_REST_LOW     2
#define  SUPPORT_FORMATION_DIFF 10
#define  SUPPORT_COUNT_MAIN     10
#define  SUPPORT_COUNT_SEC      20
#define  SUPPORT_ZIGZAG_COUNT_MAIN     2
#define  ZIGZAG_HIGH      1
#define  ZIGZAG_LOW       2
#define  MA_CROSSING_DATA 10
 
enum TradeOperation 
{
   MonitorAndTrade=0,  // Monitor & Trade
   MonitorTrade=1,     // Monitor
};

enum TradeHedge 
{
   Hedging_1=1,  // Hedging_1
   Hedging_2=2,  // Hedging_2
};
enum TradeDirection 
{
   TradeLong=1,  // Long
   TradeShort=2,  //Short
   TradeBoth=3,  // Long & Short   
};

enum TradeTrend
{
   TrendLong=1,  // Trend  Long M100
   TrendShort=2,  //Trend  Short M20
   TrendNone =3,  //Trend  NoTrend    
};

enum TradeMode
{
   Trading_Agg=1,  //Agreesive
   Trading_Nor=2,  //Normal
   Trading_Cons =3,//Conservative
};




