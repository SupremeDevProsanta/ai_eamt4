//+------------------------------------------------------------------+
//|                                          ProsantTradeManager.mqh |
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
#include <.\Sale\TrendManager.mqh>



struct Scalpper_data
{
   int dOrderIndex;
   double dBaseLot;
   double dTargetPrice;
   double nCurrentLotTarget;
   double dLastPrice;
   int    nCurrentLotCompleted;
   int    nPipGap;
   int    nLoopState;
   
   
};

class TradeManager
{
private:
   double m_Increament_01_Amount;
   double m_StopLost;
   double m_TakeProfit;
   string m_TradeComment;
   double m_LotsSize; 
   double m_TrailingStop;
   double m_TrailingStopGap;
   bool   m_IsFixedLost;
   double m_FixedLotSize; 
   bool   m_bLockProfit;
   bool   m_bUseTrailingStop;
   bool   m_balreadyInLost;
   
   bool   m_bIsMartingle;
   bool   m_bUseSchasticOsc;
   bool   m_UseMovingAvg;
   
   double m_AlreadyInLostLevel;
   int    m_nPendingOrderCloseLimit;
   double m_nLockTradePriceInPip;
   double m_nLockTradePriceGapInPip;
   double m_dRisk_Per_Trade;
   // Hedge Param
   int    m_nMartingleCount;
   int    m_nMartingleDistInPips;
   int    m_nHedgeDistInPips;
   int    m_nSweptDistInPips;
   bool   m_bIsTurboActive;  
   int    m_nTrendState;
   double m_trailing_stop_AI;
   double m_trailing_TP_AI;
   Scalpper_data m_nCurrScapdata;
   bool   m_bInCloseRegion;
   
   
   
   
public:
   double m_nProfitTargetInPips;
   int    m_MagicNumber;

   double      m_Margtinglevel;
   double      m_MargtingFirstlevel;
   int         m_nTimePeriod;
   double      m_RegressionSlope5;
   double      m_RegressionSlope20;
   double      m_RegressionSlope50;
   double      m_RegressionSlope150;
   
   
   datetime m_LastCloseTime;  
   double   m_ProfitPerTrade;
   string   m_Comment;
   bool     m_bForcedTakeProfit;
   bool     m_bUseHedging;
   int      m_HedgeProfitLevelInPips;
   double   m_nHighestGainInPips;
   double   m_nLowestLostInPips;
   string   m_DebugInfo1; 
   string   m_Profit_Cal_1; 
   string   m_DebufInfo_TrailingStop; 
   string   m_DebugInfo1_Princ_Entry; 
   string   m_DebugInfo1_TimingCheck; 
   double   m_LostRegistered_1;
   double   m_LostRegistered_2;
   bool     m_bTradeCommentEnable;
   double m_LastOrderPriceBuy;
   double m_LastOrderPriceSell;
   
   
   
   
   int      m_TradeFreezing_Sec;
   bool     m_bEnableFreez;
   int      m_nCurrDirection;
   int      m_nSweptDirection;
   string   m_strHedgeDebug;  
   bool     m_bIsModified; 
   double   m_LastDeletedPrice_Res;
   datetime m_LastDeletedTime_Res;  
   double   m_LastDeletedPrice_Supp;
   datetime m_LastDeletedTime_Supp;  
   int      m_nDigit;
   double   m_LastDeletedPrice;
   datetime m_LastDeletedDateTime;
   double   m_PointFactor;
   double   m_Prev_Volume;
   bool     m_IsLockBreak;
   long     m_nTimeCounter;
   long     m_nTimeCounter1;
   Guppy    m_Guppy;
   double   m_CurrentData_Buy;
   double   m_CurrentData_Sel;
   double   m_SingleClosingDist;
   bool     m_SingleClosingEnable;
   double   m_Two_Link_CloseOrderPrice;
       

   
   

   
public :

   
   TradeManager(int nMagic,double dStopLost,double nTakeProfit,double nTrailingStop,double nTrailingStopGap,bool IsFixedLot,double dFixedLotSize,bool bLockProfit,bool bUseTrainlingStop,double LotsPerUnit=500)
   { 
     m_LastCloseTime=0; 
     m_MagicNumber=nMagic;
    m_TradeComment="HTR";
    m_StopLost=dStopLost;
    m_TakeProfit=nTakeProfit;
    m_LotsSize=0.01;   
    m_TrailingStop=nTrailingStop;
    m_TrailingStopGap=nTrailingStopGap;
    m_Increament_01_Amount=LotsPerUnit;
    m_IsFixedLost=IsFixedLot;
    m_FixedLotSize=dFixedLotSize;
    m_bLockProfit=bLockProfit;
    m_bUseTrailingStop=bUseTrainlingStop;
    m_bForcedTakeProfit=false;
    m_balreadyInLost=false;
    m_Margtinglevel=50;
    m_MargtingFirstlevel=25;
    m_nTimePeriod=PERIOD_CURRENT;
    m_bIsMartingle=false;
    m_nPendingOrderCloseLimit=70;
    m_bUseSchasticOsc=false;
    m_bUseHedging=false;
    m_HedgeProfitLevelInPips=30;
    m_UseMovingAvg=false;
    m_nLockTradePriceInPip=0;
    m_nLockTradePriceGapInPip=0;
    m_dRisk_Per_Trade=2;
    m_nHighestGainInPips=0;
    m_nLowestLostInPips=0;
    m_DebugInfo1=" ";
    m_TradeFreezing_Sec=120;
    m_bEnableFreez=false;
    m_nProfitTargetInPips=7;
    m_nMartingleCount=2;
    m_nMartingleDistInPips=10;
    m_nHedgeDistInPips=7;
    m_nSweptDistInPips=60;
    m_nCurrDirection=TREND_NO;
    m_nSweptDirection=TREND_NO;
    m_strHedgeDebug=" ";
    m_Profit_Cal_1="";
    m_DebufInfo_TrailingStop="";
    m_DebugInfo1_TimingCheck="";
    m_bIsModified=false;
    m_LastDeletedPrice_Res=0;
    m_LastDeletedTime_Res=0;  
    m_LastDeletedPrice_Supp=0;
    m_LastDeletedTime_Supp=0;  
    m_nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
    m_LastDeletedDateTime=0;
    m_PointFactor=10;
    m_IsLockBreak=false;
    m_DebugInfo1_TimingCheck="Test";
    m_nTrendState=0;

    m_trailing_stop_AI=0;
    m_trailing_TP_AI=0;
    m_bTradeCommentEnable=true;

     m_nCurrScapdata.dBaseLot= 0;
     m_nCurrScapdata.dOrderIndex=0;
     m_nCurrScapdata.nCurrentLotTarget= 0;
     m_nCurrScapdata.nCurrentLotCompleted=0;
     m_nCurrScapdata.nLoopState=false;
     m_nCurrScapdata.nPipGap=0;
     m_nCurrScapdata.dTargetPrice=0;
     m_CurrentData_Buy=0;
     m_CurrentData_Sel=0;
     m_SingleClosingDist=120;
     m_SingleClosingEnable=true;
     m_Two_Link_CloseOrderPrice=0;
     m_bInCloseRegion=false;
     m_LastOrderPriceBuy=0;
     m_LastOrderPriceSell=0;

   }
        
   void SetTradeParam(int nMagic,double dStopLost,double nTakeProfit,double nTrailingStop,double nTrailingStopGap,bool IsFixedLot,double dFixedLotSize,bool bLockProfit,bool bUseTrainlingStop,double LotsPer500=0.05)
   { 
     m_LastCloseTime=0; 
     m_MagicNumber=nMagic;
    m_TradeComment="HTR";
    m_StopLost=dStopLost;
    m_TakeProfit=nTakeProfit;
    m_LotsSize=0.01;   
    m_TrailingStop=nTrailingStop;
    m_TrailingStopGap=nTrailingStopGap;
    m_Increament_01_Amount=LotsPer500;
    m_IsFixedLost=IsFixedLot;
    m_FixedLotSize=dFixedLotSize;
    m_bLockProfit=bLockProfit;
    m_bUseTrailingStop=bUseTrainlingStop;
    m_Margtinglevel=50;
    m_MargtingFirstlevel=25;
    m_nTimePeriod=PERIOD_CURRENT;
    m_bIsMartingle=false;
    m_bUseSchasticOsc=false;
    m_nPendingOrderCloseLimit=70;
    m_bUseHedging=false;
    m_HedgeProfitLevelInPips=30;
    m_UseMovingAvg=false;
    m_nLockTradePriceInPip=0;
    m_nLockTradePriceGapInPip=0;
    m_dRisk_Per_Trade=2;
    m_nHighestGainInPips=0;
    m_nLowestLostInPips=0;
    m_DebugInfo1=" ";
    m_TradeFreezing_Sec=120;
    m_bEnableFreez=false;
    m_nCurrDirection=TREND_NO;
    m_nSweptDirection=TREND_NO;
    m_strHedgeDebug=" ";
    m_Profit_Cal_1="";
    m_DebufInfo_TrailingStop="";
    m_DebugInfo1_TimingCheck="";
    m_bIsModified=false;
    m_LastDeletedPrice_Res=0;
    m_LastDeletedTime_Res=0;  
    m_LastDeletedPrice_Supp=0;
    m_LastDeletedTime_Supp=0; 
    m_nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);     
    m_LastDeletedDateTime=0;
    m_PointFactor=10;
    m_IsLockBreak=false;
    m_DebugInfo1_TimingCheck="Test";
     m_nTrendState=0;
    m_trailing_stop_AI=0;
    m_trailing_TP_AI=0;
    m_nProfitTargetInPips=7;
    m_bTradeCommentEnable=true;
     m_nCurrScapdata.dBaseLot= 0;
     m_nCurrScapdata.dOrderIndex=0;
     m_nCurrScapdata.nCurrentLotTarget= 0;
     m_nCurrScapdata.nCurrentLotCompleted=0;
     m_nCurrScapdata.nLoopState=false;
     m_nCurrScapdata.nPipGap=0;
     m_nCurrScapdata.dTargetPrice=0;

     m_CurrentData_Buy=0;
     m_CurrentData_Sel=0;
     m_SingleClosingDist=120;
     m_SingleClosingEnable=true;
     m_Two_Link_CloseOrderPrice=0;
     m_bInCloseRegion=false;
     m_LastOrderPriceBuy=0;
     m_LastOrderPriceSell=0;

   }
   //void SetAI_Engine(AI_MovingAvg *pEngine){m_AI_Engine=pEngine; }    
            
   void SetStopLost(double dStopLostInPip){m_StopLost=dStopLostInPip;}
   void SetOrderStopLost(double dStopLostInPip){m_StopLost=dStopLostInPip;}
   
   void SetTakeProfit(double dTakeProfit){m_TakeProfit=dTakeProfit;}
   void SetTradeComment(string tComment){ if(m_bTradeCommentEnable)m_TradeComment=tComment;}
   void SetForcedTakeProfit(bool bFlag){m_bForcedTakeProfit=bFlag;}
   void SetUseHedging(bool nFlag){m_bUseHedging=nFlag;}
   void SetHedgeProfitLevel(int nValInPips){m_HedgeProfitLevelInPips=nValInPips;}
   void SetLockPipValue(double nLockPriceInPip, double nLockPriceGapeInPip){m_nLockTradePriceInPip=nLockPriceInPip;m_nLockTradePriceGapInPip=nLockPriceGapeInPip;}    
   double  GetLockPriceInPip(){ return (m_nLockTradePriceInPip);}
   double  GetLockGapPriceInPip(){ return (m_nLockTradePriceGapInPip);}
   
   void AlreadyInLostLevel(int LostInPips){m_AlreadyInLostLevel=LostInPips;}
   void SetPendingOrderCloseLimit(int nValueInPips){m_nPendingOrderCloseLimit=nValueInPips;}
   void GetOrderCount(int &BuyCount,int &SelCount);
   int  GetOrderCount(int nOrderType);

   bool CloseAllCurrentOrder();
   bool CloseAllCurrentOrderByDir(int nBuySal);
   void WaitUntilContex ();
   int  GetTradeCount();
   void ManageRunningTrade_Scalpping_Gladiator(int nExitMethod,int nTimeDuration);  
   void ManageRunningTrade_Scalpping_Gladiator_1(double dFilterCoeff,int nExitMethod,int nTimeDuration,int HardCloseTimeDuration,double dExitFilterCoeff);  
   void ManageRunningTrade_Scalpping_Gladiator_Spartucus(int nTimeDuration,int nTimeDuration2,int HardCloseTimeDuration,int StepingStoneTime,bool StopLOstMoving);  
   void ManageRunningTrade_Scalpping_Gladiator_Momentum(int nTimeDuration,int nTimeDuration2,int HardCloseTimeDuration,int StepingStoneTime,bool StopLOstMoving);  
 
 
   void ManageRunningTrade_Scalpping_Gladiator_Spartucus_Rev(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLOstMoving); 

   void ManageRunningTrade_Scalpping_Gladiator_Spartucus_Fix(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLostMoving);  

   
   void ManageRunningTrade_Scalpping_Gladiator_3(double dFilterCoeff,int nExitMethod,int nTimeDuration,int HardCloseTimeDuration,double dExitFilterCoeff);  
   void ManageRunningTrade_Scalpping_Gladiator_Spider(double dFilterCoeff,int nExitMethod,int nTimeDuration_1,int nTimeDuration_2,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeff_Limit);  
   void ManageRunningTrade_Scalpping_Gladiator_5(double dFilterCoeff,int nExitMethod,int nTimeDuration, int HardCloseTimeDuration,double dExitFilterCoeff); 
   void ManageRunningTrade_Scalpping_Gladiator_Revers(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLOstMoving);  
   
   void Manage_StopLost_Spartucus();//-1
   bool ModifyStopLostFromExitingStopLost(double DeltaInPips, int nOrderType);

   void ManageRunningTrade_Scalpping_Gladiator();

   void ManageRunningTrade_Scalpping_2017();  
   void ManageRunningTrade_Scalpping_2018();  
    
   void ManageRunningTrade_Scalpping_2011();   
   void ManageRunningTrade_Scalpping_2016_Rev();   
   void ManageRunningTrade_Scalpping_Martingle();
   void ManageRunningTrade_Scalpping_Martingle_1();
   void ManageRunningTrade_Scalpping_Martingle_2018();
   
   void ManageRunningTrade_Scalpping_Martingle_Regression();
   
   void ManageRunningTrade_Scalpping_Martingle_1T();
   void ManageRunningTrade_Scalpping_Martingle_2T();
   void ManageRunningTrade_Scalpping_Martingle_3T() ;  
   void ManageRunningTrade_Scalpping_Martingle_Fract();
   void ManageRunningTrade_Scalpping_Martingle_2();
   void ManageRunningTrade_Scalpping_Martingle_3();
   void ManageRunningTrade_Scalpping_Martingle_4();
   void ManageRunningTrade_Scalpping_Martingle_11();
   void ManageRunningTrade_Scalpping_Martingle_12();
   void ManageRunningTrade_Scalpping_Martingle_1_trail_1();
   void ManageRunningTrade_Scalpping_Martingle_1_Old();
   void ManageRunningTrade_Scalpping_Martingle_Fast();
   void ManageRunningTrade_Scalpping_Martingle_Fast_MULTI();   
   void ManageRunningTrade_Scalpping_Martingle_Fast_1();
   
   int ManageMartingle_CloseLastAndFistTrade(double nTargetProfit,double dClosingDist);

   
   double GetLowestPrice(int TradeType);
   double GetHighestPrice(int TradeType);
  
   bool CloseAllCurrentOrderByOrderID(int nID);
   
   int  CheckTrend();   
   int CheckTrend_1();
   bool MoveStopLostToBEP();
   bool MoveStopLostFromOrder(double DeltaInPips);
   bool MoveStopLostFromExitingStopLOst(double DeltaInPips);
   bool MoveStopLostToBEP_ForLockPip();
   double RiskManagedLotCalculation(double dRisk);
   
   bool TraillingStop();
   bool TraillingStop_New();
   bool TraillingStop_AI();

   bool TraillingStop_1();
   bool TraillingStop_TimeBase();
   
   datetime LastOrderCloseTime();
   datetime LastOrderOpenTime();
   datetime LastOrderCloseTimeBuyOrSell();
   
   bool Trade_Pending_SellStop(int nPipLevelFromCurrent);
   
   int TradeBuy();
   int TradeBuywithTimefilter();
   int TradeSell();
   int TradeSellwithTimefilter();
   
   bool TradeBuy(double dStopLost);
   bool TradeSell(double dStopLost);    
   bool TradeBuy(double dLotsize,double dStopLostInPip);
   bool TradeSell(double dLotsize,double dStopLostInPip);

     
   
   bool Trade_Pending_SellLimit(int nPipLevelFromCurrent);
   bool Trade_Pending_BuyStop(int nPipLevelFromCurrent);

   bool Trade_Pending_SellStop_Freezing(int nPipLevelFromCurrent);
   bool Trade_Pending_BuyStop_Freezing(int nPipLevelFromCurrent);

   bool Trade_Pending_BuyStop_ByValue_Freezing(double dVal);
   bool Trade_Pending_SellStop_ByValue_Freezing(double dVal);
   
   bool Trade_Pending_BuyLimit(int nPipLevelFromCurrent);

   bool Trade_Pending_SellStop_ByValue(double dVal);
   bool Trade_Pending_SellStop_ByValue_M(double dVal, int nMagic);
   
   bool Trade_Pending_SellLimit_ByValue(double dVal);
   bool Trade_Pending_BuyStop_ByValue(double dVal);
   bool Trade_Pending_Modify_ByValue(double dVal,int nPendingType);
   
   
   bool Trade_Pending_BuyLimit_ByValue(double dVal);
   void DeletAllPending();
   void DeletPending(int nOrderType);
   
   int GetPendingOrderCount();
   bool IsPendingOrderExist(int nOrderType);
   double GetPendingOrderPrice(int nPendingType);
   int GetPendingOrderTicket(int nPendingType);
   
   double GetPendingOrderStopLost(int nPendingType);
   
   double GetCurrOrderStopLost();
   
   datetime GetPendingOrderDateTime(int nPendingType);
   double SetMagnet(double dVal);

   void CheckPendingStopLost(int nPendingType);
   

   void PendingOrderAtZigZag(int dOffsetDist,double ZigZagHigh,double ZigZagLow);

   void PendingOrderAtZigZag_Res(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);

   void PendingOrderAtZigZag_Res_Magnet(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Magnet(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);

   void PendingOrderAtZigZag_Res_Algo_Org(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Algo_Org(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip);


   void PendingOrderAtZigZag_Res_Algo( bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Algo(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);

   void PendingOrderAtZigZag_Res_Algo_Rev(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Algo_Rev(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip);

   void PendingOrderAtZigZag_Res_Spartacus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Spartacus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);




  bool OrderModifyCheck(ulong ticket,double price,double sl,double tp);

   void PendingOrderAtZigZag_Res_Spartucus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   void PendingOrderAtZigZag_Supp_Spartucus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip);
   
   void HighLowTrader(int Dir,double PipSpeedCurr,double PipSpeedHigh,double PipSpeedLow,int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double ZigZagLow);
   

   void PendingOrderAtZigZag_Res_Reverse(bool nTradeFlag,int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh);
   void PendingOrderAtZigZag_Supp_Reverse(bool nTradeFlag, int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow);
  
   double GetLotSize(){ return(m_LotsSize);}
   double  SetLostSize(double dLot)
   {
      int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
      double LotStep=MarketInfo(Symbol(),MODE_LOTSTEP);
      double  dLotCount= dLot/LotStep;
      int     nLotCount=(int)dLotCount;
      
      double  TotalLots=nLotCount*LotStep;
       if(TotalLots<MarketInfo(Symbol(),MODE_MINLOT))
       {
          TotalLots=MarketInfo(Symbol(),MODE_MINLOT);
       }
       
       TotalLots=NormalizeDouble(TotalLots,nDigit);
     
       m_LotsSize=TotalLots;
       
       return (m_LotsSize);
   }

   void CheckOrderExpireTime(datetime dTime);
   
   void DeletePendingOrder(int nOrderType);
   void CheckForPendingOrderCloser();
   void ResetAlreadyInLost(){m_balreadyInLost=false;}
   void TradeInLost(int LostLimitInPips);
   string GetTradeComment();
   datetime GetCurrTradeOpenTime();
   double GetCurrTradeOrderPrice();
   double GetCurrTradeOrderProfit();
   
   int    GetCurrentOrderType();
   double    GetCurrentTradeLotSize();

   
   double    GetTargetProfit_AllTrade(int nPips); 
   double    CalculateOrderProfit_AllTrade();
     
   double   GetCurrentProfit();
   void  SetTurboMode(bool bFlag){m_bIsTurboActive=bFlag;}
   void  PendingOrderAtBAR(double dOffsetDist,double dDeleteDist);
   void  PendingOrderAtBAR_2(double dOffsetDist,double dDeleteDist);
   void  PendingOrderAtBAR_3(double dOffsetDist,double dDeleteDist);
   void  ModifyPendingOrder(int nOrderType,double dVal);
   void  SetStopLostForMultiTrade_Ext(int ProfitTargetInPips);
   
   // Hedge
   void UpdatePointFactor()
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

    void ResetScalperCond(){m_nCurrScapdata.nLoopState=false;}
    bool ChangeTpByOrderID(int nID,int nOrderTypeID,double dTp);
    
    int GetHighestOrderID(int TradeType);
    int GetLowestOrderID(int TradeType);
    bool CheckVolumeValue(double volume,string &description,double &validlot);

   
};

int  TradeManager::GetTradeCount()
{
   int nBuyCount=0;
   int nSellCount=0;
   
   GetOrderCount(nBuyCount,nSellCount);
   
   return(nBuyCount+nSellCount);
 
}


double TradeManager::GetCurrentProfit()
{
   datetime date=0;
   double dOrderPrice=0;
   int Count=0;
   int nOrderType=-1;
   double HighestPrice=0;

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
            if(Count==0)
           {
            //OrderLot=OrderLots();
            dOrderPrice=OrderOpenPrice();
            //OrderDateTime=OrderOpenTime();
            nOrderType  =OrderType();
            date=OrderOpenTime();
            //dOrderStopLost=OrderStopLoss();
            //dOrderTakeProfit=OrderTakeProfit();
            //nOrderTicket=OrderTicket();
            
            Count++;
            
           }
           else
           {
             if(date<OrderOpenTime())
             {  
               //OrderLot=OrderLots();
               dOrderPrice=OrderOpenPrice();
               //OrderDateTime=OrderOpenTime();
               nOrderType  =OrderType();
               date=OrderOpenTime();
               //dOrderStopLost=OrderStopLoss();
               //dOrderTakeProfit=OrderTakeProfit();
               //nOrderTicket=OrderTicket();
             }
           }
                    
        }
      }
     }
    
    HighestPrice=dOrderPrice;


    if(nOrderType==OP_BUY)
    {
          HighestPrice=Ask-HighestPrice;
    }
    else if(nOrderType==OP_SELL)
    {
          HighestPrice=HighestPrice-Bid;    
    }
    

     return (HighestPrice/(Point*m_PointFactor));
}




int TradeManager::GetCurrentOrderType()
{
   int nOrderType=0;
   int Count=0;

   for(int i=OrdersTotal();i>0;i--)
   {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderType()==OP_BUY || OrderType()==OP_SELL)
          {
             nOrderType  =OrderType();
             break;
          }
        }
      }
   }
     
     
   return (nOrderType);
}

double TradeManager::GetTargetProfit_AllTrade(int nPips)
{
   datetime date=0;
   int nOrderType=0;
   int Count=0;
   double LotSize=0;
   double Total_Profit=0;
   
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               LotSize=LotSize+OrderLots();
        }
      }
     }
     
     
   Total_Profit=LotSize*10*nPips;
     
   return(Total_Profit);
}







double TradeManager::GetCurrentTradeLotSize()
{
   datetime date=0;
   int nOrderType=0;
   int Count=0;
   double LotSize=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
            if(Count==0)
           {
            date=OrderOpenTime();
            LotSize=OrderLots();
            nOrderType  =OrderType();
            Count++;
            
           }
           else
           {
             if(date<OrderOpenTime())
             {  
               nOrderType  =OrderType();
               LotSize=OrderLots();
               date=OrderOpenTime();
             }
           }
                    
        }
      }
     }
     
     
     return (LotSize);
}


string TradeManager::GetTradeComment()
  {
   datetime date=0;
   int Count=0;
   string StrTradeComment="";
   
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
            if(Count==0)
           {
           
            date=OrderOpenTime();
            StrTradeComment=OrderComment();
            
            Count++;
            
           }
           else
           {
             if(date<OrderOpenTime())
             {  
               date=OrderOpenTime();
               StrTradeComment=OrderComment();
             }
           }
                    
        }
      }
     }
     
     return(StrTradeComment);
}


double TradeManager::GetCurrTradeOrderProfit()
{
   int Count=0;
   double TradeOrderProfit=0;
   
    for(int i=OrdersTotal();i>0;i--)
    {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderType()==OP_BUY ||OrderType()==OP_SELL)
          {
             if(OrderCommission()<0)
             TradeOrderProfit=TradeOrderProfit+OrderProfit()+OrderCommission()+OrderSwap();
             else
             TradeOrderProfit=TradeOrderProfit+OrderProfit()-OrderCommission()+OrderSwap();
          }
        }
      }
    }
   
   return(TradeOrderProfit);
}


double TradeManager::GetCurrTradeOrderPrice()
  {
   int Count=0;
   double TradeOrderPrice=0;
   
    for(int i=OrdersTotal();i>0;i--)
    {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderType()==OP_BUY ||OrderType()==OP_SELL)
          {
             TradeOrderPrice=OrderOpenPrice();
             break;
          }
        }
      }
     }
   
       
   return(TradeOrderPrice);
}

datetime TradeManager::GetCurrTradeOpenTime()
  {
   datetime date=0;
   int Count=0;
   int ID=OrdersTotal()-1;

    for(int i=OrdersTotal();i>0;i--)
     {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderType()==OP_BUY ||OrderType()==OP_SELL)
          {
            date=OrderOpenTime();
            break;
          }
        }
      }
     }

     return(date);
}

void TradeManager::CheckForPendingOrderCloser()
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==OP_BUYLIMIT)
            {
               if(MathAbs(OrderOpenPrice()-Ask)>m_nPendingOrderCloseLimit*Point*m_PointFactor)
               {
                   bool tes=OrderDelete(OrderTicket());
               }
            }
            else if(OrderType()==OP_BUYSTOP)
            {
               if(MathAbs(OrderOpenPrice()-Ask)>m_nPendingOrderCloseLimit*Point*m_PointFactor)
               {
                   bool tes=OrderDelete(OrderTicket());
               }
            }
            else if(OrderType()==OP_SELLLIMIT )
            {            
               if(MathAbs(OrderOpenPrice()-Ask)>m_nPendingOrderCloseLimit*Point*m_PointFactor)
               {
                   bool tes=OrderDelete(OrderTicket());
               }
            
            }
            else if(OrderType()==OP_SELLSTOP)
            {
               if(MathAbs(OrderOpenPrice()-Ask)>m_nPendingOrderCloseLimit*Point*m_PointFactor)
               {
                  bool tes=OrderDelete(OrderTicket());
               } 
            }
         }
     }
  }
}

void TradeManager::CheckOrderExpireTime(datetime dTime)
{
  
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==OP_BUYLIMIT ||OrderType()==OP_BUYSTOP)
            {
               if(OrderOpenTime()<dTime)
               {
                   bool tes=OrderDelete(OrderTicket());
               }
            }
            else if(OrderType()==OP_SELLLIMIT ||OrderType()==OP_SELLSTOP)
            {
               if(OrderOpenTime()<dTime)
               {
                   bool tes=OrderDelete(OrderTicket());
               }
            }
         }
     }
  }
  
  
}



void TradeManager::DeletePendingOrder(int nOrderType)
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nOrderType)
            {
                bool tes=OrderDelete(OrderTicket());
            }
         }
     }
  }
}


void TradeManager::DeletAllPending()
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==OP_BUYLIMIT ||OrderType()==OP_BUYSTOP || OrderType()==OP_SELLLIMIT ||OrderType()==OP_SELLSTOP)
            {
                bool tes=OrderDelete(OrderTicket());
            }
         }
     }
  }
}

void TradeManager::DeletPending(int nOrderType)
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nOrderType)
            {
                bool tes=OrderDelete(OrderTicket());
            }
         }
     }
  }
}


void TradeManager::GetOrderCount(int &BuyCount,int &SelCount)
{   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==OP_BUY)
            {
               BuyCount++;
            }
            else if(OrderType()==OP_SELL)
            {
              SelCount++;
            }
         }
     }
  }
}

int TradeManager::GetOrderCount(int nOrderType)
{  
   int BuyCount=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nOrderType)
            {
               BuyCount++;
            }
            else if(OrderType()==nOrderType)
            {
              BuyCount++;
            }
         }
     }
  }
  
  return(BuyCount);
}


bool TradeManager::IsPendingOrderExist(int nOrderType)
{
   int nCOuntDD=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nOrderType)
            {
               nCOuntDD++;
            }
         }
     }
  }
  
  if(nCOuntDD>0)
   return(true);
  else 
  return(false);
   
}

int TradeManager::GetPendingOrderCount()
{   
   int nCOuntDD=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==OP_BUYLIMIT ||OrderType()==OP_BUYSTOP)
            {
               nCOuntDD++;
            }
            else if(OrderType()==OP_SELLLIMIT ||OrderType()==OP_SELLSTOP)
            {
              nCOuntDD++;
            }
         }
     }
  }
  
 return(nCOuntDD);

}

void TradeManager::CheckPendingStopLost(int nPendingType)
{
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nPendingType)
            {
              double dPendingPrice=OrderStopLoss();
              if(dPendingPrice==0)
              {
                double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
                double dOrderPrice=OrderOpenPrice();
                
                
                if(StopLevel>m_StopLost)
                m_StopLost=StopLevel;
                
                if(OrderType()==OP_BUYLIMIT ||OrderType()==OP_BUYSTOP)
                {
                  bool Test=OrderModify(OrderTicket(),dOrderPrice,dOrderPrice-m_StopLost*Point*m_PointFactor,dOrderPrice+m_TakeProfit*Point*m_PointFactor,OrderExpiration(),CLR_NONE);                
                  
                }
                else if(OrderType()==OP_SELLLIMIT ||OrderType()==OP_SELLSTOP)
                {
                  bool Test=OrderModify(OrderTicket(),dOrderPrice,dOrderPrice+m_StopLost*Point*m_PointFactor,dOrderPrice-m_TakeProfit*Point*m_PointFactor,OrderExpiration(),CLR_NONE);                
                }
                
              }
            }
         }
     }
  }
}

