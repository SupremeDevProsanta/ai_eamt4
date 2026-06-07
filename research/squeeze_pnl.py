import numpy as np, pandas as pd
from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
bbw=(2*d['bb_sd']/d['bb_mid']); d['bbw_p']=bbw.rolling(252).rank(pct=True)
roll=48; dchi=d['high'].rolling(roll).max(); dclo=d['low'].rolling(roll).min()
d['donch']=(d['close']-dclo)/(dchi-dclo)
d=d.dropna()
bbwp=d['bbw_p'].values; don=d['donch'].values
# Squeeze-breakout signal: prior bar in squeeze, price breaking the channel edge
def sig(dd,i):
    # use precomputed global-aligned arrays via dd alignment: recompute locally is costly; use columns
    bp=dd['bbw_p'].values; dn=dd['donch'].values
    if bp[i-1]<0.15 and dn[i-1]>0.90: return 1     # squeeze then breaking up
    if bp[i-1]<0.15 and dn[i-1]<0.10: return -1    # squeeze then breaking down
    return 0
ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
print("SQUEEZE-BREAKOUT as a P&L strategy (let winners run vs tight stop):")
print(f"{'config':<28}{'split':<6}{'pf':>6}{'win%':>7}{'dd':>6}{'n':>6}{'net':>9}")
for sl,tp,ts in [(2.0,6.0,48),(2.5,8.0,96),(3.0,10.0,96),(2.0,4.0,48)]:
    for sp,seg in [('IN',ins),('OOS',oos)]:
        r=backtest(seg,sig,sl_atr=sl,tp_atr=tp,time_stop=ts,exit_mid=None)
        print(f"sl{sl} tp{tp} ts{ts:<14}{sp:<6}{r['pf']:>6}{r.get('win',0):>6}%{r['dd']:>6}{r['n']:>6}{r['net']:>9.0f}")
    print()
