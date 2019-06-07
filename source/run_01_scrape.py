import sys
import pandas as pd
import pathlib
import html
import json
import logging
from bs3 import BeautifulSoup


def gen_url(keywords=None, categoryId=None, locationStr=None, locationId=None, radius=None, sortingField="SORTING_DATE", adType=None, posterType=None, pageNum=1, action="find", maxPrice=None, minPrice=None):
    return "https://www.ebay-kleinanzeigen.de/s-suchanfrage.html?&keywords={}&categoryId={}&locationStr={}&locationId={}&radius={}&sortingField={}&adType={}&posterType={}&pageNum={}&action={}&maxPrice={}&minPrice={}".format(keywords, categoryId, locationStr, locationId, radius, sortingField, adType, posterType, pageNum, action, maxPrice, minPrice)
