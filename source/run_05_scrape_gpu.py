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
entry=df["Theoretical Performance FP16 (half) performance"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Theoretical Performance FP16 (half) performance: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Theoretical Performance FP32 (float) performance"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Theoretical Performance FP32 (float) performance: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Theoretical Performance FP64 (double) performance"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Theoretical Performance FP64 (double) performance: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Theoretical Performance Pixel Rate"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Theoretical Performance Pixel Rate: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Theoretical Performance Texture Rate"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Theoretical Performance Texture Rate: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Graphics Processor Transistors"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Graphics Processor Transistors: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Memory Bandwidth"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Memory Bandwidth: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Graphics Processor Die Size"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Graphics Processor Die Size: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Board Design TDP"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Board Design TDP: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Graphics Card Launch Price"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Graphics Card Launch Price: '{}' : value={} unit={}".format(entry, value, unit))
entry=df["Graphics Processor Process Size"].iloc[1403]
if ( ((pd.isnull(entry)) or (((entry)==("unknown")))) ):
    value=np.nan
    unit=""
else:
    entry_stripped=entry.strip()
    entry_parts=entry_stripped.split(" ")
    value=float(entry_parts[0].replace(",", ""))
    unit=" ".join(entry_parts[1:])
print("Graphics Processor Process Size: '{}' : value={} unit={}".format(entry, value, unit))