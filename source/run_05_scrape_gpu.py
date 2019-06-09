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
def gen_url(keywords="", categoryId="225", locationStr="", locationId="", radius="", sortingField="SORTING_DATE", adType="", posterType="", pageNum="1", action="find", maxPrice="", minPrice=""):
    return "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?&keywords={}&categoryId={}&locationStr={}&locationId={}&radius={}&sortingField={}&adType={}&posterType={}&pageNum={}&action={}&maxPrice={}&minPrice={}".format(urllib.parse.quote(keywords), urllib.parse.quote(categoryId), urllib.parse.quote(locationStr), urllib.parse.quote(locationId), urllib.parse.quote(radius), urllib.parse.quote(sortingField), urllib.parse.quote(adType), urllib.parse.quote(posterType), urllib.parse.quote(pageNum), urllib.parse.quote(action), urllib.parse.quote(maxPrice), urllib.parse.quote(minPrice))
df=pd.read_csv("techpowerup_gpu-specs_details.csv")
print("Theoretical Performance FP16 (half) performance: {}".format(df["Theoretical Performance FP16 (half) performance"].iloc[1203]))
print("Theoretical Performance FP32 (float) performance: {}".format(df["Theoretical Performance FP32 (float) performance"].iloc[1203]))
print("Theoretical Performance FP64 (double) performance: {}".format(df["Theoretical Performance FP64 (double) performance"].iloc[1203]))
print("Theoretical Performance Pixel Rate: {}".format(df["Theoretical Performance Pixel Rate"].iloc[1203]))
print("Theoretical Performance Texture Rate: {}".format(df["Theoretical Performance Texture Rate"].iloc[1203]))
print("Graphics Processor Transistors: {}".format(df["Graphics Processor Transistors"].iloc[1203]))
print("Memory Bandwidth: {}".format(df["Memory Bandwidth"].iloc[1203]))
print("Graphics Processor Die Size: {}".format(df["Graphics Processor Die Size"].iloc[1203]))
print("Board Design TDP: {}".format(df["Board Design TDP"].iloc[1203]))
print("Graphics Card Release Date: {}".format(df["Graphics Card Release Date"].iloc[1203]))
print("Graphics Card Launch Price: {}".format(df["Graphics Card Launch Price"].iloc[1203]))
print("Graphics Processor Process Size: {}".format(df["Graphics Processor Process Size"].iloc[1203]))