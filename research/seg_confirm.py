import numpy as np, pandas as pd
from engine import read_hst, prep, DATA
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
c=d['close'].values; at=d['atr'].values; idx=d.index
ef=d['close'].ewm(span=20,adjust=False).mean().values
es=d['close'].ewm(span=50,adjust=False).mean().values
state=np.sign(ef-es); cross=np.where(np.diff(state)!=0)[0]+1
isin=np.array(idx<'2016-01-01')
PIP=0.0001; COST_PIP=1.0   # ~spread+commission roundtrip in pips

def run(K, conf_thr):
    # enter K bars after each cross IF price confirmed in new dir; exit at next cross
    res_in=[]; res_oos=[]
    for k in range(len(cross)-1):
        a=cross[k]; nxt=cross[k+1]
        dirn=state[a]
        e=a+K
        if e>=nxt: continue          # segment too short to confirm
        if at[a]<=0: continue
        moved=(c[e]-c[a])*dirn/at[a]  # confirmation move in ATR over K bars
        if moved< conf_thr: continue  # not confirmed
        # enter at c[e], exit at next cross c[nxt]
        pnl_atr=(c[nxt]-c[e])*dirn/at[a]
        cost_atr=COST_PIP*PIP/at[a]
        net=pnl_atr-cost_atr
        (res_in if isin[a] else res_oos).append(net)
    def stat(r):
        r=np.array(r)
        if len(r)==0: return "n=0"
        w=r[r>0]; l=r[r<0]
        pf=w.sum()/abs(l.sum()) if len(l) and l.sum() else 99
        return f"n{len(r):<4} win%{(r>0).mean()*100:4.1f} avgATR{r.mean():+5.2f} sumATR{r.sum():6.1f} pf{pf:4.2f}"
    return stat(res_in), stat(res_oos)

print("Enter K bars after cross, require confirm move >= thr ATR, exit at next cross.")
print("(avgATR>0 and pf>1 in BOTH IN and OOS = a real edge)\n")
print(f"{'K':>2}{'thr':>5}  | IN  {'':<38} | OOS")
for K in [0,3,6,10]:
    for thr in [0.0,0.5,1.0]:
        i,o=run(K,thr)
        print(f"{K:>2}{thr:>5}  | {i:<42} | {o}")
