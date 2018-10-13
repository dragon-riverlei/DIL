# -*- coding: utf-8 -*-

# 证券分红
# http://data.eastmoney.com/DataCenter_V3/yjfp/getlist.ashx?js=var%20%s&pagesize=50&page=%s&sr=-1&sortType=SZZBL&mtk=%C8%AB%B2%BF%B9%C9%C6%B1&filter=(ReportingPeriod=^%s^)&rt=%s
#
# Example:
# scrapy crawl StockDividendChinaSpider -a years=201506,201512

import json

import re

import scrapy

from crawl.mysettings import ITEM_EXPORTER_PATH

from crawl.utils import EastMoney as em


class StockDividendChinaSpider(scrapy.Spider):
    name = "StockDividendChinaSpider"
    allowed_domains = ["data.eastmoney.com"]
    dividend_url_tpl = "http://data.eastmoney.com/DataCenter_V3/yjfp/getlist.ashx?js=var%20{}&pagesize=50&page={}&sr=-1&sortType=SZZBL&mtk=%C8%AB%B2%BF%B9%C9%C6%B1&filter=(ReportingPeriod=^{}^)&rt={}"
    dividend_url_rexp = re.compile(
        r".*var%20([a-zA-Z]{8}).*&page=([0-9]+)&sr=-1.*ReportingPeriod=%5E([0-9]{4}-[0-9]{2}-[0-9]{2})%5E.*&rt=([0-9]+)$"
    )
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockDividendChinaPipeline': 300
        }
    }

    def start_requests(self):
        assert self.years is not None, "Dividend years not given."
        self.logger.info("scrape stock dividend for years: " + self.years)
        for year in self.years.split(","):
            date = year[:4] + "-06-30" if year[
                4:] == "06" else year[:4] + "-12-31"
            url = self.dividend_url_tpl.format(
                em.randomString(8), 1, date, em.currentTime())
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        match = self.dividend_url_rexp.match(response.request.url)
        assert match is not None, response.request.url + " does not match " + str(
            self.dividend_url_rexp)
        result = json.loads(response.body[13:].decode("GBK").encode("UTF-8"))
        pages = result['pages']
        page = match.group(2)
        data = result['data']
        yield {"time": match.group(3), "dividend": data}

        if int(page) < int(pages):
            reporting_period = match.group(3)
            link = self.dividend_url_tpl.format(
                em.randomString(8),
                int(page) + 1, reporting_period, em.currentTime())
            yield scrapy.Request(link)
