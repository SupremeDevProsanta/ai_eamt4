//+------------------------------------------------------------------+
//|                                               FractalManager.mqh |
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
#include <.\Sale\prosantaconst.mqh>
#include <.\Sale\SuppRest.mqh>
#include <.\Sale\Graphics.mqh>
#include <.\Sale\FractalManager.mqh>

#define PSAR_DATA_LENTGH 300

struct TradeParam
{
  double   m_Current_1_4;
  double   m_Current_1_5;
  double   m_Current_1_7;
  double   m_Current_1_18;
  double   m_Current_1_20;
  double   m_Current_1_50;
  double   m_Current_1_100;
  double   m_Current_1_400; 
  double   m_Current_5_10;
  double   m_Current_7_12;
  double   m_Current_7_20;
  double   m_Current_7_50;
  double   m_Current_7_150;
  double   m_Current_20_40;
  double   m_Current_50_100;
  double   m_Current_50_150;  
  double   m_Current_100_150;
  double   m_Current_100_200;
  double   m_Current_100_300;

  double   m_iClose[3];
  double   m_iOpen[3];
  double   m_FractalHigh[3];
  double   m_FractalLow[3];


  double   m_Resistance_10;
  double   m_Resistance_40;
  double   m_Resistance_100;
  double   m_Resistance_200;  
  double   m_Resistance_400;

  double   m_Support_10;
  double   m_Support_40;
  double   m_Support_100;
  double   m_Support_200;  
  double   m_Support_400;
  
   
  double   m_MA_3_1;
  double   m_MA_3_2;
  double   m_MA_3_3;
  double   m_MA_3_4;

  double   m_MA_8_1;
  double   m_MA_8_2;
  double   m_MA_8_3;
  double   m_MA_8_7;  
  double   m_MA_8_20;

  double   m_MA_10_1;
  double   m_MA_10_2;
  double   m_MA_10_3;
  double   m_MA_10_4;
  
  double   m_MA_10_5;
  double   m_MA_10_7;
  double   m_MA_10_14;
  double   m_MA_10_20;

  double   m_MA_14_1;
  double   m_MA_14_2;
  double   m_MA_14_3;
  double   m_MA_14_14;

  
  double   m_MA_20_1;
  double   m_MA_20_2;
  double   m_MA_20_3;
  double   m_MA_20_5;
  double   m_MA_20_7;
  double   m_MA_20_14;
  double   m_MA_20_20;

  
  double   m_MA_30_1;
  double   m_MA_30_2;
  double   m_MA_30_3;
  double   m_MA_30_14;
  
  double   m_MA_50_1;
  double   m_MA_50_2;
  double   m_MA_50_3;
  double   m_MA_50_7;
  double   m_MA_50_14;
  double   m_MA_50_20;
  
  
  double   m_MA_75_1;
  double   m_MA_75_2;
  double   m_MA_75_3;
  double   m_MA_100_1;
  double   m_MA_100_2;
  double   m_MA_100_3;
  double   m_MA_100_7;  
  double   m_MA_100_14;
  double   m_MA_100_20;

  double   m_MA_125_1;
  double   m_MA_125_2;
  double   m_MA_125_3;
  
  double   m_MA_150_1;
  double   m_MA_150_2;
  double   m_MA_150_3;
  double   m_MA_200_1;
  double   m_MA_200_2;
  double   m_MA_200_3;
  double   m_MA_200_5;
  
  double   m_MA_300_1;
  double   m_MA_300_2;
  double   m_MA_300_3;

  double   m_MA_400_1;
  double   m_MA_400_2;
  double   m_MA_400_3;


  double   m_d14_20;
  double   m_dist_3_10;
  double   m_dist_3_20;
  double   m_dist_10_20;
  double   m_dist_10_50;
  double   m_dist_20_50;
  double   m_dist_20_100;
  double   m_dist_50_100;
  double   m_dist_100_200;
  
  
  
  int   m_ma_cross_3_10;

  int   m_ma_cross_8_20;
  
  int   m_ma_cross_8_30;
  int   m_ma_cross_8_50;
  int   m_ma_cross_8_100;

  int   m_ma_cross_10_20;
  int   m_ma_cross_10_30;  
  int   m_ma_cross_10_50;
  int   m_ma_cross_10_100;

 
  int   m_ma_cross_14_20;
  
  int   m_ma_cross_20_30;
  int   m_ma_cross_20_50;
  int   m_ma_cross_20_75;
  int   m_ma_cross_20_100;
  int   m_ma_cross_20_200;

  int   m_ma_cross_30_50;
  int   m_ma_cross_30_75;
  int   m_ma_cross_30_100;
  int   m_ma_cross_30_200;

  
  int   m_ma_cross_50_75;  
  int   m_ma_cross_50_100;
  int   m_ma_cross_50_200;
  int   m_ma_cross_75_100;

  int   m_ma_cross_100_150;
  int   m_ma_cross_100_200;
  int   m_ma_cross_100_300;

  int   m_ma_cross_150_200;
  int   m_ma_cross_150_300;
  
  int   m_ma_cross_200_300;
  int   m_ma_cross_300_400;
  
  
  double   m_dSlope8[10];
  double   m_dSlope10[10];               
  double   m_dSlope20[10];
  double   m_dSlope50[10];
  double   m_dSlope100[10];
  
  double   m_Close_1;
  double   m_Open_1;
  double   m_Close_2;
  double   m_Open_2;
  double   m_Close_3;
  double   m_Open_3;
  double   m_Close_4;
  double   m_Open_4;
  
  
  
  double   GetAbsOpenDiffClose(int m_nTimeFrame,int nIndex);
  double   GetOpenDiffClose(int m_nTimeFrame,int nIndex);
  double   GetCloseDiffOpen(int m_nTimeFrame,int nIndex);
  bool     IsDojji(int m_nTimeFrame,int nIndex);
  bool     IsRanging();
  
};

class Pattern
{
  public:
     
};

class MA_Trend
{
   public:
      double m_PointFactor;
      double Buffer_Linear[10];
      int    n_Counter;
      RoboGraphics  m_gObj;
      string m_TradeComment;
      FractalManager m_Fractal;
      TradeParam     m_TradeParam;
       
   public:
    void MA_Trend(){n_Counter=0;m_TradeComment="Default";}
    int FindMaCrossing(int nTimeInterval,int PeriodFastMA,int PeriodSlowMA);
    int FindMaCrossingEx(int nStartIndex, int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal,double& HighLowDiff,double& dSlope,int& nRunlenght);

    void UpdatePointFactor();
    double GetSlope(int nTimeInterval,int nPeriod,int SlopInit, int SlopEnd);
    int FindMaCrossingDist(int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal);
    int FindMaCrossingCustom(int nStartPos,int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal);
    double GetLinearRegressionSlope(int nTimeFrame,int nStart,int Count,double &nnslope);
    double GetRegressionSlope(int nTimeFrame,int nStart,int Count);
    
    
    void DrawObjects(string ObjName, int shft_bgn, double Price_Bgn, int shft_end, double Price_End, color clr, int wdth); 
    int LinearRegression(int nTimeFrame,int nStart,int Count,string strName,int x,int y);
    void LoadDataParam(int m_nTimeFrame);    
    
    int CheckTrend(int nfast,int nslow, int ntime_frame, int nShift,int nPrice);
    int CheckTrend_1();
    int CheckTrend_2();
    int CheckTrend_3();
    int CheckTrend_4();
    int CheckTrend_5();
    int CheckTrend_6();
    int CheckTrend_7();
    int CheckTrend_8();

    int CheckTrend_9();
    int CheckTrend_10();
    int CheckTrend_11();
    int CheckTrend_12();
    int CheckTrend_13();
    int CheckTrend_14();

    int CheckTrend_15();
    int CheckTrend_16();
    int CheckTrend_17();
    int CheckTrend_18();
    int CheckTrend_19();
    int CheckTrend_20();
    int CheckTrend_21();
    int CheckTrend_22();
    int CheckTrend_23();
    int CheckTrend_24();
    int CheckTrend_25();

    int CheckTrend_26();
    int CheckTrend_26_1();
    
    int CheckTrend_27();
    int CheckTrend_28();
    int CheckTrend_29();
    int CheckTrend_30();
    int CheckTrend_31();
    int CheckTrend_32();
    int CheckTrend_33();
    int CheckTrend_34();
    int CheckTrend_35();
    int CheckTrend_36();
    int CheckTrend_37();
    int CheckTrend_38();
    int CheckTrend_39();
    int CheckTrend_40();    
    int CheckTrend_41();
    int CheckTrend_42();
    int CheckTrend_43();
    int CheckTrend_44();
    
    int CheckTrend_45();
    int CheckTrend_46();
    int CheckTrend_47();
    int CheckTrend_48();
    int CheckTrend_49();
    int CheckTrend_50();
    int CheckTrend_51();
    int CheckTrend_52();
    int CheckTrend_53();
    int CheckTrend_54();
    int CheckTrend_55();
    int CheckTrend_58();
    int CheckTrend_59();
    int CheckTrend_60();
    int CheckTrend_Turbo();
    int CheckTrend_Turbo_1();
    int CheckTrend_Turbo_2();
    
    
    
    
};


double TradeParam::GetAbsOpenDiffClose(int m_nTimeFrame,int nIndex)
{
   return MathAbs(iClose(NULL,m_nTimeFrame,nIndex)-iOpen(NULL,m_nTimeFrame,nIndex));  
}
double TradeParam::GetOpenDiffClose(int m_nTimeFrame,int nIndex)
{
   return (iOpen(NULL,m_nTimeFrame,nIndex)-iClose(NULL,m_nTimeFrame,nIndex));  
}
double TradeParam::GetCloseDiffOpen(int m_nTimeFrame,int nIndex)
{
   return (iClose(NULL,m_nTimeFrame,nIndex)-iOpen(NULL,m_nTimeFrame,nIndex));  

}
bool TradeParam::IsDojji(int m_nTimeFrame,int nIndex)
{

   return true;
}


bool TradeParam::IsRanging()
{
    double Dx=NormalizeDouble(m_dSlope100[0],2);
    double Ax=NormalizeDouble(m_Current_1_100,2);

   if(MathAbs(Ax)<0.1 && MathAbs(Dx)<1)
     return true;
   
   return false;
}



