import matplotlib
import matplotlib.pyplot as plt
plt.ion()
import pandas as pd
import pathlib
import html
from bs4 import BeautifulSoup
df=pd.read_csv("output_kempen_pc.csv")
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
soup=BeautifulSoup(df2.iloc[10].content, "html.parser")
details=soup.find("div", {("class"):("aditem-details")})
def tbl(df2):
    with pd.option_context("display.max_rows", None, "display.max_columns", None, "display.max_colwidth", 1000, "display.width", 1000):
        print(df2[["link_name", "gen_id", "group_keyword", "device_id"]])
tbl(df2)
plt.hist(df2_xeon[((0)<(df2_xeon.index))].index, bins=120, label="xeon")
plt.hist(df2_i5[((0)<(df2_i5.index))].index, bins=120, label="i5")
plt.hist(df2_i7[((0)<(df2_i7.index))].index, bins=120, label="i7")
plt.hist(df2_i3[((0)<(df2_i3.index))].index, bins=120, label="i3")
plt.legend()
plt.grid()