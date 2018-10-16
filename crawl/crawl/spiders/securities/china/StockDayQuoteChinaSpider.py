# -*- coding: utf-8 -*-
#
# 上海证券当日行情
# http://qt.gtimg.cn/q=sh${code},
#
# 深圳证券当日行情
# http://qt.gtimg.cn/q=sz${code},

from datetime import date

import json

import time

import scrapy

from crawl.items import StockDayQuoteItem

from crawl.mysettings import ITEM_EXPORTER_PATH, FILE_STOCK_CODE_LIST_CHINA


class StockDayQuoteChinaSpider(scrapy.Spider):
    name = "StockDayQuoteChinaSpider"
    allowed_domains = ["qt.gtimg.cn"]
    url_tpl = "http://qt.gtimg.cn/q="
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockDayQuoteChinaPipeline': 400
        }
    }

    def start_requests(self):
        self.logger.info("Start to scrape stock day quote china...")
        stock_code_list_file = open(ITEM_EXPORTER_PATH["StockCodeListChina"] +
                                    FILE_STOCK_CODE_LIST_CHINA)
        url = ""
        for count, line in enumerate(stock_code_list_file, 1):
            stock = json.loads(line)
            if count % 20 == 1:
                url = self.url_tpl + stock['code']
            else:
                url = url + "," + stock['code']
            if count % 20 == 0:  # query 20 stock day quotes per request.
                yield scrapy.Request(url=url, callback=self.parse)
                url = ""
        if url != "":
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        for line in response.body.split("\n"):
            quote = line.split("~")
            if len(quote) > 46:
                item = StockDayQuoteItem()
                item['code'] = quote[2]
                item['price'] = float(quote[3])
                item['pe_ratio'] = quote[39]
                item['pb_ratio'] = quote[46]
                item['cap'] = float(quote[45])
                item['date'] = time.strftime("%Y-%m-%d", time.localtime())
                yield item
