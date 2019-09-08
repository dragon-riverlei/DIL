# -*- coding: utf-8 -*-
#
# 总股本
# http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_StockStructureHistory/stockid/{}/stocktype/TotalStock.phtml

# Example:
# scrapy crawl StockStructureTotalShareChinaSpider
# scrapy crawl StockStructureTotalShareChinaSpider -a codes=000001,000002

from datetime import date

import json

import re

import subprocess

import time

import scrapy

from crawl.mysettings import DIL_ROOT


class StockStructureTotalShareChinaSpider(scrapy.Spider):
    codes = None
    name = "StockStructureTotalShareChinaSpider"
    allowed_domains = ["vip.stock.finance.sina.com.cn"]
    url_tpl = "http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_StockStructureHistory/stockid/{}/stocktype/TotalStock.phtml"
    code_rexp = re.compile(
        r"http://vip.stock.finance.sina.com.cn/corp/go.php/vCI_StockStructureHistory/stockid/([0-9]{6})/stocktype/TotalStock.phtml"
    )
    date_share_rexp = re.compile(r"^([0-9.]+)([^0-9.]{2})")
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockStructureTotalShareChinaPipeline': 400
        }
    }

    def start_requests(self):
        self.logger.info(
            "Start to scrape stock structure total share china...")
        if self.codes is None:
            cmd = subprocess.Popen(
                args=[DIL_ROOT + '/sh/find_stock_list_china.sh'],
                stdout=subprocess.PIPE)
            out, err = cmd.communicate()
            missings = out.decode().split('\n')
            for missing in missings:
                if len(missing) > 0:
                    url = self.url_tpl.format(missing)
                    yield scrapy.Request(url=url, callback=self.parse)
        else:
            self.logger.info("Code list: " + self.codes)
            for code in self.codes.split(","):
                if len(code) > 0:
                    url = self.url_tpl.format(code)
                    yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        match = self.code_rexp.match(response.request.url)
        assert match is not None, response.request.url + " does not match " + str(
            self.code_rexp)
        share_histories = response.xpath(
            '//table[@id="StockStructureHistoryTable"]//table[contains(@id,"historyTable")]/tr/td/div/text()'
        ).extract()
        assert len(
            share_histories) % 2 == 0, "no equal number of dates and shares."
        results = [
            ",".join((match.group(1), sh[0],
                      self.date_share_rexp.match(sh[1]).group(1),
                      self.date_share_rexp.match(sh[1]).group(2)))
            for sh in zip(share_histories[0::2], share_histories[1::2])
        ]

        yield {"results": results}
