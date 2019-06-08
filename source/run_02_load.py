import matplotlib
import matplotlib.pyplot as plt
plt.ion()
import pandas as pd
import pathlib
df=pd.read_csv("output_20190608b.csv")
def parse_price(row):
    try:
        p=row["price"].strip()
        if ( (("VB")==(p)) ):
            return (0.0e+0)
        return float(p.split("\u20ac")[0])
    except Exception as e:
        return (0.0e+0)
df["price_eur"]=df.apply(parse_price, axis=1)
df["link_name"]=df.apply(lambda row: "/".join(row["href"].split("/")[2:-1]), axis=1)
df1=df.set_index("price_eur").sort_index()
laptop=((df1.link_name.str.contains("probook")) | (df1.link_name.str.contains("notebook")) | (df1.link_name.str.contains("laptop")) | (df1.link_name.str.contains("thinkpad")) | (df1.link_name.str.contains("ideapad")) | (df1.link_name.str.contains("lifebook")) | (df1.link_name.str.contains("yoga")) | (df1.link_name.str.contains("latitude")))
nvidia=((df1.link_name.str.contains("gtx")) | (df1.link_name.str.contains("nvidia")))
amd=((df1.link_name.str.contains("hd")) | (df1.link_name.str.contains("amd")) | (df1.link_name.str.contains("radeon")))
cpu=((df1.link_name.str.contains("processor")) | (df1.link_name.str.contains("prozessor")))
desktop=((df1.link_name.str.contains("thinkcentre")) | (df1.link_name.str.contains("lenovo")) | (df1.link_name.str.contains("hp")) | (df1.link_name.str.contains("fujitsu")) | (df1.link_name.str.contains("medion")) | (df1.link_name.str.contains("dell")) | (df1.link_name.str.contains("optiplex")) | (df1.link_name.str.contains("prodesk")) | (df1.link_name.str.contains("esprimo")) | (df1.link_name.str.contains("workstation")) | (df1.link_name.str.contains("elitedesk")))
older_than_haskell=((df1.link_name.str.contains("i3-2")) | (df1.link_name.str.contains("i3-3")) | (df1.link_name.str.contains("i5-2")) | (df1.link_name.str.contains("i5-3")) | (df1.link_name.str.contains("i5-2")) | (df1.link_name.str.contains("i5-3")))
df2=df1[((((20)<(df1.index))) & (~laptop) & (~cpu) & (~older_than_haskell) & (desktop))]
with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.max_colwidth", 1000, "display.width", 1000):
    print(df2[["link_name", "generation"]])
plt.hist(df1[((0)<(df1.index))].index, bins=120)
plt.hist(df1[((((0)<(df1.index))) & (~laptop))].index, bins=120)
plt.grid()