double TradeManager::GetCurrOrderStopLost()
  {
   int Count=0;
   double TradeOrderPrice=0;
   
    for(int i=OrdersTotal();i>0;i--)
    {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderType()==OP_BUY ||OrderType()==OP_SELL)
          {
             TradeOrderPrice=OrderStopLoss();
             break;
          }
        }
      }
     }
   
       
   return(TradeOrderPrice);
}


double TradeManager::GetPendingOrderStopLost(int nPendingType)
{   
   int nCOuntDD=0;
   double dPendingPrice=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nPendingType)
            {
              dPendingPrice=OrderStopLoss();
            }
         }
     }
  }
  
 return(dPendingPrice);

}

double TradeManager::GetPendingOrderPrice(int nPendingType)
{   
   int nCOuntDD=0;
   double dPendingPrice=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nPendingType)
            {
              dPendingPrice=OrderOpenPrice();
            }
         }
     }
  }
  
 return(dPendingPrice);

}


int TradeManager::GetPendingOrderTicket(int nPendingType)
{   
   int nCOuntDD=0;
   int dPendingPrice=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nPendingType)
            {
              dPendingPrice=OrderTicket();
            }
         }
     }
  }
  
 return(dPendingPrice);

}




datetime TradeManager::GetPendingOrderDateTime(int nPendingType)
{   
   int nCOuntDD=0;
   datetime dPendingDateTime=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nPendingType)
            {
              dPendingDateTime=OrderOpenTime();
            }
         }
     }
  }
  
 return(dPendingDateTime);

}


bool TradeManager::OrderModifyCheck(ulong ticket,double price,double sl,double tp)
  {
//--- select order by ticket
   double dOrderPrice;
   double dOrderStopLost;
   double dOrderTakeProfit;
   bool   OrderFound=false;
   string OrderSym;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
              if(ticket==OrderTicket())
              {
                dOrderPrice=OrderOpenPrice();
                dOrderStopLost=OrderStopLoss();
                dOrderTakeProfit=OrderTakeProfit();
                OrderFound=true;
                OrderSym=OrderSymbol();
                break;
              }
         }
      }
  }
  
      double StopLevel=MarketInfo(NULL,MODE_STOPLEVEL);
      
     if(OrderFound)
     {
      //--- point size and name of the symbol, for which a pending order was placed
      string symbol=OrderSym;
      double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
      int digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
      //--- check if there are changes in the Open price
      bool PriceOpenChanged=(MathAbs(dOrderPrice-price)>point);
      //--- check if there are changes in the StopLoss level
      bool StopLossChanged=(MathAbs(dOrderStopLost-sl)>point);

      bool StopLossChanged_1=(MathAbs(dOrderStopLost-sl)>StopLevel);
      
       if(StopLossChanged)
       {
          if(StopLossChanged_1)
          {
            StopLossChanged=true;
          }
          else
          {
             StopLossChanged=false;
          }
       }
      
      //--- check if there are changes in the Takeprofit level
      bool TakeProfitChanged=(MathAbs(dOrderTakeProfit-tp)>point);
      //--- if there are any changes in levels
      if(StopLossChanged==true || TakeProfitChanged==true)
      {
         return(true);  // order can be modified      
      //--- there are no changes in the Open, StopLoss and Takeprofit levels
      }
      else
      {
      //--- notify about the error
         PrintFormat("Order #%d already has levels of Open=%.5f SL=%.5f TP=%.5f",
                     ticket,dOrderPrice,dOrderStopLost,dOrderTakeProfit);
       }
     }
//--- came to the end, no changes for the order
   return(false);       // no point in modifying 
  }

void TradeManager::ModifyPendingOrder(int nOrderType,double dVal)
{
   int nCOuntDD=0;
   datetime dPendingDateTime=0;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber() == m_MagicNumber)
         {
            if(OrderType()==nOrderType)
            {
              double dOrderPrice=NormalizeDouble(dVal,5);
              double dOrderStopLost=m_StopLost*Point*m_PointFactor;
              double dOrderTakProfit=m_TakeProfit*Point*m_PointFactor;
              
              
              bool test=OrderModify(OrderTicket(),dOrderPrice,0,0,0);

              if(test)
              {
               if(nOrderType==OP_BUYSTOP)
               test=OrderModify(OrderTicket(),dOrderPrice,dOrderPrice-dOrderStopLost,dOrderPrice+dOrderTakProfit,0);
               else if(nOrderType==OP_SELLSTOP)
               test=OrderModify(OrderTicket(),dOrderPrice,dOrderPrice+dOrderStopLost,dOrderPrice-dOrderTakProfit,0);
               
               if(test)
               {
                  //Print("Magnet Success...");
               }
               else
               {
                  //Print("Magnet failed...");
               }
              }
            }
         }
     }
  }
}



void TradeManager::HighLowTrader(int Dir,double PipSpeedCurr,double PipSpeedHigh,double PipSpeedLow,int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double ZigZagLow)
{


    double tmpDeleteDist=50*Point*m_PointFactor;

    if(PipSpeedCurr>PipSpeedHigh)
    {
      if(Close[1]>Open[1] && Close[0]>Open[0] && (High[1]-Low[1])>25*Point*m_PointFactor)
      {// UP
          if((Close[0]-Open[0])<15*Point*m_PointFactor )
          {
             if(Dir==TREND_UP)
             TradeBuy();
          }        
      }
      else if(Close[1]<Open[1] && Close[0]<Open[0] && (High[1]-Low[1])>25*Point*m_PointFactor)
      {//DOWN
          if((Open[0]-Close[0])<15*Point*m_PointFactor )
          {
             if(Dir==TREND_DOWN)
             TradeSell();
          }        
      }

    }
    else if(PipSpeedCurr<PipSpeedLow)
    {

     if(IsPendingOrderExist(OP_BUYSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
       
          if(dPendingPrice>(Ask+tmpDeleteDist))
          {
            DeletPending(OP_BUYSTOP);
          }

     
     }
     if(IsPendingOrderExist(OP_SELLSTOP))
     {
        double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);             
        
        if(Ask>(dPendingPrice+tmpDeleteDist))
        {
         DeletPending(OP_SELLSTOP);
        }
     
     }
     
    
       if(MathAbs(ZigZagHigh-Ask)<25*Point*m_PointFactor)
       {
           if(IsPendingOrderExist(OP_BUYSTOP))
           {
           
           }
           else
           {
             if(Bid>(ZigZagHigh-7*Point*m_PointFactor))       
             {
                   double OrderPoint=Bid-9*Point*m_PointFactor;                              
                   Trade_Pending_SellStop_ByValue(OrderPoint); 
             }
           }
         
       }
       else if(MathAbs(ZigZagLow-Ask)<25*Point*m_PointFactor)
       {
           if(IsPendingOrderExist(OP_SELLSTOP))
           {
           
           }
           else           
           {
             if(Ask<(ZigZagLow+7*Point*m_PointFactor))       
             {
             
                   double OrderPoint1=Ask+9*Point*m_PointFactor;                              
                   Trade_Pending_BuyStop_ByValue(OrderPoint1); 
                
             }
          
          }
       }
   }
   
}

void TradeManager::PendingOrderAtBAR(double dOffsetDist,double dDeleteDist)
{
     double tmpOffset=dOffsetDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     double dOpen_0  =iOpen(NULL,0,0);
     double dClose_0 =iClose(NULL,0,0);
     double dHigh_0  =iHigh(NULL,0,0);
     double dLow_0   =iLow(NULL,0,0);
     
     
     if(dOpen_0==dHigh_0)
     {
        if((dClose_0-dOpen_0)>tmpOffset)
        {
           Trade_Pending_SellStop_ByValue(dOpen_0);
        }
        else if((dOpen_0-dClose_0)>tmpOffset)
        {
           Trade_Pending_BuyStop_ByValue(dOpen_0);
        }
     }
     else if(dLow_0==dOpen_0)
     {
        if((dClose_0-dOpen_0)>tmpOffset)
        {
           Trade_Pending_SellStop_ByValue(dOpen_0);
        }
        else if((dOpen_0-dClose_0)>tmpOffset)
        {
           Trade_Pending_BuyStop_ByValue(dOpen_0);
        }
       
     }
     
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
        datetime dPendingTime=GetPendingOrderDateTime(OP_BUYSTOP);
        
        if(MathAbs(TimeCurrent()-dPendingTime)>80)
        {
          DeletPending(OP_BUYSTOP);
        }
     
     }
     if(IsPendingOrderExist(OP_SELLSTOP))
     {
        datetime dPendingTime=GetPendingOrderDateTime(OP_SELLSTOP);
        
        if(MathAbs(TimeCurrent()-dPendingTime)>80)
        {
          DeletPending(OP_SELLSTOP);
        }     
     }
     
     
}
void TradeManager::PendingOrderAtBAR_2(double dOffsetDist,double dDeleteDist)
{
     double tmpOffset=dOffsetDist*Point*m_PointFactor;
     double Entry    =dDeleteDist*Point*m_PointFactor*0.5;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     double dOpen_0  =iOpen(NULL,0,0);
     double dClose_0 =iClose(NULL,0,0);
     double dHigh_0  =iHigh(NULL,0,0);
     double dLow_0   =iLow(NULL,0,0);
     
     
     
     if(dOpen_0==dHigh_0)
     {
        if((dClose_0-dOpen_0)>tmpOffset)
        {  
          if(dClose_0<dHigh_0)
          {
            double OrderVal=dOpen_0+Entry;
            OrderVal=NormalizeDouble(OrderVal,5);
            
           Trade_Pending_SellStop_ByValue(OrderVal);
          }
        }
        else if((dOpen_0-dClose_0)>tmpOffset)
        {
          if(dClose_0>dLow_0)
          {
            double OrderVal=dOpen_0-Entry;
            OrderVal=NormalizeDouble(OrderVal,5);

           Trade_Pending_BuyStop_ByValue(OrderVal);
          }
        }
     }
     else if(dLow_0==dOpen_0)
     {
        if((dClose_0-dOpen_0)>tmpOffset)
        {
          if(dClose_0<dHigh_0)
          {
            double OrderVal=dOpen_0+Entry;
            OrderVal=NormalizeDouble(OrderVal,5);
        
           Trade_Pending_SellStop_ByValue(OrderVal);
          }
        }
        else if((dOpen_0-dClose_0)>tmpOffset)
        {
         if(dClose_0>dLow_0)
         {
            double OrderVal=dOpen_0-Entry;
            OrderVal=NormalizeDouble(OrderVal,5);
        
           Trade_Pending_BuyStop_ByValue(OrderVal);
          }
        }
       
     }
     
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
        datetime dPendingTime=GetPendingOrderDateTime(OP_BUYSTOP);
        double dOrderVal=GetPendingOrderPrice(OP_BUYSTOP);
        
        if(MathAbs(dOrderVal-Ask)>tmpDeleteDist)
        {
           DeletPending(OP_BUYSTOP);
        }
        
        if(MathAbs(TimeCurrent()-dPendingTime)>55)
        {
          DeletPending(OP_BUYSTOP);
        }
     
     }
     if(IsPendingOrderExist(OP_SELLSTOP))
     {
        datetime dPendingTime=GetPendingOrderDateTime(OP_SELLSTOP);
        double dOrderVal=GetPendingOrderPrice(OP_SELLSTOP);
        if(MathAbs(dOrderVal-Ask)>tmpDeleteDist)
        {
           DeletPending(OP_BUYSTOP);
        }
        
        if(MathAbs(TimeCurrent()-dPendingTime)>55)
        {
          DeletPending(OP_SELLSTOP);
        }     
     }
     
     
}

void TradeManager::PendingOrderAtBAR_3(double dOffsetDist,double dDeleteDist)
{
     double tmpOffset=dOffsetDist*Point*m_PointFactor;
     double Entry    =dOffsetDist*Point*m_PointFactor*0.5;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     double dOpen_0  =iOpen(NULL,0,0);
     double dClose_0 =iClose(NULL,0,0);
     double dHigh_0  =iHigh(NULL,0,0);
     double dLow_0   =iLow(NULL,0,0);
     int  nHighest  =iHighest(NULL,0,MODE_HIGH,3,0);
     int  nLowest   =iLowest(NULL,0,MODE_LOW,3,0);
     double  Highest=High[nHighest];
     double  Lowest=Low[nLowest];
     
     if((Highest-Lowest)<15*Point*10)
     {
       if(Ask<Highest && Bid>Lowest)
       {
          if((Highest-5*Point*10)>Ask && Bid>(Lowest+5*Point*10))
          {
             
             double dVal=iMA(NULL,0,8,0,MODE_SMA,PRICE_CLOSE,0);
             double dVal1=iMA(NULL,0,8,0,MODE_SMA,PRICE_CLOSE,1);
             
             
             
             if(dVal>dVal1 && Close[0]>Close[1])
             TradeBuy();
             else if(dVal<dVal1 && Close[0]<Close[1])
             TradeSell();
          }
       }
     }
     
     
     
}

void TradeManager::PendingOrderAtZigZag_Res(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     
     
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
       
       if(Bid>(dPendingPrice-3*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);
             
             //double OrderPoint=Bid-9*Point*m_PointFactor;     
             //Trade_Pending_SellStop_ByValue(OrderPoint); 
             
          } 
          
          double dLow=iLow(NULL,PERIOD_M5,0);
          double dHigh=iHigh(NULL,PERIOD_M5,0);
          double dHighest=iHighest(NULL,PERIOD_M5,MODE_HIGH,5,0);
          double dIOpen  =iOpen(NULL,PERIOD_M5,0);
          
          if(m_bIsTurboActive==true && nTradeFlag==true)
          {
             if(MathAbs(dPendingPrice-dHighest)>0.5*Point*m_PointFactor &&  MathAbs(dPendingPrice-dHighest)<2*Point*m_PointFactor)
             {
                //DeletPending(OP_SELLSTOP);
                TradeBuy();
                //Trade_Pending_SellStop_ByValue_M(dHighest,100);
             }
          }
                   
       }
       
       
       
       
       double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
       double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
       
       if(dStopLost==0)
       {
          if(StopLevel>m_StopLost)
          m_StopLost=StopLevel;
          DeletPending(OP_BUYSTOP);
          Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
          //printf("dStopLost 0");
       }
       
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-30*Point*m_PointFactor) && MathAbs(Bid-(ZigZagHigh+tmpOffset))>20*Point*m_PointFactor)
       //if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-10*Point*m_PointFactor))
       {
       
         
         if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
         {
            double Dist=(ZigZagHigh-Bid)/(Point*m_PointFactor);         
            //string Txt="New trad at="+DoubleToStr(Dist,1)+" Symbol="+Symbol()+" Offset ="+tmpOffset;;
            //printf(Txt);
         }
         
       }
     }
}



void TradeManager::PendingOrderAtZigZag_Res_Spartucus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     
     
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
       
       if(Bid>(dPendingPrice-3*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);
             m_LastDeletedPrice=Ask;
             m_LastDeletedDateTime=Time[0];
             //TradeSell();
             
             
          }           
       }
       
       
       
       
       if(IsPendingOrderExist(OP_BUYSTOP))       
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
             //printf("dStopLost 0");
          }
       }
       
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
       //if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-30*Point*m_PointFactor) && MathAbs(Bid-(ZigZagHigh+tmpOffset))>20*Point*m_PointFactor)
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-10*Point*m_PointFactor))
       {
         if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
         {
            double Dist=(ZigZagHigh-Bid)/(Point*m_PointFactor);       
            double atDist=ZigZagHigh+tmpOffset;
              
            string Txt="New trad at="+DoubleToStr(atDist,1)+" Symbol="+Symbol();
            //printf(Txt);
         }
         
       }
       
       if((Time[0]-m_LastDeletedDateTime)>60 && (Time[0]-m_LastDeletedDateTime)<Period()*60*5)
       {
          if(Ask>m_LastDeletedPrice)
          {
            if(nTradeFlag)
              TradeBuy();
          
          }
          else if(Ask<m_LastDeletedPrice)
          {
             TradeSell();
          }
         
       }
       
     }
}

void TradeManager::PendingOrderAtZigZag_Supp(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);

       
       if(Ask<(dPendingPrice+3*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);
             
          }
          
       }
       
       
      if(IsPendingOrderExist(OP_SELLSTOP))
      { 
       double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
       double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
       
       if(dStopLost==0)
       {
          if(StopLevel>m_StopLost)
          m_StopLost=StopLevel;
          DeletPending(OP_SELLSTOP);   
          Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
          //printf("dStopLost 0");
       }
      }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+10*Point*m_PointFactor))
       {
        if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
        { 
         double Dist=(Ask-ZigZagLow)/(Point*m_PointFactor);
         double dAtValue=ZigZagLow-tmpOffset;         
         //string Txt="New trad at="+DoubleToStr(Dist,1)+" Symbol="+Symbol()+" at Price ="+dAtValue;
         //printf(Txt);
        }

       }
     }

}

void TradeManager::PendingOrderAtZigZag_Supp_Spartucus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);

       
       if(Ask<(dPendingPrice+3*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);             
             m_LastDeletedPrice=Ask;
             m_LastDeletedDateTime=Time[0];
             
          }          
          
       }
       
      if(IsPendingOrderExist(OP_SELLSTOP))
      {
       double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
       double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
       
       if(dStopLost==0)
       {
          if(StopLevel>m_StopLost)
          m_StopLost=StopLevel;
          DeletPending(OP_SELLSTOP);
          
          Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
          //printf("dStopLost 0");
       }
      }


       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       //if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+30*Point*m_PointFactor) && MathAbs(Ask-(ZigZagLow-tmpOffset))>20*Point*m_PointFactor)
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+10*Point*m_PointFactor))
       {
        if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
        { 
         
         double AtValue=ZigZagLow-tmpOffset;       
         string Txt="New trade at="+DoubleToStr(AtValue,m_nDigit)+" Symbol="+Symbol();
         //printf(Txt);
        }

       }
       
       
       if((Time[0]-m_LastDeletedDateTime)>60 && (Time[0]-m_LastDeletedDateTime)<Period()*60*5)
       {
          if(Ask>m_LastDeletedPrice)
          {
            
              TradeBuy();
          
          }
          else if(Ask<m_LastDeletedPrice)
          {
             if(nTradeFlag)
             TradeSell();
          }
         
       }
       
     }

}

double TradeManager::SetMagnet(double dVal)
{
     double ProfitInPips=GetCurrentProfit();
     double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
   
     double dHighest=High[iHighest(NULL,0,MODE_HIGH,4,0)];
     double dLowest =Low[iLowest(NULL,0,MODE_HIGH,4,0)];
     
   
   
   if(nOrderType==OP_BUYSTOP)
   {
      double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
      
      if((dPendingPrice-dHighest)<dVal*Point*m_PointFactor)
      {
         if((dHighest-Ask)>7*Point*m_PointFactor)
         {
            DeletPending(OP_BUYSTOP);
            Trade_Pending_BuyStop_ByValue(dHighest+1*Point*m_PointFactor);            
         }
      }
  
   }
   else if(nOrderType==OP_SELLSTOP)
   {
      double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
      
      if((dLowest-dPendingPrice)<dVal*Point*m_PointFactor)
      {
         if((Bid-dLowest)>7*Point*m_PointFactor)
         {
            DeletPending(OP_SELLSTOP);
            Trade_Pending_SellStop_ByValue(dLowest-1*Point*m_PointFactor);            
         }
      }
   }
   
   return(0);
}
 


void TradeManager::PendingOrderAtZigZag_Res_Magnet(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     double dHighest=High[iHighest(NULL,0,MODE_HIGH,4,0)];
     
     
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
       
         m_LastDeletedPrice_Res=0;
         m_LastDeletedTime_Res=0;  
       /*
       if(dHighest>(dPendingPrice-15*Point*m_PointFactor))       
       {
          if(m_bIsModified==false)
          {
            if((dHighest-Ask)>3*Point*m_PointFactor)
            {
               ModifyPendingOrder(OP_BUYSTOP,dHighest);
               m_bIsModified=true;
            }
          }
       }
       */
       
       
       if(Bid>(dPendingPrice-3*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);
             m_LastDeletedPrice_Res=dPendingPrice;
             m_LastDeletedTime_Res=Time[0];  

             //double OrderPoint=Bid-9*Point*m_PointFactor;     
             //printf("Sell stop due to slow pip movement");
             //Trade_Pending_SellStop_ByValue(OrderPoint); 
          }           
       }
       
       
       
       
       if(IsPendingOrderExist(OP_BUYSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
             //printf("StopLost 0");
          }
       }
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
        m_bIsModified=false;
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-30*Point*m_PointFactor) && MathAbs(Bid-(ZigZagHigh+tmpOffset))>20*Point*m_PointFactor)
       //if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-10*Point*m_PointFactor))
       {
       
         
         if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
         {
            double Dist=(ZigZagHigh-Bid)/(Point*m_PointFactor);         
            //string Txt="New trad at="+DoubleToStr(Dist,1)+" Symbol="+Symbol()+" Offset ="+tmpOffset;;
            //printf(Txt);
         }
         
       }
     }
}

void TradeManager::PendingOrderAtZigZag_Supp_Magnet(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,5);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
       m_LastDeletedPrice_Supp=0;
       m_LastDeletedTime_Supp=0;  

    /*
       if(dLowest<(dPendingPrice+15*Point*m_PointFactor))       
       {
         if(m_bIsModified==false)
         {
            if((Bid-dLowest)>3*Point*m_PointFactor)
            {
               ModifyPendingOrder(OP_SELLSTOP,dLowest);
               m_bIsModified=true;
            }
         }
       }
       */
       
       if(Ask<(dPendingPrice+3*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order deleted for pip movemoment is slow Symbol="+Symbol()+" Dist(Pip)="+DoubleToStr(Dist,1);
             //printf(Txt);
             m_LastDeletedPrice_Supp=dPendingPrice;
             m_LastDeletedTime_Supp=Time[0];  
             
             //double OrderPoint1=Ask+9*Point*m_PointFactor;                              
             //Trade_Pending_BuyStop_ByValue(OrderPoint1); 
          }          
       }
       
       if(IsPendingOrderExist(OP_SELLSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_SELLSTOP);
             Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
             //printf("StopLost 0");
          }
       }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       m_bIsModified=false;
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+30*Point*m_PointFactor) && MathAbs(Ask-(ZigZagLow-tmpOffset))>20*Point*m_PointFactor)
       //if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+10*Point*m_PointFactor))
       {
        if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
        { 
         double Dist=(Ask-ZigZagLow)/(Point*m_PointFactor);         
         //string Txt="New trad at="+DoubleToStr(Dist,1)+" Symbol="+Symbol()+" Offset ="+tmpOffset;
         //printf(Txt);
        }

       }
     }

}

void TradeManager::PendingOrderAtZigZag_Res_Algo_Org(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
          
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
        double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
                
       if(Bid>(dPendingPrice-3*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at ="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Res=dPendingPrice;
             m_LastDeletedTime_Res=Time[0]; 
          }           
       }
       
       if(IsPendingOrderExist(OP_BUYSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
             //printf("StopLost 0");
          }
       }
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
        m_bIsModified=false;
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-20*Point*m_PointFactor))
       {
       
         
         if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
         {
            double Dist=ZigZagHigh+tmpOffset;
            
            string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol=";
            //printf(Txt);
         }
         
       }
     }
}

void TradeManager::PendingOrderAtZigZag_Supp_Algo_Org(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
       m_LastDeletedPrice_Supp=0;
       m_LastDeletedTime_Supp=0;         
       if(Ask<(dPendingPrice+3*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Supp=dPendingPrice;
             m_LastDeletedTime_Supp=Time[0]; 
          }          
       }
       
       if(IsPendingOrderExist(OP_SELLSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_SELLSTOP);
             Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
             //printf("StopLost 0");
          }
       }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       m_bIsModified=false;
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+20*Point*m_PointFactor))
       {
        if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
        { 
         double Dist=ZigZagLow-tmpOffset;
         string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol="+Symbol();
         //printf(Txt);
        }

       }
     }

}



void TradeManager::PendingOrderAtZigZag_Res_Algo(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
          
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
        double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
                
       if(Bid>(dPendingPrice-dRemoveDist*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at ="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Res=dPendingPrice;
             m_LastDeletedTime_Res=Time[0]; 
             
             
             if(nRevTradeFlag)
             {
               if(dCoefficientCurr<dCoefficientMin)
               {
                 //double revPrice=dPendingPrice-6*Point*m_PointFactor;                
                 //Trade_Pending_SellStop_ByValue(revPrice);
               }
                
             }              
          }  
          
       }
       
       if(IsPendingOrderExist(OP_BUYSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             //printf("StopLost 0");
          }
       }
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
        m_bIsModified=false;
        /*
        string tostrPrint="Factor ="+DoubleToStr(m_PointFactor,5)+ "Pending Dist="+DoubleToStr(PendingOrderDist,1)+"\n\r";
        double  Uplevel=(ZigZagHigh+tmpOffset)-PendingOrderDist*Point*m_PointFactor;
        double  LowLevel=(ZigZagHigh+tmpOffset)-tmpChangeDist;
        double  ZigZagLevel=ZigZagHigh+tmpOffset;
        double dfUp=(Uplevel-ZigZagLevel)/(Point*m_PointFactor);
        double dfLow=(ZigZagLevel-LowLevel)/(Point*m_PointFactor);
        
        tostrPrint=tostrPrint+" Up Level="+DoubleToStr(dfUp,2)+" LowLevel="+DoubleToStr(dfLow,2)+" ZigZac at="+DoubleToStr((ZigZagHigh+tmpOffset),5)+" Bid="+DoubleToStr(Bid,5);
        */
        //printf(tostrPrint);
        
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-PendingOrderDist*Point*m_PointFactor))
       {
       
         datetime lastClose=LastOrderCloseTime();
         
         if((lastClose+Period()*60*2)<TimeCurrent())
         {
            if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
            {
               double Dist=ZigZagHigh+tmpOffset;
               
               string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol=";
               //printf(Txt);
            }
            else
            {
              //printf("\n\rPending order failed failed");
            }
         }
       }
       else
       {
           //printf("\n\rCondition failed");
       }
     }
}


void TradeManager::PendingOrderAtZigZag_Supp_Algo(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
       m_LastDeletedPrice_Supp=0;
       m_LastDeletedTime_Supp=0;         
       if(Ask<(dPendingPrice+dRemoveDist*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Supp=dPendingPrice;
             m_LastDeletedTime_Supp=Time[0];
             
             if(nRevTradeFlag)
             {
               if(dCoefficientCurr<dCoefficientMin)
               {

                 //double revPrice=dPendingPrice+6*Point*m_PointFactor;                
               
                 //Trade_Pending_BuyStop_ByValue(revPrice);
               }
                
             } 
          }
          
        }
       
       if(IsPendingOrderExist(OP_SELLSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_SELLSTOP);
             Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
             //printf("StopLost 0");
          }
       }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       m_bIsModified=false;
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+PendingOrderDist*Point*m_PointFactor))
       {
         datetime lastClose=LastOrderCloseTime();
         
         if((lastClose+Period()*60*2)<TimeCurrent())
         {
       
              if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
              { 
               double Dist=ZigZagLow-tmpOffset;
               string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol="+Symbol();
               //printf(Txt);
              }
         }

       }
     }

}


void TradeManager::PendingOrderAtZigZag_Res_Algo_Rev(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
          
     if(IsPendingOrderExist(OP_SELLLIMIT))
     {
        double dPendingPrice=GetPendingOrderPrice(OP_SELLLIMIT);
                
       if(Bid>(dPendingPrice-dRemoveDist*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLLIMIT);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at ="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Res=dPendingPrice;
             m_LastDeletedTime_Res=Time[0]; 
             
             
             if(nRevTradeFlag)
             {
               if(dCoefficientCurr<dCoefficientMin)
               {
                 //double revPrice=dPendingPrice-6*Point*m_PointFactor;                
                 //Trade_Pending_SellStop_ByValue(revPrice);
               }
                
             }              
          }           
       }
       
       if(IsPendingOrderExist(OP_SELLLIMIT))
       {
          double dStopLost=GetPendingOrderStopLost(OP_SELLLIMIT);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
             //printf("StopLost 0");
          }
       }
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_SELLLIMIT);
       }
              
     }
     else
     {
        m_bIsModified=false;
        /*
        string tostrPrint="Factor ="+DoubleToStr(m_PointFactor,5)+ "Pending Dist="+DoubleToStr(PendingOrderDist,1)+"\n\r";
        double  Uplevel=(ZigZagHigh+tmpOffset)-PendingOrderDist*Point*m_PointFactor;
        double  LowLevel=(ZigZagHigh+tmpOffset)-tmpChangeDist;
        double  ZigZagLevel=ZigZagHigh+tmpOffset;
        double dfUp=(Uplevel-ZigZagLevel)/(Point*m_PointFactor);
        double dfLow=(ZigZagLevel-LowLevel)/(Point*m_PointFactor);
        
        tostrPrint=tostrPrint+" Up Level="+DoubleToStr(dfUp,2)+" LowLevel="+DoubleToStr(dfLow,2)+" ZigZac at="+DoubleToStr((ZigZagHigh+tmpOffset),5)+" Bid="+DoubleToStr(Bid,5);
        */
        //printf(tostrPrint);
        
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-PendingOrderDist*Point*m_PointFactor))
       {
       
         datetime lastClose=LastOrderCloseTime();
         
         if((lastClose+Period()*60*2)<TimeCurrent())
         {
            if(Trade_Pending_SellLimit_ByValue(ZigZagHigh+tmpOffset))
            {
               double Dist=ZigZagHigh+tmpOffset;
               
               string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol=";
               //printf(Txt);
            }
            else
            {
              //printf("\n\rPending order failed failed");
            }
         }
       }
       else
       {
           //printf("\n\rCondition failed");
       }
     }
}

void TradeManager::PendingOrderAtZigZag_Supp_Algo_Rev(bool nRevTradeFlag,double dCoefficientMin,double dCoefficientCurr,bool nTradeFlag,double PendingOrderDist,double dRemoveDist,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_BUYLIMIT))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_BUYLIMIT);
       m_LastDeletedPrice_Supp=0;
       m_LastDeletedTime_Supp=0;    
            
       if(Ask<(dPendingPrice+dRemoveDist*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYLIMIT);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Supp=dPendingPrice;
             m_LastDeletedTime_Supp=Time[0];
             
             if(nRevTradeFlag)
             {
               if(dCoefficientCurr<dCoefficientMin)
               {

                 //double revPrice=dPendingPrice+6*Point*m_PointFactor;                
               
                 //Trade_Pending_BuyStop_ByValue(revPrice);
               }
                
             } 
          }          
       }
       
       if(IsPendingOrderExist(OP_BUYLIMIT))
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYLIMIT);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYLIMIT);
             Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
             //printf("StopLost 0");
          }
       }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_BUYLIMIT);
       }
       
     }
     else
     {
       m_bIsModified=false;
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+PendingOrderDist*Point*m_PointFactor))
       {
         datetime lastClose=LastOrderCloseTime();
         
         if((lastClose+Period()*60*2)<TimeCurrent())
         {
       
              if(Trade_Pending_BuyLimit_ByValue(ZigZagLow-tmpOffset))
              { 
               double Dist=ZigZagLow-tmpOffset;
               string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol="+Symbol();
               //printf(Txt);
              }
         }

       }
     }

}


