import numpy as np, pandas as pd
from hst import read_hst
DATA="/sessions/wizardly-vibrant-ride/mnt/AEB5440F8CD2F75DF3659328D982EC47/history/ICMarketsSC-Demo01"

def ema(s,n): return s.ewm(span=n,adjust=False).mean()
def sma(s,n): return s.rolling(n).mean()
def atr(df,n):
    h,l,c=df['high'],df['low'],df['close']; pc=c.shift(1)
    tr=pd.concat([(h-l),(h-pc).abs(),(l-pc).abs()],axis=1).max(axis=1)
    return tr.ewm(span=n,adjust=False).mean()
def rsi(s,n):
    d=s.diff(); up=d.clip(lower=0); dn=-d.clip(upper=0)
    rs=up.ewm(span=n,adjust=False).mean()/dn.ewm(span=n,adjust=False).mean().replace(0,np.nan)
    return 100-100/(1+rs)

# Mean-reversion: when price stretched >= EntryAtr*ATR below/above MA AND RSI extreme,
# fade it. Exit at MA (mean) take-profit OR hard stop StopAtr*ATR beyond entry OR time stop.
DEF=dict(MaPeriod=100, EntryAtr=2.5, StopAtr=2.0, RsiPeriod=14, RsiLo=25, RsiHi=75,
         AtrPeriod=14, RiskPct=0.5, TimeStopBars=48,
         spread_pips=0.3, commission_per_lot=7.0, usd_per_pip_per_lot=7.4,
         start_balance=10000.0, pip=0.0001, allow_long=True, allow_short=True,
         TpAtMA=True, TpAtr=0.0)

def run(P, df):
    d=df.copy()
    d['ma']=sma(d['close'],P['MaPeriod'])
    d['atr']=atr(d,P['AtrPeriod'])
    d['rsi']=rsi(d['close'],P['RsiPeriod'])
    d=d.dropna()
    o=d['open'].values;h=d['high'].values;l=d['low'].values;c=d['close'].values
    ma=d['ma'].values;at=d['atr'].values;rs=d['rsi'].values; idx=d.index
    pip=P['pip']; spr=P['spread_pips']*pip; upp=P['usd_per_pip_per_lot']; comm=P['commission_per_lot']
    bal=P['start_balance']; peak=bal; maxdd=0.0
    pos=None; trades=[]; eqc=[]
    def lots(stop_pips):
        risk=bal*P['RiskPct']/100.0; per=stop_pips*upp
        return max(0.01, round(risk/per,2)) if per>0 else 0.01
    for i in range(1,len(d)):
        # manage open
        if pos:
            dirn=pos['dir']; bars=i-pos['i']
            hit_sl = (l[i]<=pos['sl']) if dirn==1 else (h[i]>=pos['sl'])
            tp=pos['tp']
            hit_tp = (h[i]>=tp) if dirn==1 else (l[i]<=tp)
            exit_px=None; why=None
            if hit_sl: exit_px=pos['sl']; why='stop'
            elif hit_tp: exit_px=tp; why='tp'
            elif bars>=P['TimeStopBars']: exit_px=c[i]; why='time'
            if exit_px is not None:
                if dirn==1: pl=(exit_px-spr-pos['entry'])/pip*upp*pos['lots']
                else:       pl=(pos['entry']-(exit_px+spr))/pip*upp*pos['lots']
                pl-=comm*pos['lots']
                bal+=pl; trades.append(dict(t=idx[i],dir=dirn,pl=pl,why=why,bars=bars)); pos=None
        # entries (one at a time)
        if pos is None and at[i]>0:
            stretch=(c[i]-ma[i])/at[i]
            stop_pips=P['StopAtr']*at[i]/pip
            if P['allow_long'] and stretch<=-P['EntryAtr'] and rs[i]<=P['RsiLo']:
                entry=c[i]+spr; sl=entry-P['StopAtr']*at[i]
                tp= ma[i] if P['TpAtMA'] else entry+P['TpAtr']*at[i]
                pos=dict(dir=1,entry=entry,sl=sl,tp=tp,lots=lots(stop_pips),i=i)
            elif P['allow_short'] and stretch>=P['EntryAtr'] and rs[i]>=P['RsiHi']:
                entry=c[i]-spr; sl=entry+P['StopAtr']*at[i]
                tp= ma[i] if P['TpAtMA'] else entry-P['TpAtr']*at[i]
                pos=dict(dir=-1,entry=entry,sl=sl,tp=tp,lots=lots(stop_pips),i=i)
        floating=0.0
        if pos:
            if pos['dir']==1: floating=(c[i]-pos['entry'])/pip*upp*pos['lots']
            else: floating=(pos['entry']-c[i])/pip*upp*pos['lots']
        eq=bal+floating; eqc.append(eq)
        if eq>peak: peak=eq
        dd=(peak-eq)/peak*100 if peak>0 else 0
        if dd>maxdd: maxdd=dd
    tr=pd.DataFrame(trades)
    if len(tr)==0: return dict(net=0,trades=0),tr
    win=tr['pl']>0; los=tr['pl']<0
    return dict(net=round(bal-P['start_balance'],2),end=round(bal,2),trades=len(tr),
        winrate=round(win.mean()*100,1),
        pf=round(tr.loc[win,'pl'].sum()/abs(tr.loc[los,'pl'].sum()),2) if los.any() else None,
        maxdd=round(maxdd,1),
        avg_win=round(tr.loc[win,'pl'].mean(),2) if win.any() else 0,
        avg_loss=round(tr.loc[los,'pl'].mean(),2) if los.any() else 0), tr

if __name__=="__main__":
    import copy,json
    m30=read_hst(f"{DATA}/NZDCAD30.hst")
    r,tr=run(DEF,m30); print("BASE",json.dumps(r,default=str))