void MA_Trend::LoadDataParam(int m_nTimeFrame)
{

   m_Fractal.LoadData();

  
  m_TradeParam.m_Current_1_4=GetRegressionSlope(m_nTimeFrame,1,4);
  
  m_TradeParam.m_Current_1_5=GetRegressionSlope(m_nTimeFrame,1,5);
  m_TradeParam.m_Current_1_7=GetRegressionSlope(m_nTimeFrame,1,7);
  m_TradeParam.m_Current_1_18=GetRegressionSlope(m_nTimeFrame,1,18);
  m_TradeParam.m_Current_1_20=GetRegressionSlope(m_nTimeFrame,1,20);
  m_TradeParam.m_Current_1_50=GetRegressionSlope(m_nTimeFrame,1,50);
  m_TradeParam.m_Current_1_100=GetRegressionSlope(m_nTimeFrame,1,100);
  m_TradeParam.m_Current_1_400=GetRegressionSlope(m_nTimeFrame,1,400);

  m_TradeParam.m_Current_5_10=GetRegressionSlope(m_nTimeFrame,5,10);

   
  m_TradeParam.m_Current_7_12=GetRegressionSlope(m_nTimeFrame,7,5);
  m_TradeParam.m_Current_7_20=GetRegressionSlope(m_nTimeFrame,7,20);
  m_TradeParam.m_Current_7_50=GetRegressionSlope(m_nTimeFrame,7,50);
  m_TradeParam.m_Current_7_150=GetRegressionSlope(m_nTimeFrame,7,150);
 
  m_TradeParam.m_Current_20_40=GetRegressionSlope(m_nTimeFrame,20,40);
  m_TradeParam.m_Current_50_100=GetRegressionSlope(m_nTimeFrame,50,100);

  m_TradeParam.m_Current_100_150=GetRegressionSlope(m_nTimeFrame,100,150);

  m_TradeParam.m_Current_100_200=GetRegressionSlope(m_nTimeFrame,100,200);

  m_TradeParam.m_Current_50_150=GetRegressionSlope(m_nTimeFrame,50,150);
  m_TradeParam.m_Current_100_300=GetRegressionSlope(m_nTimeFrame,100,300);
  
  for(int i=0;i<3;i++)
  {  
     m_TradeParam.m_iClose[i] =iClose(NULL,m_nTimeFrame,i+1);
     m_TradeParam.m_iOpen[i]  =iOpen(NULL,m_nTimeFrame,i+1);
  }
  
  int nIndex=0;
  m_TradeParam.m_FractalHigh[0]=m_Fractal.GetNearestFactralHighParam(m_nTimeFrame,nIndex,1);
  m_TradeParam.m_FractalHigh[1]=m_Fractal.GetNearestFactralHighParam(m_nTimeFrame,nIndex,2);
  m_TradeParam.m_FractalHigh[2]=m_Fractal.GetNearestFactralHighParam(m_nTimeFrame,nIndex,3);
  
  m_TradeParam.m_FractalLow[0]=m_Fractal.GetNearestFactralLowParam(m_nTimeFrame,nIndex,1);
  m_TradeParam.m_FractalLow[1]=m_Fractal.GetNearestFactralLowParam(m_nTimeFrame,nIndex,2);
  m_TradeParam.m_FractalLow[2]=m_Fractal.GetNearestFactralLowParam(m_nTimeFrame,nIndex,3);
  

   int index=0;
   double HighVal=0;
   double LowVal=0;
   
   index=iHighest(NULL,m_nTimeFrame,MODE_HIGH,10,1);
   HighVal=iHigh(NULL,m_nTimeFrame,index);
   
   index=iLowest(NULL,m_nTimeFrame,MODE_LOW,10,3);
   LowVal=iLow(NULL,m_nTimeFrame,index);
  
   m_TradeParam.m_Resistance_10=HighVal;
   m_TradeParam.m_Support_10=LowVal;

   index=iHighest(NULL,m_nTimeFrame,MODE_HIGH,40,1);
   HighVal=iHigh(NULL,m_nTimeFrame,index);
   
   index=iLowest(NULL,m_nTimeFrame,MODE_LOW,40,3);
   LowVal=iLow(NULL,m_nTimeFrame,index);
  
   m_TradeParam.m_Resistance_40=HighVal;
   m_TradeParam.m_Support_40=LowVal;


   index=iHighest(NULL,m_nTimeFrame,MODE_HIGH,100,1);
   HighVal=iHigh(NULL,m_nTimeFrame,index);
   
   index=iLowest(NULL,m_nTimeFrame,MODE_LOW,100,3);
   LowVal=iLow(NULL,m_nTimeFrame,index);

   m_TradeParam.m_Resistance_100=HighVal;
   m_TradeParam.m_Support_100=LowVal;


   index=iHighest(NULL,m_nTimeFrame,MODE_HIGH,200,1);
   HighVal=iHigh(NULL,m_nTimeFrame,index);


   index=iLowest(NULL,m_nTimeFrame,MODE_LOW,200,3);
   LowVal=iLow(NULL,m_nTimeFrame,index);

   m_TradeParam.m_Resistance_200=HighVal;
   m_TradeParam.m_Support_200=LowVal;


   index=iHighest(NULL,m_nTimeFrame,MODE_HIGH,400,1);
   HighVal=iHigh(NULL,m_nTimeFrame,index);
   
   index=iLowest(NULL,m_nTimeFrame,MODE_LOW,400,3);
   LowVal=iLow(NULL,m_nTimeFrame,index);

   m_TradeParam.m_Resistance_400=HighVal;
   m_TradeParam.m_Support_400=LowVal;
  
   

  int nPeriod=3;
  m_TradeParam.m_MA_3_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_3_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_3_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_3_4=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 4);
  

  nPeriod=8;
  m_TradeParam.m_MA_8_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_8_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_8_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_8_7=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 7); 
  m_TradeParam.m_MA_8_20=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 20);


  nPeriod=10;
  m_TradeParam.m_MA_10_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_10_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_10_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_10_4=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 4);
  
  m_TradeParam.m_MA_10_5=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 5);
  m_TradeParam.m_MA_10_7=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 7);
  m_TradeParam.m_MA_10_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);
  m_TradeParam.m_MA_10_20=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,20);


  nPeriod=14;
  m_TradeParam.m_MA_14_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_14_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_14_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_14_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);

  
  nPeriod=20;
  m_TradeParam.m_MA_20_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_20_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_20_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_20_5=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 5);
  m_TradeParam.m_MA_20_7=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 7);
  m_TradeParam.m_MA_20_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);
  m_TradeParam.m_MA_20_20=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,20);

  nPeriod=30;  
  m_TradeParam.m_MA_30_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_30_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_30_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_30_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);
  
  nPeriod=50;
  m_TradeParam.m_MA_50_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_50_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_50_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_50_7=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 7);
  m_TradeParam.m_MA_50_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);
  m_TradeParam.m_MA_50_20=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,20);
  
  
  nPeriod=75;  
  m_TradeParam.m_MA_75_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_75_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_75_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);

  nPeriod=100;    
  m_TradeParam.m_MA_100_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_100_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_100_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_100_7=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 7);  
  m_TradeParam.m_MA_100_14=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,14);
  m_TradeParam.m_MA_100_20=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE,20);

  nPeriod=125;    
  m_TradeParam.m_MA_125_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_125_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_125_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  
  nPeriod=150;  
  m_TradeParam.m_MA_150_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_150_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_150_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  
  nPeriod=200;  
  m_TradeParam.m_MA_200_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_200_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_200_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);
  m_TradeParam.m_MA_200_5=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 5);
  
  nPeriod=300;    
  m_TradeParam.m_MA_300_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_300_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_300_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);

  nPeriod=400;    
  m_TradeParam.m_MA_400_1=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 1);
  m_TradeParam.m_MA_400_2=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 2);
  m_TradeParam.m_MA_400_3=iMA(NULL, m_nTimeFrame, nPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);


  double d8_20=0;
   
  m_TradeParam.m_ma_cross_3_10=FindMaCrossingDist(m_nTimeFrame,3,10,m_TradeParam.m_dist_3_10); 
  m_TradeParam.m_ma_cross_8_20=FindMaCrossingDist(m_nTimeFrame,8,20,d8_20);
  m_TradeParam.m_ma_cross_8_30=FindMaCrossingDist(m_nTimeFrame,8,30,d8_20);
  m_TradeParam.m_ma_cross_8_50=FindMaCrossingDist(m_nTimeFrame,8,50,d8_20);

  
  m_TradeParam.m_ma_cross_8_100=FindMaCrossingDist(m_nTimeFrame,8,100,d8_20);

  m_TradeParam.m_ma_cross_10_20=FindMaCrossingDist(m_nTimeFrame,10,20,m_TradeParam.m_dist_10_20);
  m_TradeParam.m_ma_cross_10_30=FindMaCrossingDist(m_nTimeFrame,10,30,m_TradeParam.m_dist_10_20);
  
  m_TradeParam.m_ma_cross_10_50=FindMaCrossingDist(m_nTimeFrame,10,50,m_TradeParam.m_dist_10_50);
  m_TradeParam.m_ma_cross_10_100=FindMaCrossingDist(m_nTimeFrame,10,100,d8_20);
  
 
  m_TradeParam.m_ma_cross_14_20=FindMaCrossingDist(m_nTimeFrame,14,20,m_TradeParam.m_d14_20);
  
  m_TradeParam.m_ma_cross_20_30=FindMaCrossingDist(m_nTimeFrame,20,30,d8_20);
  m_TradeParam.m_ma_cross_20_50=FindMaCrossingDist(m_nTimeFrame,20,50,m_TradeParam.m_dist_20_50);
  m_TradeParam.m_ma_cross_20_75=FindMaCrossingDist(m_nTimeFrame,20,75,d8_20);
  m_TradeParam.m_ma_cross_20_100=FindMaCrossingDist(m_nTimeFrame,20,100,m_TradeParam.m_dist_20_100);
  m_TradeParam.m_ma_cross_20_200=FindMaCrossingDist(m_nTimeFrame,20,200,d8_20);

  m_TradeParam.m_ma_cross_30_50=FindMaCrossingDist(m_nTimeFrame,30,50,d8_20);
  m_TradeParam.m_ma_cross_30_75=FindMaCrossingDist(m_nTimeFrame,30,75,d8_20);
  m_TradeParam.m_ma_cross_30_100=FindMaCrossingDist(m_nTimeFrame,30,100,d8_20);
  m_TradeParam.m_ma_cross_30_200=FindMaCrossingDist(m_nTimeFrame,30,200,d8_20);

  
  m_TradeParam.m_ma_cross_50_75=FindMaCrossingDist(m_nTimeFrame,50,75,d8_20);  
  
  m_TradeParam.m_ma_cross_50_100=FindMaCrossingDist(m_nTimeFrame,50,100,m_TradeParam.m_dist_50_100);
  m_TradeParam.m_ma_cross_50_200=FindMaCrossingDist(m_nTimeFrame,50,200,d8_20);

  m_TradeParam.m_ma_cross_75_100=FindMaCrossingDist(m_nTimeFrame,75,100,d8_20);  
  
  m_TradeParam.m_ma_cross_100_150=FindMaCrossingDist(m_nTimeFrame,100,150,d8_20);  
  m_TradeParam.m_ma_cross_100_200=FindMaCrossingDist(m_nTimeFrame,100,200,m_TradeParam.m_dist_100_200);
  m_TradeParam.m_ma_cross_100_300=FindMaCrossingDist(m_nTimeFrame,100,300,d8_20);

  m_TradeParam.m_ma_cross_150_200=FindMaCrossingDist(m_nTimeFrame,150,200,d8_20);
  m_TradeParam.m_ma_cross_150_300=FindMaCrossingDist(m_nTimeFrame,150,300,d8_20);

  m_TradeParam.m_ma_cross_200_300=FindMaCrossingDist(m_nTimeFrame,200,300,d8_20);
  m_TradeParam.m_ma_cross_300_400=FindMaCrossingDist(m_nTimeFrame,300,400,d8_20);
  
  
               
   int    Counter=1;               
   for(int i=0;i<10;i++)
   {
      m_TradeParam.m_dSlope8[i]=GetSlope(PERIOD_M30,8,Counter,Counter+6)*100;
      m_TradeParam.m_dSlope10[i]==GetSlope(PERIOD_M30,10,Counter,Counter+6)*100;
      m_TradeParam.m_dSlope20[i]=GetSlope(PERIOD_M30,20,Counter,Counter+6)*100;
      m_TradeParam.m_dSlope50[i]=GetSlope(PERIOD_M30,50,Counter,Counter+6)*100;
      m_TradeParam.m_dSlope100[i]=GetSlope(PERIOD_M30,100,Counter,Counter+6)*100;
      Counter=Counter+6;
   }
 
      Buffer_Linear[9]=Buffer_Linear[8];
      Buffer_Linear[8]=Buffer_Linear[7];
      Buffer_Linear[7]=Buffer_Linear[6];
      Buffer_Linear[6]=Buffer_Linear[5];
      Buffer_Linear[5]=Buffer_Linear[4];
      Buffer_Linear[4]=Buffer_Linear[3];
      Buffer_Linear[3]=Buffer_Linear[2];
      Buffer_Linear[2]=Buffer_Linear[1];
      Buffer_Linear[1]=Buffer_Linear[0];
      Buffer_Linear[0]=m_TradeParam.m_Current_1_7;
      n_Counter++;
      
      if(n_Counter>50 ) n_Counter=50;

 
      m_TradeParam.m_Close_1=iClose(NULL,PERIOD_M30,1);
      m_TradeParam.m_Open_1=iOpen(NULL,PERIOD_M30,1);

      m_TradeParam.m_Close_2=iClose(NULL,PERIOD_M30,2);
      m_TradeParam.m_Open_2=iOpen(NULL,PERIOD_M30,2);

      m_TradeParam.m_Close_3=iClose(NULL,PERIOD_M30,3);
      m_TradeParam.m_Open_3=iOpen(NULL,PERIOD_M30,3);

      m_TradeParam.m_Close_4=iClose(NULL,PERIOD_M30,4);
      m_TradeParam.m_Open_4=iOpen(NULL,PERIOD_M30,4);

  
}    

void MA_Trend::UpdatePointFactor()
{

      double dPointValue=MarketInfo(Symbol(),MODE_POINT);
      int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
      
      dPointValue=NormalizeDouble(dPointValue,nDigit);

      if(dPointValue==0.01)
         m_PointFactor=1;      
      else if(dPointValue==0.001)
         m_PointFactor=10;
      else if(dPointValue==0.0001)
         m_PointFactor=1;
      else if(dPointValue==0.00001)
         m_PointFactor=10;
      else 
         m_PointFactor=1;

}



int MA_Trend::CheckTrend(int nfast,int nslow, int ntime_frame, int nShift,int nPrice)
{
      if(iMA(NULL, ntime_frame, nfast, 0, MODE_SMA, nPrice, nShift)>iMA(NULL, ntime_frame, nslow, 0, MODE_SMA, nPrice, nShift))
      {
         return TREND_UP;
      }
      else if(iMA(NULL, ntime_frame, nfast, 0, MODE_SMA, nPrice, nShift)<iMA(NULL, ntime_frame, nslow, 0, MODE_SMA, nPrice, nShift))
      {
         return TREND_DOWN;
      } 
      else
      {
         return TREND_SIDEWAY;
      }
}


int MA_Trend::FindMaCrossing(int nTimeInterval,int PeriodFastMA,int PeriodSlowMA)
{
  bool Test=true;
  int i=0;
  int CountFound=-1;
  
  
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,0)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,0))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        double SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          break;        
        }
        
        i++;
        
        if(i>2000)
         break;
     }
  }
  
  if(CountFound>0) CountFound=CountFound+1;
  
  return (CountFound);
   
}

int MA_Trend::FindMaCrossingDist(int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal)
{

  bool Test=true;
  int i=0;
  int CountFound=-1;
  int CountFound1=-1;
  
  double SlowMa_S=0;
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,0)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,0))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }

     Test=true;
     
     CountFound1=CountFound;
     i=0;
     
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }

  }
  
  if(CountFound1>0)
  {
   if(CountFound>CountFound1)
    CountFound=CountFound1;
  }
    
  
  if(CountFound>0) CountFound=CountFound+1;
  
  return (CountFound);

/*
  bool Test=true;
  int i=0;
  int CountFound=-1;
  int CountFound1=-1;
  
  double SlowMa_S=0;
  double SlowMa_S1=0;
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,0)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,0))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i);
        SlowMa_S1=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        else if(FastMa_S1>SlowMa_S1 && FastMa_S2<SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S1 && FastMa_S2>SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }//while
   }
  
  if(CountFound>0) CountFound=CountFound+1;
  
  return (CountFound);
*/   
}

int MA_Trend::FindMaCrossingCustom(int nStartPos,int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal)
{


  bool Test=true;
  int i=nStartPos;
  int CountFound=-1;
  int CountFound1=-1;
  
  double SlowMa_S=0;
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,nStartPos)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,nStartPos))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }

     Test=true;
     
     CountFound1=CountFound;
     i=nStartPos;
     
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }

  }
  
  if(CountFound1>0)
  {
   if(CountFound>CountFound1)
    CountFound=CountFound1;
  }
    
  if(CountFound>0) CountFound=CountFound+1;  
  return (CountFound);

/*
  bool Test=true;
  int i=nStartPos;
  int CountFound=-1;
  int CountFound1=-1;
  
  double SlowMa_S=0;
  double SlowMa_S1=0;
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,nStartPos)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,nStartPos))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        double FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        double FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);

        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i);
        SlowMa_S1=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        else if(FastMa_S1>SlowMa_S1 && FastMa_S2<SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S1 && FastMa_S2>SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         
         break;
        }
     }//while
   }//if
    
  
  if(CountFound>0) CountFound=CountFound+1;
  
  return (CountFound);
  */
  
   
}


int MA_Trend::FindMaCrossingEx(int nStartIndex, int nTimeInterval,int PeriodFastMA,int PeriodSlowMA, double& dVal,double& HighLowDiff,double& dSlope,int& nRunlenght)
{
  bool Test=true;
  int i=nStartIndex;
  int CountFound=-1;
  int index=0;
  double HighVal=0;
  double LowVal=0;
  double FastMa_S1=0;
  double FastMa_S2=0;
  double SlowMa_S=0;
  double SlowMa_S1=0;
  
  
  
  
  if(MathAbs(iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,nStartIndex)-iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,nStartIndex))>(0.5*Point*m_PointFactor))
  {  
     while(Test)
     {
        FastMa_S1=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i);
        FastMa_S2=iMA(NULL,nTimeInterval,PeriodFastMA,0,MODE_SMA,PRICE_CLOSE,i+2);
        SlowMa_S=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i);
        SlowMa_S1=iMA(NULL,nTimeInterval,PeriodSlowMA,0,MODE_SMA,PRICE_CLOSE,i+1);
        
        
        if(FastMa_S1>SlowMa_S && FastMa_S2<SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1>SlowMa_S1 && FastMa_S2<SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;
        }
        else if(FastMa_S1<SlowMa_S && FastMa_S2>SlowMa_S)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        else if(FastMa_S1<SlowMa_S1 && FastMa_S2>SlowMa_S1)
        {
          Test=false;
          CountFound=i;
          dVal=SlowMa_S;
          break;        
        }
        
        
        
        i++;
        
        if(i>2000)
        {
         i=0;
         break;
        }
     }//while
  }//if

   HighLowDiff=0;
   nRunlenght= 0;      
   dSlope=0;

  
  if(CountFound>0) 
  {
      CountFound=CountFound+1;
          
      if(FastMa_S2>SlowMa_S)
      {
           index=iHighest(NULL,PERIOD_M30,MODE_HIGH,5,CountFound);
           HighVal=iHigh(NULL,PERIOD_M30,index);

           index=iLowest(NULL,PERIOD_M30,MODE_LOW,5,nStartIndex);
           LowVal=iLow(NULL,PERIOD_M30,index);
      
      
         HighLowDiff=(HighVal-LowVal)/(Point*m_PointFactor);
         nRunlenght= CountFound- nStartIndex;      
         dSlope=HighLowDiff/nRunlenght;

      }
      else
      {
           index=iHighest(NULL,PERIOD_M30,MODE_HIGH,5,nStartIndex);
           HighVal=iHigh(NULL,PERIOD_M30,index);

           index=iLowest(NULL,PERIOD_M30,MODE_LOW,5,CountFound);
           LowVal=iLow(NULL,PERIOD_M30,index);
      
           HighLowDiff=(HighVal-LowVal)/(Point*m_PointFactor);
           nRunlenght= CountFound- nStartIndex;      
           dSlope=HighLowDiff/nRunlenght;

      } 
  }
  
  
  
  return (CountFound);
   
}

double MA_Trend::GetSlope(int nTimeInterval,int nPeriod,int SlopInit, int SlopEnd)
{
   
   double ma4=iMA(NULL,nTimeInterval,nPeriod,0,MODE_SMA,PRICE_CLOSE,SlopInit);
   double ma5=iMA(NULL,nTimeInterval,nPeriod,0,MODE_SMA,PRICE_CLOSE,SlopEnd);
        
   double Slope=0;
  
      if((SlopInit-SlopEnd)!=0)
      {             
         Slope=((ma4-ma5)/(Point*m_PointFactor))/((Time[SlopInit]-Time[SlopEnd])/60);
      }
      
      return (Slope);
}


//-------------PSAR-------------------

double MA_Trend::GetLinearRegressionSlope(int nTimeFrame,int nStart,int Count,double &nnslope)
{
   // calculate price values
   double slope=0;
   double a,b,c,
          sumy=0.0,
          sumx=0.0,
          sumxy=0.0,
          sumx2=0.0;
    
    double barsStart=nStart;    
    double barsToCount=Count;
    
    nnslope=0.0;
    
   if(Bars>(barsStart+barsToCount))
   {  
   
   for(int i=barsStart; i<(barsStart+barsToCount); i++)
   {
      sumy+=iClose(NULL,nTimeFrame,i);
      sumxy+=iClose(NULL,nTimeFrame,i)*i;
      sumx+=i;
      sumx2+=i*i;
   }
   
   c=sumx2*barsToCount-sumx*sumx;
   
   if(c!=0.0)
   {
      b=(sumxy*barsToCount-sumx*sumy)/c;
      a=(sumy-sumx*b)/barsToCount;
      
      double YStart=a+b*barsStart;
      double YEnd =a+b*barsToCount;
      
      nnslope=(double)(((YStart-YEnd)/(Point*m_PointFactor))/(barsToCount-barsStart));
     //DrawObjects(strName,barsStart,xStart, (xStart+barsToCount),xEnd,Red,2);
        
   }
   }
   else
   {
     nnslope=0.001;
     
   }
   return(nnslope);
}

