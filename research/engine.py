import numpy as np, pandas as pd
from hst import read_hst
DATA="/sessions/wizardly-vibrant-ride/mnt/AEB5440F8CD2F75DF3659328D982EC47/history/ICMarketsSC-Demo01"

# ---------- indicators ----------
def sma(s,n): return s.rolling(n).mean()
def ema(s,n): return s.ewm(span=n,adjust=False).mean()
def stdev(s,n): return s.rolling(n).std()
def atr(df,n):
    h,l,c=df['high'],df['low'],df['close']; pc=c.shift(1)
    tr=pd.concat([(h-l),(h-pc).abs(),(l-pc).abs()],axis=1).max(axis=1)
    return tr.ewm(span=n,adjust=False).mean()
def rsi(s,n):
    d=s.diff(); up=d.clip(lower=0); dn=-d.clip(upper=0)
    rs=up.ewm(span=n,adjust=False).mean()/dn.ewm(span=n,adjust=False).mean().replace(0,np.nan)
    return 100-100/(1+rs)

def prep(df):
    d=df.copy()
    d['atr']=atr(d,14)
    for n in (20,50,100,200): d[f'sma{n}']=sma(d['close'],n)
    d['rsi2']=rsi(d['close'],2); d['rsi14']=rsi(d['close'],14)
    d['bb_mid']=sma(d['close'],20); d['bb_sd']=stdev(d['close'],20)
    return d

# ---------- generic single-position backtest ----------
# signal_fn(d, i) -> (+1 long / -1 short / 0), uses ONLY data up to i-1 (close of prior bar)
# exit handled by: TP at tp_atr*ATR, SL at sl_atr*ATR, optional revert-to-mean exit, time stop
def backtest(d, signal_fn, sl_atr, tp_atr, time_stop, risk=0.5,
             spread_pips=0.3, comm=7.0, upp=7.4, pip=0.0001, start=10000.0,
             exit_mid=None):
    o=d['open'].values;h=d['high'].values;l=d['low'].values;c=d['close'].values
    at=d['atr'].values; idx=d.index
    mid = d[exit_mid].values if exit_mid else None
    spr=spread_pips*pip
    bal=start; peak=bal; maxdd=0; pos=None; trades=[]
    def lots(stop_pips):
        per=stop_pips*upp; return max(0.01,round(bal*risk/100.0/per,2)) if per>0 else 0.01
    for i in range(1,len(d)):
        if pos:
            dirn=pos['dir']; bars=i-pos['i']; ex=None;why=None
            hit_sl=(l[i]<=pos['sl']) if dirn==1 else (h[i]>=pos['sl'])
            hit_tp=(h[i]>=pos['tp']) if dirn==1 else (l[i]<=pos['tp'])
            if hit_sl: ex=pos['sl'];why='sl'
            elif hit_tp: ex=pos['tp'];why='tp'
            elif mid is not None and ((dirn==1 and c[i]>=mid[i]) or (dirn==-1 and c[i]<=mid[i])): ex=c[i];why='mid'
            elif bars>=time_stop: ex=c[i];why='time'
            if ex is not None:
                pl=((ex-spr-pos['entry']) if dirn==1 else (pos['entry']-(ex+spr)))/pip*upp*pos['lots']-comm*pos['lots']
                bal+=pl; trades.append(pl); pos=None
        if pos is None and at[i]>0:
            sig=signal_fn(d,i)
            if sig!=0:
                sp=sl_atr*at[i]
                if sig==1: entry=c[i]+spr; pos=dict(dir=1,entry=entry,sl=entry-sp,tp=entry+tp_atr*at[i],lots=lots(sp/pip),i=i)
                else:      entry=c[i]-spr; pos=dict(dir=-1,entry=entry,sl=entry+sp,tp=entry-tp_atr*at[i],lots=lots(sp/pip),i=i)
        fl=0.0
        if pos: fl=((c[i]-pos['entry']) if pos['dir']==1 else (pos['entry']-c[i]))/pip*upp*pos['lots']
        eq=bal+fl
        if eq>peak: peak=eq
        dd=(peak-eq)/peak*100 if peak>0 else 0
        if dd>maxdd: maxdd=dd
    tr=np.array(trades)
    if len(tr)==0: return dict(net=0,n=0,pf=0,wr=0,dd=round(maxdd,1))
    w=tr[tr>0]; ls=tr[tr<0]
    return dict(net=round(bal-start,0),n=len(tr),
                pf=round(w.sum()/abs(ls.sum()),3) if len(ls) and ls.sum()!=0 else 99,
                wr=round((tr>0).mean()*100,1), dd=round(maxdd,1),
                aw=round(w.mean(),1) if len(w) else 0, al=round(ls.mean(),1) if len(ls) else 0)

def evalsplit(d, signal_fn, **kw):
    ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
    return backtest(ins,signal_fn,**kw), backtest(oos,signal_fn,**kw)
