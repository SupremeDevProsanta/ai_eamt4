import numpy as np, pandas as pd
from engine import read_hst, prep, DATA

def backtest_trail(d, sl_atr, tp_atr, time_stop, exit_mid='bb_mid',
                   lock_trig_atr=0.0, lock_atr=0.0, trail_start_atr=0.0, trail_gap_atr=0.0,
                   risk=0.5, spread_pips=0.3, comm=7.0, upp=7.4, pip=0.0001, start=10000.0):
    o=d['open'].values;h=d['high'].values;l=d['low'].values;c=d['close'].values
    at=d['atr'].values; bbm=d['bb_mid'].values; sd=d['bb_sd'].values; r=d['rsi14'].values
    mid=d[exit_mid].values if exit_mid else None
    spr=spread_pips*pip; bal=start; peak=bal; maxdd=0; pos=None; trades=[]
    BBK=3.2; RLO=20; RHI=80
    def lots(stop_pips):
        per=stop_pips*upp; return max(0.01,round(bal*risk/100.0/per,2)) if per>0 else 0.01
    for i in range(1,len(d)):
        if pos:
            dirn=pos['dir']; bars=i-pos['i']; ex=None
            hit_sl=(l[i]<=pos['sl']) if dirn==1 else (h[i]>=pos['sl'])
            hit_tp=(h[i]>=pos['tp']) if dirn==1 else (l[i]<=pos['tp'])
            if hit_sl: ex=pos['sl']
            elif hit_tp: ex=pos['tp']
            elif mid is not None and ((dirn==1 and c[i]>=mid[i]) or (dirn==-1 and c[i]<=mid[i])): ex=c[i]
            elif bars>=time_stop: ex=c[i]
            if ex is not None:
                pl=((ex-spr-pos['entry']) if dirn==1 else (pos['entry']-(ex+spr)))/pip*upp*pos['lots']-comm*pos['lots']
                bal+=pl; trades.append(pl); pos=None
            else:
                a=at[pos['i']]  # ATR at entry for stable distances
                if dirn==1:
                    pos['hwm']=max(pos['hwm'],h[i]); fav=pos['hwm']-pos['entry']
                    if lock_atr>0 and fav>=lock_trig_atr*a: pos['sl']=max(pos['sl'],pos['entry']+lock_atr*a)
                    if trail_gap_atr>0 and fav>=trail_start_atr*a: pos['sl']=max(pos['sl'],pos['hwm']-trail_gap_atr*a)
                else:
                    pos['hwm']=min(pos['hwm'],l[i]); fav=pos['entry']-pos['hwm']
                    if lock_atr>0 and fav>=lock_trig_atr*a: pos['sl']=min(pos['sl'],pos['entry']-lock_atr*a)
                    if trail_gap_atr>0 and fav>=trail_start_atr*a: pos['sl']=min(pos['sl'],pos['hwm']+trail_gap_atr*a)
        if pos is None and at[i]>0:
            z=(c[i-1]-bbm[i-1])/sd[i-1]
            sig=1 if (z<=-BBK and r[i-1]<=RLO) else (-1 if (z>=BBK and r[i-1]>=RHI) else 0)
            if sig!=0:
                sp=sl_atr*at[i]
                if sig==1: e=c[i]+spr; pos=dict(dir=1,entry=e,sl=e-sp,tp=e+tp_atr*at[i],lots=lots(sp/pip),i=i,hwm=e)
                else:      e=c[i]-spr; pos=dict(dir=-1,entry=e,sl=e+sp,tp=e-tp_atr*at[i],lots=lots(sp/pip),i=i,hwm=e)
        fl=((c[i]-pos['entry']) if pos and pos['dir']==1 else (pos['entry']-c[i]) if pos else 0)
        if pos: fl=fl/pip*upp*pos['lots']
        eq=bal+fl; peak=max(peak,eq); dd=(peak-eq)/peak*100 if peak>0 else 0; maxdd=max(maxdd,dd)
    tr=np.array(trades)
    if len(tr)==0: return dict(net=0,n=0,pf=0,wr=0,dd=round(maxdd,1))
    w=tr[tr>0]; ls=tr[tr<0]
    return dict(net=round(bal-start,0),n=len(tr),pf=round(w.sum()/abs(ls.sum()),3) if len(ls) and ls.sum() else 99,
                wr=round((tr>0).mean()*100,1),dd=round(maxdd,1))

d=prep(read_hst(f"{DATA}/NZDCAD30.hst")).dropna()
d['bb_sd']=d['close'].rolling(20).std(ddof=0); d=d.dropna()
ins=d[d.index<'2016-01-01']; oos=d[d.index>='2016-01-01']
base=dict(sl_atr=4.5,tp_atr=3.0,time_stop=96,exit_mid='bb_mid')

def show(tag,**extra):
    ri=backtest_trail(ins,**base,**extra); ro=backtest_trail(oos,**base,**extra)
    print(f"{tag:<34} IN pf{ri['pf']:<6}dd{ri['dd']:<5}wr{ri['wr']:<5}n{ri['n']:<5}net{ri['net']:<7.0f}| OOS pf{ro['pf']:<6}dd{ro['dd']:<5}wr{ro['wr']:<5}n{ro['n']:<5}net{ro['net']:.0f}")

print("BASELINE v1.1 (no lock/trail):")
show("  none")
print("\nLOCK only (breakeven+lock minimum):")
show("  lock@1.0->+0.3", lock_trig_atr=1.0, lock_atr=0.3)
show("  lock@1.5->+0.5", lock_trig_atr=1.5, lock_atr=0.5)
show("  lock@2.0->+1.0", lock_trig_atr=2.0, lock_atr=1.0)
print("\nTRAIL only (gap behind high-water):")
show("  trail start1.5 gap1.5", trail_start_atr=1.5, trail_gap_atr=1.5)
show("  trail start2.0 gap2.0", trail_start_atr=2.0, trail_gap_atr=2.0)
show("  trail start1.0 gap1.0", trail_start_atr=1.0, trail_gap_atr=1.0)
print("\nLOCK + TRAIL combined:")
show("  lock1.0/0.3 + trail2.0/1.5", lock_trig_atr=1.0,lock_atr=0.3,trail_start_atr=2.0,trail_gap_atr=1.5)
show("  lock1.5/0.5 + trail2.0/2.0", lock_trig_atr=1.5,lock_atr=0.5,trail_start_atr=2.0,trail_gap_atr=2.0)