double MA_Trend::GetRegressionSlope(int nTimeFrame,int nStart,int Count)
{
   // calculate price values
   double slope=0;
   double a,b,c,
          sumy=0.0,
          sumx=0.0,
          sumxy=0.0,
          sumx2=0.0;
    
    double barsStart=nStart;    
    double barsToCount=Count;
    
    double nnslope=0.0;
    
   if(Bars>(barsStart+barsToCount))
   {  
   
      for(int i=barsStart; i<(barsStart+barsToCount); i++)
      {
         sumy+=iClose(NULL,nTimeFrame,i);
         sumxy+=iClose(NULL,nTimeFrame,i)*i;
         sumx+=i;
         sumx2+=i*i;
      }
   
      c=sumx2*barsToCount-sumx*sumx;
   
   if(c!=0.0)
   {
      b=(sumxy*barsToCount-sumx*sumy)/c;
      a=(sumy-sumx*b)/barsToCount;
      
      double YStart=a+b*barsStart;
      double YEnd =a+b*barsToCount;
      
      nnslope=(double)(((YStart-YEnd)/(Point*m_PointFactor))/(barsToCount-barsStart));
     //DrawObjects(strName,barsStart,xStart, (xStart+barsToCount),xEnd,Red,2);
        
   }
   }
   else
   {
     nnslope=0.001;
     
   }
   return(nnslope);
}

int MA_Trend::LinearRegression(int nTimeFrame,int nStart,int Count,string strName,int x,int y)
{
   // calculate price values
   double a,b,c,
          sumy=0.0,
          sumx=0.0,
          sumxy=0.0,
          sumx2=0.0;
    
    int barsStart=nStart;    
    int barsToCount=Count; 
    
    if(Bars> barsStart+barsToCount)
    {
            
            for(int i=barsStart; i<(barsStart+barsToCount); i++)
            {
               sumy+=iClose(NULL,nTimeFrame,i);
               sumxy+=iClose(NULL,nTimeFrame,i)*i;
               sumx+=i;
               sumx2+=i*i;
            }
            
            c=sumx2*barsToCount-sumx*sumx;
            
            if(c!=0.0)
            {
               b=(sumxy*barsToCount-sumx*sumy)/c;
               a=(sumy-sumx*b)/barsToCount;
               
               double xStart=a+b*barsStart;
               double xEnd =a+b*barsToCount;
               double YStart=a+b*barsStart;
               double YEnd =a+b*barsToCount;
               
               double nnslope=(double)(((YStart-YEnd)/(Point*m_PointFactor))/(barsToCount-barsStart));
              
               
              DrawObjects(strName,barsStart,xStart, (barsStart+barsToCount),xEnd,Red,2);
              DrawObjects(strName,barsStart,xStart, (barsStart+barsToCount),xEnd,Red,2);
              string Slope="Slope "+strName+"= "+DoubleToString(nnslope,2);
              
              int MidX=(barsStart+barsToCount/2);
              int MidY=(xEnd+xStart)/2;
              
              string Name2=strName+"WWP";
              
              m_gObj.setLabel(Slope,Name2,x,y,12,Red); 
            }
      }
      

   return(0);
}

void MA_Trend::DrawObjects(string ObjName, int shft_bgn, double Price_Bgn, int shft_end, double Price_End, color clr, int wdth) 
{
   
   ObjectDelete(ObjName);
   ObjectCreate(ObjName, OBJ_TREND, 0, Time[shft_bgn], Price_Bgn, Time[shft_end], Price_End ); 
   ObjectSet(ObjName, OBJPROP_WIDTH, wdth);
   ObjectSet(ObjName,OBJPROP_RAY,false);
   ObjectSet(ObjName,OBJPROP_STYLE,STYLE_SOLID);
   ObjectSet(ObjName,OBJPROP_COLOR,clr);
   
}

