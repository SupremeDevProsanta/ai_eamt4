import numpy as np, pandas as pd, pickle
from engine import *
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
n=len(d)
o=d['open'].values;c=d['close'].values;hi=d['high'].values;lo=d['low'].values;at=d['atr'].values

# ---- FEATURES (all use info up to bar i only) ----
F={}
# 1 Bollinger band width + squeeze percentile (low = compression)
bbw = (2*d['bb_sd']/d['bb_mid'])
F['bbw_pctile'] = bbw.rolling(252).rank(pct=True).values          # 0=tightest in last yr-ish
# 2 ATR compression: atr vs its 100-bar mean
F['atr_ratio'] = (d['atr']/d['atr'].rolling(100).mean()).values
# 3 N-bar range compression (Donchian width vs history)
roll=48
dchi=d['high'].rolling(roll).max(); dclo=d['low'].rolling(roll).min()
dwidth=(dchi-dclo)
F['range_pctile']=dwidth.rolling(252).rank(pct=True).values
# 4 Donchian position (where price sits in its range): near 1 = at highs
F['donch_pos']=((d['close']-dclo)/(dchi-dclo)).values
# 5 RSI level and slope
F['rsi']=d['rsi14'].values
F['rsi_slope']=(d['rsi14']-d['rsi14'].shift(6)).values
# 6 Momentum ROC
F['roc12']=(d['close']/d['close'].shift(12)-1).values
F['roc24']=(d['close']/d['close'].shift(24)-1).values
# 7 ADX (trend strength) - Wilder
def adx(df,nn=14):
    up=df['high'].diff(); dn=-df['low'].diff()
    plus=np.where((up>dn)&(up>0),up,0.0); minus=np.where((dn>up)&(dn>0),dn,0.0)
    tr=pd.concat([df['high']-df['low'],(df['high']-df['close'].shift()).abs(),(df['low']-df['close'].shift()).abs()],axis=1).max(axis=1)
    atr_=tr.ewm(alpha=1/nn,adjust=False).mean()
    pdi=100*pd.Series(plus,index=df.index).ewm(alpha=1/nn,adjust=False).mean()/atr_
    mdi=100*pd.Series(minus,index=df.index).ewm(alpha=1/nn,adjust=False).mean()/atr_
    dx=100*(pdi-mdi).abs()/(pdi+mdi)
    return dx.ewm(alpha=1/nn,adjust=False).mean()
F['adx']=adx(d).values
# 8 inside-bar streak (consolidation): count consecutive bars whose range inside prev
inside=((d['high']<=d['high'].shift())&(d['low']>=d['low'].shift())).astype(int)
streak=np.zeros(n)
iv=inside.values
for i in range(1,n): streak[i]=streak[i-1]+1 if iv[i] else 0
F['inside_streak']=streak

pickle.dump(F, open('/tmp/bt/_feats.pkl','wb'))
print("features:", list(F.keys()))
for k,v in F.items():
    s=pd.Series(v); print(f"  {k:<14} nNaN={s.isna().sum():>6}  median={np.nanmedian(v):.3f}")
