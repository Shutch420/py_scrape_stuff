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
import random
from bs4 import BeautifulSoup
df=pd.read_csv("techpowerup_gpu-specs.csv")
res=[]
for idx, row in [(1,df.iloc[347],)]:
    url=(("https://www.techpowerup.com")+(row.url))
    time.sleep((((9.999999776482582e-3))*(random.randint(10, 60))))
    print("requesting {} [{}/{}]".format(url, idx, len(df)))
    # https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/
    r=requests.get(url)
    content=r.text.replace("&#8203", "")
    soup=BeautifulSoup(content, "html.parser")
    sections=soup.find_all(lambda tag: ((((tag.name)==("section"))) and (((tag.get("class"))==(["details"])))))
    titles=[]
    for section in sections:
        tit_orig=section.h2.text.strip()
        tit=tit_orig
        count=2
        while ((tit in titles)):
            tit=((tit_orig)+("_")+(str(count)))
            count=((1)+(count))
        titles.append(tit)
    dres={("scrape_timestamp"):(time.time())}
    for col in df.columns:
        dres[(("stage0_")+(col))]=row[col]
    try:
        for tit_name, section in zip(titles, sections):
            if ( section.div ):
                for line in section.div.find_all("dl"):
                    dres[((tit_name)+(" ")+(line.dt.text.strip()))]=line.dd.text.strip()
    except Exception as e:
        print("warn {}".format(e))
        pass
    res.append(dres)
    df_out=pd.DataFrame(res)
    df_out.to_csv("techpowerup_gpu-specs_details_{}.csv".format("intermediate"))
df_out.to_csv("techpowerup_gpu-specs_details_{}.csv".format(int(time.time())))