void TradeManager::PendingOrderAtZigZag_Res_Spartacus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh,double CutOffLenghtInPip)
{
     
     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
          
     if(IsPendingOrderExist(OP_BUYSTOP))
     {
        double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
                
       if(Bid>(dPendingPrice-3*Point*m_PointFactor))       
       {
          if(nTradeFlag==false)
          {
             DeletPending(OP_BUYSTOP);
             
             double Dist=(dPendingPrice-Bid)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at ="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Res=dPendingPrice;
             m_LastDeletedTime_Res=Time[0]; 
          }           
       }
       
       if(IsPendingOrderExist(OP_BUYSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_BUYSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          
          
          
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_BUYSTOP);
             Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset);
             //printf("StopLost 0");
          }
       }
       

       if(dPendingPrice>(Ask+tmpDeleteDist))
       {
         DeletPending(OP_BUYSTOP);
       }
              
     }
     else
     {
        m_bIsModified=false;
       if(Bid>((ZigZagHigh+tmpOffset)-tmpChangeDist) && Bid<((ZigZagHigh+tmpOffset)-5*Point*m_PointFactor))
       {
       
         
         if(Trade_Pending_BuyStop_ByValue(ZigZagHigh+tmpOffset))
         {
            double Dist=ZigZagHigh+tmpOffset;
            
            string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol=";
            //printf(Txt);
         }
         
       }
     }
}

void TradeManager::PendingOrderAtZigZag_Supp_Spartacus(bool nTradeFlag,double dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow,double CutOffLenghtInPip)
{

     double tmpOffset=NormalizeDouble(dOffsetDist*Point*m_PointFactor,m_nDigit);
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;

     if(IsPendingOrderExist(OP_SELLSTOP))
     {
       double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
       m_LastDeletedPrice_Supp=0;
       m_LastDeletedTime_Supp=0;         
       if(Ask<(dPendingPrice+3*Point*m_PointFactor))       
       {       
          if(nTradeFlag==false)
          {
             DeletPending(OP_SELLSTOP);
             
             double Dist=(Ask-dPendingPrice)/(Point*m_PointFactor);
             string Txt="Order filtered out by Highpass filter Symbol="+Symbol()+" at="+DoubleToStr(dPendingPrice,m_nDigit);
             //printf(Txt);
             m_LastDeletedPrice_Supp=dPendingPrice;
             m_LastDeletedTime_Supp=Time[0]; 
          }          
       }
       
       if(IsPendingOrderExist(OP_SELLSTOP))
       {
          double dStopLost=GetPendingOrderStopLost(OP_SELLSTOP);       
          double StopLevel=MarketInfo(Symbol(),MODE_STOPLEVEL)/10;
          if(dStopLost==0)
          {
             if(StopLevel>m_StopLost)
             m_StopLost=StopLevel;
             DeletPending(OP_SELLSTOP);
             Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset);
             //printf("StopLost 0");
          }
       }

       if(Ask>(dPendingPrice+tmpDeleteDist))
       {
         DeletPending(OP_SELLSTOP);
       }
       
     }
     else
     {
       m_bIsModified=false;
       if(Ask<((ZigZagLow-tmpOffset)+tmpChangeDist) && Ask>((ZigZagLow-tmpOffset)+4*Point*m_PointFactor))
       {
        if(Trade_Pending_SellStop_ByValue(ZigZagLow-tmpOffset))
        { 
         double Dist=ZigZagLow-tmpOffset;
         string Txt="New trade at="+DoubleToStr(Dist,1)+" Symbol="+Symbol();
         //printf(Txt);
        }

       }
     }

}


void TradeManager::PendingOrderAtZigZag_Res_Reverse(bool nTradeFlag,int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagHigh)
{
     double tmpOffset=dOffsetDist*Point*m_PointFactor;
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;
     
     if(m_LastDeletedPrice_Res!=0 && m_LastDeletedTime_Res!=0)
     {
        if((Time[0]-m_LastDeletedTime_Res)>PeriodSeconds()*3)
        {
           if(ZigZagHigh>m_LastDeletedPrice_Res)
           {
              if((Ask<m_LastDeletedPrice_Res) && (m_LastDeletedPrice_Res-Ask)<10*Point*m_PointFactor)
              {
                 TradeSell();
              }
              
           }
        
        }        
     }
}

void TradeManager::PendingOrderAtZigZag_Supp_Reverse(bool nTradeFlag,int dOffsetDist,int dDeleteDist,int dVisibleDist,double ZigZagLow)
{

     double tmpOffset=dOffsetDist*Point*m_PointFactor;
     double tmpChangeDist=dVisibleDist*Point*m_PointFactor;
     double tmpDeleteDist=dDeleteDist*Point*m_PointFactor;


     if(m_LastDeletedPrice_Supp!=0 && m_LastDeletedTime_Supp!=0)
     {
        if((Time[0]-m_LastDeletedTime_Supp)>PeriodSeconds()*3)
        {
           if(m_LastDeletedPrice_Supp>ZigZagLow)
           {
              if((Bid>m_LastDeletedTime_Supp) && (Bid-m_LastDeletedTime_Supp)<10*Point*m_PointFactor)
              {
                 TradeBuy();
              }
           }
        }        
     }
}



void TradeManager::PendingOrderAtZigZag(int dOffsetDist,double ZigZagHigh,double ZigZagLow)
{
  
  double tmpOffset=dOffsetDist*Point*m_PointFactor;
  double tmpChangeDist=15*Point*m_PointFactor;
  
  if(IsPendingOrderExist(OP_BUYSTOP))
  {
    double dPendingPrice=GetPendingOrderPrice(OP_BUYSTOP);
    
    dPendingPrice=dPendingPrice-tmpOffset;
    
    
    if(ZigZagHigh>(dPendingPrice+tmpChangeDist))
    {
      DeletPending(OP_BUYSTOP);
      Trade_Pending_BuyStop_ByValue_Freezing(ZigZagHigh+tmpOffset);
    }
    else if(ZigZagHigh<(dPendingPrice-tmpChangeDist))
    {
      DeletPending(OP_BUYSTOP);
      Trade_Pending_BuyStop_ByValue_Freezing(ZigZagHigh+tmpOffset);
    }
  }
  else
  {
    Trade_Pending_BuyStop_ByValue_Freezing(ZigZagHigh+tmpOffset);
  }
  
  if(IsPendingOrderExist(OP_SELLSTOP))
  {
    double dPendingPrice=GetPendingOrderPrice(OP_SELLSTOP);
    dPendingPrice=dPendingPrice+tmpOffset;

    
    if(ZigZagLow>(dPendingPrice+tmpChangeDist))
    {
      DeletPending(OP_SELLSTOP);
      Trade_Pending_SellStop_ByValue_Freezing(ZigZagLow-tmpOffset);
    }
    else if(ZigZagLow<(dPendingPrice-tmpChangeDist))
    {
      DeletPending(OP_SELLSTOP);
      Trade_Pending_SellStop_ByValue_Freezing(ZigZagLow-tmpOffset);    
    }
  }
  else
  {
    Trade_Pending_SellStop_ByValue_Freezing(ZigZagLow-tmpOffset);
  }


}

double TradeManager::CalculateOrderProfit_AllTrade()
  {
   int buys=0,sells=0;
   double dOrderProfit=0;
   double dComission=0;
   double dSwap=0;
   double dOrderPrice=0;
   double dOrderStopLost;
   
//--------------------------------
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          dOrderProfit=dOrderProfit+OrderProfit(); 
          dComission=dComission+OrderCommission(); 
          dSwap=dSwap+OrderSwap(); 
          dOrderPrice=OrderOpenPrice(); 
          dOrderStopLost=OrderStopLoss(); 
          
          
          if(OrderType()==OP_BUY)
          {
           if( (dOrderPrice-Ask)>m_AlreadyInLostLevel*Point*m_PointFactor)
           {
              m_balreadyInLost=true;
           }
           
          }
          else if(OrderType()==OP_SELL)
          {
           if( (Bid-dOrderPrice)>m_AlreadyInLostLevel*Point*m_PointFactor)
           {
              m_balreadyInLost=true;
           }
          }
        }
      }
     }
//-------------------------------    
    return  (dOrderProfit+dSwap+dComission);
  }





datetime TradeManager::LastOrderCloseTime()
  {

   datetime OrderClose_Time=0;
   
    for(int i=OrdersHistoryTotal();i>0;i--)
   {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_HISTORY))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
          if(OrderClose_Time==0)
          {
           OrderClose_Time=OrderCloseTime();
          }
          else
          {
            if(OrderCloseTime()>OrderClose_Time)
            OrderClose_Time=OrderCloseTime();
          }
        }
      }
     } 
    return  (OrderClose_Time);
  }
  
  

datetime TradeManager::LastOrderOpenTime()
  {

   datetime OrderClose_Time=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
        
          if(OrderClose_Time==0)
          {
           OrderClose_Time=OrderOpenTime();
           
          }
          else
          {
            if(OrderOpenTime()>OrderClose_Time)
            OrderClose_Time=OrderOpenTime();
          }
        }
      }
     } 
    return  (OrderClose_Time);
  }



datetime TradeManager::LastOrderCloseTimeBuyOrSell()
  {

   datetime OrderClose_Time=0;
   for(int i=0;i<OrdersHistoryTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
        
         if(OrderType()==OP_BUY ||OrderType()==OP_SELL)
         {
             if(OrderClose_Time==0)
             {
              OrderClose_Time=OrderCloseTime();
              
             }
             else
             {
               if(OrderCloseTime()>OrderClose_Time)
               OrderClose_Time=OrderCloseTime();
             }
          }
        }
      }
     } 
    return  (OrderClose_Time);
  }



bool TradeManager::CloseAllCurrentOrder()
{
   int k=0;
   int reRun=10;
   bool bClose=true;

    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
            {
               
		          k = 0;	
		          while (k<reRun)
		          {
		             //WaitUntilContex ();
		   
                   if(OrderType()==OP_SELL)
                   bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
                   else if(OrderType()==OP_BUY)
                   bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet);
         
			          if (!bClose) 
			          {
                      while (!IsTradeAllowed()) Sleep(500); 
                      RefreshRates();
			             k++;
			          }
			          else
			          {
			           break;
			          }
                }
            }
         }
      }
      
      m_LastCloseTime=iTime(NULL,0,0);
      return (true);
}

bool TradeManager::CloseAllCurrentOrderByDir(int nBuySal)
{
   int k=0;
   int reRun=10;
   bool bClose=true;

    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
            {
               
		          k = 0;	
		          while (k<reRun)
		          {
		             //WaitUntilContex ();
		   
                   if(OrderType()==nBuySal)
                   bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
                   else if(OrderType()==nBuySal)
                   bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet);
         
			          if (!bClose) 
			          {
                      while (!IsTradeAllowed()) Sleep(500); 
                      RefreshRates();
			             k++;
			          }
			          else
			          {
			           break;
			          }
                }
            }
         }
      }
      
      m_LastCloseTime=iTime(NULL,0,0);
      return (true);
}

bool TradeManager::MoveStopLostToBEP_ForLockPip()
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               int nOrderTicket=OrderTicket();
               
               if(OrderType()==OP_SELL)
               {
                 if(dStopLost>OrderPrice || dStopLost==0)
                 {
                   double Dist=(m_nLockTradePriceInPip+m_nLockTradePriceGapInPip)*Point*m_PointFactor;
                   
                   if(Ask<(OrderPrice-Dist))
                   {  
                      double Delat=m_nLockTradePriceInPip*Point*m_PointFactor;
                      double Delat1=m_TakeProfit*Point*m_PointFactor;
                   
                     bool test=OrderModify(nOrderTicket,OrderPrice,OrderPrice-Delat,OrderPrice-Delat1,OrderExpiration(),CLR_NONE);
                   }
                 }               
               }
               else if(OrderType()==OP_BUY)
               {
                 if(dStopLost<OrderPrice || dStopLost==0)
                 {
                    double Dist=(m_nLockTradePriceInPip+m_nLockTradePriceGapInPip)*Point*m_PointFactor;
                    
                   if(Bid>(OrderPrice+Dist))
                   {
                     double Delat=m_nLockTradePriceInPip*Point*m_PointFactor;
                     double Delat1=m_TakeProfit*Point*m_PointFactor;

                     bool test=OrderModify(nOrderTicket,OrderPrice,OrderPrice+Delat,OrderPrice+Delat1,OrderExpiration(),CLR_NONE);
                   }
                 }                 
               }
        }
      }
   }
 return(false);
}

bool TradeManager::MoveStopLostToBEP()
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               
               if(OrderType()==OP_SELL)
               {
                 if(dStopLost>OrderPrice)
                 {
                   bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice-6*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                 }
                 else if(dStopLost==0)
                 {
                   bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice-6*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);                    
                 }               
               }
               else if(OrderType()==OP_BUY)
               {
                 if(dStopLost<OrderPrice)
                 {
                  bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice+6*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                 } 
                 else if(dStopLost==0)
                 {                 
                  bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice+6*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                 }                
               }
        }
      }
   }
 return(false);
}
bool TradeManager::MoveStopLostFromOrder(double DeltaInPips)
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               
               if(OrderType()==OP_BUY)
               {
                   bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice-DeltaInPips*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
               }
               else if(OrderType()==OP_SELL)
               {
                  bool test=OrderModify(OrderTicket(),OrderPrice,OrderPrice+DeltaInPips*Point*m_PointFactor,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
               }
        }
      }
   }
 return(false);
}

bool TradeManager::MoveStopLostFromExitingStopLOst(double DeltaInPips)
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   
  double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               
               
               if(OrderType()==OP_SELL)
               {
                 //if(dStopLost>OrderPrice)
                 {
                   double NewStopLost=dStopLost-DeltaInPips*Point*m_PointFactor;
                                      
                   bool test=OrderModify(OrderTicket(),OrderPrice,NewStopLost,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                 }
               }
               else if(OrderType()==OP_BUY)
               {
                 //if(dStopLost<OrderPrice)
                 {
                  double NewStopLost=dStopLost+DeltaInPips*Point*m_PointFactor;
                  
                  bool test=OrderModify(OrderTicket(),OrderPrice,NewStopLost,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                 }
               }
        }
      }
   }
 return(false);
}


bool TradeManager::ModifyStopLostFromExitingStopLost(double DeltaInPips, int nOrderType)
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double dOrderPrice=0;
   double dOrderTP=0;
   
  double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               dOrderPrice=OrderOpenPrice();
               
               
               if(OrderType()==nOrderType)
               {
                     if(OrderType()==OP_SELL)
                     {
                          double NewStopLost=dOrderPrice+DeltaInPips*Point*m_PointFactor;  
                          
                       if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),NewStopLost,OrderTakeProfit()))
                       {
                                          
                          bool test=OrderModify(OrderTicket(),dOrderPrice,NewStopLost,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                       }
                        
                     }
                     else if(OrderType()==OP_BUY)
                     {
                           double NewStopLost=dOrderPrice-DeltaInPips*Point*m_PointFactor;
                       if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),NewStopLost,OrderTakeProfit()))
                       {

                           bool test=OrderModify(OrderTicket(),dOrderPrice,NewStopLost,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                       }

                     }
                }
        }
      }
   }
 return(false);
}


bool TradeManager::TraillingStop_TimeBase()
{

   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   double dOrderTakePrice=0;
   datetime dtOrderOpenTime=0;
   m_DebufInfo_TrailingStop="\n\r";
   
   int duration=15;
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               int nOrderTicket=OrderTicket();
               double dOrderStopLost=OrderStopLoss();
               dOrderTakePrice=OrderTakeProfit();
               dtOrderOpenTime=OrderOpenTime();
               
               if((TimeCurrent()-dtOrderOpenTime)>duration)
               {
                 //int duration=TimeCurrent()-dtOrderOpenTime; 
                 //string strData="-- The Duration After---"+duration; 
                 //Print(strData);
                
               if(OrderType()==OP_SELL)
               {
                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";               
                    if(dStopLost>OrderPrice ||dStopLost==0)
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Sell dStopLost>OrderPrice || 0"+"\n\r";
                      double PipMoved=(OrderPrice-Ask)/(Point*m_PointFactor);
                      
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Pip Moved="+DoubleToStr(PipMoved,2)+"\n\r";
                      
                      if(Ask<(OrderPrice-(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                         double delta=m_TrailingStop*Point*m_PointFactor;
                         double Delata1=m_TakeProfit*Point*m_PointFactor;
                         
                         bool tes=OrderModify(nOrderTicket,OrderPrice,OrderPrice-delta,OrderPrice-Delata1,OrderExpiration(),CLR_NONE);
                         if(tes)
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                         }
                         else
                         {
                           //m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed "+GetLastError()+" Delta ="+delta+"\n\r";;                         
                         }
                      }
                      else
                      {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Waiting more condition to satiesfy"+"\n\r";;                         
                        
                      }
                    }
                    else
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Sell dStopLost < OrderPrice"+"\n\r";
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";

                      
                      if(Ask<(dStopLost-m_TrailingStopGap*Point*m_PointFactor))
                      {
                         double Delat=m_TrailingStopGap*Point*m_PointFactor;
                         
                         double NewStopLost=(dStopLost-Delat)-Bid;
                         double Delata1=m_TakeProfit*Point*m_PointFactor;
                         
                         bool tes=OrderModify(nOrderTicket,OrderPrice,dStopLost-NewStopLost,OrderPrice-Delata1,OrderExpiration(),CLR_NONE);
                      }
                    }
               }
               else if(OrderType()==OP_BUY)
               {    
                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";               
               
                    if(OrderPrice>dStopLost|| OrderPrice==0)
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy OrderPrice > dStopLost or dStopLost=0 "+"\n\r";
                      
                       double PipMoved=(Bid-OrderPrice)/(Point*m_PointFactor);
                       
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Pip Moved="+DoubleToStr(PipMoved,2)+"\n\r";
                    
                      if(Bid>(OrderPrice+(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                         double Delat=m_TrailingStop*Point*m_PointFactor;
                         double Delata1=m_TakeProfit*Point*m_PointFactor;
                         bool tes=OrderModify(nOrderTicket,OrderPrice,OrderPrice+Delat,OrderPrice+Delata1,OrderExpiration(),CLR_NONE); 
                         if(tes)
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                         }
                         else
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed"+"\n\r";;                         
                         }
                      }
                      else
                      {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Waiting more condition to satiesfy"+"\n\r";;                                                  
                      }
                     
                    }
                    else
                    {
                     if(Bid>(dStopLost+m_TrailingStopGap*Point*m_PointFactor))
                     {
                         m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy dStopLost>OrderPrice or dStopLost=0 "+"\n\r";
                         
                         double Delat=m_TrailingStopGap*Point*m_PointFactor;
                         double NewStopLost=Bid-(dStopLost+Delat);
                         double Delata1=m_TakeProfit*Point*m_PointFactor;
                         
                         bool tes=OrderModify(nOrderTicket,OrderPrice,(dStopLost+NewStopLost),OrderPrice+Delata1,OrderExpiration(),CLR_NONE);
                     } 
                    }
               }//----------
            }
            else
            {
                 //int duration=TimeCurrent()-dtOrderOpenTime; 
                 //string strData="-- The Duration before---"+duration; 
                 //Print(strData);
            }  
        }
      }
   }

 return (true);
}

bool TradeManager::TraillingStop_1()
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   double dOrderTakePrice=0;
   m_DebufInfo_TrailingStop="\n\r";
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               int nOrderTicket=OrderTicket();
               double dOrderStopLost=OrderStopLoss();
               dOrderTakePrice=OrderTakeProfit();
               
               if(OrderType()==OP_SELL)
               {
                    if(dStopLost>OrderPrice ||dStopLost==0)
                    {
                      double PipMoved=(OrderPrice-Ask);
                      
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Pip Moved="+DoubleToStr(PipMoved/(Point*m_PointFactor),2)+"\n\r";
                      
                      if(PipMoved>0)
                      {
                         double dNewStopLost=(Ask+m_StopLost*Point*m_PointFactor);
                         double dNewTP=dOrderTakePrice;
                        
                         if(dStopLost==0)
                         {
                            bool tes=OrderModify(nOrderTicket,OrderPrice,dNewStopLost,dNewTP,OrderExpiration(),CLR_NONE);
                            if(tes)
                            {
                              m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                            }
                            else
                            {
                              //m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed "+GetLastError()+" Delta at="+dNewStopLost+"\n\r";;                         
                            }
                         
                         }
                         else if((dOrderStopLost-dNewStopLost)>0.2*Point*m_PointFactor)
                         {
                            
                            bool tes=OrderModify(nOrderTicket,OrderPrice,dNewStopLost,dNewTP,OrderExpiration(),CLR_NONE);
                            if(tes)
                            {
                              m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                            }
                            else
                            {
                              //m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed "+GetLastError()+" Delta ="+dNewStopLost+"\n\r";;                         
                            }
                            
                         }
                      }
                      else
                      {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Waiting more condition to satiesfy"+"\n\r";;                         
                        
                      }
                    }
                    else
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Sell dStopLost < OrderPrice"+"\n\r";
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";

                      
                      if(Ask<(dStopLost-m_TrailingStopGap*Point*m_PointFactor))
                      {
                         double TrailingDist=m_TrailingStopGap*Point*m_PointFactor;                         
                         double dNewStoplost=Ask+TrailingDist;
                                                  
                         // -Ve current stoplost is lowered down to new stoplost
                         bool tes=OrderModify(nOrderTicket,OrderPrice,dNewStoplost,dOrderTakePrice,OrderExpiration(),CLR_NONE);
                         if(tes)
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                         }
                         else
                         {
                           //m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed "+GetLastError()+" Delta ="+dNewStoplost+"\n\r";;                         
                         }
                         
                      }
                    }
               }
               else if(OrderType()==OP_BUY)
               {    
                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";               
               
                    if(OrderPrice>dStopLost|| OrderPrice==0)
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy OrderPrice > dStopLost or dStopLost=0 "+"\n\r";
                      
                       double PipMoved=(Bid-OrderPrice);///(Point*m_PointFactor);
                       
                       if(PipMoved>0)
                       {
                         double dNewStopLost=(Bid-m_StopLost*Point*m_PointFactor);
                         double dNewTP=dOrderTakePrice;
                         
                          if(dStopLost==0)
                          {
                               bool tes=OrderModify(nOrderTicket,OrderPrice,dNewStopLost,dNewTP,OrderExpiration(),CLR_NONE); 
                               if(tes)
                               {
                                 m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                               }
                               else
                               {
                                 m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed"+"\n\r";;                         
                               }
                          }
                          else if((dNewStopLost-dStopLost)>0.2*Point*m_PointFactor)
                          {
                               bool tes=OrderModify(nOrderTicket,OrderPrice,dNewStopLost,dNewTP,OrderExpiration(),CLR_NONE); 
                               if(tes)
                               {
                                 m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                               }
                               else
                               {
                                 m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed"+"\n\r";;                         
                               }
                          }
                       }                       
                    }
                    else
                    {
                     if(Bid>(dStopLost+m_TrailingStopGap*Point*m_PointFactor))
                     {
                         m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy dStopLost>OrderPrice or dStopLost=0 "+"\n\r";
                         
                         double dTrailingGap=m_TrailingStopGap*Point*m_PointFactor;
                         double NewStopLost=Bid-(dTrailingGap);
                                                  
                         bool tes=OrderModify(nOrderTicket,OrderPrice,NewStopLost,dOrderTakePrice,OrderExpiration(),CLR_NONE);
                         if(tes)
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                         }
                         else
                         {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed"+"\n\r";;                         
                         }
                         
                     } 
                    }
               }
        }
      }
   }
 return(0);
}


bool TradeManager::TraillingStop_AI()
{
   bool bClose=0;
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   double OrderTp=0;
   
   m_DebufInfo_TrailingStop="\n\r";
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               OrderTp   =OrderTakeProfit();
               
               
               
               int nOrderTicket=OrderTicket();
               
               if(OrderType()==OP_SELL)
               {
                    if(m_trailing_stop_AI==0)
                    {
                      double PipMoved=(OrderPrice-Ask)/(Point*m_PointFactor);
                                            
                      if(Bid<(OrderPrice-(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                         double delta=m_TrailingStop*Point*m_PointFactor;
                         m_trailing_stop_AI=OrderPrice-delta;
                                  
                      }
                    }
                    else
                    {
                      
                      if(Bid<(m_trailing_stop_AI-(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                            double Delat1=m_TrailingStop*Point*m_PointFactor;                           
                            m_trailing_stop_AI=m_trailing_stop_AI-Delat1;                            
                      }
                    }
                    
                    
                
                  if(Bid>(dStopLost-5*Point*m_PointFactor))
                  {     
                     bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),1,Violet);
                     m_trailing_stop_AI=0;
                     
                     //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());
                     
                  }
                  else if(Bid>m_trailing_stop_AI && m_trailing_stop_AI>0)
                  {
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),1,Violet);
                      m_trailing_stop_AI=0;
                      //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());
     
                  }
                  else if((Bid-OrderTp)<2*Point*m_PointFactor)
                  {
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),1,Violet);
                      m_trailing_stop_AI=0;
                      //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());
                  
                  }
               }
               else if(OrderType()==OP_BUY)
               {    
                    if(m_trailing_stop_AI==0)
                    {
                      
                       double PipMoved=(Bid-OrderPrice)/(Point*m_PointFactor);
                                           
                      if(Bid>(OrderPrice+(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                            double Delat=m_TrailingStop*Point*m_PointFactor;
                                                 
                            m_trailing_stop_AI=  OrderPrice+Delat;
                      }
                    }
                    else
                    {

                         if(Ask>(m_trailing_stop_AI+(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                         {
                            double Delat=m_TrailingStop*Point*m_PointFactor;
                            m_trailing_stop_AI=(m_trailing_stop_AI+Delat);
                         }
                                                              
                    }
                    
                    if(Ask<(dStopLost+5*Point*m_PointFactor))
                    {
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),1,Violet);
                      
                      m_trailing_stop_AI=0;
                      //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());

                    }
                    else if(Ask<m_trailing_stop_AI && m_trailing_stop_AI>0)
                    {
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),1,Violet);
                      m_trailing_stop_AI=0;
                      //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());

                    }
                    else if((OrderTp-Ask)<5*Point*m_PointFactor)
                    {
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),1,Violet);                     
                      m_trailing_stop_AI=0;                    
                      //m_AI_Engine.m_TradeRecord.WriteDataDetail(OrderTicket(),m_MagicNumber,OrderType(),OrderProfit(),OrderOpenPrice());
                    }
                    
               }//--------
        }
      }
   }
 return(0);

}

bool TradeManager::TraillingStop()
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   m_DebufInfo_TrailingStop="\n\r";
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               dStopLost=OrderStopLoss();
               OrderPrice=OrderOpenPrice();
               int nOrderTicket=OrderTicket();
               
               bool SL_check=false,TP_check=false;
               
               if(OrderType()==OP_SELL)
               {
                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";               
                    if(dStopLost>OrderPrice ||dStopLost==0)
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Sell dStopLost>OrderPrice || 0"+"\n\r";
                      double PipMoved=(OrderPrice-Ask)/(Point*m_PointFactor);
                      
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Pip Moved="+DoubleToStr(PipMoved,2)+"\n\r";
                      
                      if(Ask<(OrderPrice-(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                         double delta=m_TrailingStop*Point*m_PointFactor;
                         double Delata1=m_TakeProfit*Point*m_PointFactor;
                         
                                if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderPrice-delta,OrderTakeProfit()))
                                {                         
                                  // prosanta 
                                  bool tes=OrderModify(nOrderTicket,OrderOpenPrice(),OrderPrice-delta,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                                  if(tes)
                                  {
                                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                                  }
                                  else
                                  {
                                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed "+GetLastError()+" Delta ="+delta+"\n\r";;   
                                    
                                    
                                    //printf(m_DebufInfo_TrailingStop);
                                                          
                                  }
                                }
                      }
                      else
                      {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Waiting more condition to satiesfy"+"\n\r";;                         
                        
                      }
                    }
                    else
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Sell dStopLost < OrderPrice"+"\n\r";
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";

                      
                      if(Ask<(dStopLost-((m_TrailingStopGap+1)*Point*m_PointFactor)))
                      {
                            double Delat=1*Point*m_PointFactor;
                            
                            //double NewStopLost=(dStopLost-Delat)-Bid;
                            double Delata1=m_TakeProfit*Point*m_PointFactor;
                            
                                if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),dStopLost-Delat,OrderTakeProfit()))
                                {                         
                            
                                  bool tes=OrderModify(nOrderTicket,OrderOpenPrice(),dStopLost-Delat,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                                }
                      }
                    }
               }
               else if(OrderType()==OP_BUY)
               {    
                    m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+"Traing Stop in Pip="+DoubleToStr(m_TrailingStop,1)+" Stop Gap="+DoubleToStr(m_TrailingStopGap)+"\n\r";               
               
                    if(OrderPrice>dStopLost|| OrderPrice==0)
                    {
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy OrderPrice > dStopLost or dStopLost=0 "+"\n\r";
                      
                       double PipMoved=(Bid-OrderPrice)/(Point*m_PointFactor);
                       
                      m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Pip Moved="+DoubleToStr(PipMoved,2)+"\n\r";
                    
                      if(Bid>(OrderPrice+(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                            double Delat=m_TrailingStop*Point*m_PointFactor;
                            double Delata1=m_TakeProfit*Point*m_PointFactor;
              
                          if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderPrice+Delat,OrderTakeProfit()))
                          {                         

                            
                            bool tes=OrderModify(nOrderTicket,OrderPrice,OrderPrice+Delat,OrderTakeProfit(),OrderExpiration(),CLR_NONE); 
                            if(tes)
                            {
                              m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                            }
                            else
                            {
                              m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify failed"+"\n\r";;  
                              //printf(m_DebufInfo_TrailingStop);                       
                            }
                          }
                      }
                      else
                      {
                           m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Waiting more condition to satiesfy"+"\n\r";;                                                  
                      }
                     
                    }
                    else
                    {
                     if(Bid>(dStopLost+((1+m_TrailingStopGap)*Point*m_PointFactor)))
                     {
                         m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Buy dStopLost>OrderPrice or dStopLost=0 "+"\n\r";
                               
                               double Delat=1*Point*m_PointFactor;
                               double NewStopLost=Bid-(dStopLost+Delat);
                               double Delata1=m_TakeProfit*Point*m_PointFactor;

                         
                          if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),(dStopLost+Delat),OrderTakeProfit()))
                          {                         

                               
                               bool tes=OrderModify(nOrderTicket,OrderOpenPrice(),(dStopLost+Delat),OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                           }
                     } 
                    }
               }//--------
        }
      }
   }
 return(false);
}