int  MA_Trend::CheckTrend_1()
{
                int m_Trade_Period=PERIOD_M30;
                

               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               
               
               if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_30_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_100_2>m_TradeParam.m_MA_100_3 &&
                  m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_50_1&& m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_20_30<16 && dSar1<Close[1] && Close[1]>Open[1])
               {
                   return TREND_UP;
               }
               else if(m_TradeParam.m_MA_30_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_200_1&& m_TradeParam.m_MA_100_2>m_TradeParam.m_MA_100_3 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && dSar1<Close[1] && dSar2<Close[2] && m_TradeParam.m_ma_cross_30_50>70 && Close[1]>Open[1])
               {
                  
                   return TREND_UP;      
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_2()
{

               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               
               if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_30_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1 &&
                  m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_50_1&& m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_20_30<16 && dSar1<Close[1] && dSar1>Close[1])
               {
                  
                   return TREND_DOWN;
               }
               else if(m_TradeParam.m_MA_30_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && dSar1<Close[1] && dSar2<Close[2] && m_TradeParam.m_ma_cross_30_50>70 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1)
               {
                   return TREND_UP;      
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_3()
{
               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_150_1>m_TradeParam.m_MA_100_1 && dSar1>Close[1] && dSar2>Close[2] && dSar3<Close[3] && dSar4<Close[4] &&
                  (m_TradeParam.m_MA_100_1-Ask)<35*Point*10 && MathAbs(m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_20_1)>6*Point*10 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_100_1 && Close[1]<Open[1] && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1)
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_4()
{
                int m_Trade_Period=PERIOD_M30;
                
 
               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(m_TradeParam.m_MA_300_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_200_1 && dSar1<Close[1] && dSar2<Close[2] && dSar3>Close[3] && dSar4>Close[4] && Close[1]>Open[1] &&
                  (Ask-m_TradeParam.m_MA_100_1)<30*Point*10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_50_3 && m_TradeParam.m_ma_cross_100_200<300)
               {
                  if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50<30)
                     return TREND_SIDEWAY;
                  if(m_TradeParam.m_ma_cross_100_200>160 && Ask<m_TradeParam.m_MA_20_1)
                     return TREND_SIDEWAY;   
                  else 
                   return TREND_UP;
               }
               /*
               else if(m_TradeParam.m_MA_300_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_200_1 && dSar1<Close[1] && dSar2<Close[2] && dSar3>Close[3] && dSar4>Close[4] && Close[1]>Open[1] &&
                  (Ask-m_TradeParam.m_MA_100_1)>50*Point*10)
               {
                  
                   return TREND_DOWN;
               }*/
               
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_5()
{
                int m_Trade_Period=PERIOD_M30;
                
                //double Slope1,Slope2,Slope3,Slope20,Slope_20,Slope50,Slope250;
                //GetLinearRegressionSlope(1,6,Slope1);
                //GetLinearRegressionSlope(4,10,Slope2);
                //GetLinearRegressionSlope(10,16,Slope3);
                //GetLinearRegressionSlope(1,20,Slope20);
                //GetLinearRegressionSlope(1,50,Slope50);


               double d20_50,d8_20,d50_100,d50_150,d30_50,d200_300,d20_30;
               

               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(m_TradeParam.m_MA_300_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && 
                  (m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_20_1)>80*Point*10 && (m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_30_1)>80*Point*10 && (m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_8_1)>80*Point*10 &&
                  dSar1>Close[1] && dSar2>Close[2] && dSar3<Close[3] && dSar4<Close[4])
               {
                   return TREND_UP;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_6()
{
                int m_Trade_Period=PERIOD_M30;
                
                //double Slope1,Slope2,Slope3,Slope20,Slope_20,Slope50,Slope250;
                //GetLinearRegressionSlope(1,6,Slope1);
                //GetLinearRegressionSlope(4,10,Slope2);
                //GetLinearRegressionSlope(10,16,Slope3);
                //GetLinearRegressionSlope(1,20,Slope20);
                //GetLinearRegressionSlope(1,50,Slope50);



               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_150_1>m_TradeParam.m_MA_100_1 && 
                  (m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_100_1)>80*Point*10 && (m_TradeParam.m_MA_30_1-m_TradeParam.m_MA_100_1)>80*Point*10 && (m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_100_1)>80*Point*10 &&
                  dSar1<Close[1] && dSar2<Close[2] && dSar3>Close[3] && dSar4>Close[4])
               {
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_7()
{
                int m_Trade_Period=PERIOD_M30;
                
                //double Slope1,Slope2,Slope3,Slope20,Slope_20,Slope50,Slope250;
                //GetLinearRegressionSlope(1,6,Slope1);
                //GetLinearRegressionSlope(4,10,Slope2);
                //GetLinearRegressionSlope(10,16,Slope3);
                //GetLinearRegressionSlope(1,20,Slope20);
                //GetLinearRegressionSlope(1,50,Slope50);


               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(MathAbs(m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_400_1)<10*Point*10 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_30_1 &&
                 m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_100_1) 
               {
                  if(m_TradeParam.m_ma_cross_8_20<15 && (m_TradeParam.m_MA_100_1-Ask)<35*Point*10 && Ask<m_TradeParam.m_MA_8_1)
                   return TREND_DOWN;
               }
               
               
    
    
    return (TREND_SIDEWAY);
}
int  MA_Trend::CheckTrend_8()
{
                int m_Trade_Period=PERIOD_M30;
                
                //double Slope1,Slope2,Slope3,Slope20,Slope_20,Slope50,Slope250;
                //GetLinearRegressionSlope(1,6,Slope1);
                //GetLinearRegressionSlope(4,10,Slope2);
                //GetLinearRegressionSlope(10,16,Slope3);
                //GetLinearRegressionSlope(1,20,Slope20);
                //GetLinearRegressionSlope(1,50,Slope50);

               double dSar=iSAR(NULL,0,0.02,0.2,0);
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);
               
               
               if(m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_30_50>40 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_300_1 &&    
                 m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_30_1 && dSar1>Close[1] &&
                 m_TradeParam.m_ma_cross_50_100>100) 
               {
                  if(m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_ma_cross_50_100<80 && Close[1]>Open[1])
                  {
                    if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_8_1 && MathAbs(m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_20_1)>5*Point*10 && MathAbs(m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_30_1)>5*Point*10)
                     return TREND_DOWN;
                  }                  
               }
               
               
    
    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_9()
{

               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_400_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_100_1 &&     
                 m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 &&m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>50 && dSar1<Close[1]) 
               {
                  
                   return TREND_UP;
               }
               else if(m_TradeParam.m_MA_400_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1 &&   
                 m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_50_1 &&m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_100_200>50 && dSar1<Close[1])
                 {
                   return TREND_UP;
                 }
               
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_10()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               
               if(m_TradeParam.m_MA_400_1<m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_300_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 &&
                  ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_400_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_150_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_150_1-m_TradeParam.m_MA_100_1)>30*Point*10) &&     
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_300_1 && 
                    dSar1>Close[1]) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_11()
{
               
               
               if(m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>50*Point*10) &&
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_100_1)>50*Point*10) &&
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_300_1) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_12()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && 
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_100_1)>30*Point*10) &&
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_200_1) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_13()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_50_1 && 
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_100_1)>30*Point*10) &&
                    m_TradeParam.m_ma_cross_50_100<30 &&
                    (m_TradeParam.m_MA_100_1-Ask)<20*Point*10 &&
                    dSar1>Close[1]) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_14()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_300_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                    m_TradeParam.m_ma_cross_50_100<30 &&
                    (Ask-m_TradeParam.m_MA_100_1)<20*Point*10 &&
                    dSar1<Close[1]) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_15()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_300_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                    Open[1]>Close[1] &&
                    Open[1]>m_TradeParam.m_MA_20_1 && Close[1]<m_TradeParam.m_MA_20_1 &&
                    Open[1]>m_TradeParam.m_MA_30_1 && Close[1]<m_TradeParam.m_MA_30_1 &&
                    Open[1]>m_TradeParam.m_MA_100_1 && Close[1]<m_TradeParam.m_MA_100_1 &&
                    Open[1]>m_TradeParam.m_MA_50_1 && Close[1]<m_TradeParam.m_MA_50_1) 
               {
                  
                   return TREND_DOWN;
               }
               
    
    
    return (TREND_SIDEWAY);
}
int  MA_Trend::CheckTrend_16()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && 
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_100_1)>30*Point*10) &&
                    Open[1]<Close[1] &&
                    Open[1]<m_TradeParam.m_MA_20_1 && Close[1]>m_TradeParam.m_MA_20_1 &&
                    Open[1]<m_TradeParam.m_MA_30_1 && Close[1]>m_TradeParam.m_MA_30_1 &&
                    Open[1]<m_TradeParam.m_MA_100_1 && Close[1]>m_TradeParam.m_MA_100_1 &&
                    Open[1]<m_TradeParam.m_MA_50_1 && Close[1]>m_TradeParam.m_MA_50_1) 
               {
                  
                   return TREND_UP;
               }
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_17()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               
               
            if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_100_200>70 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_30_50>30 &&
              m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_8_1 && Close[2]<Open[2] && Close[1]<Open[1] && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_50_3 &&
              CheckTrend(100,150,PERIOD_M5,1,PRICE_CLOSE)==TREND_DOWN)
            {
                 if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && Ask>m_TradeParam.m_MA_200_1 && Ask<m_TradeParam.m_MA_100_1)
                   return TREND_SIDEWAY;
                 else 
                  return TREND_DOWN;
            }
    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_18()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);

               
               if(m_TradeParam.m_MA_300_1<m_TradeParam.m_MA_400_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_300_1 && 
                   ((m_TradeParam.m_MA_400_1-m_TradeParam.m_MA_300_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_200_1)>30*Point*10) &&
                    m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && 
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && dSar1>Close[1] && 
                    dSar2>Close[2] && dSar3>Close[3] &&
                    dSar2>m_TradeParam.m_MA_150_1) 
               {
                  
                   return TREND_DOWN;
               }
               
               
    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_19()
{
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);

               
               if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1  && 
                   ((m_TradeParam.m_MA_200_1-m_TradeParam.m_MA_100_1)>30*Point*10) &&
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)>30*Point*10) && 
                    m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 &&  
                    dSar2<Close[2] && dSar3<Close[3] &&
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_20_1) 
                  {
                  
                   return TREND_UP;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_20()
{
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               double dSar3=iSAR(NULL,0,0.02,0.2,3);

               
               if( m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100<100 &&
                   m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_125_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1  && 
                   ((m_TradeParam.m_MA_125_1-m_TradeParam.m_MA_100_1)>10*Point*10) &&
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)>15*Point*10) && 
                    m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_14_1 && m_TradeParam.m_MA_14_1>m_TradeParam.m_MA_20_1 &&  
                    dSar2<Close[2] && dSar3<Close[3] &&
                    m_TradeParam.m_MA_20_3<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_5<m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_125_1 &&
                    m_TradeParam.m_MA_125_1<m_TradeParam.m_MA_150_1 &&
                    m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_200_1 && 
                    m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1) 
                  {
                  
                  
                   return TREND_DOWN;
                  }
                  else if( m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100<100 &&
                   m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_125_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1  && 
                   ((m_TradeParam.m_MA_125_1-m_TradeParam.m_MA_100_1)>10*Point*10) &&
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)>15*Point*10) && 
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_14_1 && m_TradeParam.m_MA_14_1<m_TradeParam.m_MA_20_1 &&  
                    dSar2>Close[2] && dSar3>Close[3] &&
                    m_TradeParam.m_MA_20_3>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_5>m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_125_1 &&
                    m_TradeParam.m_MA_125_1>m_TradeParam.m_MA_150_1 &&
                    m_TradeParam.m_MA_150_1>m_TradeParam.m_MA_200_1 && 
                    m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1)
                    {
                       return TREND_UP;
                    }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_21()
{

               
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                     m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<60)
               {
                           m_TradeComment="Trade 3000U";
                           return TREND_SIDEWAY;
               
               }               
               else if( 
                   m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_125_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1  &&
                   m_TradeParam.m_MA_150_1>m_TradeParam.m_MA_200_1 && 
                   ((m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_125_1)>10*Point*10) &&
                   ((m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_100_1)>15*Point*10) &&   
                    m_TradeParam.m_MA_20_7<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_7<m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_ma_cross_20_50<50 &&
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.GetAbsOpenDiffClose(PERIOD_M30,1)>4*Point*m_PointFactor) 
                  {
                  
                      
                      if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_20_50>=2 && m_TradeParam.m_ma_cross_20_50<90 &&
                         m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && 
                         m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>5 && m_TradeParam.m_ma_cross_50_100<120)
                      {
                        m_TradeComment="Trade 3000U1";
                        return TREND_UP;
                      
                      }
                      else
                      {
                       if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_10_20>=1 && m_TradeParam.m_ma_cross_10_20<11 )
                       {
                       
                       }
                       else
                       {

                           if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>=5 && m_TradeParam.m_ma_cross_50_100<80 &&
                              m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1)
                             {
                                    m_TradeComment="Trade 3000U2";
                                    return TREND_UP;
                             
                             }
                             else
                             {
                         
                         
                               m_TradeComment="Trade 3000D ";//+m_TradeParam.m_ma_cross_20_50+" "+m_TradeParam.m_ma_cross_50_100;
                                return TREND_DOWN;
                             }
                       }
                      }
                  }
               
               
    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_22()
{

               
               if( 
                   m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_14_1 && 
                   m_TradeParam.m_ma_cross_14_20>20 &&
                   m_TradeParam.m_ma_cross_20_30>30 &&
                   ((Ask-m_TradeParam.m_d14_20)>20*Point*10) &&
                    (MathAbs(m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_14_1)<6*Point*10) &&
                    m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_14_1 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 &&
                    (m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_8_1)>2*Point*10) 
                  {
                     double LG=0;
                     double Body=MathAbs(iOpen(NULL,PERIOD_M30,1)-iClose(NULL,PERIOD_M30,1));
                     
                     if(iOpen(NULL,PERIOD_M30,1)>iClose(NULL,PERIOD_M30,1))
                       LG=iClose(NULL,PERIOD_M30,1)-iLow(NULL,PERIOD_M30,1);
                     else 
                       LG=iOpen(NULL,PERIOD_M30,1)-iLow(NULL,PERIOD_M30,1);
                     
                   if(LG>2.5*Body)
                      return TREND_SIDEWAY;
                   else 
                   {
                     return TREND_DOWN;
                   }
                  }
               
               
    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_23()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar4=iSAR(NULL,0,0.02,0.2,4);

               
               if( 
                   m_TradeParam.m_MA_10_14>m_TradeParam.m_MA_14_14 &&
                   m_TradeParam.m_MA_14_14>m_TradeParam.m_MA_20_14 &&
                   m_TradeParam.m_MA_20_14>m_TradeParam.m_MA_30_14 &&
                   m_TradeParam.m_MA_30_14>m_TradeParam.m_MA_50_14 &&
                   m_TradeParam.m_MA_50_14>m_TradeParam.m_MA_100_14&&
                   m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_14_1 &&
                   m_TradeParam.m_MA_14_1<m_TradeParam.m_MA_20_1 &&
                   dSar1>Close[1] &&
                   dSar4>Close[4] &&
                   (m_TradeParam.m_MA_10_14-m_TradeParam.m_MA_20_14)>10*Point*10 &&
                   (m_TradeParam.m_MA_20_14-m_TradeParam.m_MA_50_14)>20*Point*10 ) 
                  {
                    if(Ask>Close[1])
                      return TREND_SIDEWAY;
                    else if(Close[2]<Open[2] && Close[1]<Open[1] && Close[3]<Open[3])
                    return TREND_SIDEWAY;
                    else 
                    {
                     
                     if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                        m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 &&
                        m_TradeParam.m_ma_cross_20_200>4 && m_TradeParam.m_ma_cross_20_200<70)
                     {
                     
                        m_TradeComment="DN 2";
                        return TREND_UP;
                     }
                     else
                     {
                      if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                         m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && 
                         m_TradeParam.m_ma_cross_50_100>2 && m_TradeParam.m_ma_cross_50_100<50)
                      {
                        m_TradeComment="DN 3";
                        return TREND_UP;
                         
                      }
                      else
                      {
                       m_TradeComment="DN 1";
                       return TREND_DOWN;
                      }
                     }
                    }
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_24()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);

               
               if( 
                   m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                   m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_300_1 &&
                   m_TradeParam.m_MA_50_20<m_TradeParam.m_MA_100_20 &&
                   m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                   m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 &&
                   m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && 
                   dSar1<Close[1] &&
                   dSar2<Close[2])
                  {
                   return TREND_UP;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_25()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);

               
               if( 
                   MathAbs(m_TradeParam.m_MA_20_20-m_TradeParam.m_MA_10_20)<2*Point*10 &&
                   MathAbs(m_TradeParam.m_MA_20_20-m_TradeParam.m_MA_8_20)<2*Point*10 &&
                   (m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_14_1)>3*Point*10 &&
                   (m_TradeParam.m_MA_14_1-m_TradeParam.m_MA_20_1)>2*Point*10 &&
                   m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                   m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                   m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_10_1 &&
                   m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_14_1 &&
                   m_TradeParam.m_MA_14_1>m_TradeParam.m_MA_20_1 &&
                   m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1&&
                   m_TradeParam.m_ma_cross_20_30<50 &&
                   m_TradeParam.m_ma_cross_20_50<50 &&                   
                   dSar1<Close[1] &&
                   dSar2<Close[2] &&
                   Close[1]>Open[1] &&
                   MathAbs(Ask-m_TradeParam.m_MA_50_1)<50*Point*10)
                  {
                    if(m_TradeParam.m_MA_400_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1 && MathAbs(m_TradeParam.m_MA_300_1-m_TradeParam.m_MA_400_1)<2*Point*10)
                    {
                     return TREND_SIDEWAY;                       
                    }
                    else 
                     return TREND_UP;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_26()
{
                int m_Trade_Period=PERIOD_M30;

               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
               double SCI_Main_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,2);
               double SCI_Signal_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,2);
               double SCI_Main_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,3);
               double SCI_Signa_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,3);

              double CC_3     =iCCI(Symbol(),PERIOD_M30,14,PRICE_TYPICAL,3);
              
               
               if( 
                   m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 &&
                   CC_3<-100 &&
                   SCI_Main_3<SCI_Signa_3 &&
                   SCI_Main>SCI_Signal &&
                   SCI_Main_2<60 && 
                   m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_200_5 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_10_1)
                  {
                   return TREND_UP;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_26_1()
{
                int m_Trade_Period=PERIOD_M30;

               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
               double SCI_Main_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,2);
               double SCI_Signal_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,2);
               double SCI_Main_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,3);
               double SCI_Signa_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,3);

              double CC_3     =iCCI(Symbol(),PERIOD_M30,14,PRICE_TYPICAL,3);
              

               
               if( 
                   m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 &&
                   CC_3<-100 &&
                   SCI_Main_3<SCI_Signa_3 &&
                   SCI_Main>SCI_Signal &&
                   SCI_Main_2<60 && 
                   m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_200_5 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 )
                  {
                   return TREND_DOWN;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_27()
{
                int m_Trade_Period=PERIOD_M30;

               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
               double SCI_Main_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,2);
               double SCI_Signal_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,2);
               double SCI_Main_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,3);
               double SCI_Signa_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,3);

              double CC_3     =iCCI(Symbol(),PERIOD_M30,14,PRICE_TYPICAL,3);
              
               
               if( 
                   CC_3>100 &&
                   SCI_Main_3>SCI_Signa_3 &&
                   SCI_Main<SCI_Signal &&
                   SCI_Main_2>40 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1)
                  {
                    if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100<20)
                      return TREND_SIDEWAY;
                    else 
                   return TREND_DOWN;
                  }
               
               
    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_28()
{
              double CC_1     =iCCI(Symbol(),PERIOD_M30,14,PRICE_TYPICAL,1);
              double CC_3     =iCCI(Symbol(),PERIOD_M30,14,PRICE_TYPICAL,3);
              


               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               
               if( CC_3>120 && CC_1<CC_3 && m_TradeParam.m_ma_cross_200_300<400 &&
                    m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && dSar1>Close[1] && dSar2>Close[2] && 
                    m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_20_50<25)
                   {
                       if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1)
                          return TREND_SIDEWAY;
                       else if( m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>140 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1)
                          return TREND_SIDEWAY;   
    
                       return (TREND_DOWN);
                    }
                    
                    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_29()
{
               double dSar1=iSAR(NULL,0,0.02,0.2,1);
               double dSar2=iSAR(NULL,0,0.02,0.2,2);
               
               if( m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_50_2 &&m_TradeParam.m_MA_50_2<m_TradeParam.m_MA_50_3  && m_TradeParam.m_ma_cross_20_30<50 && dSar1<Close[1] && dSar2<Close[2] &&
                   m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_10_5 && MathAbs(m_TradeParam.m_MA_50_1-Ask)<50*Point*10 && Close[1]<Open[1] && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1)
                   {
                   
                       if(m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && (m_TradeParam.m_MA_100_1-Ask)>35*Point*10)
                         return TREND_SIDEWAY;
                       else if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_8_1)
                         return TREND_SIDEWAY;
    
                       return (TREND_DOWN);
                   }
                    
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_31()
{
                int m_Trade_Period=PERIOD_M30;
                

               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
               double SCI_Main_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,2);
               double SCI_Signal_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,2);
               double SCI_Main_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,3);
               double SCI_Signa_3=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,3);

               
               if(SCI_Main_3>SCI_Signa_3 && SCI_Main_3>70 && 
                  SCI_Main_2<SCI_Signal_2 && SCI_Main_1<SCI_Signal_1 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_10_1 &&
                  m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                  m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                  m_TradeParam.m_MA_50_2<m_TradeParam.m_MA_100_2)
                 {
                   
                       return (TREND_DOWN);
                 }
                    
                    
                    
    return (TREND_SIDEWAY);
}
  
  
int  MA_Trend::CheckTrend_32()
{
                int m_Trade_Period=PERIOD_M30;
                

               double SCI_Main0=iStochastic(NULL,m_Trade_Period,5,3,3,MODE_SMA,0,MODE_MAIN,0);
               
               if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && (MathAbs(m_TradeParam.m_MA_20_7-m_TradeParam.m_MA_8_7)<3*Point*10) &&
                  m_TradeParam.m_ma_cross_20_50<20 &&
                  m_TradeParam.m_MA_8_20<20 && SCI_Main0<70 && Close[1]>Open[1] && m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_8_1 && m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_10_1 &&
                  MathAbs(m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_10_1)>1*Point*10 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1)
                 {
                   
                       return (TREND_UP);
                 }
                    
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_33()
{
                int m_Trade_Period=PERIOD_M30;

               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
               double SCI_Main_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,2);
               double SCI_Signal_2=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,2);
               
               if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && (MathAbs(m_TradeParam.m_MA_20_7-m_TradeParam.m_MA_8_7)<2*Point*10) &&
                  (MathAbs(m_TradeParam.m_MA_20_7-m_TradeParam.m_MA_50_7)<2*Point*10) &&
                  m_TradeParam.m_ma_cross_20_50<20 &&
                  m_TradeParam.m_MA_8_20<20 && SCI_Main_1>60 && SCI_Main_1<SCI_Signal_1)
                 {
                   
                       return (TREND_DOWN);
                 }
                    
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_34()
{
                int m_Trade_Period=PERIOD_M30;
               
               if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                  m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_200_2 &&
                  m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                  m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_8_2>m_TradeParam.m_MA_50_2 &&
                  m_TradeParam.m_ma_cross_50_100<100 && Close[1]<Open[1] &&
                  MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_20_3)>2*Point*10)
                 {
                  int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,8,1);
                  double val=iHigh(NULL,PERIOD_M30,index);
                  
                  if((val-Ask)>80*Point*m_PointFactor)
                    return TREND_SIDEWAY;
                 else
                 {
                   
                       return (TREND_DOWN);
                 }
                 }
                    
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_35()
{
              

               
               if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_100_2 &&
                  m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                  m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                  m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
                  m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_8_2>m_TradeParam.m_MA_20_2 &&
                  MathAbs(m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)>MathAbs(m_TradeParam.m_MA_100_7-m_TradeParam.m_MA_50_7)&&
                  Close[1]<Open[1])
                 {
                   
                       return (TREND_DOWN);
                 }
                 else if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_100_2 &&
                  m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                  m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                  m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_8_2>m_TradeParam.m_MA_50_2 &&
                  MathAbs(m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)>MathAbs(m_TradeParam.m_MA_100_7-m_TradeParam.m_MA_50_7) &&
                  Close[1]<Open[1])
                  {
                       return (TREND_DOWN);                  
                  }
                    
                    
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_36()
{
               
               if((m_TradeParam.m_MA_8_3-m_TradeParam.m_MA_100_3)>90*Point*10 &&
                   (m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_50_1)>50*Point*10 &&
                   m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_8_2 &&
                   (m_TradeParam.m_MA_8_3-m_TradeParam.m_MA_20_3)>55*Point*10 &&
                   (m_TradeParam.m_MA_8_3-m_TradeParam.m_MA_20_3)>(m_TradeParam.m_MA_8_1-m_TradeParam.m_MA_20_1) &&
                   (Close[1]-Open[1])>4*Point*10)                  
                 {
                       return (TREND_DOWN);
                 }
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_38()
{
                 
                 if(m_TradeParam.m_dSlope8[0]<-6 && m_TradeParam.m_dSlope8[1]>34 && m_TradeParam.m_dSlope8[4]<0)
                 {
                      if(m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_400_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1)
                       return TREND_SIDEWAY;
                      else  
                       return (TREND_DOWN);
                 }
                 
                 else if(m_TradeParam.m_dSlope8[0]<-6 && m_TradeParam.m_dSlope8[1]<3 && m_TradeParam.m_dSlope8[2]>20 && m_TradeParam.m_dSlope8[3]>15 && m_TradeParam.m_dSlope8[4]<10)
                 {
                      if(m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_400_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1)
                       return TREND_SIDEWAY;
                      else 
                       return (TREND_DOWN);
                 }
                 
                 
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_39()
{
               
                 if(m_TradeParam.m_dSlope8[0]>5 && m_TradeParam.m_dSlope8[1]<-5 && m_TradeParam.m_dSlope8[2]<-5 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_100_14 &&
                    (Ask-m_TradeParam.m_MA_100_1)<60*Point*m_PointFactor && (m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_200_1)<60*Point*m_PointFactor)
                 {
                     if(MathAbs(Close[2]-Open[2])<4*Point*m_PointFactor && Close[1]>Open[1])
                        return (TREND_SIDEWAY);
                        
                      return (TREND_UP);
                 }
 
/*
                 if(dSlope8[0]<-5 && dSlope8[1]>5 &&dSlope8[2]>5 && (m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_200_1)<60*Point*m_PointFactor)
                 {                        
                      return (TREND_DOWN);
                 }
  */               
                    
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_40()
{
               
                 if(m_TradeParam.m_dSlope20[0]<6 && m_TradeParam.m_dSlope20[0]>0 &&
                    m_TradeParam.m_dSlope20[1]<6 && m_TradeParam.m_dSlope20[1]>0 &&
                    m_TradeParam.m_dSlope20[2]<6 && m_TradeParam.m_dSlope20[2]>0 &&
                    m_TradeParam.m_dSlope20[3]<6 && m_TradeParam.m_dSlope20[3]>0 &&
                    m_TradeParam.m_dSlope50[1]<6 && m_TradeParam.m_dSlope50[1]>0 &&
                    m_TradeParam.m_dSlope100[1]<6 && m_TradeParam.m_dSlope100[1]>0)
                 {
                     if(m_TradeParam.m_dSlope8[0]>m_TradeParam.m_dSlope8[1] && m_TradeParam.m_dSlope8[0]>0)   
                      return (TREND_UP);
                 }
                 else if(m_TradeParam.m_dSlope20[0]<0 && m_TradeParam.m_dSlope20[0]>-6 &&
                    m_TradeParam.m_dSlope20[1]<0 && m_TradeParam.m_dSlope20[1]>-8 &&
                    m_TradeParam.m_dSlope20[2]<0 && m_TradeParam.m_dSlope20[2]>-8 &&
                    m_TradeParam.m_dSlope50[2]<0 && m_TradeParam.m_dSlope50[2]>-8 &&
                    m_TradeParam.m_dSlope50[0]<0 && m_TradeParam.m_dSlope50[0]>-8 &&
                    m_TradeParam.m_dSlope100[0]<0 && m_TradeParam.m_dSlope100[0]>-6)
                 {
                     if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1)
                       return TREND_SIDEWAY;
                      
                     if(m_TradeParam.m_dSlope8[0]<m_TradeParam.m_dSlope8[1] && m_TradeParam.m_dSlope8[0]<0 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1)   
                      return (TREND_DOWN);
                      
                 }
                     
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_41()
{               
               
              if(m_TradeParam.m_ma_cross_20_50>65 && MathAbs(m_TradeParam.m_MA_10_1-m_TradeParam.m_MA_20_1)<3*Point*m_PointFactor)
              {
                  return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_Current_7_20>-0.8 && m_TradeParam.m_Current_7_20<0.8)
              {
                 return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_8_20<10)
              {
                 return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1)
              {
                 return TREND_SIDEWAY;
              }
              else if(MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_10_1)<4*Point*m_PointFactor)
                 return TREND_SIDEWAY;

              else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.7 && m_TradeParam.m_Current_7_50<-0.5  && m_TradeParam.m_Current_7_20>-2 &&
                 Buffer_Linear[2]>0 && m_TradeParam.m_Current_1_7<-0.8)
               {
                  if(iClose(NULL,PERIOD_M30,1)>iOpen(NULL,PERIOD_M30,1))
                    return TREND_SIDEWAY;
                  else 
                  {
                   if(m_TradeParam.m_Current_7_150<-0.5 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1)
                    return TREND_SIDEWAY;
                   else
                   {
                     m_TradeComment="Trade 201";
                    return TREND_DOWN;
                    }
                  }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.7 && m_TradeParam.m_Current_7_50<-0.4 &&
                 Buffer_Linear[3]>2 && Buffer_Linear[2]>2 && m_TradeParam.m_Current_1_7<-0.3)
               {
                   
                    m_TradeComment="Trade 202";
                    return TREND_DOWN;
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.7 && m_TradeParam.m_Current_7_50<-0.4 &&
                 Buffer_Linear[3]>2 && m_TradeParam.m_Current_1_7<-0.3)
               {
                    
                    if(m_TradeParam.m_ma_cross_20_50>70 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
                        m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && 
                       m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_400_1)
                    {
                    
                    } 
                    else
                    {
                    
                     if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_50_100>90 &&
                        m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1)
                     {
                       if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && 
                          m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_200_1 &&
                          m_TradeParam.m_ma_cross_150_200<90 && m_TradeParam.m_ma_cross_150_200>3)
                       {
                       
                       }
                       else
                       { 
                        m_TradeComment="Trade 205";
                        return TREND_UP;
                       }
                     }
                     else
                     {
                      m_TradeComment="Trade 203 "+m_TradeParam.m_ma_cross_50_100;
                      return TREND_DOWN;
                     }
                    }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.7 && m_TradeParam.m_Current_7_50>1 &&
                 m_TradeParam.m_Current_1_7<-1 && m_TradeParam.m_Current_7_20<4 && m_TradeParam.m_Current_7_20>-4 && m_TradeParam.m_Current_5_10<-0.5)
               {
                   if(MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_50_1)<3.5*Point*m_PointFactor && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1)
                     return TREND_SIDEWAY;
                   else
                   {
                    if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_100_1 &&
                       m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<40)
                    {
                    
                       if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_20_1 &&
                          m_TradeParam.m_ma_cross_3_10>2 && m_TradeParam.m_ma_cross_3_10<15 && 
                          m_TradeParam.m_dist_10_20>m_TradeParam.m_MA_50_1 && m_TradeParam.m_dist_3_10>m_TradeParam.m_MA_50_1) 
                       {
                        
                        m_TradeComment="Trade 206D";
                        return TREND_DOWN;
                       
                       }
                       else
                       {
                        m_TradeComment="Trade 206";
                        return TREND_UP;
                       }
                    
                    }
                    else
                    {
                     m_TradeComment="Trade 204";
                     return TREND_DOWN;
                    }
                   }
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_42()
{
              if((Ask-m_TradeParam.m_MA_20_1)>25*Point*m_PointFactor)
              {
                 return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_8_20<10)
              {
                 return TREND_SIDEWAY;
              }    
                        
              else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1 && m_TradeParam.m_Current_7_50>0.5  && m_TradeParam.m_Current_7_50<2 &&
                 Buffer_Linear[2]<0 && m_TradeParam.m_Current_1_7>0.5)
               {
                   
                   if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_20_50>3 &&
                      m_TradeParam.m_ma_cross_20_50<30 && m_TradeParam.m_ma_cross_10_20>10)
                      {
                       m_TradeComment="Trade 201D";
                       return TREND_DOWN;
                      
                      }
                      else
                      {
                       m_TradeComment="Trade 200U";
                       return TREND_UP;
                     }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1 && m_TradeParam.m_Current_7_50>0.4 &&
                 Buffer_Linear[2]<0 && m_TradeParam.m_Current_1_7>0.3)
               {
                  if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>40)
                     return TREND_SIDEWAY;
                  else
                  {
                   
                   if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && 
                      m_TradeParam.m_ma_cross_20_50>1 && m_TradeParam.m_ma_cross_20_50<30 &&
                      m_TradeParam.m_ma_cross_10_50>1 && m_TradeParam.m_ma_cross_10_20<30 && m_TradeParam.m_ma_cross_10_20>5 )
                      {
                         
                         if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_150_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_150_1)
                            return TREND_SIDEWAY;
                         else
                         {
                      
                          if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_75_1 && m_TradeParam.m_ma_cross_50_75>0 && m_TradeParam.m_ma_cross_50_75<10)
                          {
                           m_TradeComment="Trade 202E";
                           return TREND_UP;
                          
                          }
                          else
                          {
                           m_TradeComment="Trade 202D";
                           return TREND_DOWN;
                          }
                         }
                      
                      }
                      else
                      {
                          m_TradeComment="Trade 201U";
                          return TREND_UP;
                      
                      }                   
                 }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1 && m_TradeParam.m_Current_7_50>0.4 &&
                 Buffer_Linear[3]<0 && m_TradeParam.m_Current_1_7>0.3 && m_TradeParam.m_ma_cross_50_100<50)
               {
                  if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>40)
                     return TREND_SIDEWAY;
                  else
                  {
                   m_TradeComment="Trade 202U";
                    return TREND_UP;
                  }
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_43()
{
              
              
              if((Ask-m_TradeParam.m_MA_20_1)>25*Point*m_PointFactor)
              {
                 return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_8_20<10)
              {
                 return TREND_SIDEWAY;
              }    
                        
              else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1 && m_TradeParam.m_Current_7_50>0.5  && m_TradeParam.m_Current_7_50>4 &&
                 m_TradeParam.m_Current_7_20>1.8 && m_TradeParam.m_Current_7_20<4 && m_TradeParam.m_Current_1_7<-4)
               {
                   
                    return TREND_DOWN;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_44()
{
                int m_Trade_Period=PERIOD_M30;
                
               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               double SCI_Main_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,1);
               double SCI_Signal_1=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,1);
                             
              
              if((Ask-m_TradeParam.m_MA_20_1)>25*Point*m_PointFactor)
              {
                 return TREND_SIDEWAY;
              }
              else if(m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_8_20<10)
              {
                 return TREND_SIDEWAY;
              }    
                        
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.8 && m_TradeParam.m_Current_7_50<-0.8  && m_TradeParam.m_Current_7_20>1 &&  m_TradeParam.m_Current_1_7<-2 && SCI_Main<SCI_Signal)
               {
                   
                    return TREND_DOWN;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_45()
{
                int m_Trade_Period=PERIOD_M30;
                
               
              
              
              if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.7 && m_TradeParam.m_Current_7_50>0.3 &&
                 m_TradeParam.m_Current_7_20<-0.5 && m_TradeParam.m_Current_7_20<-3)
               {
                   
                    return TREND_DOWN;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}


int  MA_Trend::CheckTrend_46()
{
              
              if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.3 && m_TradeParam.m_Current_7_50<-0.4 &&
                 m_TradeParam.m_Current_7_20<0.2 && m_TradeParam.m_Current_7_20>3)
               {
                   
                    return TREND_UP;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_47()
{
              
              if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>0.2 && m_TradeParam.m_Current_7_150<0.4 && m_TradeParam.m_Current_7_20>1.5 && m_TradeParam.m_Current_7_20<5 && m_TradeParam.m_Current_1_7<-2)
               {
                   if(m_TradeParam.m_ma_cross_100_200<20 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1)
                     return TREND_SIDEWAY;
                   else if(Close[1]<Open[1] && Close[0]>Open[0])
                      return TREND_SIDEWAY;  
                   else if(Close[2]<Open[2] && Close[1]>Open[1])
                      return TREND_SIDEWAY;  
                   else if(Close[3]<Open[3] && Close[2]>Open[2])
                      return TREND_SIDEWAY;  
                   else if(MathAbs(Close[1]-Open[1])<2*Point*m_PointFactor &&
                           MathAbs(Close[2]-Open[2])<2*Point*m_PointFactor)
                      return TREND_SIDEWAY;  
                   else if(MathAbs(Close[2]-Open[2])<2*Point*m_PointFactor &&
                           MathAbs(Close[3]-Open[3])<2*Point*m_PointFactor)
                      return TREND_SIDEWAY;  
                   else if(MathAbs(Close[3]-Open[3])<2*Point*m_PointFactor &&
                           MathAbs(Close[4]-Open[4])<2*Point*m_PointFactor)
                      return TREND_SIDEWAY;  
                  else
                  {
                       int m_nTimeFrame=PERIOD_CURRENT;
                       
                       double MA_10=iMA(NULL, m_nTimeFrame, 10, 0, MODE_SMA, PRICE_CLOSE, 3);
                       double MA_20=iMA(NULL, m_nTimeFrame, 20, 0, MODE_SMA, PRICE_CLOSE, 3);
                       double MA_50=iMA(NULL, m_nTimeFrame, 50, 0, MODE_SMA, PRICE_CLOSE, 3);
                       double d8_20=0;
                       double m_ma_cross_20_50=FindMaCrossingDist(m_nTimeFrame,20,50,d8_20);
                       
                       if(MA_20>MA_50 && m_ma_cross_20_50>2 && m_ma_cross_20_50<35)
                         return TREND_SIDEWAY;
                       else 
                       {
                        m_TradeComment="Trade DN 1";
                        return TREND_DOWN;
                        }
                   }
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_48()
{
              
              if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>0.2 && m_TradeParam.m_Current_7_150<0.7 && m_TradeParam.m_Current_7_20>6 && m_TradeParam.m_Current_1_7<1 && Close[1]>Open[1])
               {
                   
                    return TREND_UP;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}
  
  
int  MA_Trend::CheckTrend_49()
{
              
              /* working
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150<-0.7  && m_TradeParam.m_Current_7_20>3 &&  m_TradeParam.m_Current_1_7<-5)
               {
                    return TREND_DOWN;
               }
               */

               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_20<-2 &&  m_TradeParam.m_Current_1_7>9)
               {
                    return TREND_UP;
               }
                      
                    
                     
    return (TREND_SIDEWAY);
}

int  MA_Trend::CheckTrend_50()
{
                //double dSlope20_1=GetSlope(PERIOD_M30,20,6,12)*100;               
               //double dSlope50=GetSlope(PERIOD_M30,50,1,6)*100;
               //double dSlope100=GetSlope(PERIOD_M30,100,1,6)*100;
               //string strComment=" Comment 8="+dSlope8+","+dSlope8_1+" Slope20="+dSlope20+","+dSlope20_1+" Slope50="+dSlope50+" Slope100="+dSlope100;
              
              /* working
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150<-0.7  && m_TradeParam.m_Current_7_20>3 &&  m_TradeParam.m_Current_1_7<-5)
               {
                    return TREND_DOWN;
               }
               */
               
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.5 && m_TradeParam.m_Current_7_50<-0.5 &&  m_TradeParam.m_Current_7_20>0 &&  m_TradeParam.m_Current_1_7>6)
               {
                    double d1=iHigh(NULL,PERIOD_M30,1);
                    double d2=iHigh(NULL,PERIOD_M30,2);
                    double d3=iHigh(NULL,PERIOD_M30,3);
                    
                    if(MathAbs(d1-d2)<3*Point*m_PointFactor && MathAbs(d3-d2)<3*Point*m_PointFactor)
                     return TREND_SIDEWAY;
                    else 
                    {
                      
                      if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100<40)
                        return TREND_SIDEWAY;
                      else
                      {
                       if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_75_1 && m_TradeParam.m_MA_75_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_75>30 &&
                          m_TradeParam.m_ma_cross_75_100>20 && m_TradeParam.m_ma_cross_75_100<60)
                          {
                           
                            if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_10_20>=1 && m_TradeParam.m_ma_cross_10_20<25 &&
                               m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1)
                            {
                             m_TradeComment="Trade 108";
                             return TREND_UP;
                            
                            }
                            else
                            {
                          
                            
                             m_TradeComment="Trade 107 "+m_TradeParam.m_ma_cross_10_20;
                             return TREND_DOWN;
                            }                          
                          }
                          else
                          {  
                          
                            if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_150_1)
                            {
                            
                            }
                            else
                            { 
                             m_TradeComment="Trade 101";
                             return TREND_UP;
                            }
                          }
                      }
                    }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>0.5 && m_TradeParam.m_Current_7_50<1 &&  m_TradeParam.m_Current_7_20>0 &&  m_TradeParam.m_Current_1_7>7)
               {
                    if((Close[1]-Open[1])<5*Point*m_PointFactor &&
                       (Close[2]-Open[2])<5*Point*m_PointFactor)
                       return TREND_SIDEWAY;
                    else if(m_TradeParam.m_Current_7_150>m_TradeParam.m_Current_7_50)
                    {
                      return TREND_SIDEWAY;
                    }
                    else
                    {
                      m_TradeComment="Trade 102";
                      return TREND_UP;
                    }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<-0.12 && m_TradeParam.m_Current_7_50>2 &&  m_TradeParam.m_Current_7_20<2 && m_TradeParam.m_Current_7_20>1.33 &&  m_TradeParam.m_Current_1_7>5)
               {
                    m_TradeComment="Trade 103";
                    return TREND_UP;
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>0.4 && m_TradeParam.m_Current_7_150<0.8 && m_TradeParam.m_Current_7_50>1.6  && m_TradeParam.m_Current_7_20>1.33 &&
                  Buffer_Linear[1]>Buffer_Linear[2] &&  m_TradeParam.m_Current_1_7>5)
               {
                   if(m_TradeParam.m_Current_1_18<-0.25)
                      return TREND_SIDEWAY;
                   else 
                   {
                    m_TradeComment="Trade 104";
                    return TREND_UP;
                    }
               }
               
               
                    
                     
    return (TREND_SIDEWAY);
  }

