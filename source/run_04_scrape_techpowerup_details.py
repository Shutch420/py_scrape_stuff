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
row=df.iloc[-1]
url=(("https://www.techpowerup.com")+(row.url))
print("requesting {}".format(url))
# https://pythonprogramminglanguage.com/web-scraping-with-pandas-and-beautifulsoup/
r=requests.get(url)
content=r.text.replace("&#8203", "")
soup=BeautifulSoup(content, "html.parser")
sections=soup.find_all("section", {("class"):("details")})
detail_list=list(map(lambda section: {("title"):(section.find("h2").text),("data"):(list(map(lambda row: (row.dt.text,row.dd.text,), ((((section.find("div")) and (section.find("div").find_all("dl")))) or ([])))))}, sections))