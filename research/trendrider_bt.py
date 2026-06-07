import numpy as np, pandas as pd
from hst import read_hst

DATA="/sessions/wizardly-vibrant-ride/mnt/AEB5440F8CD2F75DF3659328D982EC47/history/ICMarketsSC-Demo01"

# ---------- indicators ----------
def ema(s,n): return s.ewm(span=n,adjust=False).mean()
def atr(df,n):
    h,l,c=df['high'],df['low'],df['close']
    pc=c.shift(1)
    tr=pd.concat([(h-l),(h-pc).abs(),(l-pc).abs()],axis=1).max(axis=1)
    return tr.ewm(span=n,adjust=False).mean()
def adx(df,n):
    h,l,c=df['high'],df['low'],df['close']
    up=h.diff(); dn=-l.diff()
    plus=np.where((up>dn)&(up>0),up,0.0)
    minus=np.where((dn>up)&(dn>0),dn,0.0)
    pc=c.shift(1)
    tr=pd.concat([(h-l),(h-pc).abs(),(l-pc).abs()],axis=1).max(axis=1)
    atrn=tr.ewm(span=n,adjust=False).mean()
    pdi=100*pd.Series(plus,index=df.index).ewm(span=n,adjust=False).mean()/atrn
    mdi=100*pd.Series(minus,index=df.index).ewm(span=n,adjust=False).mean()/atrn
    dx=100*(pdi-mdi).abs()/(pdi+mdi).replace(0,np.nan)
    return dx.ewm(span=n,adjust=False).mean()

# ---------- params (mirror TrendRider.mq4 defaults) ----------
P=dict(MaFast=20,MaMid=50,MaSlow=100,AdxPeriod=14,AdxMin=22.0,
       AtrPeriod=14,AtrSlMult=2.0,RiskPct=1.0,
       UsePullback=True,PullbackAtr=0.5,UseBreakout=True,DonchianN=20,
       UsePyramid=True,MaxUnits=4,AddEveryAtr=1.0,TrailAtrMult=3.0,
       spread_pips=2.0, start_balance=10000.0)

