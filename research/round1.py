from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))

# ---- strategy family signal functions (use prior-bar data: i-1) ----
def s_bb(d,i,k=2.0):   # Bollinger fade
    c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values
    if c[i-1] < mid[i-1]-k*sd[i-1]: return 1
    if c[i-1] > mid[i-1]+k*sd[i-1]: return -1
    return 0
def s_rsi2(d,i,lo=5,hi=95): # RSI(2) extreme (Connors-style)
    r=d['rsi2'].values
    if r[i-1]<lo: return 1
    if r[i-1]>hi: return -1
    return 0
def s_rsi2_trend(d,i,lo=10,hi=90): # RSI2 in direction of SMA200 (buy dips in uptrend only)
    r=d['rsi2'].values; c=d['close'].values; s=d['sma200'].values
    if c[i-1]>s[i-1] and r[i-1]<lo: return 1     # uptrend, buy dip
    if c[i-1]<s[i-1] and r[i-1]>hi: return -1    # downtrend, sell rip
    return 0
def s_atrstretch(d,i,k=4.0,lo=15,hi=85): # current MR winner
    c=d['close'].values; m=d['sma100'].values; at=d['atr'].values; r=d['rsi14'].values
    st=(c[i-1]-m[i-1])/at[i-1]
    if st<=-k and r[i-1]<=lo: return 1
    if st>= k and r[i-1]>=hi: return -1
    return 0

tests=[
 ("BB fade k2.0",      lambda d,i:s_bb(d,i,2.0),   dict(sl_atr=3.5,tp_atr=2.0,time_stop=72,exit_mid='bb_mid')),
 ("BB fade k2.5",      lambda d,i:s_bb(d,i,2.5),   dict(sl_atr=3.5,tp_atr=2.0,time_stop=72,exit_mid='bb_mid')),
 ("BB fade k3.0",      lambda d,i:s_bb(d,i,3.0),   dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')),
 ("RSI2 5/95",         lambda d,i:s_rsi2(d,i,5,95),dict(sl_atr=3.5,tp_atr=2.0,time_stop=48)),
 ("RSI2 10/90",        lambda d,i:s_rsi2(d,i,10,90),dict(sl_atr=3.5,tp_atr=2.0,time_stop=48)),
 ("RSI2+trend200",     lambda d,i:s_rsi2_trend(d,i,10,90),dict(sl_atr=3.0,tp_atr=2.0,time_stop=48,exit_mid='sma100')),
 ("RSI2+trend 5/95",   lambda d,i:s_rsi2_trend(d,i,5,95),dict(sl_atr=3.0,tp_atr=2.0,time_stop=48,exit_mid='sma100')),
 ("ATRstretch4 (cur)", lambda d,i:s_atrstretch(d,i,4.0,15,85),dict(sl_atr=3.5,tp_atr=2.0,time_stop=72)),
 ("ATRstretch3",       lambda d,i:s_atrstretch(d,i,3.0,20,80),dict(sl_atr=3.5,tp_atr=2.0,time_stop=72)),
]
print(f"{'strategy':<20} | {'IN  pf/dd/n':<22} | {'OOS pf/dd/n':<22} | OOS net")
print("-"*86)
rows=[]
for name,fn,kw in tests:
    ins,oos=evalsplit(d,fn,**kw)
    rows.append((oos['pf'],name,ins,oos))
for pf,name,ins,oos in sorted(rows,reverse=True):
    print(f"{name:<20} | pf{ins['pf']:<5} dd{ins['dd']:<5} n{ins['n']:<6} | pf{oos['pf']:<5} dd{oos['dd']:<5} n{oos['n']:<6} | {oos['net']:>8.0f}")
