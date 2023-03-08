import requests
from bs4 import BeautifulSoup
import pandas as pd
import json

#002910
FIND_FUND_URL_PREFIX = "http://fund.eastmoney.com/"
FUND_URL_PREFIX = "http://fundf10.eastmoney.com/ccmx_"

def get_amount(fund_code):
    amount = 0
    if len(fund_code)==6:
        FIND_FUND_URL = FIND_FUND_URL_PREFIX + fund_code + ".html"
        res = requests.get(FIND_FUND_URL)
        res.encoding = "utf8"
        html = res.text
        soup = BeautifulSoup(html, 'lxml')
        #print(soup.prettify())

        li = soup.find(id='position_shares')
        for tr in li.table.contents:
            try:
                increase = tr.span.string[0:-1]
                td = tr.contents
                position = td[3].string[0:-1]
                amount += float(increase) * float(position)
            except Exception:
                continue
        ratio = float(li.p.select('.sum-num')[0].string[0:-1])
        amount = amount * ratio / 100
    else:
        amount = 0

    return amount


if __name__ == '__main__':
    fund_code = input("please input fund code:")
    ratio = round(get_amount(fund_code)/100, 4)
    print(f'{ratio}%')
    #print(str(get_amount(fund_code)) + "%")
