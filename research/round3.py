from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))
def win(d,i):
    c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values; r=d['rsi14'].values
    if c[i-1]<mid[i-1]-3.0*sd[i-1] and r[i-1]<=20: return 1
    if c[i-1]>mid[i-1]+3.0*sd[i-1] and r[i-1]>=80: return -1
    return 0
kw=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')

print("=== winner: BB k3 + RSI20/80, per 4-year period (walk-forward) ===")
periods=[('2006','2010'),('2010','2014'),('2014','2018'),('2018','2022'),('2022','2027')]
print(f"{'period':<14} pf     dd    n     net")
allpos=True
for a,b in periods:
    seg=d[(d.index>=a+'-01-01')&(d.index<b+'-01-01')]
    r=backtest(seg,win,**kw)
    print(f"{a}-{b:<8} {str(r['pf']):<6} {str(r['dd']):<5} {r['n']:<5} {r['net']:>7.0f}")
    if r['net']<0: allpos=False
print("ALL periods profitable:",allpos)

print("\n=== sensitivity: small param perturbations (OOS 2016-2026) ===")
oos=d[d.index>='2016-01-01']
def f(k,rlo,rhi,sl,tp):
    def g(d,i):
        c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values; rr=d['rsi14'].values
        if c[i-1]<mid[i-1]-k*sd[i-1] and rr[i-1]<=rlo: return 1
        if c[i-1]>mid[i-1]+k*sd[i-1] and rr[i-1]>=rhi: return -1
        return 0
    return g
for k in (2.8,3.0,3.2):
  for rl,rh in ((18,82),(20,80),(25,75)):
    r=backtest(oos,f(k,rl,rh,4,2.5),sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
    print(f"k{k} rsi{rl}/{rh}: pf{r['pf']} dd{r['dd']} n{r['n']} net{r['net']:.0f}")
