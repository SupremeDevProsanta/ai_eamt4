from engine import *
import pandas as pd, numpy as np
d0=read_hst(f"{DATA}/NZDCAD30.hst")
d=d0.copy()
d['atr']=atr(d,14); d['rsi14']=rsi(d['close'],14)
d['bb_mid']=d['close'].rolling(20).mean()
# MT4 iBands uses POPULATION std (ddof=0); pandas .std() default is sample (ddof=1)
d['bb_sd_samp']=d['close'].rolling(20).std()          # ddof=1 (what we used)
d['bb_sd_pop'] =d['close'].rolling(20).std(ddof=0)    # ddof=0 (MT4)
d=d.dropna()
def make(sdcol):
    def f(dd,i):
        c=dd['close'].values; mid=dd['bb_mid'].values; sd=dd[sdcol].values; r=dd['rsi14'].values
        if c[i-1]<mid[i-1]-3.0*sd[i-1] and r[i-1]<=20: return 1
        if c[i-1]>mid[i-1]+3.0*sd[i-1] and r[i-1]>=80: return -1
        return 0
    return f
kw=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
for lab,sdc in [("sample ddof1 (was)","bb_sd_samp"),("population ddof0 (MT4)","bb_sd_pop")]:
    ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
    ri=backtest(ins,make(sdc),**kw); ro=backtest(oos,make(sdc),**kw)
    print(f"{lab:<22} IN pf{ri['pf']} dd{ri['dd']} n{ri['n']} | OOS pf{ro['pf']} dd{ro['dd']} n{ro['n']} net{ro['net']:.0f}")
