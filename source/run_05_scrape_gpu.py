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
        value_string=entry_parts[0].replace(",", "")
        value=((((((value_string)==("System"))) and ((-1.e+0)))) or (float(value_string)))
        unit=" ".join(entry_parts[1:])
        if ( ("GFLOPS" in unit) ):
            unit=unit.replace("GFLOPS", "TFLOPS")
            value=(((1.0000000474974513e-3))*(value))
    if ( value_p ):
        return value
    else:
        return unit
df["flops16"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP16 (half) performance", value_p=True), axis=1)
df["flops16_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP16 (half) performance", value_p=False), axis=1)
df["flops32"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP32 (float) performance", value_p=True), axis=1)
df["flops32_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP32 (float) performance", value_p=False), axis=1)
df["flops64"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP64 (double) performance", value_p=True), axis=1)
df["flops64_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance FP64 (double) performance", value_p=False), axis=1)
df["pixel_rate"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Pixel Rate", value_p=True), axis=1)
df["pixel_rate_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Pixel Rate", value_p=False), axis=1)
df["tex_rate"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Texture Rate", value_p=True), axis=1)
df["tex_rate_unit"]=df.apply(lambda row: parse_entry(row, column="Theoretical Performance Texture Rate", value_p=False), axis=1)
df["transistors"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Transistors", value_p=True), axis=1)
df["transistors_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Transistors", value_p=False), axis=1)
df["mem_bandwidth"]=df.apply(lambda row: parse_entry(row, column="Memory Bandwidth", value_p=True), axis=1)
df["mem_bandwidth_unit"]=df.apply(lambda row: parse_entry(row, column="Memory Bandwidth", value_p=False), axis=1)
df["die_size"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Die Size", value_p=True), axis=1)
df["die_size_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Die Size", value_p=False), axis=1)
df["tdp"]=df.apply(lambda row: parse_entry(row, column="Board Design TDP", value_p=True), axis=1)
df["tdp_unit"]=df.apply(lambda row: parse_entry(row, column="Board Design TDP", value_p=False), axis=1)
df["launch_price"]=df.apply(lambda row: parse_entry(row, column="Graphics Card Launch Price", value_p=True), axis=1)
df["launch_price_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Card Launch Price", value_p=False), axis=1)
df["process_size"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Process Size", value_p=True), axis=1)
df["process_size_unit"]=df.apply(lambda row: parse_entry(row, column="Graphics Processor Process Size", value_p=False), axis=1)