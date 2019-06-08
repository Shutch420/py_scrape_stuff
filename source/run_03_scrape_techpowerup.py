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
def gen_url(mfgr="NVIDIA", released="2008", sort="name"):
    return "https://www.techpowerup.com/gpu-specs/?&mfgr={}&released={}&sort={}".format(urllib.parse.quote(mfgr), urllib.parse.quote(released), urllib.parse.quote(sort))
data=[]
for mfgr in ["NVIDIA", "AMD"]:
    for year in range(2008, ((1)+(2019))):
        url=gen_url(mfgr=mfgr, released=str(year))
        time.sleep(3)
        print("requesting {}".format(url))
        r=requests.get(url)
        content=r.text.replace("&#8203", "")
        soup=BeautifulSoup(content, "html.parser")
        table=soup.find("table", {("class"):("processors")})
        head=table.find("thead", {("class"):("colheader")})
        columns=list(map(lambda x: x.text.strip(), head.find_all("th")))
        rows=table.find_all("tr")
        data=((data)+(list(map(lambda row: dict((([("time",time.time(),), ("mfgr",mfgr,), ("year",year,)])+(list(zip(columns, map(lambda td: td.text.strip(), row.find_all("td"))))))), rows[2:]))))
        df=pd.DataFrame(data)
        df.to_csv("techpowerup_gpu.csv")