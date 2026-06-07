from engine import *
import numpy as np, pandas as pd
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))
# extra indicators
ef=d['close'].ewm(span=12,adjust=False).mean(); es=d['close'].ewm(span=26,adjust=False).mean()
d['macd']=ef-es; d['macd_sig']=d['macd'].ewm(span=9,adjust=False).mean(); d['macd_hist']=d['macd']-d['macd_sig']
d['mom']=d['close']-d['close'].shift(10)
d=d.dropna()

def base(k,rlo,rhi):
    def f(dd,i):
        c=dd['close'].values; mid=dd['bb_mid'].values; sd=dd['bb_sd_pop'].values if 'bb_sd_pop' in dd else dd['bb_sd'].values
        # use population std to match MT4
        r=dd['rsi14'].values
        if c[i-1]<mid[i-1]-k*sd[i-1] and r[i-1]<=rlo: return 1
        if c[i-1]>mid[i-1]+k*sd[i-1] and r[i-1]>=rhi: return -1
        return 0
    return f
# population std column
d['bb_sd']=d['close'].rolling(20).std(ddof=0); d=d.dropna()

# looser band + MACD-histogram turn confirmation (momentum rolling over toward mean)
def loose_macd(k,rlo,rhi):
    def f(dd,i):
        c=dd['close'].values; mid=dd['bb_mid'].values; sd=dd['bb_sd'].values; r=dd['rsi14'].values; mh=dd['macd_hist'].values
        # long: below band, RSI low, MACD hist turning UP (mh[i-1]>mh[i-2])
        if c[i-1]<mid[i-1]-k*sd[i-1] and r[i-1]<=rlo and mh[i-1]>mh[i-2]: return 1
        if c[i-1]>mid[i-1]+k*sd[i-1] and r[i-1]>=rhi and mh[i-1]<mh[i-2]: return -1
        return 0
    return f
def loose_only(k,rlo,rhi):  # looser, no macd, for comparison
    return base(k,rlo,rhi)

kw=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
rows=[]
def add(name,fn):
    ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
    ri=backtest(ins,fn,**kw); ro=backtest(oos,fn,**kw); rows.append((ro['pf'],name,ri,ro))

print("=== can MACD confirmation let us LOOSEN the band & get more trades, keeping OOS>1? ===")
add("k3.0 RSI20/80 (current)", base(3.0,20,80))
add("k2.5 RSI25/75 LOOSE only", loose_only(2.5,25,75))
add("k2.5 RSI25/75 +MACDturn",  loose_macd(2.5,25,75))
add("k2.0 RSI30/70 LOOSE only", loose_only(2.0,30,70))
add("k2.0 RSI30/70 +MACDturn",  loose_macd(2.0,30,70))
add("k2.0 RSI25/75 +MACDturn",  loose_macd(2.0,25,75))
add("k2.5 RSI20/80 +MACDturn",  loose_macd(2.5,20,80))
add("k1.5 RSI30/70 +MACDturn",  loose_macd(1.5,30,70))
print(f"{'variant':<28} | IN pf/dd/n          | OOS pf/dd/n         | OOSnet  trades/yr")
print("-"*92)
for pf,name,ri,ro in sorted(rows,reverse=True):
    tpy=round(ro['n']/10.4,1)
    print(f"{name:<28} | pf{ri['pf']:<5} dd{ri['dd']:<5} n{ri['n']:<5} | pf{ro['pf']:<5} dd{ro['dd']:<5} n{ro['n']:<5} | {ro['net']:>6.0f}  {tpy}/yr")
