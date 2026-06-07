import numpy as np, pandas as pd, pickle
from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
n=len(d); idx=d.index
L=np.load('/tmp/bt/_labels.npy')   # [small,medium,big] each +1/-1/0
F=pickle.load(open('/tmp/bt/_feats.pkl','rb'))
isin=np.array(idx<'2016-01-01'); oos=~isin
SCALES=['small','medium','big']

def rate(mask, lab, target):  # P(label==target | mask)
    m=mask & ~np.isnan(mask.astype(float))
    if m.sum()==0: return np.nan,0
    return np.mean(lab[m]==target), int(m.sum())

# Conditions to test (formation hypotheses). Each: name, boolean array, predicted direction target(s)
def pct(name): return F[name]
cond={}
cond['SQUEEZE bbw<10%']      = pct('bbw_pctile')<0.10
cond['SQUEEZE bbw<20%']      = pct('bbw_pctile')<0.20
cond['ATR compress <0.7']    = pct('atr_ratio')<0.70
cond['RANGE tight <15%']     = pct('range_pctile')<0.15
cond['LOW ADX <15 (consol)'] = pct('adx')<15
cond['INSIDE streak>=3']     = pct('inside_streak')>=3
# directional/breakout style
cond['Donch HIGH >0.95']     = pct('donch_pos')>0.95
cond['Donch LOW <0.05']      = pct('donch_pos')<0.05
cond['ADX>30 & roc12>0']     = (pct('adx')>30)&(pct('roc12')>0)
cond['ADX>30 & roc12<0']     = (pct('adx')>30)&(pct('roc12')<0)
cond['RSI>70 rising']        = (pct('rsi')>70)&(pct('rsi_slope')>0)
cond['RSI<30 falling']       = (pct('rsi')<30)&(pct('rsi_slope')<0)
# combo: squeeze THEN breakout up/down (squeeze last bar + price breaks donchian)
sq=pct('bbw_pctile')<0.15
cond['Squeeze+breakUP']      = sq & (pct('donch_pos')>0.90)
cond['Squeeze+breakDN']      = sq & (pct('donch_pos')<0.10)

print("LIFT = P(trend|formation) / base rate.  >1 helps, must hold IN *and* OOS.")
for si,sc in enumerate(SCALES):
    lab=L[si]
    print(f"\n############ SCALE = {sc} ############")
    for tgt,tname in [(1,'UP'),(-1,'DOWN')]:
        bIN,_=rate(isin,lab,tgt); bOO,_=rate(oos,lab,tgt)
        print(f"\n  predicting {tname}-trend  (base: IN {bIN*100:.1f}%  OOS {bOO*100:.1f}%)")
        print(f"    {'formation':<22}{'IN p%':>7}{'IN lift':>8}{'IN n':>7}{'OOS p%':>8}{'OOS lift':>9}{'OOS n':>7}  verdict")
        for cname,cm in cond.items():
            cmf=np.where(np.isnan(cm.astype(float)),False,cm)
            pIN,nIN=rate(isin&cmf,lab,tgt); pOO,nOO=rate(oos&cmf,lab,tgt)
            if nIN<200 or nOO<200: continue
            lIN=pIN/bIN if bIN else 0; lOO=pOO/bOO if bOO else 0
            v=""
            if lIN>=1.15 and lOO>=1.15: v="** ROBUST **"
            elif lIN>=1.15 and lOO<1.0: v="overfit (IN only)"
            elif lIN>=1.10 and lOO>=1.10: v="weak+"
            print(f"    {cname:<22}{pIN*100:>6.1f}{lIN:>8.2f}{nIN:>7}{pOO*100:>7.1f}{lOO:>9.2f}{nOO:>7}  {v}")