int  MA_Trend::CheckTrend_51()
{
              
              /* working
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150<-0.7  && m_TradeParam.m_Current_7_20>3 &&  m_TradeParam.m_Current_1_7<-5)
               {
                    return TREND_DOWN;
               }
               */
               
               
               if(Bars>150 && n_Counter>10 &&  m_TradeParam.m_Current_7_150<0 &&
                                               m_TradeParam.m_Current_7_150>-2 &&
                                               m_TradeParam.m_Current_7_20>3 &&
                                              Buffer_Linear[1]<Buffer_Linear[2] &&
                                              m_TradeParam.m_Current_1_7<-1)
               {
                   if(m_TradeParam.m_ma_cross_100_200>200 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1)
                      return TREND_SIDEWAY;
                  
                  if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
                        m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<60)
                  {
                         m_TradeComment="Trade 3001";
                         return TREND_UP;
                  
                  }
                  else    
                  {
                   
                    if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_50_100>100)
                    {
                    
                    }
                    else
                    {  
                      m_TradeComment="Trade 101";
                      return TREND_DOWN;
                    }
                  }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_20>7 &&
                                              Buffer_Linear[1]<Buffer_Linear[2] &&
                                              m_TradeParam.m_Current_1_7<-2)
               {
  
                    m_TradeComment="Trade 102";
                    return TREND_DOWN;
               }
               
               
                    
                     
    return (TREND_SIDEWAY);
  }

