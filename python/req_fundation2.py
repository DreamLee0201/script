import requests
from bs4 import BeautifulSoup
import pandas as pd
import json

#002910
STOCK_URL_PREFIX = "https://push2.eastmoney.com/api/qt/ulist.np/get?fields=f3,f12,f14&secids=1."
FUND_URL_PREFIX = "http://fund.eastmoney.com/"
#FUND_URL_PREFIX = "http://fundf10.eastmoney.com/ccmx_"

def get_stock_info(stock_code):
    FIND_STOCK_URL = STOCK_URL_PREFIX + str(stock_code)
    res = requests.get(FIND_STOCK_URL).text
    format_res = json.loads(res)
    increase = format_res.get('data').get('diff')[0].get('f3')
    return increase / 100

def get_amount(fund_code):
    amount = 0
    if len(fund_code)==6:
        FIND_FUND_URL = FUND_URL_PREFIX + fund_code + ".html"
        res = requests.get(FIND_FUND_URL)
        res.encoding = "utf8"
        html = res.text
        soup = BeautifulSoup(html, 'lxml')
        #print(soup.prettify())

        li = soup.find(id='position_shares')
        for tr in li.table.contents:
            try:
                td = tr.contents
                stock_code = td[1].a.attrs["href"][-6:]
                increase = get_stock_info(stock_code)
                position = td[3].string[0:-1]
                stock = td[1].a.attrs['title']
                print(stock + "【涨跌幅:" + f'{increase}' + ",持仓比例:" + f'{position}】')
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
    print("综合预测结果[" + fund_code + "]涨跌幅: " + f'{ratio}%')
    #get_stock_info(601699)
