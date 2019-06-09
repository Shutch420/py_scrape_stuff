import matplotlib
import matplotlib.pyplot as plt
plt.ion()
import sys
import numpy as np
import pandas as pd
import pathlib
import html
import json
import logging
import requests
import urllib
import time
from bs4 import BeautifulSoup
def gen_url(keywords="", categoryId="225", locationStr="", locationId="", radius="", sortingField="SORTING_DATE", adType="", posterType="", pageNum="1", action="find", maxPrice="", minPrice="", extra=""):
    return (("https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?&keywords={}&categoryId={}&locationStr={}&locationId={}&radius={}&sortingField={}&adType={}&posterType={}&pageNum={}&action={}&maxPrice={}&minPrice={}")+(extra)).format(urllib.parse.quote(keywords), urllib.parse.quote(categoryId), urllib.parse.quote(locationStr), urllib.parse.quote(locationId), urllib.parse.quote(radius), urllib.parse.quote(sortingField), urllib.parse.quote(adType), urllib.parse.quote(posterType), urllib.parse.quote(pageNum), urllib.parse.quote(action), urllib.parse.quote(maxPrice), urllib.parse.quote(minPrice))
df=pd.read_csv("techpowerup_gpu-specs_details_1560089059.csv")
def parse_entry(row, column=None, value_p=None):
    try:
        entry=row[column]
        if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
            value=np.nan
            unit=""
        else:
            entry_stripped=entry.strip()
            entry_parts=entry_stripped.split(" ")
            value_string=entry_parts[0].replace(",", "")
            value=((((((value_string)==("System"))) and (np.nan))) or (float(value_string)))
            unit=" ".join(entry_parts[1:])
            if ( ("GFLOPS" in unit) ):
                unit=unit.replace("GFLOPS", "TFLOPS")
                value=((value)/(1000))
            if ( ("MPixel" in unit) ):
                unit=unit.replace("MPixel", "GPixel")
                value=((value)/(1000))
            if ( ("MTexel" in unit) ):
                unit=unit.replace("MTexel", "GTexel")
                value=((value)/(1000))
            if ( ("MVertices" in unit) ):
                unit=unit.replace("MVertices", "GVertices")
                value=((value)/(1000))
    except Exception as e:
        print("warn {}".format(e))
        return np.nan
    if ( value_p ):
        return value
    else:
        return unit
def parse_date(row, column=None, value_p=None):
    str=row[column]
    try:
        return pd.to_datetime(str)
    except Exception as e:
        return np.nan
df["tflops16"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP16 (half) performance", value_p=True), axis=1)
df["tflops16_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP16 (half) performance", value_p=False), axis=1)
df["tflops32"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP32 (float) performance", value_p=True), axis=1)
df["tflops32_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP32 (float) performance", value_p=False), axis=1)
df["tflops64"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP64 (double) performance", value_p=True), axis=1)
df["tflops64_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP64 (double) performance", value_p=False), axis=1)
df["pixel_rate"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Pixel Rate", value_p=True), axis=1)
df["pixel_rate_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Pixel Rate", value_p=False), axis=1)
df["tex_rate"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Texture Rate", value_p=True), axis=1)
df["tex_rate_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Texture Rate", value_p=False), axis=1)
df["vertex_rate"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Vertex Rate", value_p=True), axis=1)
df["vertex_rate_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Vertex Rate", value_p=False), axis=1)
df["transistors"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Transistors", value_p=True), axis=1)
df["transistors_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Transistors", value_p=False), axis=1)
df["mem_bandwidth"]=df.apply(lambda row: parse_entry(row, column="Memory Bandwidth", value_p=True), axis=1)
df["mem_bandwidth_unit"]=df.apply(lambda row: parse_entry(row, column="Memory Bandwidth", value_p=False), axis=1)
df["die_size"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Die Size", value_p=True), axis=1)
df["die_size_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Die Size", value_p=False), axis=1)
df["tdp"]=df.apply(lambda row: parse_entry(row, column="Board Design TDP", value_p=True), axis=1)
df["tdp_unit"]=df.apply(lambda row: parse_entry(row, column="Board Design TDP", value_p=False), axis=1)
df["release_date"]=df.apply(lambda row: parse_date(row, column="Graphics Card Release Date", value_p=True), axis=1)
# no unit
df["launch_price"]=df.apply(lambda row: parse_entry(row, column="Graphics Card Launch Price", value_p=True), axis=1)
df["launch_price_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Card Launch Price", value_p=False), axis=1)
df["process_size"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Process Size", value_p=True), axis=1)
df["process_size_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Process Size", value_p=False), axis=1)
url=gen_url(keywords="", categoryId="225", maxPrice="350", minPrice="120", locationStr="Kempen+-+Nordrhein-Westfalen", locationId="1139", radius="4000", extra="&attributeMap[pc_zubehoer_software.art_s]=grafikkarten")
print("get {}".format(url))
r=requests.get(url)
content=r.text.replace("&#8203", "")
soup=BeautifulSoup(content, "html.parser")
articles=soup.find_all("article", {("class"):("aditem")})