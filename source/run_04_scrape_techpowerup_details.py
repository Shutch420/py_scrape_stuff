import sys
import pandas as pd
import pathlib
import html
import json
import logging
import requests
import urllib
import time
import functools
import operator
from bs4 import BeautifulSoup
df=pd.read_csv("techpowerup_gpu-specs.csv")
res=[]
for idx, row in [(0,df.iloc[-1],), (1,df.iloc[-2],)]:
    url=(("https://www.techpowerup.com")+(row.url))
    time.sleep(3)
    print("requesting {} [{}/{}]".format(url, idx, len(df)))
    # https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/
    r=requests.get(url)
    content=r.text.replace("&#8203", "")
    soup=BeautifulSoup(content, "html.parser")
    sections=soup.find_all("section", {("class"):("details")})
    detail_list=(([("url",row.url,), ("time",time.time(),)])+(functools.reduce(operator.iconcat, list(map(lambda section: list(map(lambda row: (((section.find("h2").text.strip())+(" ")+(row.dt.text.strip())),row.dd.text.strip(),), ((((section.find("div")) and (section.find("div").find_all("dl")))) or ([])))), sections)), [])))
    res.append(dict(detail_list))
    df_out=pd.DataFrame(res)
    df_out.to_csv()