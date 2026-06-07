import numpy as np, pandas as pd
from engine import *

d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
c=d['close'].values; hi=d['high'].values; lo=d['low'].values; at=d['atr'].values
n=len(d); idx=d.index

# ---------- TRIPLE-BARRIER LABELS (no look-ahead in features; label uses future = the target) ----------
def label_tb(K, M):
    up=c+K*at; dn=c-K*at
    lab=np.zeros(n, dtype=np.int8); done=np.zeros(n,bool)
    for j in range(1,M+1):
        if j>=n: break
        h=np.empty(n); h[:]=np.nan; l=np.empty(n); l[:]=np.nan
        h[:n-j]=hi[j:]; l[:n-j]=lo[j:]
        up_hit=(~done)&(h>=up); dn_hit=(~done)&(l<=dn)
        both=up_hit&dn_hit            # ambiguous same-bar: resolve by candle direction
        only_up=up_hit&~dn_hit; only_dn=dn_hit&~up_hit
        lab[only_up]=1; lab[only_dn]=-1
        # both: use that bar's close vs open direction as tiebreak
        if both.any():
            co=np.empty(n); co[:]=0.0
            co[:n-j]=c[j:]-d['open'].values[j:]
            lab[both & (co>=0)]=1; lab[both & (co<0)]=-1
        done |= (up_hit|dn_hit)
    lab[~done]=0  # neither barrier within horizon = no trend
    return lab

SCALES=[("small",2.5,12),("medium",4.0,24),("big",6.0,48)]
labels={}
for name,K,M in SCALES:
    labels[name]=label_tb(K,M)

isin=np.array(idx<'2016-01-01'); oos=~isin
print("=== BASE RATES (how often a 'trend' even happens) ===")
print(f"{'scale':<8}{'split':<6}{'up%':>7}{'down%':>8}{'none%':>8}")
for name,K,M in SCALES:
    L=labels[name]
    for sp,mask in [("IN",isin),("OOS",oos)]:
        x=L[mask]; tot=len(x)
        print(f"{name:<8}{sp:<6}{100*np.mean(x==1):>6.1f}%{100*np.mean(x==-1):>7.1f}%{100*np.mean(x==0):>7.1f}%")
np.save('/tmp/bt/_labels.npy', np.array([labels[s[0]] for s in SCALES]))
import pickle; pickle.dump(dict(isin=isin,oos=oos), open('/tmp/bt/_masks.pkl','wb'))
print("\nlabels saved.")
