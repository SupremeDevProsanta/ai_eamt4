from engine import *
import pandas as pd
d=prep(read_hst(f"{DATA}/NZDCAD30.hst"))
d['bb_sd']=d['close'].rolling(20).std(ddof=0)   # MT4-matching
d=d.dropna()
def win(d,i):
    c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values; r=d['rsi14'].values
    if c[i-1]<mid[i-1]-3.0*sd[i-1] and r[i-1]<=20: return 1
    if c[i-1]>mid[i-1]+3.0*sd[i-1] and r[i-1]>=80: return -1
    return 0
kw=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')

# instrument backtest to capture entry timestamps
def run_times(d):
    o=d['open'].values;h=d['high'].values;l=d['low'].values;c=d['close'].values
    at=d['atr'].values; mid=d['bb_mid'].values; idx=d.index
    pip=0.0001;spr=0.3*pip;upp=7.4;comm=7.0;bal=10000;pos=None;ent=[]
    def lots(sp): per=sp*upp; return max(0.01,round(bal*0.5/100/per,2)) if per>0 else 0.01
    for i in range(1,len(d)):
        if pos:
            dirn=pos['dir'];bars=i-pos['i'];ex=None
            if (l[i]<=pos['sl']) if dirn==1 else (h[i]>=pos['sl']): ex=pos['sl']
            elif (h[i]>=pos['tp']) if dirn==1 else (l[i]<=pos['tp']): ex=pos['tp']
            elif (dirn==1 and c[i]>=mid[i]) or (dirn==-1 and c[i]<=mid[i]): ex=c[i]
            elif bars>=96: ex=c[i]
            if ex is not None: pos=None
        if pos is None and at[i]>0:
            s=win(d,i)
            if s!=0:
                sp=4.0*at[i]
                if s==1: e=c[i]+spr; pos=dict(dir=1,entry=e,sl=e-sp,tp=e+2.5*at[i],i=i)
                else: e=c[i]-spr; pos=dict(dir=-1,entry=e,sl=e+sp,tp=e-2.5*at[i],i=i)
                ent.append(idx[i])
    return pd.Series(1,index=pd.DatetimeIndex(ent))

ent=run_times(d)
print("NZDCAD strict model — entry frequency")
print("total entries:", len(ent), "over", round((d.index[-1]-d.index[0]).days/365.25,1),"years")
permonth=ent.resample('MS').count()
print("avg trades/month:", round(permonth.mean(),2))
print("median trades/month:", int(permonth.median()))
print("max in a month:", int(permonth.max()), " | months with 0 trades:", int((permonth==0).sum()),"/",len(permonth))
print("avg trades/year:", round(len(ent)/((d.index[-1]-d.index[0]).days/365.25),1))
print("\nby year:")
print(ent.resample('YS').count().to_string())
