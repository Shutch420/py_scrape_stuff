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
df["link_name"]=df.apply(lambda row: "/".join(row["href"].split("/")[2:]), axis=1)
df1=df.set_index("price_eur").sort_index()
with pd.option_context("display.max_rows", None, "display.max_columns", None):
    print(df1[((((20)<(df1.index))) & (((df1.link_name.str.contains("thinkcentre")) | (df1.link_name.str.contains("hp")) | (df1.link_name.str.contains("fujitsu")) | (df1.link_name.str.contains("medion")))))][["link_name"]])
plt.hist(df1.index(), bins=100)