bool TradeManager::TraillingStop_New()
{
   int Count=0;
   double OrderLot=0;
   double dStopLost=0;
   double OrderPrice=0;
   m_DebufInfo_TrailingStop="\n\r";
   
  /*
  double PointValue;
  for (int i = 0; i < OrdersTotal(); i++) 
  {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)==true)
      if (OrderSymbol() != Symbol()) continue; // Skipping positions in other currency pairs
      //Calculate the point value in case there are extra digits in the quotes
      if (MarketInfo(OrderSymbol(), MODE_POINT) == 0.00001) PointValue = 0.0001;
      else if (MarketInfo(OrderSymbol(), MODE_POINT) == 0.001) PointValue = 0.01;
      else PointValue = MarketInfo(OrderSymbol(), MODE_POINT);
      //Normalize trailing stop value to the point value
      double TSTP = TrailingStop * PointValue;
 
      if (OrderType() == OP_BUY)
      {
         if (Bid - OrderOpenPrice() > TSTP)
         {
            if (OrderStopLoss() < Bid - TSTP)
            {
               if (!OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TSTP, OrderTakeProfit(), Red))
                  Print("Error setting Buy trailing stop: ", GetLastError());
            }
         }
         else if ((OrderStopLoss() != Bid - StopLoss * PointValue) && 
                   (StopLoss != 0) && (OrderStopLoss() == 0))
            {
                    if (!OrderModify(OrderTicket(), OrderOpenPrice(), Bid - StopLoss * PointValue, OrderTakeProfit(), Red))
                     Print("Error setting Buy stop-loss: ", GetLastError());
            }
      }
      else if (OrderType() == OP_SELL)
      {
         if (OrderOpenPrice() - Ask > TSTP)
         {
            if ((OrderStopLoss() > Ask + TSTP) || (OrderStopLoss() == 0))
            {
               if (!OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TSTP, OrderTakeProfit(), Red))
                  Print("Error setting Sell trailing stop: ", GetLastError());
            }
         }
         else if ((OrderStopLoss() != Ask + StopLoss * PointValue) && 
                   (StopLoss != 0) && (OrderStopLoss() == 0))
             {
                  if (!OrderModify(OrderTicket(), OrderOpenPrice(), Ask + StopLoss * PointValue, OrderTakeProfit(), Red))
                     Print("Error setting Sell stop-loss: ", GetLastError());
             }
      }
	}
   */


   for(int i=OrdersTotal();i>0;i--)
   {
      if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               
               bool SL_check=false,TP_check=false;
               
               if(OrderType()==OP_SELL)
               {
                     dStopLost=OrderStopLoss();
                     OrderPrice=OrderOpenPrice();
                     int nOrderTicket=OrderTicket();

                    if(dStopLost>OrderPrice ||dStopLost==0)
                    {
                      double PipMoved=(OrderPrice-Ask)/(Point*m_PointFactor);
                                            
                      if(Ask<(OrderPrice-(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                          double delta=m_TrailingStop*Point*m_PointFactor;
                         
                          if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-delta,OrderTakeProfit()))
                          {                         
                            // prosanta 
                            RefreshRates();
                            if(OrderTicket()>=0)
                            {
                              bool tes=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-delta,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                            }
                          }
                       }
                    }
                    else
                    {
                      if(Ask<(dStopLost-((m_TrailingStopGap+m_TrailingStop)*Point*m_PointFactor)))
                      {
                            double Delat=OrderStopLoss()-m_TrailingStopGap*Point*m_PointFactor;
                            
                            //double NewStopLost=(dStopLost-Delat)-Bid;
                            //double Delata1=m_TakeProfit*Point*m_PointFactor;
                            
                                
                                if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),Delat,OrderTakeProfit()))
                                {             
                                  RefreshRates();        
                                  if(OrderTicket()>=0)
                                  {
                                    bool tes=OrderModify(OrderTicket(),OrderOpenPrice(),Delat,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                                  }
                                }
                      }
                    }
               }
               else if(OrderType()==OP_BUY)
               {    
               
                     dStopLost=OrderStopLoss();
                     OrderPrice=OrderOpenPrice();
                     int nOrderTicket=OrderTicket();
               
                    if(OrderPrice>dStopLost|| dStopLost==0)
                    {
                      
                       double PipMoved=(Bid-OrderPrice)/(Point*m_PointFactor);
                                           
                      if(Bid>(OrderPrice+(m_TrailingStop*Point*m_PointFactor+m_TrailingStopGap*Point*m_PointFactor)))
                      {
                            double Delat=m_TrailingStop*Point*m_PointFactor;
              
                          
                          if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Delat,OrderTakeProfit()))
                          {
                                                                                  
                            RefreshRates() ;           
                            if(OrderTicket()>=0)
                            {
                               bool tes=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+Delat,OrderTakeProfit(),OrderExpiration(),CLR_NONE); 
                               if(tes)
                               {
                                 m_DebufInfo_TrailingStop=m_DebufInfo_TrailingStop+" Modify Ticket"+"\n\r";;
                               }
                            }
                          }
                      }
                    }
                    else
                    {
                     if(Bid>(dStopLost+((m_TrailingStop+m_TrailingStopGap)*Point*m_PointFactor)))
                     {
                               
                          double Delat=dStopLost+m_TrailingStop*Point*m_PointFactor;
                         
                          if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),Delat,OrderTakeProfit()))
                          {                         

                            RefreshRates();            
                            if(OrderTicket()>=0)
                            {
                               
                               bool tes=OrderModify(OrderTicket(),OrderOpenPrice(),Delat,OrderTakeProfit(),OrderExpiration(),CLR_NONE);
                            }
                           }
                     } 
                    }
               }//--------
        }
      }
   }
   

 return(0);
}


void TradeManager::WaitUntilContex ()
{
   if (!IsTesting())
   {
   
	  while (IsTradeContextBusy() == TRUE)
	  {

		  Sleep(100);
		  RefreshRates();		  
		  
	  }
	  
	}
}


int TradeManager::TradeBuy()
{
   int Order_ID;
   int K=0;
   int nRepeat=10;
   int nSleep=100;
   
     int TcketID=0;

   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
//   if((iTime(NULL,PERIOD_M30,0)-LastOrderCloseTime)>(Period()*60)*4)
   {

      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_BUY,m_LotsSize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0);;          
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }


     Order_ID=TcketID;
     
     if(TcketID<0)
     {
         int ErrorCode = GetLastError();
         
         string ErrLog = StringConcatenate("Error Code",ErrorCode,"Bid: ",Bid," Ask: ",Ask," Lots: ",m_LotsSize," | Current Spread: ",MODE_SPREAD," | Min Lot size expected: ",MODE_STOPLEVEL);
         //Print(ErrLog);     
     
     }  
     else
     {
       bool test=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
       
       
       test=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,0,CLR_NONE);
     } 
  }   
   
   return Order_ID;
}

int TradeManager::TradeBuywithTimefilter()
{
   int Order_ID;
   int K=0;
   int nRepeat=10;
   int nSleep=100;
   
     int TcketID=0;

   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
   if((iTime(NULL,PERIOD_M30,0)-LastOrderCloseTime)>(Period()*60)*4)
   {

      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_BUY,m_LotsSize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0);;          
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }


     Order_ID=TcketID;
     
     if(TcketID<0)
     {
         int ErrorCode = GetLastError();
         
         string ErrLog = StringConcatenate("Error Code",ErrorCode,"Bid: ",Bid," Ask: ",Ask," Lots: ",m_LotsSize," | Current Spread: ",MODE_SPREAD," | Min Lot size expected: ",MODE_STOPLEVEL);
         //Print(ErrLog);     
     
     }  
     else
     {
       bool test=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
       
       
       test=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,0,CLR_NONE);
     } 
  }   
   
   return Order_ID;
}
   
int TradeManager::TradeSell()
{
   int Order_ID=0;
   int K=0;
   int nRepeat=10;
   int nSleep=100;


   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
   //if((iTime(NULL,PERIOD_M30,0)-LastOrderCloseTime)>(Period()*60)*4)
   {
     int TcketID=0;

      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_SELL,m_LotsSize,Bid,3,0,0,m_TradeComment,m_MagicNumber,0);          
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }

     
     Order_ID=TcketID;
     
     if(TcketID<0)
     {
         int ErrorCode = GetLastError();
         
         string ErrLog = StringConcatenate("Error Code",ErrorCode,"Bid: ",Bid," Ask: ",Ask," Lots: ",m_LotsSize," | Current Spread: ",MODE_SPREAD," | Min Lot size expected: ",MODE_STOPLEVEL);
         Print(ErrLog);     
     
     }  
     else
     {
       bool test=OrderSelect(TcketID,SELECT_BY_TICKET);

       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
       
       string ID="xxxxxx Tickted ID "+ TcketID+" xxxxxxxxxxxxxx";
       
       //Print(ID);
       
       if(test)
       test=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
     } 
  }
  return Order_ID;
}


int TradeManager::TradeSellwithTimefilter()
{
   int Order_ID=0;
   int K=0;
   int nRepeat=10;
   int nSleep=100;


   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
   if((iTime(NULL,PERIOD_M30,0)-LastOrderCloseTime)>(Period()*60)*4)
   {
     int TcketID=0;

      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_SELL,m_LotsSize,Bid,3,0,0,m_TradeComment,m_MagicNumber,0);          
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }

     
     Order_ID=TcketID;
     
     if(TcketID<0)
     {
         int ErrorCode = GetLastError();
         
         string ErrLog = StringConcatenate("Error Code",ErrorCode,"Bid: ",Bid," Ask: ",Ask," Lots: ",m_LotsSize," | Current Spread: ",MODE_SPREAD," | Min Lot size expected: ",MODE_STOPLEVEL);
         Print(ErrLog);     
     
     }  
     else
     {
       bool test=OrderSelect(TcketID,SELECT_BY_TICKET);

       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
       
       string ID="xxxxxx Tickted ID "+ TcketID+" xxxxxxxxxxxxxx";
       
       //Print(ID);
       
       if(test)
       test=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
     } 
  }
  return Order_ID;
}



bool TradeManager::Trade_Pending_SellStop(int nPipLevelFromCurrent)
{


   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLSTOP)==false)
   {
     int TcketID=OrderSend(Symbol(),OP_SELLSTOP,m_LotsSize,Bid-nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
       return true;
     } 
   }
  }
  return false;
}

bool TradeManager::Trade_Pending_SellStop_Freezing(int nPipLevelFromCurrent)
{


   datetime  LastOrderCloseTime=LastOrderCloseTime();
   
   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLSTOP)==false)
   {
     int TcketID=OrderSend(Symbol(),OP_SELLSTOP,m_LotsSize,Bid-nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
       if(m_bEnableFreez==false)
       {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+m_StopLost*Point*m_PointFactor,OrderOpenPrice()-m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
       }
       
       return true;
     } 
   }
  }
  return false;
}



bool TradeManager::Trade_Pending_SellLimit(int nPipLevelFromCurrent)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLLIMIT)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_SELLLIMIT,m_LotsSize,Ask+nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);

       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;

        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
       return true;
     } 
   }
  }
  return false;
}
   


bool TradeManager::Trade_Pending_BuyStop_Freezing(int nPipLevelFromCurrent)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {
   
   if(IsPendingOrderExist(OP_BUYSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_BUYSTOP,m_LotsSize,Ask+nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
      if(m_bEnableFreez==false)
      {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-m_StopLost*Point*m_PointFactor,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
      }
       return true;
     }
   } 
  }     
   return(false);

}

   
bool TradeManager::Trade_Pending_BuyStop(int nPipLevelFromCurrent)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {
   
   if(IsPendingOrderExist(OP_BUYSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_BUYSTOP,m_LotsSize,Ask+nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,0,CLR_NONE);
       return true;
     }
   } 
  }     
   return(false);

}
bool TradeManager::Trade_Pending_BuyLimit(int nPipLevelFromCurrent)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_BUYLIMIT)==false)
   {
     int TcketID=OrderSend(Symbol(),OP_BUYLIMIT,m_LotsSize,Ask-nPipLevelFromCurrent*Point*m_PointFactor,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
         tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,0,CLR_NONE);
       return true;
     }
   } 
  }     
   return(false);
}

bool TradeManager::Trade_Pending_SellStop_ByValue_Freezing(double dVal)
{

   if(IsPendingOrderExist(OP_SELLSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_SELLSTOP,m_LotsSize,NormalizeDouble(dVal,5),3,0,0,m_TradeComment,m_MagicNumber,0);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
       if(m_bEnableFreez==false)
       {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+m_StopLost*Point*m_PointFactor,OrderOpenPrice()-m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
       }
       
       return true;
     } 
   }
  return false;

}


bool TradeManager::Trade_Pending_SellStop_ByValue(double dVal)
{
   int nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_SELLSTOP,m_LotsSize,NormalizeDouble(dVal,nDigit),3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
       return true;
     } 
   }
  }
  return false;

}

bool TradeManager::Trade_Pending_SellStop_ByValue_M(double dVal, int nMagic)
{
   datetime  LastOrderCloseTime=LastOrderCloseTime();

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_SELLSTOP,m_LotsSize,dVal,3,0,0,m_TradeComment,nMagic,0,CLR_NONE);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,0,CLR_NONE);
       return true;
     } 
   }
  }
  return false;

}

bool TradeManager::Trade_Pending_SellLimit_ByValue(double dVal)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_SELLLIMIT)==false)
   {
     datetime dtExpire=iTime(Symbol(),0,0)+60*60*5;// 5 hours
     
     int TcketID=OrderSend(Symbol(),OP_SELLLIMIT,m_LotsSize,dVal,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);
     
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+Delta,OrderOpenPrice()-Delta1,OrderExpiration(),CLR_NONE);
       return true;
     } 
   }
  }
  return false;

}
bool TradeManager::Trade_Pending_BuyStop_ByValue_Freezing(double dVal)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();
   int nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_BUYSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_BUYSTOP,m_LotsSize,NormalizeDouble(dVal,nDigit),3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
       if(m_bEnableFreez==false)
       {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-m_StopLost*Point*m_PointFactor,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
       }
       
       return true;
     } 
   }
  }     
   return(false);

}


bool TradeManager::Trade_Pending_BuyStop_ByValue(double dVal)
{

   int nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {

   if(IsPendingOrderExist(OP_BUYSTOP)==false)
   {
   
     int TcketID=OrderSend(Symbol(),OP_BUYSTOP,m_LotsSize,NormalizeDouble(dVal,nDigit),3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,0,CLR_NONE);
       return true;
     } 
   }
  }     
   return(false);

}



bool TradeManager::Trade_Pending_Modify_ByValue(double dVal,int nPendingType)
{

   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
               double dStopLost=OrderStopLoss();
               double dOrderTakeProfit=OrderTakeProfit();               
               if(OrderType()==nPendingType)
               {
                  bool test=OrderModify(OrderTicket(),dVal,dStopLost,dOrderTakeProfit,OrderExpiration(),CLR_NONE) ; 
               }
         }
       }
     }          


   return(true);

}


bool TradeManager::Trade_Pending_BuyLimit_ByValue(double dVal)
{

   datetime  LastOrderCloseTime=LastOrderCloseTime();

   //if((iTime(NULL,0,0)-LastOrderCloseTime)>(Period()*60)*1)
   {
   if(IsPendingOrderExist(OP_BUYLIMIT)==false)
   {
   
     datetime dtExpire=iTime(Symbol(),0,0)+60*60*5;
     int TcketID=OrderSend(Symbol(),OP_BUYLIMIT,m_LotsSize,dVal,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
       double Delta=m_StopLost*Point*m_PointFactor;
       double Delta1=m_TakeProfit*Point*m_PointFactor;
        
        tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-Delta,OrderOpenPrice()+Delta1,OrderExpiration(),CLR_NONE);
       return true;
     } 
   }
   }
   return(false);
}




bool TradeManager::TradeBuy(double dStopLost)
{

   int Order_ID;
   int K=0;
   int nRepeat=10;
   int nSleep=100;
   
     int TcketID=0;
      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_BUY,m_LotsSize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);          
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }
     
    
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
         //tes=OrderModify(TcketID,OrderOpenPrice(),dStopLost,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
        K=0;
        nRepeat=10;

         int TcketID_1=-1;
         while(K<nRepeat)
         {
             //TcketID=OrderSend(Symbol(),OP_BUY,m_LotsSize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE); 
             TcketID_1=OrderModify(TcketID,OrderOpenPrice(),dStopLost,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);         
             if(TcketID_1>=0)
             {
                K=nRepeat; 
                break;       
             }
             else
             {
                K++;
                Sleep(nSleep);
                RefreshRates();
             }                  
         }


       return true;
     } 
  
   
   return(false);
}

bool TradeManager::TradeSell(double dStopLost)
{
   int K=0;
   int nRepeat=10;
   int nSleep=100;
   
   int TcketID=0;

      while(K<nRepeat)
      {
          TcketID=OrderSend(Symbol(),OP_SELL,m_LotsSize,Bid,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);          
         
          if(TcketID>=0)
          {
             K=nRepeat; 
             break;       
          }
          else
          {
             K++;
             Sleep(nSleep);
             RefreshRates();
          }                  
      }

     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
         //tes=OrderModify(TcketID,OrderOpenPrice(),dStopLost,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
        K=0;
        nRepeat=10;
        //Print("----------MOD------------");
        
        int TcketID_1=-1;
        
         while(K<nRepeat)
         {
             //TcketID=OrderSend(Symbol(),OP_BUY,m_LotsSize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE); 
             TcketID_1=OrderModify(TcketID,OrderOpenPrice(),dStopLost,OrderOpenPrice()-m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
         
             if(TcketID_1>=0)
             {
                K=nRepeat; 
                break;       
             }
             else
             {
                K++;
                Sleep(nSleep);
                RefreshRates();
             }                  
         }

       
       
       
       return true;
     } 
     
     return(false);


}

bool TradeManager::TradeBuy(double dLotsize,double dStopLostInPip)
{

     int TcketID=OrderSend(Symbol(),OP_BUY,dLotsize,Ask,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     
    
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
         tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()-dStopLostInPip*Point*m_PointFactor,OrderOpenPrice()+m_TakeProfit*Point*m_PointFactor,0,CLR_NONE);
       return true;
     } 
}

bool TradeManager::TradeSell(double dLotsize,double dStopLostInPip)
{

     int TcketID=OrderSend(Symbol(),OP_SELL,dLotsize,Bid,3,0,0,m_TradeComment,m_MagicNumber,0,CLR_NONE);

     
    
     if(TcketID<0)
     {
      return false;
     }  
     else
     {
        bool tes=OrderSelect(TcketID,SELECT_BY_TICKET);
         tes=OrderModify(TcketID,OrderOpenPrice(),OrderOpenPrice()+dStopLostInPip*Point*m_PointFactor,OrderOpenPrice()-m_TakeProfit*Point*m_PointFactor,0);
       return true;
     } 

}


void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Spartucus(int nTimeDuration,int nTimeDuration2,int HardCloseTimeDuration,int StepingStoneTime,bool StopLOstMoving) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     double tmpiForce[3];
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
    
    
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);

     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
     
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
       
     int nTimeSecond=TimeSeconds(TimeCurrent())+TimeMinute(TimeCurrent())*60;
     
     int nSecondOrdrOpen=TimeMinute(dtdatetime)+TimeMinute(dtdatetime)*60;
     
     int nElapseTime=nTimeSecond-nSecondOrdrOpen;
     
    m_DebugInfo1_TimingCheck=" Elapse : "+IntegerToString(nElapseTime)+"\n\r"; 
    
    //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(TotalinSecond)+"\n\r"; 
    //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
     
      if(m_nTimeCounter==0)
      m_nTimeCounter=nTimeSecond;
   
      if(m_nTimeCounter1==0)
      m_nTimeCounter1=nTimeSecond;
   
   
      
      
      
      if(dProfit>0)
      {
         //MoveStopLostFromExitingStopLOst((1+Spread));
        if(nOrderType==OP_BUY)
        {
           double PipGained=(Ask- dOrderPrice)/(Point*10);
           if(PipGained>1.0)
           {
             if(tmpiForce[0]<=tmpiForce[1])
             {
               CloseAllCurrentOrder();
             }
              if(PipGained>5)
              {
              
              }
              else if(PipGained>4)
              {
                MoveStopLostFromOrder(-2);
              }
              else if(PipGained>2)
              {
                 MoveStopLostFromOrder(-1);
              }                     
           }
           else if(PipGained>0.5)
           {
              MoveStopLostFromOrder(2.0);
           }        
        }
        else if(nOrderType==OP_SELL)
        {
           double PipGained=(dOrderPrice-Bid)/(Point*10);
           
           if(PipGained>1.0)
           {
             if(tmpiForce[0]>=tmpiForce[1])
             {
               CloseAllCurrentOrder();
             }

              if(PipGained>5)
              {
              
              }
              else if(PipGained>4)
              {
                MoveStopLostFromOrder(-2);
              }
              else if(PipGained>2)
              {
                 MoveStopLostFromOrder(-1);
              }                     
           }
           else if(PipGained>0.5)
           {
              MoveStopLostFromOrder(2.0);
           }        
        
        }
      }
      else
      {
         if(nTimeSecond>HardCloseTimeDuration)
         {
         
         }
         else
         {
         
         }
      }
     
      
      
      
   
      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter1>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration1"+" Order Profit="+DoubleToStr(dProfit,2)+"\n\r\n\r";      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Diff ="+DiffInPip+"\n\r\n\r";
   
      if(m_Prev_Volume==0)
      m_Prev_Volume=tmpVolume;  
     
     if(tmpVolume>m_Prev_Volume)
     m_Prev_Volume=tmpVolume;
}

void TradeManager::Manage_StopLost_Spartucus() 
{
     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     double tmpiForce[3];
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
    
    
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);

     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
     
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
       
     int nTimeSecond=TimeSeconds(TimeCurrent())-TimeSeconds(dtdatetime);
     
     
     
    m_DebugInfo1_TimingCheck=" Elapse : "+IntegerToString(nTimeSecond)+"\n\r"; 
    //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(TotalinSecond)+"\n\r"; 
    //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
      
      if(dProfit>0)
      {
         if(m_LostRegistered_1==true)
         {
           CloseAllCurrentOrder();
         }
        if(nOrderType==OP_BUY)
        {
           double PipGained=(Ask- dOrderPrice)/(Point*10);
           if(PipGained>1.0)
           {
           
           }
        }
        else if(nOrderType==OP_SELL)
        {
           double PipGained=(dOrderPrice-Bid)/(Point*10);
           
           if(PipGained>1.0)
           {
           
           }        
        }
      }
      else
      {
        
        if(nOrderType==OP_BUY)
        {
           //nTimeSecond
           double PipGained=MathAbs(Ask- dOrderPrice)/(Point*10);
           
           if(PipGained<0.5)
           {
           
           }
           else if(PipGained<1.0)
           {
              ModifyStopLostFromExitingStopLost(3.5,OP_BUY);
              m_LostRegistered_1=true;
           }           
           else if(PipGained<1.5)
           {
              ModifyStopLostFromExitingStopLost(2.5,OP_BUY);
              m_LostRegistered_1=true;
           }
           else if(PipGained<2)
           {
              m_LostRegistered_1=true;
           }        
        }
        else if(nOrderType==OP_SELL)
        {
           double PipGained=MathAbs(Bid-dOrderPrice)/(Point*10);
           
           if(PipGained<0.5)
           {
           
           }
           else if(PipGained<1.0)
           {
              ModifyStopLostFromExitingStopLost(3.5,OP_SELL);
              m_LostRegistered_1=true;
           }           
           else if(PipGained<1.5)
           {
              ModifyStopLostFromExitingStopLost(2.5,OP_SELL);
              m_LostRegistered_1=true;
           }
           else if(PipGained<2)
           {
              m_LostRegistered_1=true;
           }        
        }
      }            
}


void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Momentum(int nTimeDuration,int nTimeDuration2,int HardCloseTimeDuration,int StepingStoneTime,bool StopLOstMoving) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     double tmpiForce[3];
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
    
    
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);

     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
     
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
     long TimeElapse=TimeCurrent()-dtdatetime; 
       
     int nTimeSecond=TimeSeconds(TimeCurrent())-TimeSeconds(dtdatetime);
     
     int TotalinSecond=  nTimeSecond;
     
     
    m_DebugInfo1_TimingCheck=" Elapse Time int Second "+IntegerToString(TimeElapse)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(TotalinSecond)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
     
      if(m_nTimeCounter==0)
      m_nTimeCounter=TotalinSecond;
   
      if(m_nTimeCounter1==0)
      m_nTimeCounter1=TotalinSecond;
   
   
      
      
      
      if(dProfit>0)
      {
         //MoveStopLostFromExitingStopLOst((1+Spread));
        if(nOrderType==OP_BUY)
        {
           double PipGained=(Ask- dOrderPrice)/(Point*10);
           if(PipGained>1.0)
           {
             if(tmpiForce[0]<tmpiForce[1])
             {
               CloseAllCurrentOrder();
             }
              if(PipGained>2)
              {
                 MoveStopLostFromOrder(-1);
              }                     
              else if(PipGained>1)
              {
                 MoveStopLostFromOrder(1);
              }                     
           }
           else if(PipGained>0.2)
           {
              MoveStopLostFromOrder(1.8);
           }        
        }
        else if(nOrderType==OP_SELL)
        {
           double PipGained=(dOrderPrice-Bid)/(Point*10);
           
           if(PipGained>1.0)
           {
             if(tmpiForce[0]>tmpiForce[1])
             {
               CloseAllCurrentOrder();
             }

              if(PipGained>2)
              {
                 MoveStopLostFromOrder(-1);
              }                     
              else if(PipGained>1)
              {
                 MoveStopLostFromOrder(1);
              }                     
           }
           else if(PipGained>0.2)
           {
              MoveStopLostFromOrder(1.8);
           }        
        
        }
      }
      else
      {  
            
        if(nOrderType==OP_BUY)
        {
           double PipGainedLost=(Ask- dOrderPrice)/(Point*10);

          if((TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {           
               if(StopLOstMoving)
               {
                 if(dStopLostLevel>0)
                 {
                   if((TimeElapse-m_nTimeCounter)>=nTimeDuration)
                   MoveStopLostFromExitingStopLOst((1+Spread));         
                 }                    
                 else
                 {
                  if((TimeElapse-m_nTimeCounter)>=nTimeDuration)
                  MoveStopLostFromExitingStopLOst(1+Spread);
                 }         
               }
          } 
                  
        }
        else if(nOrderType==OP_SELL)
        {
           double PipGainedLost=(dOrderPrice-Bid)/(Point*10);

          if((TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {           
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      if((TimeElapse-m_nTimeCounter)>=nTimeDuration)
                      MoveStopLostFromExitingStopLOst((1+Spread));         
                    }                    
                    else
                    {
                      if((TimeElapse-m_nTimeCounter)>=nTimeDuration)               
                      MoveStopLostFromExitingStopLOst(1+Spread);
                    }         
               }
           }
           
        } 
      }
      
     
      
      if(TimeElapse>HardCloseTimeDuration)
      {
          if(dProfit<0)
          CloseAllCurrentOrder();
      }
      
      
   
      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter1>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration1"+" Order Profit="+DoubleToStr(dProfit,2)+"\n\r\n\r";      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Diff ="+DiffInPip+"\n\r\n\r";
   
      if(m_Prev_Volume==0)
      m_Prev_Volume=tmpVolume;  
     
     if(tmpVolume>m_Prev_Volume)
     m_Prev_Volume=tmpVolume;
}

void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Spartucus_Fix(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLOstMoving) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
     long  TimeElapse=TimeCurrent()-dtdatetime; 
       
     int nTimeMinut=TimeMinute(TimeCurrent())-TimeMinute(dtdatetime);
     
     long TotalinSecond=  nTimeMinut*60+ TimeElapse;
     
     //TimeElapse=TotalinSecond;
     
    m_DebugInfo1_TimingCheck=" Elapse Time int Second "+IntegerToString(TimeElapse)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(nTimeMinut)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     if(nOrderType==OP_BUY)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderPrice-dOrderStopLost)/(Point*m_PointFactor);  
        
     }
     else if(nOrderType==OP_SELL)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderStopLost-dOrderPrice)/(Point*m_PointFactor);
     }
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
     
      if(m_nTimeCounter==0)
      m_nTimeCounter=TimeElapse;
   
      if(m_nTimeCounter1==0)
      m_nTimeCounter1=TimeElapse;
      
      if(dProfit>=0)
      {
        TraillingStop();
       //CloseAllCurrentOrder();
      }
   
   
      
      /*
      
      if(dProfit>=0)
      {
        if(DiffInPip>4)
        {
          if(dStopLostLevel>0)
          {
            MoveStopLostFromOrder((2+Spread+dStopLostLevel));
          }
          else
          MoveStopLostFromOrder((2+Spread));
        }
        else
        {
         if(StopLOstMoving)
         {
              if(dStopLostLevel>0)
              {
                MoveStopLostFromExitingStopLOst((1+Spread+dStopLostLevel));         
              }
              else
               MoveStopLostFromExitingStopLOst((1+Spread));         
         }
        }        
      }
      else
      {      
        if(nOrderType==OP_BUY)
        {
          if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(0.5+Spread)*Point*m_PointFactor) && (TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
           
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                   if(dStopLostLevel>0)
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                   }
                   else
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                   }
              }
              else
              {
                  if(StopLOstMoving)
                  {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(0.8+Spread);         
                  }
              }        
            }             
          }          
          else if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(1+Spread)*Point*m_PointFactor))
          {
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                  if(dStopLostLevel>0)              
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                  
                  }
                  else
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                  }
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(0.8+Spread);         
               }
              }        
            }             
          }          

        }
        else if(nOrderType==OP_SELL)
        {
          if(m_nLowestLostInPips<Bid && ((Bid-m_nLowestLostInPips)>(0.5+Spread)*Point*m_PointFactor) &&(TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
              
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else               
                     MoveStopLostFromExitingStopLOst(0.8+Spread);         
               }
              }        
            }             
          } 
          else if(m_nLowestLostInPips<Bid && (Bid-m_nLowestLostInPips)>(1+Spread)*Point*m_PointFactor)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((1+Spread+dStopLostLevel));         
                    }                    
                    else                              
                     MoveStopLostFromExitingStopLOst(1+Spread);         
                  
               }
              }        
            }             
          }        
                 
        } 
        
      }
      
      */
      
      /*
      if(TimeElapse>HardCloseTimeDuration)
      {
          if(nOrderType==OP_BUY)
          {
            if((m_nHighestGainInPips-Ask)>0.2*Point*m_PointFactor)
            {
               CloseAllCurrentOrder();
            }
          }
          else if(nOrderType==OP_SELL)
          {
            if((Bid-m_nLowestLostInPips)>0.2*Point*m_PointFactor)
            {
               CloseAllCurrentOrder();
            }
          }
      }
      
       
      if((TimeElapse-m_nTimeCounter1)>StepingStoneTime)
      {
          if(dProfit>dOrderLots*10*1)
          {
            CloseAllCurrentOrder();
          }
         
          if(dProfit>0)
          {
              if(nOrderType==OP_BUY)
              {
                  if((m_nHighestGainInPips-Ask)>0.2*Point*m_PointFactor)
                  {
                     CloseAllCurrentOrder();
                  }
              }
              else if(nOrderType==OP_SELL)
              {
                  if((Bid-m_nLowestLostInPips)>0.2*Point*m_PointFactor)
                  {
                     CloseAllCurrentOrder();
                  }
              }
          }
      }

      */
      
      TraillingStop();  
      MoveStopLostToBEP_ForLockPip();

   
      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter1>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter1)+" >"+IntegerToString(nTimeDuration1)+" Duration1"+" Order Profit="+DoubleToStr(dProfit,2)+"\n\r\n\r";      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Diff ="+DiffInPip+"\n\r\n\r";
   
      if(m_Prev_Volume==0)
      m_Prev_Volume=tmpVolume;  
     
     if(tmpVolume>m_Prev_Volume)
     m_Prev_Volume=tmpVolume;
}