int  MA_Trend::CheckTrend_52()
{
                int m_Trade_Period=PERIOD_M30;
                

               double SCI_Main=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_MAIN,0);
               double SCI_Signal=iStochastic(NULL,m_Trade_Period,50,30,30,MODE_SMA,0,MODE_SIGNAL,0);
               
               
               if(Bars>150 && n_Counter>10 &&  m_TradeParam.m_Current_7_150<0 &&
                                               m_TradeParam.m_Current_7_150>-2 &&
                                               m_TradeParam.m_Current_7_20>1 &&
                                               m_TradeParam.m_Current_1_7<0.1 &&
                                              m_TradeParam.m_Current_1_4<-1)
               {
                   //SCI_Main,SCI_Signal
                   
                   if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50<20)
                     return TREND_SIDEWAY;
                   else 
                   {
                       if(MathAbs(iClose(NULL,PERIOD_M30,1)-iOpen(NULL,PERIOD_M30,1))<(iClose(NULL,PERIOD_M30,1)-iLow(NULL,PERIOD_M30,1)))
                        return TREND_SIDEWAY;
                       else if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50<40)
                       {
                        return TREND_SIDEWAY;                         
                       }
                       else if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_8_20<15)
                         return TREND_SIDEWAY;                                                 
                       else 
                       { 
                         if(Close[0]>Open[0])
                            return TREND_SIDEWAY;
                         else
                         {
                          
                          if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                             m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                             m_TradeParam.m_ma_cross_20_100>1 && m_TradeParam.m_ma_cross_20_100<30 &&
                              Ask<m_TradeParam.m_MA_20_1)
                             {
                                
                                if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && Ask<m_TradeParam.m_MA_10_1)
                                {
                                   m_TradeComment="Trade 1010";
                                   return TREND_DOWN;
                                
                                }
                                else
                                {
                                   m_TradeComment="Trade 108";
                                   return TREND_UP;
                                
                                }                                  
                             }
                             else
                             {                         
                                
                                if(MathAbs(m_TradeParam.m_Support_200-Ask)<30*Point*m_PointFactor)
                                {
                                
                                }
                                else
                                {
                                
                                  if(MathAbs(m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_100_1)<3*Point*m_PointFactor)
                                  {
                                     return TREND_SIDEWAY;
                                  }
                                  else
                                  {
                                  
                                    //m_TradeComment="Trade 102";
                                   //return TREND_DOWN;
                                  }
                                }
                             }
                         }
                       }
                   }
               }
               else if(Bars>150 && n_Counter>10 &&  m_TradeParam.m_Current_7_150<0 &&
                                               m_TradeParam.m_Current_7_150>-2 &&
                                               m_TradeParam.m_Current_7_20>0.5 &&
                                               SCI_Main<SCI_Signal &&
                                               MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_50_1)>5*Point*m_PointFactor)
               {
                    if(iClose(NULL,PERIOD_M30,1)>iOpen(NULL,PERIOD_M30,1))
                      return TREND_SIDEWAY;
                    else if((m_TradeParam.m_MA_100_1-Ask)>40*Point*m_PointFactor)
                      return TREND_SIDEWAY;
                    else if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>70 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1)
                      return TREND_SIDEWAY;                                            
                    else 
                    {
                    //m_TradeComment="Trade 103";
                      return TREND_SIDEWAY;
                    }
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<0.09 && m_TradeParam.m_Current_7_150>-0.09 && m_TradeParam.m_Current_7_20>2 && m_TradeParam.m_Current_1_7>4)
               {
                  m_TradeComment="Trade 101";
                  return TREND_UP;        
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_1_18>3 &&m_TradeParam.m_Current_7_20<0.05 && m_TradeParam.m_Current_1_7>5)
               {
                  if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1)
                     return TREND_SIDEWAY;
                  else 
                  { 
                     //m_TradeComment="Trade 108";
                     //return TREND_UP;
                  }        
               }
               else if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150<2 && m_TradeParam.m_Current_7_150>1.18 && m_TradeParam.m_Current_1_7<-4)
               {
                 if(MathAbs(iClose(NULL,PERIOD_M30,1)-iOpen(NULL,PERIOD_M30,1))<(iClose(NULL,PERIOD_M30,1)-iLow(NULL,PERIOD_M30,1)))
                  return TREND_SIDEWAY;
                 else if(Ask<m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150>0)
                  return TREND_SIDEWAY;                   
                  else
                  { 
                  if((MathAbs(iClose(NULL,PERIOD_M30,2)-iOpen(NULL,PERIOD_M30,2))<6*Point*m_PointFactor) ||
                     (MathAbs(iClose(NULL,PERIOD_M30,1)-iOpen(NULL,PERIOD_M30,1))<6*Point*m_PointFactor))
                     return TREND_SIDEWAY;
                   else
                   {
                        m_TradeComment="Trade 109";
                        return TREND_DOWN;
                   }
                 }        
               }
 
               
                    
                     
    return (TREND_SIDEWAY);
  }
  
  
  
  int  MA_Trend::CheckTrend_53()
{
              
/*               
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150>2.3  && m_TradeParam.m_Current_7_50<.5 &&  m_TradeParam.m_Current_1_7<0)
               {
                    return TREND_DOWN;
               }
               */
               /*
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1  && m_TradeParam.m_Current_7_50<.2 && m_TradeParam.m_Current_7_20<0 && m_TradeParam.m_Current_1_7<-2)
               {
                    return TREND_DOWN;
               }
               */
               if(Bars>150 && n_Counter>10 &&
               m_TradeParam.m_Current_7_20>4 &&
               m_TradeParam.m_Current_1_7<-3)
               {
                    if(m_TradeParam.m_Current_7_150>2)
                    {
                      if(m_TradeParam.m_Current_7_50>0.85)
                      {
                          if(m_TradeParam.m_Current_7_150>3 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && Ask<m_TradeParam.m_MA_20_1)
                            return TREND_SIDEWAY;
                          else
                          { 
                           
                           
                           
                             m_TradeComment="Trade 10921";
                             return TREND_DOWN;
                          }
                        
                      }  
                    }
                    else
                    {
                    
                        if(m_TradeParam.m_Current_7_150<-1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_10_50<15)
                           return TREND_SIDEWAY;
                        else 
                        {
                        
                           int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,8,1);
                           double val=iHigh(NULL,PERIOD_M30,index);
                           
                           if((val-Ask)>140*Point*m_PointFactor)
                             return TREND_SIDEWAY;
                           else
                           {
                        
                           if(m_TradeParam.m_Current_1_18<-2.5)
                             return TREND_SIDEWAY;
                           else
                           {
                           
                            if(m_TradeParam.m_Current_7_150<0.8 && m_TradeParam.m_Current_7_150>0 && m_TradeParam.m_Current_1_18>5)
                               return TREND_SIDEWAY;
                            else
                            { 
                            
                             if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_75_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_75_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 &&
                                m_TradeParam.m_ma_cross_20_50>3 && m_TradeParam.m_ma_cross_20_75>2 && m_TradeParam.m_ma_cross_20_75<50)
                                {
                                    if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && 
                                    m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_8_1)   
                                    {                          
                                       return TREND_SIDEWAY;
                                    }
                                    else
                                    {
                                     m_TradeComment="Trade 10927";
                                     return TREND_UP;
                                    }
                                      
                                }
                                else
                                {
                                   
                                    if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<20)
                                    {
                                    
                                      if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_ma_cross_3_10>1 && m_TradeParam.m_ma_cross_3_10<20)
                                      {
                                        m_TradeComment="Trade 10999";
                                        return TREND_DOWN;
                                      
                                      }
                                      else
                                      {
                                    
                                        m_TradeComment="Trade 1099";//+" "+m_TradeParam.m_ma_cross_3_10;
                                        return TREND_UP;
                                      }
                                    
                                    }
                                    else
                                    {
                                    
                                       if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && 
                                          m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                                          m_TradeParam.m_ma_cross_50_100>5 && m_TradeParam.m_ma_cross_50_100<100)
                                       {
                              
                                          if(m_TradeParam.m_MA_3_2>m_TradeParam.m_MA_3_1)
                                          {
                                          
                                          }
                                          else
                                          {
                                                      
                                           m_TradeComment="Trade 10918";
                                           return TREND_UP;
                                          }

                                       }
                                       else
                                       {
                                          if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && 
                                             m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1 &&
                                             m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_10_2)
                                          {
                                           m_TradeComment="Trade 10999";
                                           return TREND_UP;
                                          
                                          }
                                          else
                                          {
                                    
                                              m_TradeComment="Trade 1091";
                                              return TREND_DOWN;
                                           }
                                       }
                                    }
                                      
                                }
                            
                            }
                            }   
                           }
                        }                    
                    }
                  
               }
               
               
                     
    return (TREND_SIDEWAY);
  }


 
int  MA_Trend::CheckTrend_54()
{
                              
              
/*               
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Current_7_150>2.3  && m_TradeParam.m_Current_7_50<.5 &&  m_TradeParam.m_Current_1_7<0)
               {
                    return TREND_DOWN;
               }
               */
               /*
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_150>1  && m_TradeParam.m_Current_7_50<.2 && m_TradeParam.m_Current_7_20<0 && m_TradeParam.m_Current_1_7<-2)
               {
                    return TREND_DOWN;
               }
               */
               
               if(Bars>150 && n_Counter>10 && m_TradeParam.m_Current_7_50 && m_TradeParam.m_Current_7_50>m_TradeParam.m_Current_7_150 &&
               m_TradeParam.m_Current_1_18>2 &&
               m_TradeParam.m_Current_1_7<-1 && m_TradeParam.m_Current_1_4<-1)
               {
                  int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,8,1);
                  double val=iHigh(NULL,PERIOD_M30,index);
                  
                  if((val-Ask)>60*Point*m_PointFactor)
                    return TREND_SIDEWAY;
                  else 
                    {
                       if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_10_50<15 && m_TradeParam.m_Current_7_150<-1.2)
                         return TREND_SIDEWAY;
                       else
                       {
                         if(m_TradeParam.m_Current_7_150<-0.4 && m_TradeParam.m_Current_7_50>1 && m_TradeParam.m_Current_7_20>2 && m_TradeParam.m_Current_1_18>2)
                           return TREND_SIDEWAY;
                         else if(m_TradeParam.m_Current_7_150>0.2 && m_TradeParam.m_Current_7_50>0.2 && m_TradeParam.m_Current_7_20>0.2 && m_TradeParam.m_Current_1_18>2 &&
                                 m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_10_100<20)
                           return TREND_SIDEWAY;
                          else
                          {
                            double body= MathAbs(iOpen(NULL,PERIOD_M30,1)-iClose(NULL,PERIOD_M30,1));
                            double Tail= MathAbs(iClose(NULL,PERIOD_M30,1)-iLow(NULL,PERIOD_M30,1));
                            
                            if(Tail>body)
                               return TREND_SIDEWAY;
                           else
                           {                            
                             if(MathAbs(iOpen(NULL,PERIOD_M30,1)-iClose(NULL,PERIOD_M30,1))<4*Point*m_PointFactor)
                              return TREND_SIDEWAY;
                             else 
                             {
                                if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_20_50<15)
                                  return TREND_SIDEWAY;
                                else
                                {
                                 
                                   if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && 
                                      m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<60)
                                   {
                                      m_TradeComment="Trade 1093 ";//+m_TradeParam.m_ma_cross_20_50;
                                      return TREND_UP;
                                   }
                                   else
                                   {
                            

                                      if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && 
                                         m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<30 &&
                                         m_TradeParam.m_ma_cross_20_100>2 && m_TradeParam.m_ma_cross_20_100<25 &&
                                         m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_100_1)
                                      {
                                         m_TradeComment="Trade 1095 ";//+m_TradeParam.m_ma_cross_20_50;
                                         return TREND_UP;
                                      }
                                      else
                                      {

                                         if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                                            m_TradeParam.m_ma_cross_50_100>2 && m_TradeParam.m_ma_cross_50_100<50)
                                         {
                                            m_TradeComment="Trade 10969 ";//+m_TradeParam.m_ma_cross_20_50;
                                            return TREND_UP;
                                         }
                                         else
                                         {
                                  

                                           
                                           m_TradeComment="Trade 1092 "+NormalizeDouble(m_TradeParam.m_ma_cross_20_50,2);
                                          return TREND_DOWN;
                                         }
                                      }
                                   }
                                 }
                             }
                           }
                          }
                       }
                    }
               }
               
               /*
               if(Bars>150 && n_Counter>10)
               {
                  if(m_TradeParam.m_Current_1_7>2 && )
               
               }*/
               
                     
    return (TREND_SIDEWAY);
  }

int  MA_Trend::CheckTrend_55()
{
               
               if(n_Counter>50 ) n_Counter=50;
               
               if(Bars>150 && n_Counter>10 &&  m_TradeParam.m_ma_cross_20_50>40 && m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_8_2>m_TradeParam.m_MA_20_1 && m_TradeParam.m_dSlope20[4]>4 && m_TradeParam.m_dSlope20[3]<m_TradeParam.m_dSlope20[4] && m_TradeParam.m_dSlope20[2]>m_TradeParam.m_dSlope20[3])
               {
                   if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                      m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                      m_TradeParam.m_ma_cross_50_100>4 && m_TradeParam.m_ma_cross_50_100<50)
                      {
                      
                         m_TradeComment="55 UP";
                         return TREND_UP;
                      }
                      else
                      {
                        m_TradeComment="55 DN";
                       return TREND_DOWN;
                      }
               }
      
                     
    return (TREND_SIDEWAY);                     
 }

int MA_Trend::CheckTrend_58()  
  {
   int    res;
   if(Volume[0]>1) return TREND_SIDEWAY;

   int    MovingPeriod  =20;
   int    MovingShift   =1;


 
//--MAMonthly----------------------------------------------------------------------------------------------------------------  
   double mam[100],mamclose[100];
   int    km,limitmam=ArraySize(mam);
//--- go trading only for first tiks of new bar

   
  //--- get ma
   for(km=0; km<limitmam; km++)
      {
         mam[km]=iMA(NULL,PERIOD_MN1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,km);
         mamclose[km]=iMA(NULL,PERIOD_MN1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,km);
      }
    
//MAWeekly----------------------------------------------------------------------------------------------------------------      
   double maw[100],mawclose[100];
   int    kw,limitmaw=ArraySize(maw);
   
  //--- get ma
   for(kw=0; kw<limitmaw; kw++)
      {
         maw[kw]=iMA(NULL,PERIOD_W1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kw);
         mawclose[kw]=iMA(NULL,PERIOD_W1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kw);
      }
   
//MADaily----------------------------------------------------------------------------------------------------------------      
   double mad[100],madclose[100];
   int    kd,limitmad=ArraySize(mad);
   
  //--- get ma
   for(kd=0; kd<limitmad; kd++)
      {
         mad[kd]=iMA(NULL,PERIOD_D1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kd);
         madclose[kd]=iMA(NULL,PERIOD_D1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kd);
      }
      
//MAFourHour--------------------------------------------------------------------------------------------------------------      
   double mafh[100],mafhclose[100];
   int    kfh,limitmafh=ArraySize(mafh);

   
  //--- get ma
   for(kfh=0; kfh<limitmafh; kfh++)
      {
         mafh[kfh]=iMA(NULL,PERIOD_H4,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kfh);
         mafhclose[kfh]=iMA(NULL,PERIOD_H4,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kfh);
      }      
    
//MAOneHour--------------------------------------------------------------------------------------------------------------      
   double mah[100],mahclose[100];
   int    kh,limitmah=ArraySize(mah);
   
  //--- get ma
   for(kh=0; kh<limitmah; kh++)
      {
         mah[kh]=iMA(NULL,PERIOD_H1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kh);
         mahclose[kh]=iMA(NULL,PERIOD_H1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kh);
      }      
      
//MAThirtyMinutes--------------------------------------------------------------------------------------------------------      
   double mat[100],matclose[100];
   int    kt,limitmat=ArraySize(mat);
   
  //--- get ma
   for(kt=0; kt<limitmat; kt++)
      {
         mat[kt]=iMA(NULL,PERIOD_M30,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kt);
         matclose[kt]=iMA(NULL,PERIOD_M30,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kt);
      }      


//MAFifteenMinutes--------------------------------------------------------------------------------------------------------      
   double maft[100],maftclose[100];
   int    kft,limitmaft=ArraySize(maft);
   
  //--- get ma
   for(kft=0; kft<limitmaft; kft++)
      {
         maft[kft]=iMA(NULL,PERIOD_M15,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kft);
         maftclose[kft]=iMA(NULL,PERIOD_M15,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kft);
      } 



//--- sell conditions

      int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,15,1);
      double val=iHigh(NULL,PERIOD_M30,index);

      index=iLowest(NULL,PERIOD_M30,MODE_LOW,15,15);
      double vallow=iLow(NULL,PERIOD_M30,index);
      
      int m_Trade_Period=PERIOD_M30;



    if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_20_2 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1)
       return TREND_SIDEWAY;
    
       
    if(MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_50_1)<4*Point*m_PointFactor)
       return TREND_SIDEWAY;

   if ((maft[1]<maft[2]) && (mat[1]<mat[2]) &&   m_TradeParam.m_Current_7_20>0.5 && Close[1]<Open[1]) 
     {
       if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_200<30)
        return TREND_SIDEWAY;
       else if((val-Ask)>60*Point*m_PointFactor)
         return TREND_SIDEWAY;
       else
       {
            if(MathAbs(m_TradeParam.m_Support_200-Ask)<45*Point*m_PointFactor)
            {
              if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_50_1 &&
                 m_TradeParam.m_ma_cross_10_20>1 && m_TradeParam.m_ma_cross_10_20<20 && 
                 m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_50_1)
                 {
                   m_TradeComment="Trade 58-8";
                   return TREND_DOWN;
                 
                 }
                 else
                 {
                      if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1 && 
                       m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                       m_TradeParam.m_ma_cross_50_100>1 && m_TradeParam.m_ma_cross_50_100<35)
                       {
                         m_TradeComment="Trade 58-9";
                         return TREND_DOWN;
                          
                       }
                       else
                       {

                         if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && 
                          m_TradeParam.m_ma_cross_50_100>1 && m_TradeParam.m_ma_cross_50_100<70 &&
                          m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1)
                          {
                            m_TradeComment="Trade 58-99, "+NormalizeDouble(m_TradeParam.m_ma_cross_10_20,2);;
                            return TREND_DOWN;
                             
                          }
                          else
                          {
                       
                            //m_TradeComment="Trade 58-5, "+NormalizeDouble(m_TradeParam.m_ma_cross_10_20,2);
                            //return TREND_UP;
                          }
                       }
                 }
            
            }
            else
            {
               if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1)
               {
                 if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_10_20>=1 && m_TradeParam.m_ma_cross_10_20<30)
                 {
                  m_TradeComment="Trade 58-10";
                  return TREND_DOWN;
                 
                 }
                 else
                 {
                  m_TradeComment="Trade 58-6";
                  return TREND_UP;
                 }
               
               }
               else
               {
                if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_100_2)
                {
                     //m_TradeComment="Trade 58-7";
                     //return TREND_UP;
                
                }
                else
                {
                
                 m_TradeComment="Trade 58-1";
                 return TREND_DOWN;
                }
               }
            }
       }
     }
     else if ((maft[1]>maft[2]) && (mat[1]>mat[2]) && m_TradeParam.m_Current_7_20<-0.5 &&  Close[1]>Open[1]) 
     {
        ////if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_8_2<m_TradeParam.m_MA_20_1)

       if(MathAbs(m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_100_1)<3*Point*m_PointFactor && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_100_2)
        return TREND_SIDEWAY;
       else
       {

           if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
             m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<40 &&
             m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1)
             {
               
               if(MathAbs(m_TradeParam.m_MA_100_1-m_TradeParam.m_MA_50_1)<7*Point*m_PointFactor)
               {
               
               }
               else
               {
                
             
                m_TradeComment="Trade 58-3";
                return TREND_DOWN;
               }
             
             }
             else if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
             m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<40 &&
             m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 &&
             Ask>m_TradeParam.m_MA_20_1)
             {
               m_TradeComment="Trade 58-4";
               return TREND_DOWN;
             
             }
             else 
             {
             
                if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_dSlope50[0]<-1)
                {
       
                 m_TradeComment="DN 58-2";  
                 return  TREND_DOWN;
                }
                else
                {
                 m_TradeComment="Trade 58-2";  
                 return  TREND_UP;
                
                }
             }
       }
        
      }
