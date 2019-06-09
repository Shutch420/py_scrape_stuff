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
for idx, row in df.iterrows():
    url=(("https://www.techpowerup.com")+(row.url))
    time.sleep((((9.999999776482582e-3))*(random.randint(10, 60))))
    print("requesting {} [{}/{}]".format(url, idx, len(df)))
    # https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/
    r=requests.get(url)
    content=r.text.replace("&#8203", "")
    soup=BeautifulSoup(content, "html.parser")
    sections=soup.find_all(lambda tag: ((((tag.name)==("section"))) and (((tag.get("class"))==(["details"])))))
    columns=[]
    for section in sections:
        col_orig=section.h2.text.strip()
        col=col_orig
        count=2
        while ((col in columns)):
            col=((col_orig)+("_")+(str(count)))
            count=((1)+(count))
        columns.append(col)
    dres={("url"):(row.url),("scrape_timestamp"):(time.time())}
    try:
        for section in sections:
            if ( section.div ):
                for col_name, line in zip(columns, section.div.find_all("dl")):
                    dres[((col_name)+(" ")+(line.dt.text.strip()))]=line.dd.text.strip()
    except Exception as e:
        print("warn {}".format(e))
        pass
    res.append(dres)
    df_out=pd.DataFrame(res)
    df_out.to_csv("techpowerup_gpu-specs_details_{}.csv".format("intermediate"))
df_out.to_csv("techpowerup_gpu-specs_details_{}.csv".format(int(time.time())))