void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Spartucus_Rev(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLOstMoving) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
     
     HardCloseTimeDuration=60;
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
     long TimeElapse=TimeCurrent()-dtdatetime; 
       
     int nTimeMinut=TimeMinute(TimeCurrent())-TimeMinute(dtdatetime);
     
     long TotalinSecond=  nTimeMinut*60+ TimeElapse;
     
     //TimeElapse=TotalinSecond;
     
    m_DebugInfo1_TimingCheck=" Elapse Time int Second "+IntegerToString(TimeElapse)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(nTimeMinut)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     if(nOrderType==OP_BUY)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderPrice-dOrderStopLost)/(Point*m_PointFactor);  
        
     }
     else if(nOrderType==OP_SELL)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderStopLost-dOrderPrice)/(Point*m_PointFactor);
     }
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
     
      if(m_nTimeCounter==0)
      m_nTimeCounter=TimeElapse;
   
      if(m_nTimeCounter1==0)
      m_nTimeCounter1=TimeElapse;
   
   
      
      
      
      if(dProfit>dOrderLots*10*2)
      {
        //CloseAllCurrentOrder();
      }
      else
      {
       /*
        if(nOrderType==OP_BUY)
        {
          if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(0.5+Spread)*Point*m_PointFactor) && (TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
           
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                   if(dStopLostLevel>0)
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                   }
                   else
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                   }
              }
              else
              {
                  if(StopLOstMoving)
                  {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(0.8+Spread);         
                  }
              }        
            }             
          }          
          else if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(1+Spread)*Point*m_PointFactor))
          {
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                  if(dStopLostLevel>0)              
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                  
                  }
                  else
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+Spread);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                  }
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(0.8+Spread);         
               }
              }        
            }             
          }          

        }
        else if(nOrderType==OP_SELL)
        {
          if(m_nLowestLostInPips<Bid && ((Bid-m_nLowestLostInPips)>(0.5+Spread)*Point*m_PointFactor) &&(TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
              
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+Spread);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+Spread);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else               
                     MoveStopLostFromExitingStopLOst(0.8+Spread);         
               }
              }        
            }             
          } 
          else if(m_nLowestLostInPips<Bid && (Bid-m_nLowestLostInPips)>(1+Spread)*Point*m_PointFactor)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+Spread);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+Spread);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((2+Spread+dStopLostLevel));         
                    }                    
                    else                              
                     MoveStopLostFromExitingStopLOst(2+Spread);         
                  
               }
              }        
            }             
          }        
               
        } 
        */
      }
      
      
      
      
      
       
    

  
      TraillingStop();  
   
   
      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter1>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter1)+" >"+IntegerToString(nTimeDuration1)+" Duration1"+" Order Profit="+DoubleToStr(dProfit,2)+"\n\r\n\r";      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Diff ="+DiffInPip+"\n\r\n\r";
   
      if(m_Prev_Volume==0)
      m_Prev_Volume=tmpVolume;  
     
     if(tmpVolume>m_Prev_Volume)
     m_Prev_Volume=tmpVolume;
}


void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Revers(double dFilterCoeff,int nExitMethod,int nTimeDuration,int nTimeDuration1,int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeffLimit,int StepingStoneTime,bool StopLOstMoving)
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dOrderLots=GetCurrentTradeLotSize();
     double dOrderStopLost=GetCurrOrderStopLost();
     
     double Spread=MarketInfo(Symbol(),MODE_SPREAD);
     double dStopLostLevel=MarketInfo(Symbol(),MODE_STOPLEVEL);
     int    nDigit=(int)MarketInfo(Symbol(),MODE_DIGITS);
     
     double DiffInPip=0;
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
     
     Spread=Spread/m_PointFactor;
     
     if(nDigit==3 || nDigit==5)
     {
       dStopLostLevel=dStopLostLevel/m_PointFactor;
     }
     else if(nDigit==2 || nDigit==4)
     {
       dStopLostLevel=dStopLostLevel/1;
     }
     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
    
   
     long TimeElapse=TimeCurrent()-dtdatetime; 
       
     int nTimeMinut=TimeMinute(TimeCurrent())-TimeMinute(dtdatetime);
     
     long TotalinSecond=  nTimeMinut*60+ TimeElapse;
     
     //TimeElapse=TotalinSecond;
     
    m_DebugInfo1_TimingCheck=" Elapse Time int Second "+IntegerToString(TimeElapse)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Minute "+IntegerToString(nTimeMinut)+"\n\r"; 
    m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Elapse Time int Total "+IntegerToString(TotalinSecond)+"\n\r"; 
    
     
     if(nOrderType==OP_BUY)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderPrice-dOrderStopLost)/(Point*m_PointFactor);  
        
     }
     else if(nOrderType==OP_SELL)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
        
        if(m_nLowestLostInPips>Bid)
        m_nLowestLostInPips=Bid;
        
        if(Ask>m_nHighestGainInPips)
        m_nHighestGainInPips=Ask;
        
        DiffInPip=(dOrderStopLost-dOrderPrice)/(Point*m_PointFactor);
     }
     
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nHighestGainInPips "+DoubleToStr(m_nHighestGainInPips,5) +" "+DoubleToStr((m_nHighestGainInPips-Ask)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" m_nLowestLostInPips " +DoubleToStr(m_nLowestLostInPips,5) +" "+DoubleToStr((Bid-m_nLowestLostInPips)/(Point*10),1)+" Diff 0"+"\n\r\n\r";
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter)+" >"+IntegerToString(nTimeDuration)+" Duration 0"+"\n\r\n\r";
     
     
      if(m_nTimeCounter==0)
      m_nTimeCounter=TimeElapse;
   
      if(m_nTimeCounter1==0)
      m_nTimeCounter1=TimeElapse;
   
   
      
      
      
      if(dProfit>=0)
      {
       CloseAllCurrentOrder();
      }
      else
      {
        if(nOrderType==OP_BUY)
        {
          if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(0.5+Spread)*Point*m_PointFactor) && (TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
           
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                   if(dStopLostLevel>0)
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                   }
                   else
                   {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                   }
              }
              else
              {
                  if(StopLOstMoving)
                  {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((0.8+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(0.8);         
                  }
              }        
            }             
          }          
          else if(m_nHighestGainInPips>Ask && ((m_nHighestGainInPips-Ask)>(1+Spread)*Point*m_PointFactor))
          {
            if(dOrderPrice>Ask)
            {
              if(DiffInPip>5)
              {
                  if(dStopLostLevel>0)              
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                  
                  }
                  else
                  {
                     if((dOrderPrice-Bid)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5);
                     else if((dOrderPrice-Bid)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                     else if((dOrderPrice-Bid)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                     else if((dOrderPrice-Bid)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                  }
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((2+Spread+dStopLostLevel));         
                    }                    
                    else
                    MoveStopLostFromExitingStopLOst(2);         
               }
              }        
            }             
          }          

        }
        else if(nOrderType==OP_SELL)
        {
          if(m_nLowestLostInPips<Bid && ((Bid-m_nLowestLostInPips)>(0.5+Spread)*Point*m_PointFactor) &&(TimeElapse-m_nTimeCounter1)>StepingStoneTime)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
              
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((2+Spread+dStopLostLevel));         
                    }                    
                    else               
                     MoveStopLostFromExitingStopLOst(2);         
               }
              }        
            }             
          } 
          else if(m_nLowestLostInPips<Bid && (Bid-m_nLowestLostInPips)>(1+Spread)*Point*m_PointFactor)
          {
            if(dOrderPrice<Bid)
            {
              if(DiffInPip>5)
              { 
                 if(dStopLostLevel>0)              
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5+dStopLostLevel);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5+dStopLostLevel);
                 
                 }
                 else
                 {
                   if((Ask-dOrderPrice)<(1+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(1.5);
                   else if((Ask-dOrderPrice)<(1.5+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2);
                   else if((Ask-dOrderPrice)<(2+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(2.5);
                   else if((Ask-dOrderPrice)<(3+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(3.5);
                   else if((Ask-dOrderPrice)<(4+Spread)*Point*m_PointFactor)
                      MoveStopLostFromOrder(4.5);
                 }
                   
              }
              else
              {
               if(StopLOstMoving)
               {
                    if(dStopLostLevel>0)
                    {
                      MoveStopLostFromExitingStopLOst((2+Spread+dStopLostLevel));         
                    }                    
                    else                              
                     MoveStopLostFromExitingStopLOst(2+Spread);         
                  
               }
              }        
            }             
          }        
                 
        } 
      }
      
      
      
      if(TimeElapse>HardCloseTimeDuration)
      {
          if(nOrderType==OP_BUY)
          {
            if((m_nHighestGainInPips-Ask)>0.2*Point*m_PointFactor)
            {
               CloseAllCurrentOrder();
            }
          }
          else if(nOrderType==OP_SELL)
          {
            if((Bid-m_nLowestLostInPips)>0.2*Point*m_PointFactor)
            {
               CloseAllCurrentOrder();
            }
          }
      }
      
       
      if((TimeElapse-m_nTimeCounter)>nTimeDuration)
      {// Hihger time
        if(dProfit>0)
        {
          CloseAllCurrentOrder();
        }         
      }
      else if((TimeElapse-m_nTimeCounter1)>StepingStoneTime)
      {
          if(dProfit>dOrderLots*10*2)
          {
            CloseAllCurrentOrder();
          }
         
          if(dProfit>0)
          {
              if(nOrderType==OP_BUY)
              {
                  if((m_nHighestGainInPips-Ask)>0.2*Point*m_PointFactor)
                  {
                     CloseAllCurrentOrder();
                  }
              }
              else if(nOrderType==OP_SELL)
              {
                  if((Bid-m_nLowestLostInPips)>0.2*Point*m_PointFactor)
                  {
                     CloseAllCurrentOrder();
                  }
              }
          }
      }

  
      TraillingStop();  
   
   
      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" TimeElapse-m_nTimeCounter1>nTimeDuration "+IntegerToString(TimeElapse-m_nTimeCounter1)+" >"+IntegerToString(nTimeDuration1)+" Duration1"+" Order Profit="+DoubleToStr(dProfit,2)+"\n\r\n\r";      
      //m_DebugInfo1_TimingCheck=m_DebugInfo1_TimingCheck+" Diff ="+DiffInPip+"\n\r\n\r";
   
      if(m_Prev_Volume==0)
      m_Prev_Volume=tmpVolume;  
     
     if(tmpVolume>m_Prev_Volume)
     m_Prev_Volume=tmpVolume;
}

void TradeManager::ManageRunningTrade_Scalpping_Gladiator_5(double dFilterCoeff,int nExitMethod,int nTimeDuration, int HardCloseTimeDuration,double dExitFilterCoeff) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
     
     /*     
     double etmp_IVoume=iVolume(NULL,0,0);
     double tmp_IVoume_1=iVolume(NULL,0,1);
     
     double etmp_ATR=iATR(NULL,0,14,0);
     double tmp_ATR_1=iATR(NULL,0,14,2);
     */
     
     
     /*
     tmpVolume[1]        =iVolume(NULL,0,1);
     tmpVolume[2]        =iVolume(NULL,0,2);
     
     tmpiForce[0]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,0);
     tmpiForce[1]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,1);
     tmpiForce[2]        =iForce(NULL,0,14,MODE_SMA,PRICE_CLOSE,2);
     
     tmpAccumulation[0]  =iAC(NULL,0,0);
     tmpAccumulation[1]  =iAC(NULL,0,1);
     tmpAccumulation[2]  =iAC(NULL,0,2);
      */
     //m_ATR[i]           =iATR(NULL,0,14,i);
           
 
   
     long TimeElapse=TimeCurrent()-dtdatetime;   

     //int TimeElapse=TimeCurrent()-dtdatetime;   
     
   
  
      if(TimeElapse>HardCloseTimeDuration)
      {
        
         if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
         {    
           CloseAllCurrentOrder();
         }
         
      }
      
      if(TimeElapse>(12+nTimeDuration))
      {
        if(dProfit>0)
        {
          CloseAllCurrentOrder();
        }
        if(m_Prev_Volume>0)
        {
            if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
            {
             MoveStopLostFromExitingStopLOst(0.8);
             m_IsLockBreak=true;
            }
        }
      }      
      else if(TimeElapse>(3+nTimeDuration))
      {
         if(m_Prev_Volume>0)
         {
            if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
            {
             MoveStopLostFromExitingStopLOst(0.8);
             m_IsLockBreak=true;
            }
         }
      }

      TraillingStop();  
      MoveStopLostToBEP_ForLockPip();
   
     if(m_Prev_Volume==0)
     m_Prev_Volume=tmpVolume;  
     //m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+" OP Type="+IntegerToString(nOrderType)+" Trade Taken \n\r";

     /*         
     if(nOrderType==OP_BUY)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
         
         if(Ask>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Ask;
         }
         if(Bid<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Bid;
         }
         
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Bid>(dOrderPrice+2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         
         
         
         double dFactor=(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);                 
         if(ActualLost>m_StopLost*dFactor)
         {
         
            CloseAllCurrentOrder();
         }
         double ddSpread=MarketInfo(NULL,MODE_SPREAD);
         
         if(m_nLowestLostInPips<((dOrderPrice-ddSpread)-0.5*dFactor))
         {
           if(dProfit>0)
           {
             if(TimeElapse>nTimeDuration)
             CloseAllCurrentOrder();
           }
         }
         
        if(TimeElapse>HardCloseTimeDuration)
        {
           m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+"Buy "+IntegerToString(TimeElapse)+" "+DoubleToStr(dOrderPrice,5)+",";
        
           if(Ask<(dOrderPrice-1.5*dFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         
         
     }
     else if(nOrderType==OP_SELL)
     {
     
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
     
       if(Bid<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Bid;
       }
       if(Ask>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Ask;
       }
              
        //m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+"Sell "+IntegerToString(TimeElapse)+" "+DoubleToStr(dOrderPrice,5)+",";

        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Ask<(dOrderPrice-2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }

       
       double Dfactor=(Point*m_PointFactor);
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       
        double ActualLost=(Bid-dOrderPrice);
       
        if(ActualLost>m_StopLost*Dfactor)
        {
            CloseAllCurrentOrder();
        }
        
        double ddSpread=MarketInfo(NULL,MODE_SPREAD);
      
        if(m_nHighestGainInPips>((dOrderPrice+ddSpread)+0.5*Dfactor))
        {
         if(dProfit>0)
         {
           if(TimeElapse>nTimeDuration)
           CloseAllCurrentOrder();
         }
        } 
        
        if(TimeElapse>HardCloseTimeDuration)
        {
           if(Bid>(dOrderPrice+1.5*Dfactor))
           {
             CloseAllCurrentOrder();
           }
        }
        
     }
    */
    
   
   //else
   //TraillingStop_1();

      
}




void TradeManager::ManageRunningTrade_Scalpping_Gladiator_Spider(double dFilterCoeff,int nExitMethod,int nTimeDuration_1,int nTimeDuration_2, int HardCloseTimeDuration,double dExitFilterCoeff,double dExitFilterCoeff_Limit) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     double dLotSize  =GetCurrentTradeLotSize();
     
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
    
      long TimeElapse=TimeCurrent()-dtdatetime;   
 
     //int TimeElapse=TimeCurrent()-dtdatetime;   
     
   
  
      if(TimeElapse>HardCloseTimeDuration)
      {
        
         if(MathAbs(tmpVolume-m_Prev_Volume)>dExitFilterCoeff_Limit)
         {    
           CloseAllCurrentOrder();
         }
         
      }
      
      if(TimeElapse>nTimeDuration_1)
      {
        if(dProfit>dLotSize*10)
        {
          CloseAllCurrentOrder();
        }
        if(m_Prev_Volume>0)
        {
            if(MathAbs(tmpVolume-m_Prev_Volume)>dExitFilterCoeff_Limit)
            {
             MoveStopLostFromExitingStopLOst(0.8);
             m_IsLockBreak=true;
            }
        }
      }      
      else if(TimeElapse>nTimeDuration_2)
      {
         if(m_Prev_Volume>0)
         {
            if(MathAbs(tmpVolume-m_Prev_Volume)>dExitFilterCoeff_Limit)
            {
             MoveStopLostFromExitingStopLOst(0.8);
             m_IsLockBreak=true;
            }
         }
      }

      TraillingStop();  
      MoveStopLostToBEP_ForLockPip();
   
     if(m_Prev_Volume==0)
     m_Prev_Volume=tmpVolume;  
     //m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+" OP Type="+IntegerToString(nOrderType)+" Trade Taken \n\r";

     /*         
     if(nOrderType==OP_BUY)
     {
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
         
         if(Ask>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Ask;
         }
         if(Bid<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Bid;
         }
         
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Bid>(dOrderPrice+2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         
         
         
         double dFactor=(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);                 
         if(ActualLost>m_StopLost*dFactor)
         {
         
            CloseAllCurrentOrder();
         }
         double ddSpread=MarketInfo(NULL,MODE_SPREAD);
         
         if(m_nLowestLostInPips<((dOrderPrice-ddSpread)-0.5*dFactor))
         {
           if(dProfit>0)
           {
             if(TimeElapse>nTimeDuration)
             CloseAllCurrentOrder();
           }
         }
         
        if(TimeElapse>HardCloseTimeDuration)
        {
           m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+"Buy "+IntegerToString(TimeElapse)+" "+DoubleToStr(dOrderPrice,5)+",";
        
           if(Ask<(dOrderPrice-1.5*dFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         
         
     }
     else if(nOrderType==OP_SELL)
     {
     
        if(m_nLowestLostInPips==0)
        m_nLowestLostInPips=Bid;
        if(m_nHighestGainInPips==0)
        m_nHighestGainInPips=Ask;
     
       if(Bid<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Bid;
       }
       if(Ask>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Ask;
       }
              
        //m_DebugInfo1_Princ_Entry=m_DebugInfo1_Princ_Entry+"Sell "+IntegerToString(TimeElapse)+" "+DoubleToStr(dOrderPrice,5)+",";

        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Ask<(dOrderPrice-2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }

       
       double Dfactor=(Point*m_PointFactor);
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       
        double ActualLost=(Bid-dOrderPrice);
       
        if(ActualLost>m_StopLost*Dfactor)
        {
            CloseAllCurrentOrder();
        }
        
        double ddSpread=MarketInfo(NULL,MODE_SPREAD);
      
        if(m_nHighestGainInPips>((dOrderPrice+ddSpread)+0.5*Dfactor))
        {
         if(dProfit>0)
         {
           if(TimeElapse>nTimeDuration)
           CloseAllCurrentOrder();
         }
        } 
        
        if(TimeElapse>HardCloseTimeDuration)
        {
           if(Bid>(dOrderPrice+1.5*Dfactor))
           {
             CloseAllCurrentOrder();
           }
        }
        
     }
    */
    
   
   //else
   //TraillingStop_1();

      
}


void TradeManager::ManageRunningTrade_Scalpping_Gladiator_1(double dFilterCoeff,int nExitMethod,int nTimeDuration, int HardCloseTimeDuration,double dExitFilterCoeff) 
{

     double dProfit=GetCurrTradeOrderProfit();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();     
     double tmpVolume=0;
     tmpVolume=dFilterCoeff;
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
 
   
     long TimeElapse=TimeCurrent()-dtdatetime;     
    
      if(TimeElapse>HardCloseTimeDuration)
      {
         if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
         {    
           CloseAllCurrentOrder();
         }
         
      }
      
      
      if(nExitMethod==1)
      { 
         if(TimeElapse>(12+nTimeDuration))
         {
           if(dProfit>0)
           {
             CloseAllCurrentOrder();
           }
           if(m_Prev_Volume>0)
           {
               if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
               {
                MoveStopLostFromExitingStopLOst(0.8);
                m_IsLockBreak=true;
               }
           }
         }      
         else if(TimeElapse>(3+nTimeDuration))
         {
            if(m_Prev_Volume>0)
            {
               if(MathAbs(tmpVolume-m_Prev_Volume)>0.02)
               {
                MoveStopLostFromExitingStopLOst(0.8);
                m_IsLockBreak=true;
               }
            }
         }
      }
      else
      {
        if(TimeElapse>nTimeDuration)
        {
           //MoveStopLostFromOrder(4);
        }
         
      }

      TraillingStop();  
      MoveStopLostToBEP_ForLockPip();
   
     if(m_Prev_Volume==0)
     m_Prev_Volume=tmpVolume;  
/////    
   
   /*
              
     if(nOrderType==OP_BUY)
     {
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Bid>(dOrderPrice+2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
         if((dOrderPrice-m_nLowestLostInPips)>0.7*Point*m_PointFactor)
         {
           if(TimeElapse>5)
           {
              if(Bid>(dOrderPrice+1*Point*m_PointFactor))
              CloseAllCurrentOrder();
            
           }
           else if(TimeElapse>3)
           {
              //TraillingStop_1();
           }
         } 
         if(TimeElapse>HardCloseTimeDuration)
         {
           if((dOrderPrice>Ask) && ((dOrderPrice-Ask)>1.0*Point*m_PointFactor))
           CloseAllCurrentOrder();
         }        
                 
       
         double dFactor=(Point*m_PointFactor);
         //double DeltaLost=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
         //double DeltaProfit=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);
                 
         if(ActualLost>m_StopLost*dFactor)
         {
         
            CloseAllCurrentOrder();
         }
         
         
         
     }
     else if(nOrderType==OP_SELL)
     {
     
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Ask<(dOrderPrice-2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
     
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       double Dfactor=(Point*m_PointFactor);
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       double ActualLost=(Bid-dOrderPrice);
       
         if(ActualLost>m_StopLost*Dfactor)
         {
            CloseAllCurrentOrder();
         }
         
         if((m_nHighestGainInPips-dOrderPrice)>1.0*Point*m_PointFactor)
         {
           if(TimeElapse>5)
           {
              if(Ask<(dOrderPrice-1*Point*m_PointFactor))
              CloseAllCurrentOrder();
            
           }
           else if(TimeElapse>3)
           {
              //TraillingStop_1();
           }
         } 
         
         if(TimeElapse>HardCloseTimeDuration)
         {
           if((Bid>dOrderPrice) && (Bid-dOrderPrice)>0.7*Point*m_PointFactor)
           CloseAllCurrentOrder();
         }        
     }
    
      if(nExitMethod==1)
      {
         if(TimeElapse>nTimeDuration)
         {
            TraillingStop();
         }
         else
         {
              if(nOrderType==OP_BUY)
              {
               if((m_nHighestGainInPips-dOrderPrice)>3*Point*m_PointFactor)
               {
                 MoveStopLostToBEP_ForLockPip();
               }
              }
              else if(nOrderType==OP_SELL)
              {
               if((dOrderPrice-m_nLowestLostInPips)>3*Point*m_PointFactor)
               {
                 MoveStopLostToBEP_ForLockPip();
               }
              }
         }  
      }
      else 
      {
         
         TraillingStop();
      }
     //TraillingStop_1();
     
          
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+DoubleToStr(m_nLockTradePriceInPip,1)+" "+"Gep="+DoubleToStr(m_nLockTradePriceGapInPip,1)+"\n\r";
           
           if(nExitMethod==1)
           {
            if(TimeElapse>nTimeDuration)
            MoveStopLostToBEP_ForLockPip();
           }
           else
           MoveStopLostToBEP_ForLockPip();    
      }
      
      
   */         
      
}
void TradeManager::ManageRunningTrade_Scalpping_Gladiator_3(double dFilterCoeff,int nExitMethod,int nTimeDuration, int HardCloseTimeDuration,double dExitFilterCoeff) 
{

     //double ProfitInPips=GetCurrentProfit();
     //double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
    double dFactor=(Point*m_PointFactor);
 
 
   
     int TimeElapse=(int)(TimeCurrent()-dtdatetime);     
       
              
     if(nOrderType==OP_BUY)
     {
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Bid>(dOrderPrice+2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
         
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
         
         if((Bid-dOrderPrice)>2*Point*m_PointFactor)
         {
            CloseAllCurrentOrder();
         }
         
         if((m_nHighestGainInPips-Bid)>0.5*dFactor)
         {
            CloseAllCurrentOrder();
         }        
       
         //double DeltaLost=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
         //double DeltaProfit=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);
                 
         if(ActualLost>m_StopLost*dFactor)
         {
         
            CloseAllCurrentOrder();
         }
         
         
         
     }
     else if(nOrderType==OP_SELL)
     {
     
        if(dFilterCoeff<dExitFilterCoeff)
        {
           if(Ask<(dOrderPrice-2*Point*m_PointFactor))
           {
             CloseAllCurrentOrder();
           }
        }
     
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       
       if((Ask-m_nLowestLostInPips)>0.5*Point*m_PointFactor)
       {
          CloseAllCurrentOrder();
       }
       
       if((dOrderPrice-Ask)>2*Point*m_PointFactor)
       {
         CloseAllCurrentOrder();
       }
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       double ActualLost=(Bid-dOrderPrice);
       
         if(ActualLost>m_StopLost*dFactor)
         {
            CloseAllCurrentOrder();
         }
         
     }
    
         
     //TraillingStop();
          
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+DoubleToStr(m_nLockTradePriceInPip,1)+" "+"Gep="+DoubleToStr(m_nLockTradePriceGapInPip,1)+"\n\r";
           
           if(nExitMethod==1)
           {
            //if(TimeElapse>nTimeDuration)
            //MoveStopLostToBEP_ForLockPip();
           }
           else
           {
           //MoveStopLostToBEP_ForLockPip();    
           }
      }
      
          
      
}