//---

   return TREND_SIDEWAY;
  }
 

int MA_Trend::CheckTrend_59()  
  {
   int    res;
   if(Volume[0]>1) return TREND_SIDEWAY;

   int    MovingPeriod  =20;
   int    MovingShift   =1;


 
//--MAMonthly----------------------------------------------------------------------------------------------------------------  
   double mam[100],mamclose[100];
   int    km,limitmam=ArraySize(mam);
//--- go trading only for first tiks of new bar

   
  //--- get ma
   for(km=0; km<limitmam; km++)
      {
         mam[km]=iMA(NULL,PERIOD_MN1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,km);
         mamclose[km]=iMA(NULL,PERIOD_MN1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,km);
      }
    
//MAWeekly----------------------------------------------------------------------------------------------------------------      
   double maw[100],mawclose[100];
   int    kw,limitmaw=ArraySize(maw);
   
  //--- get ma
   for(kw=0; kw<limitmaw; kw++)
      {
         maw[kw]=iMA(NULL,PERIOD_W1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kw);
         mawclose[kw]=iMA(NULL,PERIOD_W1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kw);
      }
   
//MADaily----------------------------------------------------------------------------------------------------------------      
   double mad[100],madclose[100];
   int    kd,limitmad=ArraySize(mad);
   
  //--- get ma
   for(kd=0; kd<limitmad; kd++)
      {
         mad[kd]=iMA(NULL,PERIOD_D1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kd);
         madclose[kd]=iMA(NULL,PERIOD_D1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kd);
      }
      
//MAFourHour--------------------------------------------------------------------------------------------------------------      
   double mafh[100],mafhclose[100];
   int    kfh,limitmafh=ArraySize(mafh);

   
  //--- get ma
   for(kfh=0; kfh<limitmafh; kfh++)
      {
         mafh[kfh]=iMA(NULL,PERIOD_H4,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kfh);
         mafhclose[kfh]=iMA(NULL,PERIOD_H4,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kfh);
      }      
    
//MAOneHour--------------------------------------------------------------------------------------------------------------      
   double mah[100],mahclose[100];
   int    kh,limitmah=ArraySize(mah);
   
  //--- get ma
   for(kh=0; kh<limitmah; kh++)
      {
         mah[kh]=iMA(NULL,PERIOD_H1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kh);
         mahclose[kh]=iMA(NULL,PERIOD_H1,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kh);
      }      
      
//MAThirtyMinutes--------------------------------------------------------------------------------------------------------      
   double mat[100],matclose[100];
   int    kt,limitmat=ArraySize(mat);
   
  //--- get ma
   for(kt=0; kt<limitmat; kt++)
      {
         mat[kt]=iMA(NULL,PERIOD_M30,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kt);
         matclose[kt]=iMA(NULL,PERIOD_M30,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kt);
      }      


//MAFifteenMinutes--------------------------------------------------------------------------------------------------------      
   double maft[100],maftclose[100];
   int    kft,limitmaft=ArraySize(maft);
   
  //--- get ma
   for(kft=0; kft<limitmaft; kft++)
      {
         maft[kft]=iMA(NULL,PERIOD_M15,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kft);
         maftclose[kft]=iMA(NULL,PERIOD_M15,MovingPeriod,MovingShift,MODE_SMA,PRICE_CLOSE,kft);
      } 



//--- sell conditions

      int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,15,1);
      double val=iHigh(NULL,PERIOD_M30,index);

      index=iLowest(NULL,PERIOD_M30,MODE_LOW,15,15);
      double vallow=iLow(NULL,PERIOD_M30,index);
      
      int m_Trade_Period=PERIOD_M30;
                  

    if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_20_2 && m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1)
       return TREND_SIDEWAY;
    
       
    if(MathAbs(m_TradeParam.m_MA_20_1-m_TradeParam.m_MA_50_1)<4*Point*m_PointFactor)
       return TREND_SIDEWAY;

   if ((maft[1]<maft[2]) && (mat[1]<mat[2]) &&   m_TradeParam.m_Current_7_20>0.5 && Close[1]<Open[1]) 
     {
       if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_200<30)
        return TREND_SIDEWAY;
       else if((val-Ask)>60*Point*m_PointFactor)
         return TREND_SIDEWAY;
       else
        return TREND_DOWN;
     }
     else if ((maft[1]>maft[2]) && (mat[1]>mat[2]) && m_TradeParam.m_Current_7_20<-0.5 &&  Close[1]>Open[1]) 
     {
        ////if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_8_2<m_TradeParam.m_MA_20_1)

       if(MathAbs(m_TradeParam.m_MA_50_1-m_TradeParam.m_MA_100_1)<3*Point*m_PointFactor && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_100_2)
        return TREND_SIDEWAY;
       else  
        return  TREND_UP;
        
      }
//---

   return TREND_SIDEWAY;
  }



int  MA_Trend::CheckTrend_60()  
  {
  
  
      

       int index=iHighest(NULL,PERIOD_M30,MODE_HIGH,20,1);
      double HighVal=iHigh(NULL,PERIOD_M30,index);

      index=iLowest(NULL,PERIOD_M30,MODE_LOW,20,3);
      double LowVal=iLow(NULL,PERIOD_M30,index);
      
      int m_Trade_Period=PERIOD_M30;
                  
               
               double d50_100,dist_8_20Slope;
               double dist_20_50,Slope_20;

               double DiffInPip=0;
               double DiffInPip_20=0;
               double dist_8_20=0;
               double Slope=0;               
               int    RunLenght=0;
               
               int    FindMaCrossingEx_8_20  =FindMaCrossingEx(3,m_Trade_Period,8,20,dist_8_20,DiffInPip,Slope,RunLenght);
               int    FindMaCrossingEx_20_50  =FindMaCrossingEx(3,m_Trade_Period,20,50,dist_20_50,DiffInPip_20,Slope_20,RunLenght);

               double dist_50_100=0;
               double DiffInPip_50_100=0;
               double Slope_50_100=0;               
               int    RunLenght_50_100=0;

               int    FindMaCrossing_100_200  =FindMaCrossing(PERIOD_M30,100,200);


     
     if(MABOUNCE2()==1 && m_TradeParam.m_Current_1_7<-0.5 && MathAbs(m_TradeParam.m_Current_7_50)>0.5)
     {
       if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_20_50<40 && m_TradeParam.m_ma_cross_20_50>5)
       {
       
         m_TradeParam.m_MA_20_1;
         
        if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_50_2)
         return TREND_SIDEWAY;
        else 
        {
         if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 &&
            m_TradeParam.m_ma_cross_8_20>=2 && m_TradeParam.m_ma_cross_8_20<25)
            {
            
             
               m_TradeComment="UP 2";
               return TREND_UP;
            }
            else
            {
               //m_TradeComment="DN 1";
               //return TREND_DOWN;
           }
        }
       } 
       else 
       {
         if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_150_1)
         {
          if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_20_100<30 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_30_1)
          {
             if(m_TradeParam.m_ma_cross_100_200<200)
             {
             
                 if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_200<50)
                 {
                     m_TradeComment="UP 440";         
                     return TREND_UP;
                    
                 }
                 else
                 {
                  if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>2 && m_TradeParam.m_ma_cross_20_50<60 &&
                     m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_200_1)
                     {
                       if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_300_1)
                       {
                       
                       }
                       else
                       {
                        m_TradeComment="UP 540";         
                        return TREND_UP;
                       }
                     }
                     else
                     {
                                           
                     
                        m_TradeComment="DN 45";
                        return TREND_DOWN;
                     
                     }
                 
                 }
             }
             else
             {
             
               m_TradeComment="UP 44";         
               return TREND_UP;
             }
          
          }
          else
          {
           if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>10 && m_TradeParam.m_ma_cross_50_100<60)
           {
               m_TradeComment="UP 44w";         
               return TREND_UP;
           
           }
           else
           {
             if(m_TradeParam.m_MA_10_1> m_TradeParam.m_MA_20_1 )
              return TREND_SIDEWAY;
             else
             {
                m_TradeComment="DN 3";
                return TREND_DOWN;
             }
           }
          }
         }
         else 
         {
          if(DiffInPip>80 && m_TradeParam.m_Current_1_7<-0.2 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_100_200>100)
          {
             if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && 
               m_TradeParam.m_ma_cross_50_100<100 &&
               m_TradeParam.m_ma_cross_100_200<80 )
             {
                 m_TradeComment="UP 380";
                 return TREND_UP;
             }
             else
             {
             
             
                     if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>5 && m_TradeParam.m_ma_cross_20_50<50 &&
                       m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1)
                       {
                       
                              m_TradeComment="60 UP 4";//+" "+m_TradeParam.m_ma_cross_50_100+" "+m_TradeParam.m_ma_cross_100_200+"| "+FindMaCrossing_100_200;
                              return TREND_UP;
                       }
                       else
                       {
             
                            
                              m_TradeComment="DN 4";//+" "+m_TradeParam.m_ma_cross_50_100+" "+m_TradeParam.m_ma_cross_100_200+"| "+FindMaCrossing_100_200;
                              return TREND_DOWN;
                       }
             }            
          }
          else
          {
             if(DiffInPip_50_100>100 && RunLenght_50_100<140)
             {
                
               if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_20_200<50)
               {
                 m_TradeComment="DN 38";
                 return TREND_UP;
               
               }
               else
               {
                 m_TradeComment="DN 34";
                 return TREND_DOWN;
               }            
                
             }
             else
             {                       
              if(iClose(NULL,PERIOD_M30,1)<iOpen(NULL,PERIOD_M30,1))
              {
                return TREND_SIDEWAY;
              }
              else
              {
                if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                   m_TradeParam.m_ma_cross_50_100>2 && m_TradeParam.m_ma_cross_50_100<70)
                   {
                     m_TradeComment="UP 333";         
                     return TREND_DOWN;
                   
                   }
                   else
                   {
                    /*
                     if(m_TradeParam.m_Current_1_18<0.5 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1)
                     {
                     
                     }
                     else*/
                     {
                      m_TradeComment="UP 33";         
                      return TREND_UP;
                     }
                   }
               }
             }
          }
         }
       }
     }
     else if(MABOUNCE2()==2  && m_TradeParam.m_Current_1_7>0.5 && MathAbs(m_TradeParam.m_Current_7_50)>0.5)
     {
      if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50<60 && m_TradeParam.m_ma_cross_20_50>5)
      {
        if(m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_100_200<90)
        {
             m_TradeComment="DN 202";         
            return TREND_DOWN;
        
        }
        else
        {
        
            if(m_TradeParam.m_MA_8_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_100_1 &&
            m_TradeParam.m_ma_cross_8_20>=2 && m_TradeParam.m_ma_cross_8_20<25 && m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_8_1)
            {
             
              m_TradeComment="DN 202D";         
             return TREND_DOWN;
            
            }
            else
            {
               m_TradeComment="UP 20D";         
               return TREND_UP;
            
            }
        
        }
      }
      else
      { 
        if(iClose(NULL,PERIOD_M30,1)>iOpen(NULL,PERIOD_M30,1))
           return TREND_SIDEWAY;
        else 
        {
          if(DiffInPip_20>100 && m_TradeParam.m_MA_400_1>m_TradeParam.m_MA_300_1 && m_TradeParam.m_ma_cross_300_400>400)
          {
               m_TradeComment="UP 200";         
               return TREND_UP;
          }
         else 
         {
            
            if(m_TradeParam.m_MA_150_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_ma_cross_20_50>70)
            {
                m_TradeComment="DN 2000";         
                return TREND_UP;
            }
            else
            {
             
             if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_ma_cross_10_20>3 && m_TradeParam.m_ma_cross_10_20<20)
             {
                //m_TradeComment="DN 14000";         
                //return TREND_UP;
                
             }
             else
             {
             
               if(m_TradeParam.m_MA_8_1>m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_100_1)
                return TREND_SIDEWAY;
               
               if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 &&
                  m_TradeParam.m_ma_cross_100_200>5 && m_TradeParam.m_ma_cross_100_200<90 && 
                  m_TradeParam.m_ma_cross_50_100>5  && m_TradeParam.m_ma_cross_50_100<90)
                {
                   if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 &&
                      m_TradeParam.m_ma_cross_20_50>1 && m_TradeParam.m_ma_cross_20_50<40)
                      {
                         if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_dSlope50[1]>1)
                         {
                           m_TradeComment="UP 2-62";         
                           return TREND_UP;
                         
                         }                            
                      }
                      else
                      {
                  
                         m_TradeComment="DN 2-61";         
                         return TREND_UP;
                      }
                }
                else
                {
                  //m_TradeComment="DN 2-60 ";//+m_TradeParam.m_ma_cross_50_100+" "+m_TradeParam.m_ma_cross_100_200;         
                  //return TREND_DOWN;
                }
             }
            }
         }
        }
       } 
     }


     
     
     return TREND_SIDEWAY;
  }


