# -*- coding: utf-8 -*-

import json

import re

import subprocess

import scrapy

from crawl.mysettings import DIL_ROOT


class StockFdmtCashflowSheetChinaInitialSpider(scrapy.Spider):
    name = "StockFdmtCashflowSheetChinaInitialSpider"
    allowed_domains = ["money.finance.sina.com.cn"]
    cash_flow_sheet_url_tpl = "http://money.finance.sina.com.cn/corp/go.php/vDOWN_CashFlow/displaytype/4/stockid/{}/ctrl/all.phtml"
    code_rexp = re.compile(
        r"http://money.finance.sina.com.cn/corp/go.php/vDOWN_CashFlow/displaytype/4/stockid/([0-9]{6})/ctrl/all.phtml"
    )
    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockFdmtCashflowSheetChinaInitialPipeline': 300
        }
    }

    def start_requests(self):
        self.logger.info(
            "Start to scrape stock fundamental initial cash flow sheet...")
        cmd = subprocess.Popen(
            args=[
                DIL_ROOT + '/sh/find_regular_report_not_scraped.sh', 'i', 'cfs'
            ],
            stdout=subprocess.PIPE)
        out, err = cmd.communicate()
        missings = out.split('\n')
        for missing in missings:
            if len(missing) > 0:
                url = self.cash_flow_sheet_url_tpl.format(missing)
                yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        match = self.code_rexp.match(response.request.url)
        assert match is not None, response.request.url + " does not match " + str(
            self.code_rexp)
        yield {
            "code": match.group(1),
            "cash_flow_sheet": response.body.decode('GBK').encode('UTF-8')
        }
