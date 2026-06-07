import numpy as np, pandas as pd
S=pd.read_pickle('/tmp/bt/_segs.pkl')
# ---- does PREVIOUS segment predict NEXT segment's directional return? ----
S=S.reset_index(drop=True)
S['prevL']=S['L'].shift(1); S['prevSlopeAbs']=S['slope'].abs().shift(1)
S['prevRetDir']=(S['ret']*S['dir']).shift(1)
S['retDir']=S['ret']*S['dir']
W=S.dropna(subset=['prevL','prevSlopeAbs','prevRetDir','retDir'])
def corr(a,b): 
    m=np.isfinite(a)&np.isfinite(b); 
    return np.corrcoef(a[m],b[m])[0,1]
print("=== Does previous segment predict NEXT segment's ret_dir (ATR)? ===")
for spn,sub in [('IN',W[W.is_in]),('OOS',W[~W.is_in])]:
    print(f"  {spn}: corr(prevLen,nextRet)={corr(sub.prevL,sub.retDir):+.3f}  "
          f"corr(prevSlope,nextRet)={corr(sub.prevSlopeAbs,sub.retDir):+.3f}  "
          f"corr(prevRet,nextRet)={corr(sub.prevRetDir,sub.retDir):+.3f}")
# conditional: when prev segment was a STRONG trend (top tercile len AND slope), is next better?
print("\n=== Next-segment ret_dir conditioned on PREVIOUS segment strength ===")
for spn,sub in [('IN',W[W.is_in]),('OOS',W[~W.is_in])]:
    Lhi=sub.prevL.quantile(.66); Shi=sub.prevSlopeAbs.quantile(.66)
    strong=sub[(sub.prevL>=Lhi)&(sub.prevSlopeAbs>=Shi)]
    weak  =sub[(sub.prevL< sub.prevL.quantile(.5))]
    print(f"  {spn}: after STRONG prev  -> next medRetDir {strong.retDir.median():+.2f} mean {strong.retDir.mean():+.2f} win%{(strong.retDir>0).mean()*100:4.1f} n{len(strong)}")
    print(f"  {spn}: after WEAK prev    -> next medRetDir {weak.retDir.median():+.2f} mean {weak.retDir.mean():+.2f} win%{(weak.retDir>0).mean()*100:4.1f} n{len(weak)}")
