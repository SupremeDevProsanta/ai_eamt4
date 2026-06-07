import numpy as np, pandas as pd
from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
bbw=(2*d['bb_sd']/d['bb_mid']); d['bbw_p']=bbw.rolling(252).rank(pct=True)
roll=48; dchi=d['high'].rolling(roll).max(); dclo=d['low'].rolling(roll).min()
d['donch']=(d['close']-dclo)/(dchi-dclo); d=d.dropna()
def fade(dd,i):
    bp=dd['bbw_p'].values; dn=dd['donch'].values
    if bp[i-1]<0.15 and dn[i-1]>0.90: return -1   # breaking up -> FADE short
    if bp[i-1]<0.15 and dn[i-1]<0.10: return 1    # breaking down -> FADE long
    return 0
ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
print("FADE the squeeze-breakout (enter opposite), MR-style exits:")
print(f"{'config':<26}{'split':<6}{'pf':>7}{'dd':>6}{'n':>6}{'net':>9}")
for sl,tp,ts in [(4.0,2.5,96),(4.5,3.0,96),(3.5,2.0,48)]:
    for sp,seg in [('IN',ins),('OOS',oos)]:
        r=backtest(seg,fade,sl_atr=sl,tp_atr=tp,time_stop=ts,exit_mid='bb_mid')
        print(f"sl{sl} tp{tp} ts{ts:<12}{sp:<6}{r['pf']:>7}{r['dd']:>6}{r['n']:>6}{r['net']:>9.0f}")
    print()
