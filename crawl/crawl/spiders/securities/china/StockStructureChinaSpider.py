# -*- coding: utf-8 -*-
#
# 股权结构
# http://emweb.securities.eastmoney.com/PC_HSF10/CapitalStockStructure/CapitalStockStructureAjax?code={}

# Example:
# scrapy crawl StockStructureChinaSpider
# scrapy crawl StockStructureChinaSpider -a codes=000001,000002

from datetime import date

import json

import re

import subprocess

import time

import scrapy

from crawl.mysettings import DIL_ROOT


class StockStructureChinaSpider(scrapy.Spider):
    name = "StockStructureChinaSpider"
    allowed_domains = ["emweb.securities.eastmoney.com"]
    url_tpl = "http://emweb.securities.eastmoney.com/PC_HSF10/CapitalStockStructure/CapitalStockStructureAjax?code={}"
    code_rexp = re.compile(
        r"http://emweb.securities.eastmoney.com/PC_HSF10/CapitalStockStructure/CapitalStockStructureAjax\?code=s[hz]([0-9]{6})"
    )
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockStructureChinaPipeline': 400
        }
    }

    def start_requests(self):
        self.logger.info("Start to scrape stock structure china...")
        if self.codes == "":
            cmd = subprocess.Popen(
                args=[
                    DIL_ROOT +
                    '/sh/find_regular_report_not_scraped_stock_structure.sh'
                ],
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
        yield {"code": match.group(1), "result": response.body}