int  MA_Trend::CheckTrend_Turbo()
{
         
         if(m_TradeParam.IsRanging())
           return TREND_SIDEWAY;
        
         if(m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 && 
            m_TradeParam.m_ma_cross_100_200>10)
         {
             if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && 
               m_TradeParam.m_ma_cross_20_50>40 &&
               m_TradeParam.m_ma_cross_10_20<20 && m_TradeParam.m_ma_cross_10_20>=2)
             {
                //prosanta 
                
                
                if((m_TradeParam.m_Resistance_40-Ask)<120*Point*m_PointFactor)
                {
                
                
                 if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                    m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && 
                    m_TradeParam.m_ma_cross_50_100>5 &&  m_TradeParam.m_ma_cross_50_100<130 && 
                    m_TradeParam.m_ma_cross_50_200>5 &&  m_TradeParam.m_ma_cross_50_200<70)
                    {


                       if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 &&
                          m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_300_1 && 
                          m_TradeParam.m_ma_cross_200_300>300 &&  m_TradeParam.m_ma_cross_50_100>40 && 
                          m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_50_1 &&
                          m_TradeParam.m_ma_cross_10_20>0 &&  m_TradeParam.m_ma_cross_10_20<20)
                          {
                          
                          
                                m_TradeComment="DN 7";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                return TREND_DOWN;
                          
                          }
                          else
                          {

                             if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 &&  
                                m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                                m_TradeParam.m_ma_cross_3_10>0 &&  m_TradeParam.m_ma_cross_3_10<15)
                                {
                                
                                  if( m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_100_200>2 &&  m_TradeParam.m_ma_cross_100_200<30)
                                   {
                                          m_TradeComment="UP 69";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                          return TREND_UP;
                                      
                                   }
                                   else
                                   {
                                   
                                   if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 &&
                                      m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                                      m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&   
                                      m_TradeParam.m_ma_cross_20_50>3 &&  m_TradeParam.m_ma_cross_20_50<30)
                                      {
                                          m_TradeComment="UP 70";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                          return TREND_UP;
                                      
                                      }
                                      else
                                      {
                                   
                                      if(
                                         m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && 
                                         m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 &&   
                                         m_TradeParam.m_ma_cross_50_200>3 &&  m_TradeParam.m_ma_cross_50_200<60)
                                         {
                                             m_TradeComment="UP 71";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                             return TREND_UP;
                                         
                                         }
                                         else
                                         {
                                         
                                        
                                            m_TradeComment="DN 8";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                            return TREND_DOWN;
                                         }
                                     }
                                   }
                                
                                }
                                else
                                {
                          
                                          m_TradeComment="UP 6";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                          return TREND_UP;
                                }
                          
                          }
                    
                      
                       
                       
                    }
                    else
                    {
                       if(m_TradeParam.IsRanging())
                       {
                       
                       }
                       else
                       {
                        double df=MathAbs(NormalizeDouble(m_TradeParam.m_Current_1_100,2));
                        
                        if(df<1)
                         return TREND_SIDEWAY;
                        else
                        {
                        
                         if(m_TradeParam.GetCloseDiffOpen(PERIOD_M30,1)<4*Point*m_PointFactor)
                         {// dojji
                           return TREND_SIDEWAY;
                         }
                         else
                         {
                             if(
                                m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_3_2 && 
                                m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_3_3<m_TradeParam.m_MA_10_3)
                                {
                                   if(m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1)
                                   {
                                   
                                   }
                                   else
                                   {
                                    m_TradeComment="UP 111,"+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                    return TREND_UP;
                                   }
                                
                                }
                                else
                                {
                                
                                   if(
                                   m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_10_1 &&  m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_20_1 && 
                                   m_TradeParam.m_ma_cross_3_10>=1 &&  m_TradeParam.m_ma_cross_3_10<10)
                                   {
                                    m_TradeComment="UP 112";
                                    return TREND_UP;
                                   
                                   }
                                   else
                                   {
                                
                                       if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100>100)
                                       {
                                         m_TradeComment="UP 1";
                                         return TREND_UP;   
                                         
                                       }
                                       else if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1> m_TradeParam.m_MA_200_1)
                                       {
                                       
                                       }
                                       else
                                       {
                        
                                          m_TradeComment="DN 1,"+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                                          return TREND_DOWN;
                                       }
                                   }
                                }
                         }
                        }
                       }
                    }
                }
             }
             else if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && 
               m_TradeParam.m_ma_cross_20_50>40 &&
               m_TradeParam.m_ma_cross_10_20<20 && m_TradeParam.m_ma_cross_10_20>=2 )
             {
      
               if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_ma_cross_50_100>1 && m_TradeParam.m_ma_cross_50_100<40)
               {
               
                 if(m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1)
                 {
                 
                 }
                 else
                 {
                 
                   m_TradeComment="DN 3 ";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                  return TREND_DOWN;
                 }
               
               }
               else
               {
             
                 if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                    m_TradeParam.m_ma_cross_50_100>10 && m_TradeParam.m_ma_cross_50_100<65)
                    {
                    
                       m_TradeComment="UP 11";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                       return TREND_DOWN;
                    
                    }
                    else
                    {
                       m_TradeComment="UP 1";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                       return TREND_UP;
                    
                    }
             
               }
             
             }

         
         }
         else if(m_TradeParam.m_MA_200_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_150_1<m_TradeParam.m_MA_100_1 &&
              m_TradeParam.m_ma_cross_100_200>10)
         {
             if(m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 && 
               m_TradeParam.m_ma_cross_20_50>40 &&
               m_TradeParam.m_ma_cross_10_20<20 && m_TradeParam.m_ma_cross_10_20>=2)
             {
                 m_TradeComment="DN 2";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                 return TREND_DOWN;
             }
             else if(m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 && 
               m_TradeParam.m_ma_cross_20_50>40 &&
               m_TradeParam.m_ma_cross_10_20<20 && m_TradeParam.m_ma_cross_10_20>=2 )
             {
      
             
                 m_TradeComment="UP 2";//+NormalizeDouble(m_TradeParam.m_dSlope100[0],2)+" "+NormalizeDouble(m_TradeParam.m_Current_1_100,2);
                 return TREND_DOWN;
             
             }
         
         }
     
       /*
       else if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && 
         m_TradeParam.m_ma_cross_50_100<100 &&
         m_TradeParam.m_ma_cross_100_200<80 )
       {
           m_TradeComment="UP 1";
           return TREND_UP;
       }
       else if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && 
         m_TradeParam.m_ma_cross_50_100<100 &&
         m_TradeParam.m_ma_cross_100_200<80 )
       {
       
           m_TradeComment="DN 1";
           return TREND_UP;
       
       }
       */


     return TREND_SIDEWAY;
}

int  MA_Trend::CheckTrend_Turbo_1()
{    
         if(m_TradeParam.IsRanging())
           return TREND_SIDEWAY;
        
        int data=TimeYear(TimeCurrent());
        double  s_d=0;
        
        if(data>=2010)
        {
        
        /*
        
         if(m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
            m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_50_1 &&  
            m_TradeParam.m_ma_cross_20_50>40)
         {
             int nIndex=FindMaCrossingCustom(3,PERIOD_M30,3,10,s_d);
             
             if(nIndex>10)
             {
                if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1 && m_TradeParam.m_MA_3_2>m_TradeParam.m_MA_10_1)
                 return TREND_DOWN;
                else if(m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_20_1 && m_TradeParam.m_MA_3_2>m_TradeParam.m_MA_20_1)
                return TREND_DOWN;
             }
         
         }
        */
        
        if(m_TradeParam.m_Current_1_7<-2 && m_TradeParam.m_Current_7_20>1 &&
           m_TradeParam.m_Current_1_4<-2)
        {
               if(m_TradeParam.m_ma_cross_50_100>60 )
               {
                if( m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                    m_TradeParam.m_ma_cross_20_100>3 && m_TradeParam.m_ma_cross_20_100<35)
                {
                
                  if(m_TradeParam.m_MA_30_1>m_TradeParam.m_MA_10_1 &&
                     m_TradeParam.m_ma_cross_10_30>=1 && m_TradeParam.m_ma_cross_10_30<30)
                     {
                     
                        if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100>100)
                        {
                          m_TradeComment="UP 1";
                          return TREND_UP;   
                          
                        }
                        else if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1> m_TradeParam.m_MA_200_1)
                        {
                        
                        }
                        else
                        {
                         
                          m_TradeComment="DN 1";
                          return TREND_DOWN;   
                        }
                     }
                     else
                     {
                       if(m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_3_2 && 
                          m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_8_1)
                       {
                        m_TradeComment="UP 1";
                        return TREND_UP;
                       }    
                     }
                   
                }
                else
                {
                  if(m_TradeParam.m_Close_1<m_TradeParam.m_Open_1 && m_TradeParam.m_Close_2<m_TradeParam.m_Open_2)
                  {
                  
                  }
                  else  if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100>50)
                  { 
                  
                    if(m_TradeParam.m_MA_300_1>m_TradeParam.m_MA_200_1)
                    {
                    
                    }
                    else
                    {
                               
                      m_TradeComment="UP 2";
                      return TREND_UP;
                    }
                  }
                  else if(m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1<m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100>50 && 
                          m_TradeParam.m_dSlope50[1]<-1 && m_TradeParam.m_dSlope100[0]<-1)
                  {
                  
                   m_TradeComment="DN 2";
                   return TREND_DOWN;
                  }
                }
               }           
        
        }
        }
     
     return TREND_SIDEWAY;
}

int  MA_Trend::CheckTrend_Turbo_2()
{

        int data=TimeYear(TimeCurrent());
        double  s_d=0;
        
        if(data>=2010)
        {

                if( m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_100_1 && 
                    m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_200_1 &&
                     m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_200_1 &&
                     m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1)
                {
                   if(m_TradeParam.m_Open_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_Close_1<m_TradeParam.m_MA_200_1)
                   {
                     if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                        m_TradeParam.m_ma_cross_50_100>1 && m_TradeParam.m_ma_cross_50_100<40)
                     { 
                        
                     }
                     else
                     {
                      m_TradeComment="T2 DN1, "+m_TradeParam.m_ma_cross_50_100;
                       return TREND_DOWN;
                     }   
                   }
                }
                else if( m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && 
                    m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 &&
                     m_TradeParam.m_MA_20_1>m_TradeParam.m_MA_50_1 &&
                     m_TradeParam.m_MA_10_1<m_TradeParam.m_MA_20_1 &&
                     m_TradeParam.m_MA_3_1<m_TradeParam.m_MA_10_1
                     )
                {
                   if(m_TradeParam.m_Open_1>m_TradeParam.m_MA_50_1 && m_TradeParam.m_Close_1<m_TradeParam.m_MA_50_1)
                   {
                     
                     if(m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_100_1 && m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_200_1 && m_TradeParam.m_ma_cross_50_100>50)
                     {
                      m_TradeComment="T2 DN2";
                       return TREND_UP;
                     }   
                   }
                }
                else if(m_TradeParam.m_MA_200_1>m_TradeParam.m_MA_100_1 &&
                        m_TradeParam.m_MA_100_1>m_TradeParam.m_MA_50_1 &&
                        m_TradeParam.m_MA_50_1>m_TradeParam.m_MA_20_1)
                {
                    if(m_TradeParam.m_Close_1<m_TradeParam.m_Open_1 &&
                       m_TradeParam.m_Close_2>m_TradeParam.m_Open_2 &&
                       m_TradeParam.m_Close_3>m_TradeParam.m_Open_3 &&
                       m_TradeParam.m_Close_1>m_TradeParam.m_Open_2 &&
                       (m_TradeParam.m_Close_2-m_TradeParam.m_Open_3)>15*Point*m_PointFactor)
                       {
                         if( m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_10_1 &&
                             m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_20_1 &&
                             m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_50_1 &&
                             m_TradeParam.m_MA_50_1<m_TradeParam.m_MA_100_1 &&
                             m_TradeParam.m_MA_20_1<m_TradeParam.m_MA_100_1)
                             {
                             
                             }
                             else
                             {
                       
                               m_TradeComment="T2 DN3";
                               return TREND_DOWN;
                             }
                                                         
                       }
                       
                   
                }
                
                else if(m_TradeParam.m_Close_1<m_TradeParam.m_Open_1 &&
                    m_TradeParam.m_Close_2>m_TradeParam.m_Open_2 &&
                    m_TradeParam.m_Close_3>m_TradeParam.m_Open_3 &&
                    m_TradeParam.m_Close_4>m_TradeParam.m_Open_4 &&                    
                    m_TradeParam.m_Close_1>m_TradeParam.m_Open_2 &&
                    (m_TradeParam.m_Close_2-m_TradeParam.m_Open_3)>15*Point*m_PointFactor)
                    {
                       if(m_TradeParam.m_MA_3_1>m_TradeParam.m_MA_10_1 && 
                        m_TradeParam.m_MA_10_1>m_TradeParam.m_MA_20_1 &&
                        m_TradeParam.m_ma_cross_3_10>15)
                        {
                         m_TradeComment="T2 DN4";
                         return TREND_DOWN;
                        }
                    }
           }
                
                
                
  return TREND_SIDEWAY;              
}
 

int MABOUNCE1()
  {
  
int
   Period_MA_2,  Period_MA_3,       // Calculation periods of MA for other timefr.
   Period_MA_02, Period_MA_03,      // Calculation periods of supp. MAs
   K2,K3,T,T1;
   
  
   switch(Period())                 // Calculating coefficient for..
     {                              // .. different timeframes
      case     1: K2=5;K3=15;T=PERIOD_M15; break;// Timeframe M1
      case     5: K2=3;K3= 6;T=PERIOD_M15; break;// Timeframe M5
      case    15: K2=2;K3= 4;T=PERIOD_M15; break;// Timeframe M15
      case    30: K2=2;K3= 8;T=PERIOD_M15; break;// Timeframe M30
      case    60: K2=4;K3=24;T=PERIOD_M15; break;// Timeframe H1
      case   240: K2=6;K3=42;T=PERIOD_M15; break;// Timeframe H4
      case  1440: K2=7;K3=30;T=PERIOD_M15; break;// Timeframe D1
      case 10080: K2=4;K3=12; break;// Timeframe W1
      case 43200: K2=3;K3=12; break;// Timeframe MN
     }

   switch(Period())                 // Calculating coefficient for..
     {                              // .. different timeframes
      case     1: K2=5;K3=15;T1=PERIOD_M30; break;// Timeframe M1
      case     5: K2=3;K3= 6;T1=PERIOD_M30; break;// Timeframe M5
      case    15: K2=2;K3= 4;T1=PERIOD_M30; break;// Timeframe M15
      case    30: K2=2;K3= 8;T1=PERIOD_M30; break;// Timeframe M30
      case    60: K2=4;K3=24;T1=PERIOD_M30; break;// Timeframe H1
      case   240: K2=6;K3=42;T1=PERIOD_M30; break;// Timeframe H4
      case  1440: K2=7;K3=30;T1=PERIOD_M30; break;// Timeframe D1
      case 10080: K2=4;K3=12; break;// Timeframe W1
      case 43200: K2=3;K3=12; break;// Timeframe MN
     }


  
   int MAVALUE=0;
   //for(int i=20; i<100;i+=20)
     {
      int i=20;
      double FASTMA=iMA(NULL,T,i,0,MODE_LWMA,PRICE_TYPICAL,0);
      double SLOWMA=iMA(NULL,T,100,0,MODE_LWMA,PRICE_TYPICAL,0);

      double FASTMA1=iMA(NULL,T1,i,0,MODE_LWMA,PRICE_TYPICAL,0);
      double SLOWMA1=iMA(NULL,T1,100,0,MODE_LWMA,PRICE_TYPICAL,0);


      if(FASTMA>SLOWMA && FASTMA1>SLOWMA1)
           {
            return(1);
            Comment("The trend is up");
           }
      else if(FASTMA<SLOWMA && FASTMA1<SLOWMA1)
           {
               return(2);
               Comment("The trend is down");
              }
           }
      return(0);
 }

int MABOUNCE2()
  {
  
int
   Period_MA_2,  Period_MA_3,       // Calculation periods of MA for other timefr.
   Period_MA_02, Period_MA_03,      // Calculation periods of supp. MAs
   K2,K3,T,T1;
   
  
   switch(Period())                 // Calculating coefficient for..
     {                              // .. different timeframes
      case     1: K2=5;K3=15;T=PERIOD_M15; break;// Timeframe M1
      case     5: K2=3;K3= 6;T=PERIOD_M15; break;// Timeframe M5
      case    15: K2=2;K3= 4;T=PERIOD_M15; break;// Timeframe M15
      case    30: K2=2;K3= 8;T=PERIOD_M15; break;// Timeframe M30
      case    60: K2=4;K3=24;T=PERIOD_M15; break;// Timeframe H1
      case   240: K2=6;K3=42;T=PERIOD_M15; break;// Timeframe H4
      case  1440: K2=7;K3=30;T=PERIOD_M15; break;// Timeframe D1
      case 10080: K2=4;K3=12; break;// Timeframe W1
      case 43200: K2=3;K3=12; break;// Timeframe MN
     }

   switch(Period())                 // Calculating coefficient for..
     {                              // .. different timeframes
      case     1: K2=5;K3=15;T1=PERIOD_D1; break;// Timeframe M1
      case     5: K2=3;K3= 6;T1=PERIOD_D1; break;// Timeframe M5
      case    15: K2=2;K3= 4;T1=PERIOD_D1; break;// Timeframe M15
      case    30: K2=2;K3= 8;T1=PERIOD_D1; break;// Timeframe M30
      case    60: K2=4;K3=24;T1=PERIOD_D1; break;// Timeframe H1
      case   240: K2=6;K3=42;T1=PERIOD_D1; break;// Timeframe H4
      case  1440: K2=7;K3=30;T1=PERIOD_D1; break;// Timeframe D1
      case 10080: K2=4;K3=12; break;// Timeframe W1
      case 43200: K2=3;K3=12; break;// Timeframe MN
     }


  
   int MAVALUE=0;
   //for(int i=20; i<100;i+=20)
     {
      int i=20;
      double FASTMA=iMA(NULL,T,i,0,MODE_LWMA,PRICE_TYPICAL,1);
      double SLOWMA=iMA(NULL,T,100,0,MODE_LWMA,PRICE_TYPICAL,1);

      double FASTMA_3=iMA(NULL,T,i,0,MODE_LWMA,PRICE_TYPICAL,3);
      double SLOWMA_3=iMA(NULL,T,100,0,MODE_LWMA,PRICE_TYPICAL,3);

      double FASTMA1=iMA(NULL,T1,i,0,MODE_LWMA,PRICE_TYPICAL,1);
      double SLOWMA1=iMA(NULL,T1,100,0,MODE_LWMA,PRICE_TYPICAL,1);
      double FASTMA1_3=iMA(NULL,T1,i,0,MODE_LWMA,PRICE_TYPICAL,3);
      double SLOWMA1_3=iMA(NULL,T1,100,0,MODE_LWMA,PRICE_TYPICAL,3);


      if(FASTMA>SLOWMA && FASTMA_3>SLOWMA_3&& FASTMA1>SLOWMA1 && FASTMA1_3>SLOWMA1_3 && iLow(Symbol(),T,1)<=FASTMA && iOpen(Symbol(),T,1)>FASTMA)
           {
            return(1);
            Comment("The trend is up");
           }
         if(FASTMA<SLOWMA && FASTMA_3<SLOWMA_3 && FASTMA1_3<SLOWMA1_3 && FASTMA1<SLOWMA1 && iHigh(Symbol(),T,1)>=FASTMA && iOpen(Symbol(),T,1)<FASTMA)
              {
               return(2);
               Comment("The trend is down");
              }
           }
      return(0);
 }
