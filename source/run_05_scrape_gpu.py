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
def gen_url(keywords="", categoryId="225", locationStr="", locationId="", radius="", sortingField="SORTING_DATE", adType="", posterType="", pageNum="1", action="find", maxPrice="", minPrice=""):
    return "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?&keywords={}&categoryId={}&locationStr={}&locationId={}&radius={}&sortingField={}&adType={}&posterType={}&pageNum={}&action={}&maxPrice={}&minPrice={}".format(urllib.parse.quote(keywords), urllib.parse.quote(categoryId), urllib.parse.quote(locationStr), urllib.parse.quote(locationId), urllib.parse.quote(radius), urllib.parse.quote(sortingField), urllib.parse.quote(adType), urllib.parse.quote(posterType), urllib.parse.quote(pageNum), urllib.parse.quote(action), urllib.parse.quote(maxPrice), urllib.parse.quote(minPrice))
df=pd.read_csv("techpowerup_gpu-specs_details.csv")
def parse_entry(row, column=None, value_p=None):
    entry=row[column]
    if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
        value=np.nan
        unit=""
    else:
        entry_stripped=entry.strip()
        entry_parts=entry_stripped.split(" ")
        value=float(entry_parts[0].replace(",", ""))
        unit=" ".join(entry_parts[1:])
        if ( ("GFLOPS" in unit) ):
            unit=unit.replace("GFLOPS", "TFLOPS")
            value=(((1.0000000474974513e-3))*(value))
    if ( value_p ):
        return value
    else:
        return unit
print("flops16:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Theoretical Performance FP16 (half) performance", value_p=True), parse_entry(df.iloc[1503], column="Theoretical Performance FP16 (half) performance", value_p=False)))
print("flops32:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Theoretical Performance FP32 (float) performance", value_p=True), parse_entry(df.iloc[1503], column="Theoretical Performance FP32 (float) performance", value_p=False)))
print("flops64:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Theoretical Performance FP64 (double) performance", value_p=True), parse_entry(df.iloc[1503], column="Theoretical Performance FP64 (double) performance", value_p=False)))
print("pixel_rate:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Theoretical Performance Pixel Rate", value_p=True), parse_entry(df.iloc[1503], column="Theoretical Performance Pixel Rate", value_p=False)))
print("tex_rate:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Theoretical Performance Texture Rate", value_p=True), parse_entry(df.iloc[1503], column="Theoretical Performance Texture Rate", value_p=False)))
print("transistors:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Graphics Processor Transistors", value_p=True), parse_entry(df.iloc[1503], column="Graphics Processor Transistors", value_p=False)))
print("mem_bandwidth:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Memory Bandwidth", value_p=True), parse_entry(df.iloc[1503], column="Memory Bandwidth", value_p=False)))
print("die_size:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Graphics Processor Die Size", value_p=True), parse_entry(df.iloc[1503], column="Graphics Processor Die Size", value_p=False)))
print("tdp:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Board Design TDP", value_p=True), parse_entry(df.iloc[1503], column="Board Design TDP", value_p=False)))
print("launch_price:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Graphics Card Launch Price", value_p=True), parse_entry(df.iloc[1503], column="Graphics Card Launch Price", value_p=False)))
print("process_size:  : value={} unit={}".format(parse_entry(df.iloc[1503], column="Graphics Processor Process Size", value_p=True), parse_entry(df.iloc[1503], column="Graphics Processor Process Size", value_p=False)))