import sys
import numpy as np
import pandas as pd
import pathlib
import html
import json
import logging
import requests_html
import urllib
import time
from googletrans import Translator
# pip3 install --user requests-html googletransx
# pyppeteer-install
def gen_url(keyword="", star="", page="1", pageSize="30", cid="0,1,3", year="-1", language="%E8%8B%B1%E8%AF%AD", region="-1", status="-1", orderBy="0", desc="true"):
    with open("/dev/shm/site") as f:
        site=f.readline().strip()
    return "https://www.{}/list?&keyword={}&star={}&page={}&pageSize={}&cid={}&year={}&language={}&region={}&status={}&orderBy={}&desc={}".format(site, urllib.parse.quote(keyword), urllib.parse.quote(star), urllib.parse.quote(page), urllib.parse.quote(pageSize), urllib.parse.quote(cid), urllib.parse.quote(year), language, urllib.parse.quote(region), urllib.parse.quote(status), urllib.parse.quote(orderBy), urllib.parse.quote(desc))
url=gen_url()
print("get {}".format(url))
session=requests_html.HTMLSession()
r=session.get(url)
r.html.render()
elements=r.html.find("div[class=title-box]")
translator=Translator()
res=[]
def translate_type(str):
    lut={("喜剧"):("comedy"),("惊悚"):("horror"),("剧情"):("plot"),("科幻"):("scifi"),("动作"):("action"),("犯罪"):("crime"),("爱情"):("love"),("战争"):("war")}
    try:
        return lut[str]
    except Exception as e:
        return "-"
for e in elements[3:6]:
    h=e.find("a", first=True)
    title=h.text
    s=e.find("span", first=True)
    res.append({("link"):(h.attrs["href"]),("title"):(title),("type"):(s.text),("type_en"):(translate_type(s.text))})
df=pd.DataFrame(res)
rating_list=[]
def get_rating(row):
    try:
        rating_url="https://www.google.com/search?client=firefox-b-d&q={}+imdb+rating&gl=us".format(urllib.parse.quote(row.title))
        print("get rating {}".format(rating_url))
        rg=session.get(rating_url)
        rg.html.render()
        rating="-"
        rating=rg.html.xpath("//g-review-stars/..", first=True).text
        global rating_list
        rating_list.append(rg)
        print("rating {}".format(rating))
        time.sleep(3)
        return rating
    except Exception as e:
        return "-"
df["rating"]=df.apply(get_rating, axis=1)