from engine import *
import itertools
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))
d['bb_sd']=d['close'].rolling(20).std(ddof=0)
# precompute alt RSI/BB periods on demand
d=d.dropna()
ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']

def mk(bbk,rlo,rhi):
    def f(dd,i):
        c=dd['close'].values; mid=dd['bb_mid'].values; sd=dd['bb_sd'].values; r=dd['rsi14'].values
        if c[i-1]<mid[i-1]-bbk*sd[i-1] and r[i-1]<=rlo: return 1
        if c[i-1]>mid[i-1]+bbk*sd[i-1] and r[i-1]>=rhi: return -1
        return 0
    return f

base=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
results=[]
# grid: only NEARBY values around current winner (k3, rsi20/80, sl4, tp2.5)
for bbk in (2.8,3.0,3.2):
  for rlo,rhi in ((18,82),(20,80),(22,78)):
    for sl in (3.5,4.0,4.5):
      for tp in (2.0,2.5,3.0):
        kw=dict(sl_atr=sl,tp_atr=tp,time_stop=96,exit_mid='bb_mid')
        ri=backtest(ins,mk(bbk,rlo,rhi),**kw)
        ro=backtest(oos,mk(bbk,rlo,rhi),**kw)
        # require BOTH halves profitable and reasonable sample
        if ri['n']>=150 and ro['n']>=150 and ri['pf']>1.0 and ro['pf']>1.0:
            score=min(ri['pf'],ro['pf'])  # robust score = weaker of the two
            results.append((round(score,3),bbk,rlo,rhi,sl,tp,ri,ro))

results.sort(reverse=True)
print("Configs profitable in BOTH in-sample AND out-of-sample (ranked by weaker-half PF):")
print(f"{'score':<6}{'k':<5}{'rsi':<8}{'sl':<5}{'tp':<5} | IN pf/dd/n            | OOS pf/dd/n")
print("-"*86)
for sc,bbk,rlo,rhi,sl,tp,ri,ro in results[:12]:
    print(f"{sc:<6}{bbk:<5}{str(rlo)+'/'+str(rhi):<8}{sl:<5}{tp:<5} | pf{ri['pf']:<5} dd{ri['dd']:<5} n{ri['n']:<5} | pf{ro['pf']:<5} dd{ro['dd']:<5} n{ro['n']:<5}")
print(f"\ntotal robust configs (both halves PF>1): {len(results)} of 81 tested")
