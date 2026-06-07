from engine import *
def winsig(d,i):
    c=d['close'].values; mid=d['bb_mid'].values; sd=d['bb_sd'].values; r=d['rsi14'].values
    if c[i-1]<mid[i-1]-3.0*sd[i-1] and r[i-1]<=20: return 1
    if c[i-1]>mid[i-1]+3.0*sd[i-1] and r[i-1]>=80: return -1
    return 0
kw=dict(sl_atr=4.0,tp_atr=2.5,time_stop=96,exit_mid='bb_mid')
pairs=["NZDCAD","AUDCAD","AUDNZD","EURUSD"]
print(f"{'pair':<8} {'span':<23} {'full pf/dd/n':<20} {'OOS(2016+) pf/dd/n':<22} OOSnet")
print("-"*92)
for p in pairs:
    try:
        d=prep(read_hst(f"{DATA}/{p}30.hst"))
        d['bb_sd']=d['close'].rolling(20).std(ddof=0)  # match MT4
        d=d.dropna()
        span=f"{d.index[0].date()}..{d.index[-1].date()}"
        full=backtest(d,winsig,**kw)
        oos=backtest(d[d.index>='2016-01-01'],winsig,**kw)
        print(f"{p:<8} {span:<23} pf{full['pf']:<4} dd{full['dd']:<5} n{full['n']:<5} | pf{oos['pf']:<5} dd{oos['dd']:<5} n{oos['n']:<5} | {oos['net']:>6.0f}")
    except Exception as e:
        print(f"{p:<8} ERROR {e}")
