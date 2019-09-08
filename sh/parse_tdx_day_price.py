#!env python

from datetime import datetime
import sys
from struct import *


def extract(fileName):
    code = fileName[-10:-4]
    price_file = open(fileName, 'rb')
    buf = price_file.read()
    price_file.close()
    num = len(buf)
    no = num / 32
    b = 0
    e = 32
    for i in range(int(no)):
        price = unpack('IIIIIfII', buf[b:e])
        year = int(price[0] / 10000)
        m = int((price[0] % 10000) / 100)
        month = str(m)
        if m < 10:
            month = "0" + month
        d = (price[0] % 10000) % 100
        day = str(d)
        if d < 10:
            day = "0" + str(d)
        dd = str(year) + "-" + month + "-" + day
        if dd < min_date or dd > max_date:
            continue
        openPrice = price[1] / 100.0
        high = price[2] / 100.0
        low = price[3] / 100.0
        close = price[4] / 100.0
        item = ",".join(
            [dd, code,
             str(openPrice),
             str(close),
             str(high),
             str(low)])
        print(item)
        b = b + 32
        e = e + 32


min_date = datetime.strptime(sys.argv[1], '%Y-%m-%d').strftime("%Y-%m-%d")
max_date = datetime.strptime(sys.argv[2], '%Y-%m-%d').strftime("%Y-%m-%d")
for arg in sys.argv[3:]:
    extract(arg)
