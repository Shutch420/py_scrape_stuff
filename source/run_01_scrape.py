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
def gen_url(keywords="", categoryId="", locationStr="", locationId="", radius="", sortingField="SORTING_DATE", adType="", posterType="", pageNum="1", action="find", maxPrice="", minPrice=""):
    return "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?&keywords={}&categoryId={}&locationStr={}&locationId={}&radius={}&sortingField={}&adType={}&posterType={}&pageNum={}&action={}&maxPrice={}&minPrice={}".format(urllib.parse.quote(keywords), urllib.parse.quote(categoryId), urllib.parse.quote(locationStr), urllib.parse.quote(locationId), urllib.parse.quote(radius), urllib.parse.quote(sortingField), urllib.parse.quote(adType), urllib.parse.quote(posterType), urllib.parse.quote(pageNum), urllib.parse.quote(action), urllib.parse.quote(maxPrice), urllib.parse.quote(minPrice))
# load the url
url=gen_url(keywords="vega 56", maxPrice="350", minPrice="120")
r=requests.get(url)
content=r.text.replace("&#8203", "")
soup=BeautifulSoup(content, "html.parser")
articles=soup.find_all("article", {("class"):("aditem")})
if ( articles is None ):
    logging.info("No articles match.")
# parse articles
res=[]
for article in articles:
    details=article.find("div", {("class"):("aditem-details")})
    price=((details) and (details.find("strong").text))
    vb=((price) and (("VB" in price)))
    header=article.find("h2", {("class"):("text-module-begin")})
    href=((header) and (header.find("a", href=True)["href"]))
    date=article.find("div", {("class"):("aditem-addon")}).text.strip()
    ignore=False
    timestamp=time.time()
    content=article
    search_url=url
    res.append({("details"):(details),("price"):(price),("vb"):(vb),("header"):(header),("href"):(href),("date"):(date),("ignore"):(ignore),("timestamp"):(timestamp),("content"):(content),("search_url"):(search_url)})
df=pd.DataFrame(res)
df.to_csv("output.csv")