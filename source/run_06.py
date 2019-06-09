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
# pip3 install --user requests-html
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
res=[]
for e in elements:
    h=e.find("a", first=True)
    res.append({("link"):(h.attrs["href"]),("title"):(h.text)})
df=pd.DataFrame(res)