# -*- coding: utf-8 -*-

from datetime import date

import json

import time

import scrapy

from crawl.items import SecurityIdItem

from crawl.mysettings import ITEM_EXPORTER_PATH, FILE_STOCK_CODE_LIST_CHINA


class StockIpoInfoChinaSpider(scrapy.Spider):
    name = "StockIpoInfoChinaSpider"
    allowed_domains = ["vip.stock.finance.sina.com.cn"]
    url_tpl = "http://emweb.securities.eastmoney.com/PC_HSF10/CompanySurvey/CompanySurveyAjax?code={}"
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockIpoInfoChinaPipeline': 400
        }
    }

    def start_requests(self):
        self.logger.info("Start to scrape stock ipo info china...")
        stock_code_list_file = open(ITEM_EXPORTER_PATH["StockCodeListChina"] +
                                    FILE_STOCK_CODE_LIST_CHINA)
        for line in stock_code_list_file:
            stock = json.loads(line)
            url = self.url_tpl.format(stock['code'])
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        body = json.loads(response.body)

        yield {
            "code": body["Result"]["jbzl"]["agdm"],
            "found_time": body["Result"]["fxxg"]["clrq"],
            "ipo_time": body["Result"]["fxxg"]["ssrq"],
            "ipo_price": body["Result"]["fxxg"]["mgfxj"],
            "ipo_volume": body["Result"]["fxxg"]["fxl"],
            "ipo_cap": body["Result"]["fxxg"]["fxzsz"],
            "ipo_per": body["Result"]["fxxg"]["fxsyl"]
        }