void TradeManager::ManageRunningTrade_Scalpping_Gladiator()
 {

     //double ProfitInPips=GetCurrentProfit();
     //double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
        
        
       
     //m_DebugInfo1="Highest Profit in Current Trade="+ IntegerToString(m_nHighestGainInPips)+"Highest Lost in Current Trade="+IntegerToString(m_nLowestLostInPips)+"\n\r";
     
     //long TimeElapse=TimeCurrent()-dtdatetime;     
       
              
     if(nOrderType==OP_BUY)
     {
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
         double dFactor=(Point*m_PointFactor);
         //double DeltaLost=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
         //double DeltaProfit=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);
                 
         if(ActualLost>m_StopLost*dFactor)
         {
            CloseAllCurrentOrder();
         }
     }
     else if(nOrderType==OP_SELL)
     {
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       double Dfactor=(Point*m_PointFactor);
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       double ActualLost=(Bid-dOrderPrice);
       
         if(ActualLost>m_StopLost*Dfactor)
         {
            CloseAllCurrentOrder();
         }
     }
    
     TraillingStop();
          
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+DoubleToStr(m_nLockTradePriceInPip,1)+" "+"Gep="+DoubleToStr(m_nLockTradePriceGapInPip,1)+"\n\r";
           
           MoveStopLostToBEP_ForLockPip();
           
           /*  
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Trailing Stop also Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }
           */
      }
     
 }


 void TradeManager::ManageRunningTrade_Scalpping_Gladiator(int nExitMethod,int nTimeDuration)
 {

     //double ProfitInPips=GetCurrentProfit();
     //double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
        
        
       
     //m_DebugInfo1="Highest Profit in Current Trade="+ IntegerToString(m_nHighestGainInPips)+"Highest Lost in Current Trade="+IntegerToString(m_nLowestLostInPips)+"\n\r";
     
     int TimeElapse=(int )(TimeCurrent()-dtdatetime);     
       
              
     if(nOrderType==OP_BUY)
     {
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
         double dFactor=(Point*m_PointFactor);
         //double DeltaLost=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
         //double DeltaProfit=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
         double ActualLost=(dOrderPrice-Ask);
                 
         if(ActualLost>m_StopLost*dFactor)
         {
         
            CloseAllCurrentOrder();
         }
     }
     else if(nOrderType==OP_SELL)
     {
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       double Dfactor=(Point*m_PointFactor);
       //double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/Dfactor;
       //double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/Dfactor;
       double ActualLost=(Bid-dOrderPrice);
       
         if(ActualLost>m_StopLost*Dfactor)
         {
            CloseAllCurrentOrder();
         }
     }
    
      if(nExitMethod==1)
      {
         if(TimeElapse>nTimeDuration)
         {
            TraillingStop();
         }
         else
         {
              if(nOrderType==OP_BUY)
              {
               if((m_nHighestGainInPips-dOrderPrice)>3*Point*m_PointFactor)
               {
                 MoveStopLostToBEP_ForLockPip();
               }
              }
              else if(nOrderType==OP_SELL)
              {
               if((dOrderPrice-m_nLowestLostInPips)>3*Point*m_PointFactor)
               {
                 MoveStopLostToBEP_ForLockPip();
               }
              }
         }
         
         
         
         
      }
      else 
      TraillingStop();
     //TraillingStop_1();
     
          
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+DoubleToStr(m_nLockTradePriceInPip,1)+" "+"Gep="+DoubleToStr(m_nLockTradePriceGapInPip,1)+"\n\r";
           
           if(nExitMethod==1)
           {
            if(TimeElapse>nTimeDuration)
            MoveStopLostToBEP_ForLockPip();
           }
           else
           MoveStopLostToBEP_ForLockPip();
           
           /*  
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Trailing Stop also Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }
           */
      }

      TraillingStop();
     MoveStopLostToBEP_ForLockPip();
 }

 void TradeManager::ManageRunningTrade_Scalpping_2018()
 {

     double ProfitInPips=GetCurrentProfit();
     double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
        
        
       
     //m_DebugInfo1="Highest Profit in Current Trade="+ IntegerToString(m_nHighestGainInPips)+"Highest Lost in Current Trade="+IntegerToString(m_nLowestLostInPips)+"\n\r";
     
     long TimeElapse=TimeCurrent()-dtdatetime;     
       
              
     if(nOrderType==OP_BUY)
     {
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
       
         double DeltaLost=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
         double DeltaProfit=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
         
         
                          
     }
     else if(nOrderType==OP_SELL)
     {
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       double DeltaProfit=(dOrderPrice-m_nLowestLostInPips)/(Point*m_PointFactor);
       double DeltaLost=(m_nHighestGainInPips-dOrderPrice)/(Point*m_PointFactor);
       
                
     }
    
     TraillingStop();
     
     
      m_DebugInfo1=" Ellapse Time ="+IntegerToString(TimeElapse)+" Sec "+"\n\r";
     
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+DoubleToStr(m_nLockTradePriceInPip,1)+" "+"Gep="+DoubleToStr(m_nLockTradePriceGapInPip,1)+"\n\r";
           
           MoveStopLostToBEP_ForLockPip();
             
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Trailing Stop also Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }
      }
      else
      {
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Only Trailing Stop is Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }      
      }
     
 }
 
 void TradeManager::ManageRunningTrade_Scalpping_2017()
 {

     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
              
     if(nOrderType==OP_BUY)
     {
         if(Bid>m_nHighestGainInPips)             
         {
            m_nHighestGainInPips=Bid;
         }
         if(Ask<m_nLowestLostInPips)
         {
             m_nLowestLostInPips=Ask;
         }
       
         double dFactor=Point*m_PointFactor;
         double ActualLost=(dOrderPrice-Bid)/dFactor;         
         
     }
     else if(nOrderType==OP_SELL)
     {
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
       }
       if(Bid>m_nHighestGainInPips)             
       {
          m_nHighestGainInPips=Bid;
       }
       
       double dFactor=Point*m_PointFactor;
       double ActualLost=(Ask-dOrderPrice)/dFactor;
       
     }
    
     TraillingStop(); 
         
     if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
     {
        MoveStopLostToBEP_ForLockPip();          
     }     
 }
 
 void TradeManager::ManageRunningTrade_Scalpping_2016_Rev(void)
 {

     double ProfitInPips=GetCurrentProfit();
     double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
        
        
             
     TraillingStop();
     
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+m_nLockTradePriceInPip+" "+"Gep="+m_nLockTradePriceGapInPip+"\n\r";
           
           MoveStopLostToBEP_ForLockPip();
             
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Trailing Stop also Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }
      }
      else
      {
           if(m_bUseTrailingStop)
           {
            m_DebugInfo1=m_DebugInfo1+" Only Trailing Stop is Active \n\r";
            //TraillingStop();
           }
           else
           {
            m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }      
      }
     
 }
 
 void TradeManager::ManageRunningTrade_Scalpping_Martingle()
 {
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=5;

    HideTestIndicators(true);

   double Data=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_MAIN,0);
   double Signal=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_SIGNAL,0);
   //double Data1=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_MAIN,2);
   //double Signal1=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_SIGNAL,2);
   
   //double MA_20_0=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0);     
   //double MA_20_2=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);     
   //double MA_20_4=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,4);
   
   double moement_1=iMomentum(NULL,0,14,PRICE_CLOSE,1);
   double moement_2=iMomentum(NULL,0,14,PRICE_CLOSE,3);            
   double moement_3=iMomentum(NULL,0,14,PRICE_CLOSE,4);
        
   
    HideTestIndicators(false);
   
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
            {   
              if(Data>Signal)
              {           
                 double Lot2=GetCurrentTradeLotSize();
                 Lot2=Lot2*2;
                 SetLostSize(Lot2);
                 TradeBuy(dStopLost);
                 SetStopLostForMultiTrade_Ext(PipProfit);
              }
                  
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(Data>Signal && moement_1>moement_2 && moement_2>moement_3)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                       Lot2=Lot2*2;
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);                                                
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
         
      
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
            {
             if(Data<Signal)
             {
              double Lot2=GetCurrentTradeLotSize();                            
              Lot2=Lot2*2;
              SetLostSize(Lot2);
              TradeSell(dStopLost);
              SetStopLostForMultiTrade_Ext(PipProfit);
             }
            }         
            else
            {
             TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(Data<Signal && moement_1<moement_2 && moement_2<moement_3)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                          Lot2=Lot2*2;
                          SetLostSize(Lot2);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              
                  }
               } //Mart Dist            
         }// Order Count
        
      }//Order Type
   }//Order Count >0
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_12()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
       
     
    HideTestIndicators(false);
  
   
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3>MA8 && MA3>MA20)
                   {
                      if(m_nCurrScapdata.nLoopState==false)
                      {                       
                      
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                       m_nCurrScapdata.dBaseLot= Lot2;
                       m_nCurrScapdata.dOrderIndex=0;
                       m_nCurrScapdata.dTargetPrice=Ask;
                       m_nCurrScapdata.nCurrentLotTarget= Lot2;
                       m_nCurrScapdata.nCurrentLotCompleted=0;
                       m_nCurrScapdata.nLoopState=true;
                       m_nCurrScapdata.nPipGap=PipGapforScalp;
                       
                      }
                                       
                   }
                } 
              }
              else if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
              {           
                     if(m_nCurrScapdata.nLoopState==false)
                     {
      
                       double Lot2=GetCurrentTradeLotSize();
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);

                       m_nCurrScapdata.dBaseLot= Lot2;
                       m_nCurrScapdata.dOrderIndex=0;
                       m_nCurrScapdata.dTargetPrice=Ask;
                       m_nCurrScapdata.nCurrentLotTarget= Lot2;
                       m_nCurrScapdata.nCurrentLotCompleted=0;
                       m_nCurrScapdata.nLoopState=true;
                       m_nCurrScapdata.nPipGap=PipGapforScalp;
                     }

              }
              
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                     if(m_nCurrScapdata.nLoopState==false)
                     {
                       double Lot2=GetCurrentTradeLotSize();                    
                       SetLostSize(Lot2);
                       SetTradeComment("MainSSP");
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                       m_nCurrScapdata.dBaseLot= Lot2;
                       m_nCurrScapdata.dOrderIndex++;
                       m_nCurrScapdata.dTargetPrice=Ask;
                       m_nCurrScapdata.nCurrentLotTarget= m_nCurrScapdata.nCurrentLotTarget*2;
                       m_nCurrScapdata.nCurrentLotCompleted=0;
                       m_nCurrScapdata.nLoopState=true;
                       m_nCurrScapdata.nPipGap=PipGapforScalp;
                     }              
                  }
               }// Mart Dist
               
                if(m_nCurrScapdata.nLoopState)
                {
                    double Lowest=m_nCurrScapdata.dTargetPrice;
                    
                    if(dVal_OrderPrice<m_nCurrScapdata.dTargetPrice)
                    Lowest=dVal_OrderPrice;
                    
                
                   //if((Lowest-Ask)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                   {
                   double MA3_2 = iMA(NULL, m_nTimePeriod,   3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8_2 = iMA(NULL, m_nTimePeriod,   8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20_2 = iMA(NULL, m_nTimePeriod,  20, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA50_2 = iMA(NULL, m_nTimePeriod,  50, 0, MODE_SMA, PRICE_CLOSE, 1);                  
                   double MA100_2 = iMA(NULL, m_nTimePeriod, 100, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA200_2 = iMA(NULL, m_nTimePeriod, 200, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA300_2 = iMA(NULL, m_nTimePeriod, 300, 0, MODE_SMA, PRICE_CLOSE, 1);

                      switch(m_nCurrScapdata.dOrderIndex)
                      {
                          case 0:
                          case 1:
                          if((Lowest-Ask)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                          {
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B1");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }
                           }

                          break;
                          case 2:
                          if((Lowest-Ask)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                          {

                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 1;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B2");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }
                           }

                          break;
                          case 3:
                          if((Lowest-Ask)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                          {                          
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 2;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B3");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }
                           }

                          break;
                          case 4:
                          if((Lowest-Ask)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                          {
                          
                              if(MA20_2>MA50_2 && MA8_2>MA20_2 && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 3;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B4");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }
                            }

                          break;
                          case 5:
                              if(MA50_2>MA100_2 && MA20_2>MA50_2 && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 6;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B5");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 6:
                              if(MA50_2>MA100_2 && MA20_2>MA50_2 && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 8;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B6");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 7:
                              if(MA50_2>MA100_2 && MA20_2>MA50_2 && MA100_2>MA200_2 && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 10;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B7");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);               
                                                                
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 8:
                              if(MA50_2>MA100_2 && MA20_2>MA50_2 && MA100_2>MA200_2 && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= 10;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B8");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 9:
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B9");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 10:
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B10");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 11:
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B11");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;
                          case 12:
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B12");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }

                          break;

                          default:
                              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                              {
                                 int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                 SetLostSize(m_nCurrScapdata.dBaseLot);
                                 SetTradeComment("B15");
                                 TradeBuy(dStopLost);
                                 SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                 m_nCurrScapdata.nCurrentLotCompleted++; 
                                 if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                 {
                                  m_nCurrScapdata.nLoopState=false;
                                 
                                 }                              
                              }
                          
                      }   
                         
                   }
                }
               
               
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor)
             {             
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3<MA8 && MA3<MA20)
                   {
                      if(m_nCurrScapdata.nLoopState==false)
                      {

                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);

                       m_nCurrScapdata.dBaseLot= Lot2;
                       m_nCurrScapdata.dOrderIndex=0;
                       m_nCurrScapdata.dTargetPrice=Bid;
                       m_nCurrScapdata.nCurrentLotTarget= Lot2;
                       m_nCurrScapdata.nCurrentLotCompleted=0;
                       m_nCurrScapdata.nLoopState=true;
                       m_nCurrScapdata.nPipGap=PipGapforScalp;
                      }

                   }
                } 
             }
             else if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {
                 if(m_nCurrScapdata.nLoopState==false)
                 {

                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                 
                       m_nCurrScapdata.dBaseLot= Lot2;
                       m_nCurrScapdata.dOrderIndex=0;
                       m_nCurrScapdata.dTargetPrice=Bid;
                       m_nCurrScapdata.nCurrentLotTarget= Lot2;
                       m_nCurrScapdata.nCurrentLotCompleted=0;
                       m_nCurrScapdata.nLoopState=true;
                       m_nCurrScapdata.nPipGap=PipGapforScalp;
                  }


             }
             
             
            }         
            else
            {
               TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                     if(m_nCurrScapdata.nLoopState==false)
                     {
                                               
                          double Lot2=GetCurrentTradeLotSize();
                                                                     
                          SetLostSize(Lot2);
                          SetTradeComment("MainSSL");
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                          m_nCurrScapdata.dBaseLot= Lot2;
                          m_nCurrScapdata.dOrderIndex++;
                          m_nCurrScapdata.dTargetPrice=Bid;
                          m_nCurrScapdata.nCurrentLotTarget= m_nCurrScapdata.nCurrentLotTarget*2;
                          m_nCurrScapdata.nCurrentLotCompleted=0;
                          m_nCurrScapdata.nLoopState=true;
                          m_nCurrScapdata.nPipGap=PipGapforScalp;
                          
                     }              

                  }
               } //Mart Dist
               
                if(m_nCurrScapdata.nLoopState)
                {
                    double Highest=m_nCurrScapdata.dTargetPrice;
                    
                    if(dVal_OrderPrice>m_nCurrScapdata.dTargetPrice)
                    Highest=dVal_OrderPrice;
                     
                   double MA3_1 = iMA(NULL, m_nTimePeriod,   3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8_1 = iMA(NULL, m_nTimePeriod,   8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20_1 = iMA(NULL, m_nTimePeriod,  20, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA50_1 = iMA(NULL, m_nTimePeriod,  50, 0, MODE_SMA, PRICE_CLOSE, 1);                  
                   double MA100_1 = iMA(NULL, m_nTimePeriod, 100, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA200_1 = iMA(NULL, m_nTimePeriod, 200, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA300_1 = iMA(NULL, m_nTimePeriod, 300, 0, MODE_SMA, PRICE_CLOSE, 1);

                    
                    //if((Ask-Highest)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                   {
                       switch(m_nCurrScapdata.dOrderIndex)
                       {
                            case 0:
                            case 1:
                            if((Ask-dVal_OrderPrice)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                            {
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount=1;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S1");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                             }                            
                            break;
                            case 2:
                            if((Ask-Highest)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                            {
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount=1;// m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S2");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                             }
                            
                            break;
                            case 3:
                            if((Ask-Highest)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                            {
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= 2;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S3");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                             }
                            
                            break;
                            case 4:
                            if((Ask-Highest)>m_nCurrScapdata.nPipGap*Point*m_PointFactor)
                            {
                                 if(MA20_1<MA50_1 && (Time[0]-dtTime)>Period()*60)
                                 {
                                      int nOrdrCount= 3;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S4");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                             }
                            break;
                            case 5:
                                 if(MA20_1<MA50_1  && MA50_1<MA100_1 && (Time[0]-dtTime)>Period()*60)
                                 {
                                      int nOrdrCount= 7; //m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S5");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                            
                            break;
                            case 6:
                                 if(MA20_1<MA50_1  && MA50_1<MA100_1 && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= 8;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S6");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                            
                            break;
                            case 7:
                                 if(MA20_1<MA50_1  && MA8_1<MA20_1 && MA100_1<MA200_1 && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= 10;//m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S7");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                            
                            break;
                            case 8:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S8");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }

                            break;
                            case 9:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S9");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }

                            break;
                            case 10:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S10");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }

                            break;
                            case 11:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("S11");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }

                            break;
                            case 12:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("12");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                            break;
                            default:
                                 if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                                 {
                                    int nOrdrCount= m_nCurrScapdata.nCurrentLotTarget/m_nCurrScapdata.dBaseLot;
                                      SetLostSize(m_nCurrScapdata.dBaseLot);
                                      SetTradeComment("15");
                                      TradeSell(dStopLost);
                                      SetStopLostForMultiTrade_Ext(PipProfit);                                              
                                      m_nCurrScapdata.nCurrentLotCompleted++; 
                                    
                                      if(nOrdrCount<=m_nCurrScapdata.nCurrentLotCompleted)
                                      {
                                       m_nCurrScapdata.nLoopState=false;
                                      }
                                 }
                       }
                   }
                }
               
               
                           
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }
 
 void TradeManager::ManageRunningTrade_Scalpping_Martingle_1()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   int    PipProfit_3=m_nProfitTargetInPips;
   
   double MultiFactor=1.5;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
    double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA3_3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 4);
    double MA5 = iMA(NULL, m_nTimePeriod, 5, 0, MODE_SMA, PRICE_CLOSE, 1);

    double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA10 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA14 = iMA(NULL, m_nTimePeriod, 14, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA50 = iMA(NULL, m_nTimePeriod, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA100 = iMA(NULL, m_nTimePeriod, 100, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA200 = iMA(NULL, m_nTimePeriod, 200, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA300 = iMA(NULL, m_nTimePeriod, 300, 0, MODE_SMA, PRICE_CLOSE, 1);    
    double MA400 = iMA(NULL, m_nTimePeriod, 400, 0, MODE_SMA, PRICE_CLOSE, 1);
    
    double dHigh=iHigh(NULL,m_nTimePeriod,iHighest(NULL,m_nTimePeriod,MODE_HIGH,6,1));
    double dLow=iLow(NULL,m_nTimePeriod,iLowest(NULL,m_nTimePeriod,MODE_LOW,6,1));
    
    //iSAR(NULL,0,0.02,0.2,0)>Close[0]
    double dSar=iSAR(NULL,0,0.02,0.2,0);
    double dSar1=iSAR(NULL,0,0.02,0.2,1);
    double dSar2=iSAR(NULL,0,0.02,0.2,2);
    
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount<2)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
            

                 if(Ask<MA200 && dVal_OrderPrice>MA200 && MA200>MA300 && MA300>MA400)
                 {
                   
                    //CloseAllCurrentOrder();
                 }
                 
                 if(Ask<MA200 && dVal_OrderPrice>MA200 && dVal_OrderPrice>MA100 )
                 {
                   
                    //CloseAllCurrentOrder();
                 }
                 
                         
                 if(dSar<Close[0] && dSar1<Close[1])
                 {          
                      if(Close[1]<Close[2] && Close[2]<Close[3])
                      {
                      
                      }
                      else if(Close[0]<Close[2])
                      {
                      
                      }
                      
                      else
                      {
                             
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor_1);
                       TradeBuy(dStopLost);
                       //printf("xxxxxxxxxxxxxxxxxxxxx 1");
                       SetStopLostForMultiTrade_Ext(PipProfit_3);
                      }
                 }     
              }
           
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                   if(dSar<Close[0] && dSar1<Close[1])
                   {
                          double Lot2=GetCurrentTradeLotSize();                    
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);   
                          //printf("xxxxxxxxxxxxxxxxxxxxx 8");                    
                          SetStopLostForMultiTrade_Ext(PipProfit);
                   }
               }// Mart Dist
               
               if((Ask-dVal_OrderPrice)>15*Point*m_PointFactor)
               {
                     //int GetHighestOrderID(int TradeType);
                     //int GetLowestOrderID(int TradeType);
                     
                     m_bInCloseRegion=true;
                     
                                         
               }
               else
               {
                   if(m_bInCloseRegion)
                   {
                      if((Ask-dVal_OrderPrice)>=2*Point*m_PointFactor && (Ask-dVal_OrderPrice)<4*Point*m_PointFactor)
                      {
                        if(nOrderCount>=5)
                        {
                         /*
                         if(CloseAllCurrentOrderByOrderID(GetLowestOrderID(OP_BUY)))
                         {
                            m_bInCloseRegion=false;
                            m_LastOrderPriceBuy=dVal_OrderPrice;
                         }
                         */
                        }
                      }
                        
                   }
                  
               }
               
               if(nOrderCount>=3)
               {
                  if(ManageMartingle_CloseLastAndFistTrade(10,100))
                  {
                     SetStopLostForMultiTrade_Ext(PipProfit);
                  }
               }
               
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount<2)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
            
                 if(Ask>MA200 && Ask>MA300)
                 {
                   
                    //CloseAllCurrentOrder();
                 }
                 if(Ask>MA200 && dVal_OrderPrice<MA200 && dVal_OrderPrice<MA100)
                 {
                   
                    //CloseAllCurrentOrder();
                 }
                 
            
            
                if(((Ask-dVal_OrderPrice)>m_SingleClosingDist*Point*m_PointFactor) && Ask>MA400 && m_SingleClosingEnable==true)
                {
                    //CloseAllCurrentOrder();
                }                          
                else if(dSar>Close[0] && dSar1>Close[1])
                {
                   if(Close[1]>Close[2] && Close[2]>Close[3])
                   {
                   
                   }
                   else if(Close[0]>Close[2])
                   {
                   
                   }
                   else
                   {
                    double Lot2=GetCurrentTradeLotSize();                            
                    SetLostSize(Lot2*MultiFactor_1);
                    TradeSell(dStopLost);
                    //printf("xxxxxxxxxxxxxxxxxxxxx 12");
                    SetStopLostForMultiTrade_Ext(PipProfit_3);
                   }
                }
                   
            }         
         }
         else
         {
         
             

               if((dVal_OrderPrice-Ask)>15*Point*m_PointFactor)
               {
                   m_bInCloseRegion=true;
                   
               }
               else
               {
                    if(m_bInCloseRegion)
                    {
                      if((dVal_OrderPrice-Ask)>=1*Point*m_PointFactor && (dVal_OrderPrice-Ask)<4*Point*m_PointFactor)
                      {
                        if(nOrderCount>=4)
                        {
                         /*
                         if(CloseAllCurrentOrderByOrderID(GetHighestOrderID(OP_SELL)))
                         {
                            m_bInCloseRegion=false;
                            m_LastOrderPriceSell=dVal_OrderPrice;
                         }
                         */
                        }
                      }
                    }
               }
               
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  
                      if(dSar>Close[0] && dSar1>Close[1])                      
                      {
                             double Lot2=GetCurrentTradeLotSize();                             
                             SetLostSize(Lot2*MultiFactor);
                             TradeSell(dStopLost);
                             //printf("xxxxxxxxxxxxxxxxxxxxx 18");
                             SetStopLostForMultiTrade_Ext(PipProfit);
                      }
               } //Mart Dist    
               
               if(nOrderCount>=3)
               {
                  if(ManageMartingle_CloseLastAndFistTrade(10,100))
                  {
                     SetStopLostForMultiTrade_Ext(PipProfit);
                  }
               }
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }


 void TradeManager::ManageRunningTrade_Scalpping_Martingle_2018()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   int    PipProfit_3=m_nProfitTargetInPips;
   
   double MultiFactor=1.5;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
    double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA3_3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 4);

    double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA14 = iMA(NULL, m_nTimePeriod, 14, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA400 = iMA(NULL, m_nTimePeriod, 400, 0, MODE_SMA, PRICE_CLOSE, 1);
    
    double dHigh=iHigh(NULL,m_nTimePeriod,iHighest(NULL,m_nTimePeriod,MODE_HIGH,6,1));
    double dLow=iLow(NULL,m_nTimePeriod,iLowest(NULL,m_nTimePeriod,MODE_LOW,6,1));
    
    
        //double  dProfit_Target=GetTargetProfit_AllTrade(5);
        //double  dProfit_ActuaL=CalculateOrderProfit_AllTrade();
           
      
           

      if(nOrdetType==OP_BUY)
      {  
        /*if(dProfit_Target<dProfit_ActuaL)
        {
           if(Close[0]<Open[0])
             CloseAllCurrentOrderByDir(OP_BUY);
        }
         */
        if(nOrderCount<2)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if(CheckTrend()==TREND_UP)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                    
                   if(nOrderCount==1)
                   {     
                      if(m_RegressionSlope5>1 && m_RegressionSlope50>0 && m_RegressionSlope150>0.5)
                      {
                             double Lot2=GetCurrentTradeLotSize();                       
                             SetLostSize(Lot2*1);
                             TradeBuy(dStopLost);
                             SetStopLostForMultiTrade_Ext(5);
                       }
                       else if((dVal_OrderPrice-Ask)>150*Point*m_PointFactor)
                       {
                             double Lot2=GetCurrentTradeLotSize();                       
                             SetLostSize(Lot2*1);
                             TradeBuy(dStopLost);
                             SetStopLostForMultiTrade_Ext(5);
                           
                       } 
                   
                   } 
                   else
                   {
                      if(MA3>MA8 && MA3>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);  
   
                      }
                      else if(MA8>MA14 && MA8>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);  
   
                      }
                      else if((dVal_OrderPrice-Ask)>120*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit_3);
         
                      }
                       
                      
                   }
                } 
              }
              else
              {
                  if(CheckTrend()==TREND_UP)
                  {
                      if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor && MA3>MA8 && Ask>dLow)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);
         
                      } 
                  }                
              }
            }
            else
            {
             //TraillingStop(); 
             //TraillingStop_1();
             if(nOrderCount==1)
             TraillingStop_New();
             
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                      if(MA3>MA8 && MA3>MA20)
                      {

                       double Lot2=GetCurrentTradeLotSize();                    
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      }
                      else if(MA8>MA14 && MA8>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);  
   
                      }                      
                      else if((dVal_OrderPrice-Ask)>120*Point*m_PointFactor && MA3>MA3_3)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                      
                  }
                  else
                  {
                    if(CheckTrend()==TREND_UP)
                    {
                      if((dVal_OrderPrice-Ask)>120*Point*m_PointFactor && MA3>MA8 && Ask>dLow)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                     }                  
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      { /*
        if(dProfit_Target<dProfit_ActuaL)
        {
           if(Close[0]>Open[0])
             CloseAllCurrentOrderByDir(OP_SELL);
        }
        */
         if(nOrderCount<2)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {                                 
                   if(nOrderCount==1)
                   {
                      if(m_RegressionSlope5<-1 && m_RegressionSlope50<0 && m_RegressionSlope150<-0.5)
                      {

                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*1);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(5);
                      }
                      else if((Ask-dVal_OrderPrice)>150*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit_3);
                      }
                   
                   }
                   else
                   { 
                    
                      if(MA3<MA8 && MA3<MA20)
                      {
   
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);
                      }
                      else if(MA8<MA14 && MA8<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);
   
                      }
                      else if((Ask-dVal_OrderPrice)>120*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit_3);
         
                      }
                      
                   }
               
             }
             else
             {
               if(CheckTrend()==TREND_DOWN)
               {
                      if((Ask-dVal_OrderPrice)>120*Point*m_PointFactor && MA3<MA8 && Ask<dHigh)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                }
             
             }
            }         
            else
            {
               if(nOrderCount==1)
               TraillingStop_New();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN &&(Time[0]-dtTime)>Period()*60)
                  {
                  
                      if(MA3<MA8 && MA3<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                             
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);
                      }
                      else if(MA8<MA14 && MA8<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                             
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);
   
                      }
                      
                      else if((Ask-dVal_OrderPrice)>120*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);
         
                     }
                  }
               } //Mart Dist
                else if((Ask-dVal_OrderPrice)>120*Point*m_PointFactor && MA3<MA8 && Ask<dHigh)
                {
                        if(CheckTrend()==TREND_DOWN)
                        {           
                          double Lot2=GetCurrentTradeLotSize();
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);
                         }
   
               }
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }



 void TradeManager::ManageRunningTrade_Scalpping_Martingle_Regression()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   int    PipProfit_3=m_nProfitTargetInPips;
   
   double MultiFactor=1.5;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
    double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA3_3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 4);

    double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA14 = iMA(NULL, m_nTimePeriod, 14, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA400 = iMA(NULL, m_nTimePeriod, 400, 0, MODE_SMA, PRICE_CLOSE, 1);
    
    double dHigh=iHigh(NULL,m_nTimePeriod,iHighest(NULL,m_nTimePeriod,MODE_HIGH,6,1));
    double dLow=iLow(NULL,m_nTimePeriod,iLowest(NULL,m_nTimePeriod,MODE_LOW,6,1));
    
    double dSar=iSAR(NULL,0,0.02,0.2,0);
    double dSar1=iSAR(NULL,0,0.02,0.2,1);
 

      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount<2)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if(m_RegressionSlope5>3 && m_RegressionSlope20>0)
              {
                 if((Time[0]-dtTime)>Period()*60*4)
                 {
                   if(nOrderCount==1)
                   {     
                             double Lot2=GetCurrentTradeLotSize();                       
                             SetLostSize(Lot2*MultiFactor_1);
                             TradeBuy(dStopLost);
                             SetStopLostForMultiTrade_Ext(PipProfit_3);
                   } 
                   else
                   {
                       double Lot2=GetCurrentTradeLotSize();
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit_3);
                      
                   }
                } 
              }
              else
              {
                   if(nOrderCount==1)
                   TraillingStop_New();
              
              }
            }
            else
            {
             if(nOrderCount==1)
             TraillingStop_New();
             
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(m_RegressionSlope5>3 && m_RegressionSlope20>0 &&  (Time[0]-dtTime)>Period()*60*10)
                  {
                       double Lot2=GetCurrentTradeLotSize();                    
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);                       
                      if(nOrderCount>3)
                       SetStopLostForMultiTrade_Ext(PipGapforScalp);
                       else 
                       SetStopLostForMultiTrade_Ext(PipProfit);
                   }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount<2)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if(m_RegressionSlope5<-3 && m_RegressionSlope20<0 &&(Time[0]-dtTime)>Period()*60*1)
             {     
                   if(nOrderCount==1)
                   {     
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor_1);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);
                  }
                  else
                  {
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor_1);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit_3);
                  
                  }
                   
             }
             else
             {
               if(nOrderCount==1)
               TraillingStop_New();
             
             }
            }         
            else
            {
               if(nOrderCount==1)
               TraillingStop_New();
            }                                    
         }
         else
         {
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(m_RegressionSlope5<-3 && m_RegressionSlope20<0 &&  (Time[0]-dtTime)>Period()*60*10)
                  {                  
                       double Lot2=GetCurrentTradeLotSize();
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       if(nOrderCount>3)
                       SetStopLostForMultiTrade_Ext(PipGapforScalp);
                       else 
                       SetStopLostForMultiTrade_Ext(PipProfit);
                  }
               } //Mart Dist
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_Fast()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount<3)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
                 
                 if(iClose(NULL,PERIOD_CURRENT,1)>iOpen(NULL,PERIOD_CURRENT,1))
                 {
                       double Lot2=GetCurrentTradeLotSize();                       
                       
                       Lot2=Lot2+0.01;
                       
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
            }
            else
            {
             TraillingStop_1();
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  //if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                 if(iClose(NULL,PERIOD_CURRENT,1)>iOpen(NULL,PERIOD_CURRENT,1))
                  {
                       double Lot3=GetCurrentTradeLotSize(); 
                          
                         Lot3=Lot3+0.02;
                                 
                       SetLostSize(Lot3);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount<3)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
                 //if((Time[0]-dtTime)>Period()*60)
                 if(iClose(NULL,PERIOD_CURRENT,1)<iOpen(NULL,PERIOD_CURRENT,1))                 
                 {
                       double Lot4=GetCurrentTradeLotSize();                            

                       Lot4=Lot4+0.01;
                       SetLostSize(Lot4);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                } 
            }         
            else
            {
               //TraillingStop(); 
               TraillingStop_1();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  //if(CheckTrend_1()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                 if(iClose(NULL,PERIOD_CURRENT,1)<iOpen(NULL,PERIOD_CURRENT,1))                 
                  {
                          double Lot5=GetCurrentTradeLotSize();
                          
                            Lot5=Lot5+0.02;
                                    
                       
                          SetLostSize(Lot5);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_Fast_1()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount<3)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
                 
                 if(iClose(NULL,PERIOD_M5,0)>iOpen(NULL,PERIOD_M5,0))
                 //if((Time[0]-dtTime)>Period()*60)
                 {
                       double Lot2=GetCurrentTradeLotSize();                       
                       
                       Lot2=Lot2+0.01;
                       
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
            }
            else
            {
             TraillingStop_1();
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  //if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)>iOpen(NULL,PERIOD_M5,0))
                  {
                       double Lot3=GetCurrentTradeLotSize(); 
                          
                       if(Lot3<=0.04)
                         Lot3=Lot3+0.01;
                       else  
                         Lot3=Lot3+0.02;
                                 
                       SetLostSize(Lot3);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount<3)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
                 //if((Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)<iOpen(NULL,PERIOD_M5,0))                 
                 {
                       double Lot4=GetCurrentTradeLotSize();                            

                       Lot4=Lot4+0.01;
                       SetLostSize(Lot4);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                } 
            }         
            else
            {
               //TraillingStop(); 
               TraillingStop_1();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  //if(CheckTrend_1()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)<iOpen(NULL,PERIOD_M5,0))                 
                  {
                          double Lot5=GetCurrentTradeLotSize();
                          
                          if(Lot5<=0.04)
                            Lot5=Lot5+0.01;
                          else  
                            Lot5=Lot5+0.02;
                                    
                       
                          SetLostSize(Lot5);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

void TradeManager::ManageRunningTrade_Scalpping_Martingle_Fast_MULTI()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
          PipProfit=5;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount<3)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
                 
                 if(iClose(NULL,PERIOD_M5,0)>iOpen(NULL,PERIOD_M5,0))
                 //if((Time[0]-dtTime)>Period()*60)
                 {
                       double Lot2=GetCurrentTradeLotSize();                       
                       
                       Lot2=Lot2*2;
                       
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
            }
            else
            {
             TraillingStop_1();
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  //if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)>iOpen(NULL,PERIOD_M5,0))
                  {
                       double Lot3=GetCurrentTradeLotSize(); 
                          
                      
                         Lot3=Lot3*2;
                                 
                       SetLostSize(Lot3);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount<3)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
                 //if((Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)<iOpen(NULL,PERIOD_M5,0))                 
                 {
                       double Lot4=GetCurrentTradeLotSize();                            

                       Lot4=Lot4*2;
                       SetLostSize(Lot4);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                } 
            }         
            else
            {
               //TraillingStop(); 
               TraillingStop_1();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  //if(CheckTrend_1()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                 //if(iClose(NULL,PERIOD_M5,0)<iOpen(NULL,PERIOD_M5,0))                 
                  {
                          double Lot5=GetCurrentTradeLotSize();
                          
                            Lot5=Lot5*2;;
                                    
                       
                          SetLostSize(Lot5);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_1_Old()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=2;
   double MultiFactor_1=1.5;
   int    PipGapforScalp=2;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3>MA8 && MA3>MA20)
                   {
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                   }
                } 
              }
              else if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
              {           
                       double Lot2=GetCurrentTradeLotSize();
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);

              }
              
            }
            else
            {
             TraillingStop_New(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA50 = iMA(NULL, m_nTimePeriod, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
                  
                  if(nOrderCount<4)
                  {
                     if(MA3>MA8 &&  MA8>MA20 && MA20>MA50)
                     {
                          double Lot2=GetCurrentTradeLotSize();                    
                          SetLostSize(Lot2*MultiFactor_1);
                          SetTradeComment("MA need Buy");
                          TradeBuy(dStopLost);                       
                          SetStopLostForMultiTrade_Ext(PipProfit);
                        
                     }
                  
                  }
                  else
                  {                  
                     if(MA3>MA8 &&  MA8>MA20 && MA20>MA50)
                     {

                     if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                     {
                          double Lot2=GetCurrentTradeLotSize();                    
                          SetLostSize(Lot2*MultiFactor_1);
                          SetTradeComment("MA Do not care Buy");
                          TradeBuy(dStopLost);                       
                          SetStopLostForMultiTrade_Ext(PipProfit);
                         
                     }
                     }
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor)
             {             
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3<MA8 && MA3<MA20)
                   {

                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                   }
                } 
             }
             else if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {
                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);   
             }             
            }         
            else
            {
               TraillingStop_New(); 
            }                                    
         }
         else
         {
              
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {

                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA50 = iMA(NULL, m_nTimePeriod, 50, 0, MODE_SMA, PRICE_CLOSE, 1);
               
                  if(nOrderCount<4)
                  {
                     if(MA3<MA8 && MA8<MA20 && MA20<MA50)
                     {
                             double Lot2=GetCurrentTradeLotSize();                                         
                             SetLostSize(Lot2*MultiFactor_1);
                             SetTradeComment("MA need Buy");
                             TradeSell(dStopLost);
                             SetStopLostForMultiTrade_Ext(PipProfit);                                              
                        
                     }
                  
                  }
                  else
                  {                  
                     if(MA3<MA8 && MA8<MA20 && MA20<MA50)
                     {
                        if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                        {
                                double Lot2=GetCurrentTradeLotSize();                                         
                                SetLostSize(Lot2*MultiFactor_1);
                                SetTradeComment("MA Do not care Buy");
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);                                              
      
                        }
                      }
                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_1_trail_1()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if(CheckTrend()==TREND_UP)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA10 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA10>MA20)
                   {
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                   }
                } 
              }
              else if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor && (Time[0]-dtTime)>Period()*60)
              {           
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA10 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA10>MA20)
                   {
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                   }

              }
              
            }
            else
            {
             TraillingStop(); 
             //TraillingStop_1();
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                      double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                      double MA10 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
                      double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                       
                      if(MA10>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);  
   
                      }
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if(CheckTrend()==TREND_DOWN)
             {             
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA8<MA20)
                   {

                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                   }
                } 
             }
             else if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor && (Time[0]-dtTime)>Period()*60)
             {
                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);   
             }             
            }         
            else
            {
               TraillingStop(); 
               //TraillingStop_1();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                      double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                      double MA8 = iMA(NULL, m_nTimePeriod, 10, 0, MODE_SMA, PRICE_CLOSE, 1);
                      double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                       
                      if(MA8<MA20)
                      {
   
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);
                      }

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