def run(P, m30, h1):
    # H1 trend, reindexed onto M30 (use last CLOSED h1 bar -> shift)
    h1f=ema(h1['close'],P['MaFast']); h1m=ema(h1['close'],P['MaMid']); h1s=ema(h1['close'],P['MaSlow'])
    h1adx=adx(h1,P['AdxPeriod'])
    htf=pd.DataFrame({'f':h1f,'m':h1m,'s':h1s,'adx':h1adx}).shift(1)  # only closed H1
    htf=htf.reindex(m30.index, method='ffill')

    d=m30.copy()
    d['ema_fast']=ema(d['close'],P['MaFast'])
    d['atr']=atr(d,P['AtrPeriod'])
    d['donch_hi']=d['high'].rolling(P['DonchianN']).max().shift(1)
    d['donch_lo']=d['low'].rolling(P['DonchianN']).min().shift(1)
    d=d.join(htf.add_prefix('h1_'))
    d=d.dropna()

    pip=0.0001*10 if False else 0.0001   # NZDCAD 5-digit -> 1 pip=0.0001; price moves in 0.00001
    # NZDCAD quote ~0.8, 5 decimal -> point=0.00001, pip=0.0001
    point=0.00001; pip=0.0001
    spread=P['spread_pips']*pip
    # money model: pip value per 1.0 lot for XXXCAD ~ depends on CAD; approximate via tickvalue.
    # Use generic: 1.0 lot, 1 point move = $1 * (contract/100000). For 0.00001 point on 100k = $1/pip? 
    # NZDCAD: 1 pip (0.0001) on 1.0 lot ~ CAD 10 ~ USD ~7.4. We'll size in "USD per pip per lot".
    usd_per_pip_per_lot=7.4

    bal=P['start_balance']; eq=bal
    legs=[]   # each: dict(dir, entry, lots, sl)
    trades=[]; equity_curve=[]; peak=bal; maxdd=0.0
    o=d['open'].values; h=d['high'].values; l=d['low'].values; c=d['close'].values
    ef=d['ema_fast'].values; at=d['atr'].values
    dhi=d['donch_hi'].values; dlo=d['donch_lo'].values
    hf=d['h1_f'].values; hm=d['h1_m'].values; hs=d['h1_s'].values; ha=d['h1_adx'].values
    idx=d.index

    def trend_dir(i):
        if ha[i]<P['AdxMin']: return 0
        if hf[i]>hm[i]>hs[i]: return 1
        if hf[i]<hm[i]<hs[i]: return -1
        return 0

    def close_all(i, why):
        nonlocal bal, legs
        if not legs: return
        px = c[i]
        for lg in legs:
            if lg['dir']==1: pl=(px-spread - lg['entry'])/pip*usd_per_pip_per_lot*lg['lots']
            else:            pl=(lg['entry'] - (px+spread))/pip*usd_per_pip_per_lot*lg['lots']
            bal+=pl
            trades.append(dict(time=idx[i],dir=lg['dir'],entry=lg['entry'],exit=px,lots=lg['lots'],pl=pl,why=why))
        legs=[]

    def lots_for(stop_pips):
        risk=bal*P['RiskPct']/100.0
        per=stop_pips*usd_per_pip_per_lot
        if per<=0: return 0.01
        lot=risk/per
        return max(0.01, round(lot,2))

    for i in range(1,len(d)):
        # --- manage existing legs: chandelier trail + stop hit ---
        if legs:
            dirn=legs[0]['dir']
            atr_i=at[i]
            # update trailing stop on each leg
            for lg in legs:
                if dirn==1:
                    newsl=h[i-1]-P['TrailAtrMult']*atr_i
                    if newsl>lg['sl']: lg['sl']=newsl
                else:
                    newsl=l[i-1]+P['TrailAtrMult']*atr_i
                    if lg['sl']==0 or newsl<lg['sl']: lg['sl']=newsl
            # check stop hit intrabar (use worst-case: low for long, high for short)
            worst = l[i] if dirn==1 else h[i]
            sl_level = max(lg['sl'] for lg in legs) if dirn==1 else min(lg['sl'] for lg in legs)
            hit = (worst<=sl_level) if dirn==1 else (worst>=sl_level)
            if hit:
                # close all at the stop level
                px=sl_level
                for lg in legs:
                    if lg['dir']==1: pl=(px-spread-lg['entry'])/pip*usd_per_pip_per_lot*lg['lots']
                    else:            pl=(lg['entry']-(px+spread))/pip*usd_per_pip_per_lot*lg['lots']
                    bal+=pl
                    trades.append(dict(time=idx[i],dir=lg['dir'],entry=lg['entry'],exit=px,lots=lg['lots'],pl=pl,why='trail_stop'))
                legs=[]

        td=trend_dir(i)
        # trend flip against open position -> stop adding (trail handles exit). 
        atr_i=at[i]; stop_pips=P['AtrSlMult']*atr_i/pip
        if atr_i<=0: 
            equity_curve.append(bal); continue

        if td!=0:
            want=OP=td
            have = legs[0]['dir'] if legs else 0
            if have==0:
                # entry
                if td==1:
                    pb = P['UsePullback'] and (l[i-1]<=ef[i-1]+P['PullbackAtr']*at[i-1] and c[i-1]>ef[i-1])
                    bo = P['UseBreakout'] and (c[i-1]>dhi[i])
                    if pb or bo:
                        lot=lots_for(stop_pips); legs=[dict(dir=1,entry=c[i]+spread,lots=lot,sl=c[i]-P['AtrSlMult']*atr_i)]
                else:
                    pb = P['UsePullback'] and (h[i-1]>=ef[i-1]-P['PullbackAtr']*at[i-1] and c[i-1]<ef[i-1])
                    bo = P['UseBreakout'] and (c[i-1]<dlo[i])
                    if pb or bo:
                        lot=lots_for(stop_pips); legs=[dict(dir=-1,entry=c[i]-spread,lots=lot,sl=c[i]+P['AtrSlMult']*atr_i)]
            elif have==td and P['UsePyramid'] and len(legs)<P['MaxUnits']:
                last=legs[-1]['entry']
                adv = (c[i]-last) if td==1 else (last-c[i])
                if adv>=P['AddEveryAtr']*atr_i:
                    lot=lots_for(stop_pips)
                    if td==1: legs.append(dict(dir=1,entry=c[i]+spread,lots=lot,sl=c[i]-P['AtrSlMult']*atr_i))
                    else:     legs.append(dict(dir=-1,entry=c[i]-spread,lots=lot,sl=c[i]+P['AtrSlMult']*atr_i))

        # equity mark-to-market
        floating=0.0
        if legs:
            px=c[i]
            for lg in legs:
                if lg['dir']==1: floating+=(px-lg['entry'])/pip*usd_per_pip_per_lot*lg['lots']
                else:            floating+=(lg['entry']-px)/pip*usd_per_pip_per_lot*lg['lots']
        eq=bal+floating
        equity_curve.append(eq)
        if eq>peak: peak=eq
        dd=(peak-eq)/peak*100 if peak>0 else 0
        if dd>maxdd: maxdd=dd

    tr=pd.DataFrame(trades)
    if len(tr)==0:
        return dict(net=0,trades=0,winrate=0,maxdd_pct=round(maxdd,1),profit_factor=None,end=round(bal,2),start=P['start_balance'],wins=0,losses=0,avg_win=0,avg_loss=0), tr, pd.Series(equity_curve)
    win=tr['pl']>0; los=tr['pl']<0
    res=dict(
        start=P['start_balance'], end=round(bal,2), net=round(bal-P['start_balance'],2),
        trades=len(tr), wins=int(win.sum()), losses=int(los.sum()),
        winrate=round(win.mean()*100,1),
        maxdd_pct=round(maxdd,1),
        profit_factor=round(tr.loc[win,'pl'].sum()/abs(tr.loc[los,'pl'].sum()),2) if los.any() and tr.loc[los,'pl'].sum()!=0 else None,
        avg_win=round(tr.loc[win,'pl'].mean(),2) if win.any() else 0,
        avg_loss=round(tr.loc[los,'pl'].mean(),2) if los.any() else 0,
    )
    return res, tr, pd.Series(equity_curve)

if __name__=="__main__":
    m30=read_hst(f"{DATA}/NZDCAD30.hst")
    h1 =read_hst(f"{DATA}/NZDCAD60.hst")
    # focus on a meaningful window; full 20y first
    res,tr,eq=run(P,m30,h1)
    import json; print(json.dumps(res,indent=2,default=str))
