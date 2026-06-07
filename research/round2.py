from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))
import numpy as np
# add wider bands needed
def bbsig(k):
    def f(d,i):
        c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values
        if c[i-1] < mid[i-1]-k*sd[i-1]: return 1
        if c[i-1] > mid[i-1]+k*sd[i-1]: return -1
        return 0
    return f
# BB fade with extra RSI14 confirmation
def bbsig_rsi(k,lo,hi):
    def f(d,i):
        c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values; r=d['rsi14'].values
        if c[i-1]<mid[i-1]-k*sd[i-1] and r[i-1]<=lo: return 1
        if c[i-1]>mid[i-1]+k*sd[i-1] and r[i-1]>=hi: return -1
        return 0
    return f

rows=[]
def add(name,fn,**kw):
    ins,oos=evalsplit(d,fn,**kw); rows.append((oos['pf'],name,ins,oos))

print("=== round 2: tune around BB fade k3 ===")
for k in (2.75,3.0,3.25,3.5):
    add(f"BB k{k} sl4 tp2.5",bbsig(k),sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
for sl in (3.5,4.5,5.0):
    add(f"BB k3 sl{sl} tp2.5",bbsig(3.0),sl_atr=sl,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
for tp in (1.5,2.0,3.0):
    add(f"BB k3 sl4 tp{tp}",bbsig(3.0),sl_atr=4.0,tp_atr=tp,time_stop=96,exit_mid='bb_mid')
for ts in (48,144,240):
    add(f"BB k3 sl4 tp2.5 ts{ts}",bbsig(3.0),sl_atr=4.0,tp_atr=2.5,time_stop=ts,exit_mid='bb_mid')
add("BB k3 +RSI 20/80",bbsig_rsi(3.0,20,80),sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
add("BB k3 +RSI 10/90",bbsig_rsi(3.0,10,90),sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
add("BB k2.75 +RSI 15/85",bbsig_rsi(2.75,15,85),sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')

print(f"{'strategy':<26} | IN pf/dd/n            | OOS pf/dd/n           | OOSnet")
print("-"*92)
for pf,name,ins,oos in sorted(rows,reverse=True):
    print(f"{name:<26} | pf{ins['pf']:<5} dd{ins['dd']:<5} n{ins['n']:<5} | pf{oos['pf']:<5} dd{oos['dd']:<5} n{oos['n']:<5} | {oos['net']:>7.0f}")
