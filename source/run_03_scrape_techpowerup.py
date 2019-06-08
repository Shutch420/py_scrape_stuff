import sys
import pandas as pd
import pathlib
import html
import json
import logging
import requests
import urllib
import time
from bs4 import BeautifulSoup
def gen_url(mfgr="NVIDIA", released="2008", sort="name"):
    return "https://www.techpowerup.com/gpu-specs/?&mfgr={}&released={}&sort={}".format(urllib.parse.quote(mfgr), urllib.parse.quote(released), urllib.parse.quote(sort))
url=gen_url()
print("requesting {}".format(url))
r=requests.get(url)
content=r.text.replace("&#8203", "")
soup=BeautifulSoup(content, "html.parser")
table=soup.find("table", {("class"):("processors")})
head=table.find("thead", {("class"):("colheader")})
columns=map(lambda x: x.text, head.find_all("th"))
rows=rows.find_all("tr")