void TradeManager::ManageRunningTrade_Scalpping_Martingle_Fract()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
       
     
    HideTestIndicators(false);
   
   double dFractal_1u= iFractals(Symbol(),PERIOD_CURRENT,MODE_UPPER,1);
   double dFractal_1d= iFractals(Symbol(),PERIOD_CURRENT,MODE_LOWER,1);

   double dFractal_2u= iFractals(Symbol(),PERIOD_CURRENT,MODE_UPPER,2);
   double dFractal_2d= iFractals(Symbol(),PERIOD_CURRENT,MODE_LOWER,2);

   double dFractal_3u= iFractals(Symbol(),PERIOD_CURRENT,MODE_UPPER,3);
   double dFractal_3d= iFractals(Symbol(),PERIOD_CURRENT,MODE_LOWER,3);

   
   string str1= " dFractal_1u= "+dFractal_1u+ " dFractal_1d= "+dFractal_1d;
   string str2= " dFractal_2u= "+dFractal_2u+ " dFractal_2d= "+dFractal_2d;
   string str3= " dFractal_3u= "+dFractal_3u+ " dFractal_3d= "+dFractal_3d;

   m_Guppy.LoadData();
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
         
     
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if(dFractal_3d>0)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
              }
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                    if(m_Guppy.GetGuppyDirection()==TREND_DOWN)
                    {
                    
                    }
                    else
                    {
                     if(dFractal_3d>0 && (Time[0]-dtTime)>Period()*60)
                     {
                          double Lot2=GetCurrentTradeLotSize();                    
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);                       
                          SetStopLostForMultiTrade_Ext(PipProfit);
                         
                     }
                    }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {

        if(m_Guppy.guppy_short_6>m_Guppy.guppy_long_1)
        {
           //CloseAllCurrentOrder();
        }
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if(dFractal_3u>0)
             {             
                 if((Time[0]-dtTime)>Period()*60)
                 {
                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                } 
             }
            }         
            else
            {
               TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                    if(m_Guppy.GetGuppyDirection()==TREND_UP)
                    {
                    
                    }
                    else
                    {
                        if(dFractal_3u>0 && (Time[0]-dtTime)>Period()*60)
                        {
                                double Lot2=GetCurrentTradeLotSize();
                                                                           
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                SetStopLostForMultiTrade_Ext(PipProfit);                                              
      
                        }
                     }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }


 void TradeManager::ManageRunningTrade_Scalpping_Martingle_1T()
 {
     HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.5;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
   dStopLost=0;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
    double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA3_3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 4);

    double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA14 = iMA(NULL, m_nTimePeriod, 14, 0, MODE_SMA, PRICE_CLOSE, 1);
    double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
    double dHigh=iHigh(NULL,m_nTimePeriod,iHighest(NULL,m_nTimePeriod,MODE_HIGH,6,1));
    double dLow=iLow(NULL,m_nTimePeriod,iLowest(NULL,m_nTimePeriod,MODE_LOW,6,1));
    
    
      if(nOrdetType==OP_BUY)
      {  
        if(NormalizeDouble(m_CurrentData_Buy,5)==0)
           m_CurrentData_Buy=Ask;
        else if(Ask>m_CurrentData_Buy)
            m_CurrentData_Buy=Ask;
        else
        {
           double  dProfit_Target=GetTargetProfit_AllTrade(m_nProfitTargetInPips);
           double  dProfit_ActuaL=CalculateOrderProfit_AllTrade();
           
           if(dProfit_ActuaL>dProfit_Target)
           {
              
              if(nOrderCount>4)
              {
              
               if((m_CurrentData_Buy-Ask)>10*Point*10)
               {
                if(MA3<MA8)
                 CloseAllCurrentOrder();
               }
             }
             else
             {
               if((m_CurrentData_Buy-Ask)>4*Point*10)
               {
                 CloseAllCurrentOrder();
               }               
             }
           }

        }
            
            
      
        if(nOrderCount<3)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if(CheckTrend()==TREND_UP)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                    
                   if(nOrderCount==1)
                   {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor_1);
                          TradeBuy(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);  
                   
                   } 
                   else
                   {
                      if(MA3>MA8 && MA3>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);  
   
                      }
                      else if(MA8>MA14 && MA8>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);  
   
                      }
                      else if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                       
                      
                   }
                } 
              }
              else
              {
                      if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor && MA3>MA8 && Ask>dLow)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }                 
              }
            }
            else
            {
             //TraillingStop(); 
             TraillingStop_New();
            }                        
         }
         else
         {                
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                      if(MA3>MA8 && MA3>MA20)
                      {

                       double Lot2=GetCurrentTradeLotSize();                    
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);                       
                       //SetStopLostForMultiTrade_Ext(PipProfit);
                      }
                      else if(MA8>MA14 && MA8>MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                       
                          SetLostSize(Lot2*MultiFactor);
                          TradeBuy(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);  
   
                      }                      
                      else if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor && MA3>MA3_3)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                      
                  }
                  else
                  {
                      if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor && MA3>MA8 && Ask>dLow)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeBuy(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }                  
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
    
    
             if(NormalizeDouble(m_CurrentData_Sel,5)==0)
                 m_CurrentData_Sel=Ask;
              else if(Ask<m_CurrentData_Sel)
                  m_CurrentData_Sel=Ask;
              else
              {
                 double  dProfit_Target=GetTargetProfit_AllTrade(m_nProfitTargetInPips);
                 double  dProfit_ActuaL=CalculateOrderProfit_AllTrade();
                 
                 if(dProfit_ActuaL>dProfit_Target)
                 {
                    if(nOrderCount>4)
                    {
                     if((Ask-m_CurrentData_Sel)>4*Point*10)
                     {
                       if(MA3>MA8)
                       CloseAllCurrentOrder();
                     }
                   }
                   else
                   {
                     CloseAllCurrentOrder();
                   }
                 }
      
              }
      
        
         if(nOrderCount<3)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {                                 
                   if(nOrderCount==1)
                   {
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor_1);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
                   
                   }
                   else
                   { 
                    
                      if(MA3<MA8 && MA3<MA20)
                      {
   
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
                      }
                      else if(MA8<MA14 && MA8<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                            
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
   
                      }
                      else if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
                      
                   }
               
             }
             else
             {
                      if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor && MA3<MA8 && Ask<dHigh)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                      }
             
             }
            }         
            else
            {
               //TraillingStop(); 
               TraillingStop_New();
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                  
                      if(MA3<MA8 && MA3<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                             
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
                      }
                      else if(MA8<MA14 && MA8<MA20)
                      {
                          double Lot2=GetCurrentTradeLotSize();                             
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
   
                      }
                      else if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor)
                      {           
                                double Lot2=GetCurrentTradeLotSize();
                                SetLostSize(Lot2*MultiFactor);
                                TradeSell(dStopLost);
                                //SetStopLostForMultiTrade_Ext(PipProfit);
         
                     }
                  }
               } //Mart Dist
                else if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor && MA3<MA8 && Ask<dHigh)
                {           
                          double Lot2=GetCurrentTradeLotSize();
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          //SetStopLostForMultiTrade_Ext(PipProfit);
   
               }
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_3T()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.5;
   double MultiFactor_1=1.5;
   int    PipGapforScalp=2;
       
       
     
    HideTestIndicators(false);
   
   double Lot2=GetCurrentTradeLotSize(); 
   
   if(Lot2<0.03)
   {
      MultiFactor=2;
   }                      

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
                 if((Time[0]-dtTime)>Period()*60)
                 {
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
            }
            else
            {
             TraillingStop_New(); 
            }                        
         }
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    

                    SetLostSize(Lot2*MultiFactor);
                    TradeSell(dStopLost);
                    SetStopLostForMultiTrade_Ext(PipProfit);
                 }
            }         
            else
            {
               TraillingStop_New(); 
            }                                    
         }
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_2T()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();
   double   tp=GetCurrTradeOrderProfit();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=1.5;
   double MultiFactor_1=1.5;
   int    PipGapforScalp=2;
       
       
     
    HideTestIndicators(false);
   
   double Lot2=GetCurrentTradeLotSize(); 
   
   if(Lot2<0.03)
   {
      MultiFactor=2;
   }                      

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
                 if((Time[0]-dtTime)>Period()*60)
                 {
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                } 
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  if((Time[0]-dtTime)>Period()*60)
                  {
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    

                    SetLostSize(Lot2*MultiFactor);
                    TradeSell(dStopLost);
                    SetStopLostForMultiTrade_Ext(PipProfit);
                 }
            }         
            else
            {
               TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if((Time[0]-dtTime)>Period()*60)
                  {
                                                                     
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_11()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=m_nProfitTargetInPips;
   double MultiFactor=2;
   double MultiFactor_1=2;
   int    PipGapforScalp=2;
       
     
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if((dVal_OrderPrice-Ask)>100*Point*m_PointFactor)
              {
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3>MA8 && MA3>MA20)
                   {
                       double Lot2=GetCurrentTradeLotSize();                       
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);  

                   }
                } 
              }
              else if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
              {           
                       double Lot2=GetCurrentTradeLotSize();
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);

              }
              
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                       double Lot2=GetCurrentTradeLotSize();                    
                       SetLostSize(Lot2*MultiFactor);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);
                      
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
        
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if((Ask-dVal_OrderPrice)>100*Point*m_PointFactor)
             {             
                 if((Time[0]-dtTime)>Period()*60)
                 {
                   double MA3 = iMA(NULL, m_nTimePeriod, 3, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA8 = iMA(NULL, m_nTimePeriod, 8, 0, MODE_SMA, PRICE_CLOSE, 1);
                   double MA20 = iMA(NULL, m_nTimePeriod, 20, 0, MODE_SMA, PRICE_CLOSE, 1);
                    
                   if(MA3<MA8 && MA3<MA20)
                   {

                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);
                   }
                } 
             }
             else if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {
                       double Lot2=GetCurrentTradeLotSize();                            
                       SetLostSize(Lot2*MultiFactor);
                       TradeSell(dStopLost);
                       SetStopLostForMultiTrade_Ext(PipProfit);   
             }             
            }         
            else
            {
               TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                          double Lot2=GetCurrentTradeLotSize();
                                                                     
                          SetLostSize(Lot2*MultiFactor);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              

                  }
               } //Mart Dist
                                          
         }// Order Count
        
      }//Order Type
   }//Order Count >0
   else
   {
     m_nCurrScapdata.nLoopState=false;
   }
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_4()
 {
    HideTestIndicators(true);
 
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=5;

   double Data=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_MAIN,0);
   double Signal=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_SIGNAL,0);
   //double Data1=iStochastic(NULL,PERIOD_M15,30,10,5,MODE_SMA,0,MODE_MAIN,2);
   //double Signal1=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_SIGNAL,2);
   
   //double MA_20_0=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0);     
   //double MA_20_2=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);     
   //double MA_20_4=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,4);
   
   double moement_1=iMomentum(NULL,0,14,PRICE_CLOSE,1);
   double moement_2=iMomentum(NULL,0,14,PRICE_CLOSE,2);            
   double moement_3=iMomentum(NULL,0,14,PRICE_CLOSE,4);
        
   
   
    HideTestIndicators(false);
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>m_MargtingFirstlevel*Point*m_PointFactor)
            {   
              if((Time[0]-dtTime)>Period()*60)
              {           
                 double Lot2=GetCurrentTradeLotSize();
                 Lot2=Lot2*2;
                 SetLostSize(Lot2);
                 TradeBuy(dStopLost);
                 SetStopLostForMultiTrade_Ext(PipProfit);
              }
                  
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if((Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                       Lot2=Lot2*2;
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);                                                
                  }
               }// Mart Dist
         }// Order Count
      }
      else if(nOrdetType==OP_SELL)
      {
         
      
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>m_MargtingFirstlevel*Point*m_PointFactor)
            {
             if((Time[0]-dtTime)>Period()*60)
             {
              double Lot2=GetCurrentTradeLotSize();                            
              Lot2=Lot2*2;
              SetLostSize(Lot2);
              TradeSell(dStopLost);
              SetStopLostForMultiTrade_Ext(PipProfit);
             }
            }         
            else
            {
             TraillingStop(); 
            }                                    
         }
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if((Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                          Lot2=Lot2*2;
                          SetLostSize(Lot2);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              
                  }
               } //Mart Dist            
         }// Order Count
        
      }//Order Type
   }//Order Count >0
 }
 

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_2()
 {
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=5;

    HideTestIndicators(true);

   double Data=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_MAIN,0);
   double Signal=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_SIGNAL,0);
   //double Data1=iStochastic(NULL,PERIOD_M15,30,10,5,MODE_SMA,0,MODE_MAIN,2);
   //double Signal1=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_SIGNAL,2);
   
   //double MA_20_0=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0);     
   //double MA_20_2=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);     
   //double MA_20_4=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,4);
   
   double moement_1=iMomentum(NULL,0,14,PRICE_CLOSE,1);
   double moement_2=iMomentum(NULL,0,14,PRICE_CLOSE,2);            
   double moement_3=iMomentum(NULL,0,14,PRICE_CLOSE,4);
        
    HideTestIndicators(false);
   
   
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
            {   
              if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
              {           
                 double Lot2=GetCurrentTradeLotSize();
                 Lot2=Lot2*2;
                 SetLostSize(Lot2);
                 TradeBuy(dStopLost);
                 SetStopLostForMultiTrade_Ext(PipProfit);
              }
                  
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else if(nOrderCount<=3)
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                       Lot2=Lot2*2;
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);                                                
                  }
               }// Mart Dist
         }// Order Count
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                  if(CheckTrend()==TREND_UP && (Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                       Lot2=Lot2*4;
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);                                                
                  }
               }// Mart Dist
         }// Order Count

      }
      else if(nOrdetType==OP_SELL)
      {
         
      
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
            {
             if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
             {
              double Lot2=GetCurrentTradeLotSize();                            
              Lot2=Lot2*2;
              SetLostSize(Lot2);
              TradeSell(dStopLost);
              SetStopLostForMultiTrade_Ext(PipProfit);
             }
            }         
            else
            {
             TraillingStop(); 
            }                                    
         }
         else if(nOrderCount<=3)
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                          Lot2=Lot2*2;
                          SetLostSize(Lot2);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              
                  }
               } //Mart Dist            
         }// Order Count
         else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                  if(CheckTrend()==TREND_DOWN && (Time[0]-dtTime)>Period()*60)
                  {
                    double Lot2=GetCurrentTradeLotSize();
                    
                          Lot2=Lot2*4;
                          SetLostSize(Lot2);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              
                  }
               } //Mart Dist            
         }// Order Count
        
      }//Order Type
   }//Order Count >0
 }

 void TradeManager::ManageRunningTrade_Scalpping_Martingle_3()
 {
   int nOrderCount=GetTradeCount();
   int nOrdetType=GetCurrentOrderType();
   double  dVal_OrderPrice=GetCurrTradeOrderPrice();
   double  dStopLost=GetCurrOrderStopLost();
   datetime dtTime=GetCurrTradeOpenTime();

   int nBuyCount=0;
   int nSellCount=0;   
   GetOrderCount(nBuyCount,nSellCount);
   
   double dMartingleDist=m_Margtinglevel;
   int    PipProfit=5;

   double Data=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_MAIN,0);
   double Signal=iStochastic(NULL,PERIOD_M15,8,5,5,MODE_SMA,0,MODE_SIGNAL,0);
   //double Data1=iStochastic(NULL,PERIOD_M15,30,10,5,MODE_SMA,0,MODE_MAIN,2);
   //double Signal1=iStochastic(NULL,PERIOD_M5,30,10,5,MODE_SMA,0,MODE_SIGNAL,2);
   
   //double MA_20_0=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,0);     
   //double MA_20_2=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);     
   //double MA_20_4=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,4);
   
   double moement_1=iMomentum(NULL,0,14,PRICE_CLOSE,1);
   double moement_2=iMomentum(NULL,0,14,PRICE_CLOSE,2);            
   double moement_3=iMomentum(NULL,0,14,PRICE_CLOSE,4);
        
   
   
   

   if(nOrderCount>0)
   {
      if(nOrdetType==OP_BUY)
      {  
        if(nOrderCount==1)
         {
            if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
            {   
                 double Lot2=GetCurrentTradeLotSize();
                 Lot2=Lot2*2;
                 SetLostSize(Lot2);
                 TradeBuy(dStopLost);
                 SetStopLostForMultiTrade_Ext(PipProfit);
                  
            }
            else
            {
             TraillingStop(); 
            }                        
         }
         else
         {
               if((dVal_OrderPrice-Ask)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0>MA_20_2)
                    double Lot2=GetCurrentTradeLotSize();
                    
                       Lot2=Lot2*2;
                       SetLostSize(Lot2);
                       TradeBuy(dStopLost);                       
                       SetStopLostForMultiTrade_Ext(PipProfit);                                                
               }// Mart Dist
         }// Order Count

      }
      else if(nOrdetType==OP_SELL)
      {
         
      
         if(nOrderCount==1)
         {
            if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
            {
              double Lot2=GetCurrentTradeLotSize();                            
              Lot2=Lot2*2;
              SetLostSize(Lot2);
              TradeSell(dStopLost);
              SetStopLostForMultiTrade_Ext(PipProfit);
            }         
            else
            {
             TraillingStop(); 
            }                                    
         }
        else
         {
              
               if((Ask-dVal_OrderPrice)>dMartingleDist*Point*m_PointFactor)
               {
                  //if(MA_20_0<MA_20_2)
                    double Lot2=GetCurrentTradeLotSize();
                    
                          Lot2=Lot2*2;
                          SetLostSize(Lot2);
                          TradeSell(dStopLost);
                          SetStopLostForMultiTrade_Ext(PipProfit);                                              
               } //Mart Dist            
         }// Order Count
        
      }//Order Type
   }//Order Count >0
 }
 
void TradeManager::SetStopLostForMultiTrade_Ext(int ProfitTargetInPips)
{

   double  TotalLotSize= 0;
   double  CalculatedProfit=0;
   int     nPipIncrement=0;
   double  RpT=0;
   double  TotalProfitTargeted=0;
   double  BEP=0;
   int     tmpTradeCount=0;

   int     LastOrderType=GetCurrentOrderType();
   double  ReferncePt=GetCurrTradeOrderPrice();
   double  DProfitTarget=0;
   double  dStopLost=GetCurrOrderStopLost();

   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
           tmpTradeCount++;
           TotalLotSize=TotalLotSize+OrderLots();
           DProfitTarget=DProfitTarget+(OrderLots()*10*ProfitTargetInPips);
        }
      }
   }

   if(tmpTradeCount>0)
   {
     //TotalProfitTargeted=(TotalLotSize*10*ProfitTargetInPips)/tmpTradeCount;
      if(tmpTradeCount>6)
      {
        TotalProfitTargeted=DProfitTarget*1.0; 
      }
      else
      {
        TotalProfitTargeted=DProfitTarget;
      }
     
     
               
               //m_Profit_Cal_2=m_Profit_Cal_2+"Lot Size="+TotalLotSize+"Target Profit="+TotalProfitTargeted;
                
             
               while(CalculatedProfit<TotalProfitTargeted)
               {
                  nPipIncrement++;
                  
                  double ddSpread=MarketInfo(Symbol(),MODE_SPREAD);
                  
                  if(LastOrderType==OP_BUY)
                  {
                   RpT=ReferncePt+nPipIncrement*Point*m_PointFactor+ddSpread*Point;
                  }
                  else if(LastOrderType==OP_SELL)
                  {
                   RpT=ReferncePt-nPipIncrement*Point*m_PointFactor-ddSpread*Point;
                  }
                  
                  CalculatedProfit=0;
                  
                  for(int i=0;i<OrdersTotal();i++)
                  {
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
                       {
                              if(OrderType()==OP_SELL)
                              {
                               CalculatedProfit=CalculatedProfit+(((OrderOpenPrice()-RpT)/(Point*m_PointFactor))*(OrderLots()*10))+OrderCommission();
                              }
                              else if(OrderType()==OP_BUY)
                              {
                               CalculatedProfit=CalculatedProfit+(((RpT-OrderOpenPrice())/(Point*m_PointFactor))*(OrderLots()*10))+OrderCommission();
                              }
                              if(CalculatedProfit>=0 && BEP==0)
                              {
                                 BEP=RpT;
                              }
                              double DProfit=(((RpT-OrderOpenPrice())/(Point*m_PointFactor))*OrderLots());
                              
                              //printf("Pip Incrment=%d => CalculatedProfit Pt=%0.2f,OrderOpenPrice=%0.5f, Lot Size=%0.2f \n\r",nPipIncrement,DProfit,OrderOpenPrice(),OrderLots() );
                              
                       }
                     }
                  }   
               }
              
               double dOrderStopLost=RpT;
               
               //printf("Targer Profit=%0.2f=> Reference Pt=%0.5f, Pip Incrment=%d, Rtp=%0.5f => CalculatedProfit total Pt=%0.2f \n\r",TotalProfitTargeted,ReferncePt,nPipIncrement,RpT,CalculatedProfit);
              
              //m_Profit_Cal_2=m_Profit_Cal_2+"\n\r"+
              
               
               
                  for(int i=OrdersTotal();i>0;i--)
                  {
                     if(OrderSelect(i-1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
                       {
                             bool test;
                               
                              if(OrderType()==OP_SELL)
                              {
                                //printf("Sell TP Existing %0.5f, requested=%0.5f\n\r",OrderTakeProfit(),OrderStopLost);
                                                                
                                if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),dOrderStopLost))
                                {
                                   RefreshRates();
                                   string dval="-----Ticket ID "+OrderTicket()+" ------------";
                                   //Print(dval);
                                   if(OrderTicket()>=0)
                                   test=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(dOrderStopLost,Digits),OrderExpiration(),CLR_NONE);

                                       if(!test)
                                       Print("Error1 in OrderModify. Error code=",GetLastError());
                                       else
                                       Print("Order 1 modified successfully.");                 

                                }

                              
                              }
                              else if(OrderType()==OP_BUY)
                              {
                                //printf("Buy TP Existing %0.5f, requested=%0.5f\n\r",OrderTakeProfit(),OrderStopLost);

                                if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),dOrderStopLost))
                                {
                                  
                                   RefreshRates();
                                   string dval="-----Ticket ID "+OrderTicket()+" ------------";
                                   //Print(dval);
                                   
                                   if(OrderTicket()>=0)
                                   {
                                     test=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),NormalizeDouble(dOrderStopLost,Digits),OrderExpiration(),CLR_NONE);
                                     
                                       if(!test)
                                       Print("Error2 in OrderModify. Error code=",GetLastError());
                                       else
                                       Print("Order 2 modified successfully.");                 
                                   }
                                }
                              }
                       }
                     }
                  }
   }   

}

 
 void TradeManager::ManageRunningTrade_Scalpping_2011()
 {

     double ProfitInPips=GetCurrentProfit();
     double dProfit=CalculateOrderProfit_AllTrade();
     double dOrderPrice=GetCurrTradeOrderPrice();
     datetime dtdatetime=GetCurrTradeOpenTime();
     int    nOrderType=GetCurrentOrderType();
     
     if(m_nLowestLostInPips==0)
     m_nLowestLostInPips=Ask;
     if(m_nHighestGainInPips==0)
     m_nHighestGainInPips=Bid;
      
        
        
       
     //m_DebugInfo1="Highest Profit in Current Trade="+ IntegerToString(m_nHighestGainInPips)+"Highest Lost in Current Trade="+IntegerToString(m_nLowestLostInPips)+"\n\r";
     
     long TimeElapse=TimeCurrent()-dtdatetime;     
     int Minutes=(int)TimeElapse/60;
       
     
     if(ProfitInPips>0)
     {
       CloseAllCurrentOrder(); 
     }
     else if(dProfit>0)
     {
       //CloseAllCurrentOrder(); 
       
     }
     
     
         
     if(nOrderType==OP_BUY)
     {
         if(Bid>dOrderPrice)
         {
            if(Bid>m_nHighestGainInPips)
             {
               m_nHighestGainInPips=Bid;
               double Delta=(Bid-dOrderPrice)/(Point*m_PointFactor);
               if(Delta<3)
               {
                //MoveStopLostFromExitingStopLOst(Delta);
               }
               else
               {
                 //MoveStopLostFromExitingStopLOst(Delta);
                 //MoveStopLostFromOrder(2);
               }
             }
         }
     }
     else if(nOrderType==OP_SELL)
     {
      if(Ask<dOrderPrice)
      {
       if(Ask<m_nLowestLostInPips)
       {
          m_nLowestLostInPips=Ask;
          double Delta=(dOrderPrice-Ask)/(Point*m_PointFactor);
          if(Delta<3)
          {
            //MoveStopLostFromExitingStopLOst(Delta);
          }
          else
          {
            //MoveStopLostFromExitingStopLOst(Delta);
             //MoveStopLostFromOrder(2);
          }
       }
      }
     }
    
     
     TraillingStop();
         
      if(m_nLockTradePriceInPip>0 && m_nLockTradePriceGapInPip>0)
      {
           //m_DebugInfo1=m_DebugInfo1+"Lock Pip Active at LockPip="+m_nLockTradePriceInPip+" "+"Gep="+m_nLockTradePriceGapInPip+"\n\r";
           
           MoveStopLostToBEP_ForLockPip();
             
           if(m_bUseTrailingStop)
           {
            //m_DebugInfo1=m_DebugInfo1+" Trailing Stop also Active \n\r";
            //TraillingStop();
           }
           else
           {
            //m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }
      }
      else
      {
           if(m_bUseTrailingStop)
           {
            //m_DebugInfo1=m_DebugInfo1+" Only Trailing Stop is Active \n\r";
            //TraillingStop();
           }
           else
           {
            //m_DebugInfo1=m_DebugInfo1+"Trailing Stop is not Active \n\r";
           }      
      }
     
 }




double TradeManager::RiskManagedLotCalculation(double dRisk)
{
  
   double Lot;
   m_dRisk_Per_Trade=dRisk;
   double Procent=AccountEquity();
   
   
   double stops=MarketInfo(Symbol(),MODE_STOPLEVEL)*Point;
   double One_Lot=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
  
   
   if(m_IsFixedLost)
   {
      Lot=m_FixedLotSize;

      if(AccountFreeMargin()<One_Lot*Lot) 
      {  
        return (0);
      }

   }
   else
   {
       double Procent=AccountEquity();
       
       int nCountLot=Procent/m_Increament_01_Amount;
       
       if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.01)      
       Lot= 0.01*nCountLot;
       if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.1)      
       Lot= 0.1*nCountLot;
       
       
           
      if(AccountFreeMargin()<One_Lot*Lot) 
      {  
        return (0);
      }      
   }
   
   if(Lot<MarketInfo(Symbol(),MODE_MINLOT)) 
   {
     Lot=MarketInfo(Symbol(),MODE_MINLOT);
   }
  
   if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.01)
   {
      m_LotsSize=NormalizeDouble(Lot,2);   
   }
   else if(MarketInfo(Symbol(), MODE_LOTSTEP)==0.1)
   {
      m_LotsSize=NormalizeDouble(Lot,1);   
   }
   else
   {
      m_LotsSize=NormalizeDouble(Lot,2);
   }
   
   if(m_LotsSize>10) m_LotsSize=10;
   
   string Text;  
   double lots=0;
   CheckVolumeValue(m_LotsSize,Text,lots);
   
   ////printf("---Size is = %s",Text);
   
   m_LotsSize=lots;
   
   return(m_LotsSize);
}

