import struct, numpy as np, pandas as pd

def read_hst(path):
    with open(path,'rb') as f:
        raw=f.read()
    ver=struct.unpack('<i',raw[:4])[0]
    body=raw[148:]
    if ver==401:
        rec=60; fmt='<qddddqiq'   # time,open,high,low,close,tickvol,spread,realvol
    elif ver==400:
        rec=44; fmt='<idddd d'.replace(' ','')  # time(int),o,h,l,c,vol(double) -> handle below
    else:
        raise ValueError(f"ver {ver}")
    n=len(body)//rec
    rows=[]
    if ver==401:
        for i in range(n):
            t,o,h,l,c,tv,sp,rv=struct.unpack(fmt, body[i*rec:(i+1)*rec])
            rows.append((t,o,h,l,c,tv))
    else:
        fmt='<iddddd'
        for i in range(n):
            t,o,h,l,c,v=struct.unpack(fmt, body[i*rec:(i+1)*rec])
            rows.append((t,o,h,l,c,v))
    df=pd.DataFrame(rows,columns=['time','open','high','low','close','vol'])
    df['time']=pd.to_datetime(df['time'],unit='s')
    return df.set_index('time')

if __name__=="__main__":
    import sys
    d=read_hst(sys.argv[1])
    print("ver-parsed bars:",len(d))
    print(d.head(2)); print(d.tail(2))
    print("range:",d.index[0],"->",d.index[-1])
