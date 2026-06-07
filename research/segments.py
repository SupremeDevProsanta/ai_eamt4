import numpy as np, pandas as pd
from engine import read_hst, prep, DATA
d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna().copy()
c=d['close'].values; at=d['atr'].values; idx=d.index
def emaS(p): return d['close'].ewm(span=p,adjust=False).mean().values
FAST,SLOW=20,50
ef=emaS(FAST); es=emaS(SLOW)
state=np.sign(ef-es)            # +1 fast above slow (up), -1 down
cross=np.where(np.diff(state)!=0)[0]+1   # bars where state flips
# build segments between crossovers
segs=[]
for k in range(len(cross)-1):
    a=cross[k]; b=cross[k+1]      # segment occupies [a, b)
    if b-a<2: continue
    dirn=state[a]
    L=b-a
    seg_close=c[a:b]
    # slope via linear fit, normalized to ATR-per-bar
    x=np.arange(L); sl=np.polyfit(x,seg_close,1)[0]/ (at[a] if at[a]>0 else np.nan)
    ret=(c[b-1]-c[a])/ (at[a] if at[a]>0 else np.nan)   # realized move in ATR over segment
    segs.append(dict(a=a,b=b,t=idx[a],dir=int(dirn),L=L,slope=sl,ret=ret))
S=pd.DataFrame(segs)
S['is_in']=S['t']<pd.Timestamp('2016-01-01')
print(f"EMA{FAST}/{SLOW}: {len(S)} segments  (cross events {len(cross)})")
print("\n=== segment stats by direction ===")
for spn,sub in [('ALL',S),('IN',S[S.is_in]),('OOS',S[~S.is_in])]:
    up=sub[sub.dir>0]; dn=sub[sub.dir<0]
    print(f"{spn:<4} up:{len(up):4} medLen{up.L.median():5.0f} medSlope{up.slope.median():6.3f} medRet{up.ret.median():6.2f} | "
          f"dn:{len(dn):4} medLen{dn.L.median():5.0f} medSlope{dn.slope.median():6.3f} medRet{dn.ret.median():6.2f}")
# How often does the trade direction's segment actually make money (ret in dir>0)?
S['ret_dir']=S['ret']*S['dir']   # positive = MA segment moved the 'right' way
print(f"\nFraction of segments where price moved WITH the MA state (ret_dir>0): {(S.ret_dir>0).mean()*100:.1f}%")
print(f"  median ret_dir (ATR): {S.ret_dir.median():.2f}   mean: {S.ret_dir.mean():.2f}")
S.to_pickle('/tmp/bt/_segs.pkl')