int TradeManager::CheckTrend()
{
    HideTestIndicators(true);
        
    int nTrend=TREND_NO;
    /*
    double Main_D1=iStochastic(NULL,PERIOD_D1,5,3,3,MODE_SMA,0,MODE_MAIN,0);
    double Signal_D1=iStochastic(NULL,PERIOD_D1,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);  
    double Main_5=iStochastic(NULL,PERIOD_M5,20,14,9,MODE_SMA,0,MODE_MAIN,0);
    double Signal_5=iStochastic(NULL,PERIOD_M5,20,14,9,MODE_SMA,0,MODE_SIGNAL,0);  
    
    //-------------------------------
    double drsi=iRSI(NULL,0,14,PRICE_CLOSE,0);
    double dRVI_MAIN=iRVI(NULL,0,10,MODE_MAIN,0);
    double dRVI_SIGNAL=iRVI(NULL,0,10,MODE_SIGNAL,0);

    
    //-------------------------------

    double atr_1=iATR(NULL,PERIOD_M5,14,0);
    double atr_2=iATR(NULL,PERIOD_M5,14,1);
    double atr_3=iATR(NULL,PERIOD_M5,14,2);

     double CC_0     =iCCI(Symbol(),0,14,PRICE_CLOSE,0);
     double CC_1     =iCCI(Symbol(),0,14,PRICE_CLOSE,1);
     double CC_2     =iCCI(Symbol(),0,14,PRICE_CLOSE,2);
     double CC_6     =iCCI(Symbol(),0,14,PRICE_CLOSE,6);
     
     
     double tmpAC_1  =iAC(NULL,PERIOD_M5,0);
     double tmpAC_2  =iAC(NULL,PERIOD_M5,1);
     double tmpAC_3  =iAC(NULL,PERIOD_M5,2);
     
    double moement_H1_0=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,1);//120
    double moement_H1_1=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,2);
    double moement_H1_2=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,3);//  90
     
     double Force_1  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,0);
     double Force_2  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,1);
     double Force_3  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,2);
    
     double iMA_7_0=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_7_1=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_7_2=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,2);
     
     double iMA_20_0=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_20_3=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,3);
     double iMA_20_6=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double iMA_50_0=iMA(NULL,0,50,0,MODE_SMMA,PRICE_CLOSE,2);

     double iMA_100_0=iMA(NULL,0,100,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_200_0=iMA(NULL,0,200,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_200_3=iMA(NULL,0,200,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double iMA_500_0=iMA(NULL,0,500,0,MODE_SMMA,PRICE_CLOSE,2);


     double iMA_20_D1_0=iMA(NULL,PERIOD_D1  ,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_50_D1_0=iMA(NULL,PERIOD_D1  ,50,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_100_D1_0=iMA(NULL,PERIOD_D1 ,100,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_50_D1_5=iMA(NULL,PERIOD_D1  ,50,0,MODE_SMMA,PRICE_CLOSE,5);
     double iMA_100_D1_5=iMA(NULL,PERIOD_D1 ,100,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double dPSAR    =iSAR(NULL,0,0.02,0.2,0);
    
      double drsi_0     =iRSI(NULL,0,14,PRICE_CLOSE,0);
      double drsi_1     =iRSI(NULL,0,14,PRICE_CLOSE,1);
      double drsi_2     =iRSI(NULL,0,14,PRICE_CLOSE,2);
    */
    /*
     double iMA_7_0=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_7_1=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_7_2=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,2);
     
     double iMA_20_0=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_20_3=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,3);
     double iMA_20_6=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,6);
     double iMA_50_0=iMA(NULL,0,50,0,MODE_SMMA,PRICE_CLOSE,0);
     */
     
     
     double CC_0     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,0);
     double CC_1     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,1);
     double CC_2     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,2);

     double CC_30_0     =iCCI(Symbol(),m_nTimePeriod,30,PRICE_CLOSE,0);
     double CC_30_1     =iCCI(Symbol(),m_nTimePeriod,30,PRICE_CLOSE,1);

    double moement_H1_0=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,1);//120
    double moement_H1_1=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,2);
    double moement_H1_2=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,3);//  90

    double FractalHigh1 =iFractals(NULL,m_nTimePeriod,MODE_UPPER,2);
    double FractalHigh2 =iFractals(NULL,m_nTimePeriod,MODE_UPPER,3);

    //double FractalLow=iFractals(NULL,PERIOD_CURRENT,MODE_LOWER,1);
    double Main_5=iStochastic(NULL,m_nTimePeriod,20,14,9,MODE_SMA,0,MODE_MAIN,0);
    double Signal_5=iStochastic(NULL,m_nTimePeriod,20,14,9,MODE_SMA,0,MODE_SIGNAL,0);  

    double OA_0=iAO(NULL,m_nTimePeriod,0);
    double OA_1=iAO(NULL,m_nTimePeriod,1);
    double OA_2=iAO(NULL,m_nTimePeriod,2);
    double OA_3=iAO(NULL,m_nTimePeriod,3);
    double OA_4=iAO(NULL,m_nTimePeriod,4);
    double OA_5=iAO(NULL,m_nTimePeriod,5);
    double OA_6=iAO(NULL,m_nTimePeriod,6);
    double OA_7=iAO(NULL,m_nTimePeriod,7);
    double OA_8=iAO(NULL,m_nTimePeriod,8);

            /*
            bool KumoBullConfirmation=false;
            bool  KumoBearConfirmation=false;
            bool KumoChinkouBullConfirmation=false;
            bool KumoChinkouBearConfirmation=false;

             int Tenkan=9;
             int Kijun=26;
             int Senkou=52;
            // Top
            double ChinkouSpanLatest=iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_CHINKOUSPAN,1); // Latest closed bar with Chinkou.
            double tenkanSen= iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_TENKANSEN,1);//--Midel
            double kijunSen = iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_KIJUNSEN,1);//-Bottom
            
            double tenkanSen5=iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_TENKANSEN,5);
            double slope=(tenkanSen-tenkanSen5)*1000;


            // Kumo confirmation. When cross is happening current price (latest close) should be above/below both Senkou Spans, or price should close above/below both Senkou Spans after a cross.
               double SenkouSpanALatestByPrice = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANA, 1); // Senkou Span A at time of latest closed price bar.
               double SenkouSpanBLatestByPrice = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANB, 1); // Senkou Span B at time of latest closed price bar.

                             
               if(tenkanSen>kijunSen && SenkouSpanALatestByPrice>SenkouSpanBLatestByPrice) 
                   KumoBullConfirmation=true;
               else KumoBullConfirmation=false;
               
               if(tenkanSen<kijunSen && SenkouSpanALatestByPrice<SenkouSpanBLatestByPrice) 
                    KumoBearConfirmation=true;
               else KumoBearConfirmation=false;
            
            
               
               if(( kijunSen>SenkouSpanALatestByPrice && kijunSen >SenkouSpanBLatestByPrice)) 
                  KumoChinkouBullConfirmation=true;
               else KumoChinkouBullConfirmation=false;
               
               if(kijunSen<SenkouSpanALatestByPrice && kijunSen <SenkouSpanBLatestByPrice) 
                   KumoChinkouBearConfirmation=true;
               else KumoChinkouBearConfirmation=false;

            */
    HideTestIndicators(false);
    
      /*
      if(KumoBullConfirmation==true && KumoChinkouBullConfirmation==true)
      {
         return TREND_UP;
      }
      else if(KumoBearConfirmation==true && KumoChinkouBearConfirmation==true)
      {
         return TREND_DOWN;
      }
      else
      {
         return TREND_SIDEWAY;
      }
      
     */

  
     if(m_nTrendState==0)
     {
      if(CC_0>150)
        m_nTrendState=100;
      else if(CC_0<-150)
         m_nTrendState=-100;
      else if( OA_6<OA_5 && OA_0<OA_1 && OA_1<OA_2)
      {
         m_nTrendState=-100;         
      }
      else if( OA_6>OA_5 && OA_0>OA_1 && OA_1>OA_2)
      {
         m_nTrendState=100;         
      }
         
     }
     else
     {
       if(m_nTrendState==100)
       {
           if(CC_0>CC_1)
           {
            m_nTrendState=100;
           }
           else if(CC_30_0>CC_30_1)
           {
             m_nTrendState=100;
           }
           else
           {
              if(moement_H1_0<moement_H1_1 && moement_H1_1<moement_H1_2)
              {
                    m_nTrendState=0;
                    return TREND_DOWN;
              }
           }
       
       }
       else if(m_nTrendState==-100)
       {
           if(CC_0<CC_1)
           {
            m_nTrendState=-100;
           }
           else if(CC_30_0<CC_30_1)
           {
             m_nTrendState=-100;
           }
           else
           {
              if(moement_H1_0>moement_H1_1 && moement_H1_1>moement_H1_2)
              {
                     m_nTrendState=0;
                     return TREND_UP;
              }
           }
       
       }
     
     }
     
     
   
   return TREND_SIDEWAY;
}

int TradeManager::CheckTrend_1()
{
    HideTestIndicators(true);
        
    int nTrend=TREND_NO;
    /*
    double Main_D1=iStochastic(NULL,PERIOD_D1,5,3,3,MODE_SMA,0,MODE_MAIN,0);
    double Signal_D1=iStochastic(NULL,PERIOD_D1,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);  
    double Main_5=iStochastic(NULL,PERIOD_M5,20,14,9,MODE_SMA,0,MODE_MAIN,0);
    double Signal_5=iStochastic(NULL,PERIOD_M5,20,14,9,MODE_SMA,0,MODE_SIGNAL,0);  
    
    //-------------------------------
    double drsi=iRSI(NULL,0,14,PRICE_CLOSE,0);
    double dRVI_MAIN=iRVI(NULL,0,10,MODE_MAIN,0);
    double dRVI_SIGNAL=iRVI(NULL,0,10,MODE_SIGNAL,0);

    
    //-------------------------------

    double atr_1=iATR(NULL,PERIOD_M5,14,0);
    double atr_2=iATR(NULL,PERIOD_M5,14,1);
    double atr_3=iATR(NULL,PERIOD_M5,14,2);

     double CC_0     =iCCI(Symbol(),0,14,PRICE_CLOSE,0);
     double CC_1     =iCCI(Symbol(),0,14,PRICE_CLOSE,1);
     double CC_2     =iCCI(Symbol(),0,14,PRICE_CLOSE,2);
     double CC_6     =iCCI(Symbol(),0,14,PRICE_CLOSE,6);
     
     
     double tmpAC_1  =iAC(NULL,PERIOD_M5,0);
     double tmpAC_2  =iAC(NULL,PERIOD_M5,1);
     double tmpAC_3  =iAC(NULL,PERIOD_M5,2);
     
    double moement_H1_0=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,1);//120
    double moement_H1_1=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,2);
    double moement_H1_2=iMomentum(NULL,PERIOD_M5,12,PRICE_CLOSE,3);//  90
     
     double Force_1  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,0);
     double Force_2  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,1);
     double Force_3  =iForce(NULL,PERIOD_M1,13,MODE_SMA,PRICE_CLOSE,2);
    
     double iMA_7_0=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_7_1=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_7_2=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,2);
     
     double iMA_20_0=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_20_3=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,3);
     double iMA_20_6=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double iMA_50_0=iMA(NULL,0,50,0,MODE_SMMA,PRICE_CLOSE,2);

     double iMA_100_0=iMA(NULL,0,100,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_200_0=iMA(NULL,0,200,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_200_3=iMA(NULL,0,200,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double iMA_500_0=iMA(NULL,0,500,0,MODE_SMMA,PRICE_CLOSE,2);


     double iMA_20_D1_0=iMA(NULL,PERIOD_D1  ,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_50_D1_0=iMA(NULL,PERIOD_D1  ,50,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_100_D1_0=iMA(NULL,PERIOD_D1 ,100,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_50_D1_5=iMA(NULL,PERIOD_D1  ,50,0,MODE_SMMA,PRICE_CLOSE,5);
     double iMA_100_D1_5=iMA(NULL,PERIOD_D1 ,100,0,MODE_SMMA,PRICE_CLOSE,6);
     
     double dPSAR    =iSAR(NULL,0,0.02,0.2,0);
    
      double drsi_0     =iRSI(NULL,0,14,PRICE_CLOSE,0);
      double drsi_1     =iRSI(NULL,0,14,PRICE_CLOSE,1);
      double drsi_2     =iRSI(NULL,0,14,PRICE_CLOSE,2);
    */
    /*
     double iMA_7_0=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_7_1=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,1);
     double iMA_7_2=iMA(NULL,0,8,0,MODE_SMMA,PRICE_CLOSE,2);
     
     double iMA_20_0=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,0);
     double iMA_20_3=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,3);
     double iMA_20_6=iMA(NULL,0,20,0,MODE_SMMA,PRICE_CLOSE,6);
     double iMA_50_0=iMA(NULL,0,50,0,MODE_SMMA,PRICE_CLOSE,0);
     */
     
     double MA_10=iMA(NULL,0,10,0,MODE_SMMA,PRICE_CLOSE,1);     
     double MA_14=iMA(NULL,0,14,0,MODE_SMMA,PRICE_CLOSE,1);
     
     double CC_0     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,0);
     double CC_1     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,1);
     double CC_2     =iCCI(Symbol(),m_nTimePeriod,14,PRICE_CLOSE,2);

     double CC_30_0     =iCCI(Symbol(),m_nTimePeriod,30,PRICE_CLOSE,0);
     double CC_30_1     =iCCI(Symbol(),m_nTimePeriod,30,PRICE_CLOSE,1);

    double moement_H1_0=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,1);//120
    double moement_H1_1=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,2);
    double moement_H1_2=iMomentum(NULL,m_nTimePeriod,14,PRICE_CLOSE,3);//  90

    double FractalHigh1 =iFractals(NULL,m_nTimePeriod,MODE_UPPER,2);
    double FractalHigh2 =iFractals(NULL,m_nTimePeriod,MODE_UPPER,3);

    //double FractalLow=iFractals(NULL,PERIOD_CURRENT,MODE_LOWER,1);
    double Main_5=iStochastic(NULL,m_nTimePeriod,20,14,9,MODE_SMA,0,MODE_MAIN,0);
    double Signal_5=iStochastic(NULL,m_nTimePeriod,20,14,9,MODE_SMA,0,MODE_SIGNAL,0);  

    double OA_0=iAO(NULL,m_nTimePeriod,0);
    double OA_1=iAO(NULL,m_nTimePeriod,1);
    double OA_2=iAO(NULL,m_nTimePeriod,2);
    double OA_3=iAO(NULL,m_nTimePeriod,3);
    double OA_4=iAO(NULL,m_nTimePeriod,4);
    double OA_5=iAO(NULL,m_nTimePeriod,5);
    double OA_6=iAO(NULL,m_nTimePeriod,6);
    double OA_7=iAO(NULL,m_nTimePeriod,7);
    double OA_8=iAO(NULL,m_nTimePeriod,8);

            /*
            bool KumoBullConfirmation=false;
            bool  KumoBearConfirmation=false;
            bool KumoChinkouBullConfirmation=false;
            bool KumoChinkouBearConfirmation=false;

             int Tenkan=9;
             int Kijun=26;
             int Senkou=52;
            // Top
            double ChinkouSpanLatest=iIchimoku(NULL,0,Tenkan,Kijun,Senkou,MODE_CHINKOUSPAN,1); // Latest closed bar with Chinkou.
            double tenkanSen= iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_TENKANSEN,1);//--Midel
            double kijunSen = iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_KIJUNSEN,1);//-Bottom
            
            double tenkanSen5=iIchimoku(NULL,PERIOD_CURRENT,Tenkan,Kijun,Senkou,MODE_TENKANSEN,5);
            double slope=(tenkanSen-tenkanSen5)*1000;


            // Kumo confirmation. When cross is happening current price (latest close) should be above/below both Senkou Spans, or price should close above/below both Senkou Spans after a cross.
               double SenkouSpanALatestByPrice = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANA, 1); // Senkou Span A at time of latest closed price bar.
               double SenkouSpanBLatestByPrice = iIchimoku(NULL, 0, Tenkan, Kijun, Senkou, MODE_SENKOUSPANB, 1); // Senkou Span B at time of latest closed price bar.

                             
               if(tenkanSen>kijunSen && SenkouSpanALatestByPrice>SenkouSpanBLatestByPrice) 
                   KumoBullConfirmation=true;
               else KumoBullConfirmation=false;
               
               if(tenkanSen<kijunSen && SenkouSpanALatestByPrice<SenkouSpanBLatestByPrice) 
                    KumoBearConfirmation=true;
               else KumoBearConfirmation=false;
            
            
               
               if(( kijunSen>SenkouSpanALatestByPrice && kijunSen >SenkouSpanBLatestByPrice)) 
                  KumoChinkouBullConfirmation=true;
               else KumoChinkouBullConfirmation=false;
               
               if(kijunSen<SenkouSpanALatestByPrice && kijunSen <SenkouSpanBLatestByPrice) 
                   KumoChinkouBearConfirmation=true;
               else KumoChinkouBearConfirmation=false;

            */
    HideTestIndicators(false);
    
      /*
      if(KumoBullConfirmation==true && KumoChinkouBullConfirmation==true)
      {
         return TREND_UP;
      }
      else if(KumoBearConfirmation==true && KumoChinkouBearConfirmation==true)
      {
         return TREND_DOWN;
      }
      else
      {
         return TREND_SIDEWAY;
      }
      
     */

  
     if(m_nTrendState==0)
     {
      if(CC_0>150)
        m_nTrendState=100;
      else if(CC_0<-150)
         m_nTrendState=-100;
      else if( OA_6<OA_5 && OA_0<OA_1 && OA_1<OA_2)
      {
         m_nTrendState=-100;         
      }
      else if( OA_6>OA_5 && OA_0>OA_1 && OA_1>OA_2)
      {
         m_nTrendState=100;         
      }
         
     }
     else
     {
       if(m_nTrendState==100)
       {
           if(CC_0>CC_1)
           {
            m_nTrendState=100;
           }
           else if(CC_30_0>CC_30_1)
           {
             m_nTrendState=100;
           }
           else
           {
              if(MA_10<MA_14 && moement_H1_1<moement_H1_2)
              {
                    m_nTrendState=0;
                    return TREND_DOWN;
              }
           }
       
       }
       else if(m_nTrendState==-100)
       {
           if(CC_0<CC_1)
           {
            m_nTrendState=-100;
           }
           else if(CC_30_0<CC_30_1)
           {
             m_nTrendState=-100;
           }
           else
           {
              if(MA_10>MA_14 && moement_H1_1>moement_H1_2)
              {
                     m_nTrendState=0;
                     return TREND_UP;
              }
           }
       
       }
     
     }
     
     
   
   return TREND_SIDEWAY;
}


double TradeManager::GetLowestPrice(int TradeType)
{
   double ddOrderPrice=0;
   int    nCounter=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
                  
          if(OrderType()==TradeType)
          {
             if(nCounter==0)
             {
               ddOrderPrice=OrderOpenPrice(); 
               nCounter=1;
             }
             else 
             {
                if(OrderOpenPrice()<ddOrderPrice)
                {
                  ddOrderPrice=OrderOpenPrice();
                }
             }
             
           
          }
        }
      }
     }

  return (ddOrderPrice);
}
double TradeManager::GetHighestPrice(int TradeType)
{
   double ddOrderPrice=0;
   int    nCounter=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
                  
          if(OrderType()==TradeType)
          {
             if(nCounter==0)
             {
               ddOrderPrice=OrderOpenPrice(); 
               nCounter=1;
             }
             else 
             {
                if(OrderOpenPrice()>ddOrderPrice)
                {
                  ddOrderPrice=OrderOpenPrice();
                }
             }
             
           
          }
        }
      }
     }

  return (ddOrderPrice);
}


int TradeManager::GetLowestOrderID(int TradeType)
{
   int nOrderID=0;
   double ddOrderPrice=0;
   int    nCounter=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
                  
          if(OrderType()==TradeType)
          {
             if(nCounter==0)
             {
               ddOrderPrice=OrderOpenPrice(); 
               nCounter=1;
               nOrderID=OrderTicket();
             }
             else 
             {
                if(OrderOpenPrice()<ddOrderPrice)
                {
                  ddOrderPrice=OrderOpenPrice();
                  nOrderID=OrderTicket();
                }
             }
             
           
          }
        }
      }
     }

  return (nOrderID);
}


int TradeManager::GetHighestOrderID(int TradeType)
{
   int nOrderID=0;
   double ddOrderPrice=0;
   int    nCounter=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
                  
          if(OrderType()==TradeType)
          {
             if(nCounter==0)
             {
               ddOrderPrice=OrderOpenPrice(); 
               nCounter=1;
               nOrderID=OrderTicket();
             }
             else 
             {
                if(OrderOpenPrice()>ddOrderPrice)
                {
                  ddOrderPrice=OrderOpenPrice();
                  nOrderID=OrderTicket();
                }
             }
             
           
          }
        }
      }
     }

  return (nOrderID);
}





int TradeManager::ManageMartingle_CloseLastAndFistTrade(double nTargetProfit,double dClosingDist)
{
   double dOrderPriceHigh=0;
   int    nOrderIDHigh=0;
   double dOrderProfitHigh=0;
   double LotsSizeHigh=0;
   int    nOrderTypeHigh=0;
   double dOrderCommisionHigh=0;

   double dOrderPriceLow=0;
   int    nOrderIDLow=0;
   double dOrderProfitLow=0;
   double LotsSizeLow =0;
   int    nOrderTypeLow=0;
   int    nCount=0;
   int    CurrOrderType=0;
   double dOrderCommisionLow=0;
   double MiniMumProfit=1;
   bool   ReturnState=false;
   int    i=0;
   double Diff;
   
   for(i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
      {
        if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
        {
           if(nCount==0)
           {
                dOrderPriceHigh=OrderOpenPrice();
                nOrderIDHigh=OrderTicket();
                dOrderProfitHigh=OrderProfit();
                LotsSizeHigh    =OrderLots();
                nOrderTypeHigh  =OrderType();
 
               dOrderPriceLow=OrderOpenPrice();
               nOrderIDLow=OrderTicket();;
               dOrderProfitLow=OrderProfit();
               LotsSizeLow    =OrderLots();
               nOrderTypeLow  =OrderType();              
              
              nCount++;
           }
           else
           {
              if(OrderOpenPrice()>=dOrderPriceHigh)
              {
                dOrderPriceHigh=OrderOpenPrice();
                nOrderIDHigh=OrderTicket();
                dOrderProfitHigh=OrderProfit();
                LotsSizeHigh    =OrderLots();
                nOrderTypeHigh  =OrderType();
                dOrderCommisionHigh=OrderCommission();
              }
              else if(OrderOpenPrice()<dOrderPriceLow)
              {
                  dOrderPriceLow=OrderOpenPrice();
                  nOrderIDLow=OrderTicket();;
                  dOrderProfitLow=OrderProfit();
                  LotsSizeLow    =OrderLots();
                  nOrderTypeLow  =OrderType();  
                  dOrderCommisionLow=OrderCommission();            
              }
           }
        }
      }
   }
   
   if(LotsSizeLow>LotsSizeHigh)
   {
     MiniMumProfit=LotsSizeLow*1*10;
   }
   else
   {
     MiniMumProfit=LotsSizeHigh*1*10;   
   }
   
   if(dOrderCommisionHigh>0)
   dOrderProfitHigh=dOrderProfitHigh-dOrderCommisionHigh;
   else 
   dOrderProfitHigh=dOrderProfitHigh+dOrderCommisionHigh;
   
   if(dOrderCommisionLow>0)
   dOrderProfitLow=dOrderProfitLow-dOrderCommisionLow;
   else 
   dOrderProfitLow=dOrderProfitLow+dOrderCommisionLow;

   
   
   if((dOrderPriceHigh-dOrderPriceLow)>dClosingDist*Point*m_PointFactor)
   {
     Diff=(dOrderPriceHigh-dOrderPriceLow)/(Point*m_PointFactor);
     
     Print("Order Price High "+StringToDouble(dOrderPriceHigh)+" "+"Order Price Low "+StringToDouble(dOrderPriceLow)+"\n\r");
     Print("Order Diff "+" "+Diff+"\n\r");
     
      
            if((dOrderProfitHigh+dOrderProfitLow)>MiniMumProfit)
            {
               bool bClose=false;
               
                  for(i=0;i<OrdersTotal();i++)
                  {
                     if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
                       {  
                         
                         if(nOrderIDHigh==OrderTicket())
                         {
                            CurrOrderType=OrderType();
                            
                            if(OrderType()==OP_SELL)
                            bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
                            else if(OrderType()==OP_BUY)
                            bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet);
                            
                         }
                         
                         if(nOrderIDLow==OrderTicket())
                         {
                            CurrOrderType=OrderType();
         
                            if(OrderType()==OP_SELL)
                            bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
                            else if(OrderType()==OP_BUY)
                            bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet);
                         }        
                       }
                     }          
                  }
                  
                  if(bClose)
                  {   
                   if(CurrOrderType==OP_SELL)  
                   m_Two_Link_CloseOrderPrice=dOrderPriceHigh;
                   else if(CurrOrderType==OP_BUY)
                   m_Two_Link_CloseOrderPrice=dOrderPriceLow;
                   
                   ReturnState=true;
                  }
                
                  
                //SetStopLostForMultiTrade(nTargetProfit);  
              }
              else
              {
                  printf("Current Combine Profit"+" ="+(dOrderProfitHigh+dOrderProfitLow));
              }
     
    }  
    else
    {
       printf("Closing Distance not met");
    }
   
   
   return (ReturnState);
}

bool TradeManager::CloseAllCurrentOrderByOrderID(int nID)
{
   int k=0;
   int reRun=10;
   bool bClose=true;

    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
            {
               
		          k = 0;	
		          while (k<reRun)
		          {
		             //WaitUntilContex ();
		          
   		           if(OrderTicket()==nID)
   		           {
                      if(OrderType()==OP_SELL)
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3,Violet);
                      else if(OrderType()==OP_BUY)
                      bClose=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3,Violet);
                    }
         
			          if (!bClose) 
			          {
                      while (!IsTradeAllowed()) Sleep(500); 
                      RefreshRates();
			             k++;
			          }
			          else
			          {
			           break;
			          }
                }
            }
         }
      }
      
      m_LastCloseTime=iTime(NULL,0,0);
      return (bClose);
}


bool TradeManager::ChangeTpByOrderID(int nID,int nOrderTypeID,double dTp)
{
   int k=0;
   int reRun=10;
   bool bClose=true;

    int total  = OrdersTotal();
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         if(OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) 
         {
            if(OrderSymbol()==Symbol() && OrderMagicNumber()==m_MagicNumber)
            {
               
		          k = 0;	
		          while (k<reRun)
		          {
		             //WaitUntilContex ();
		          
   		           if(OrderTicket()==nID)
   		           {
   		           
   		           
                      if(OrderType()==OP_SELL && nOrderTypeID==OrderType())
                      {
                        double df=NormalizeDouble(OrderOpenPrice()+dTp*Point*m_PointFactor,Digits);
                      
                        if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),df))
                        {
                           
                           printf("---Order Modify SELL----");
                           bClose=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),df,OrderExpiration(),CLR_NONE);

                           if(!bClose)
                           Print("Error1 in OrderModify. Error code=",GetLastError());
                           else
                           Print("Order 1 modified successfully.");                                            
                         }
                         else
                         {
                            Print("---Error1 in OrderModify. Error code=--",GetLastError());
                         }
                      }
                      else if(OrderType()==OP_BUY && nOrderTypeID==OrderType())
                      {
                      
                        double df=OrderOpenPrice()-NormalizeDouble(dTp*Point*m_PointFactor,Digits);
                      
                        if(OrderModifyCheck(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),df))
                        {
                      
                           printf("---Order Modify BUY----");
                           
                           bClose=OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),df,OrderExpiration(),CLR_NONE);
                           
                           if(!bClose)
                           Print("Error1 in OrderModify. Error code=",GetLastError());
                           else
                           Print("Order 1 modified successfully.");    
                        }
                        else
                        {
                           Print("---Error1 in OrderModify. Error code=--",GetLastError());
                        }             
                        
                      }
                    }
         
			          if (!bClose) 
			          {
                      while (!IsTradeAllowed()) Sleep(500); 
                      RefreshRates();
			             k++;
			          }
			          else
			          {
			           break;
			          }
                }
            }
         }
      }
      
      m_LastCloseTime=iTime(NULL,0,0);
      return (true);
}


bool TradeManager::CheckVolumeValue(double volume,string &description,double &validlot)
  {
//--- minimal allowed volume for trade operations
   double min_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MIN);
   if(volume<min_volume)
     {
      description=StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f",min_volume);
      validlot=min_volume;
      return(true);
     }

//--- maximal allowed volume of trade operations
   double max_volume=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_MAX);
   if(volume>max_volume)
     {
      description=StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f",max_volume);
      
      validlot=max_volume;
      return(true);
     }

//--- get minimal step of volume changing
   double volume_step=SymbolInfoDouble(Symbol(),SYMBOL_VOLUME_STEP);

   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      description=StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                               volume_step,ratio*volume_step);
                               
      
      validlot=ratio*volume_step;
      
     }
     else
     {
      description="Correct volume value";
      
      validlot=volume;
      
     }
     
     return(true);
  }
