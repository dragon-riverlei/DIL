# -*- coding: utf-8 -*-

# Example:
# scrapy crawl StockFdmtCashflowSheetChinaDeltaSpider -a year=2017

import json

import re

import subprocess

import scrapy

from crawl.mysettings import DIL_ROOT


class StockFdmtCashflowSheetChinaDeltaSpider(scrapy.Spider):
    name = "StockFdmtCashflowSheetChinaDeltaSpider"
    allowed_domains = ["money.finance.sina.com.cn"]
    cash_flow_sheet_url_tpl = "http://money.finance.sina.com.cn/corp/go.php/vFD_CashFlow/stockid/{}/ctrl/{}/displaytype/4.phtml"
    code_rexp = re.compile(
        r"http://money.finance.sina.com.cn/corp/go.php/vFD_CashFlow/stockid/([0-9]{6})/ctrl/([0-9]{4})/displaytype/4.phtml"
    )

    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockFdmtCashflowSheetChinaDeltaPipeline': 300
        }
    }

    def start_requests(self):
        assert self.year is not None, "Cash flow sheet year not given."
        self.year = self.year
        self.logger.info(
            "Start to scrape stock fundamental delta cash flow sheet for year "
            + self.year)
        cmd = subprocess.Popen(
            args=[
                DIL_ROOT + '/sh/find_regular_report_not_scraped.sh', 'd',
                'cfs', self.year
            ],
            stdout=subprocess.PIPE)
        out, err = cmd.communicate()
        missings = out.split('\n')
        for missing in missings:
            if len(missing) > 0:
                url = self.cash_flow_sheet_url_tpl.format(missing, self.year)
                yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        match = self.code_rexp.match(response.request.url)
        assert match is not None, response.request.url + " does not match " + str(
            self.code_rexp)
        body_str = response.body.decode('GBK').encode('UTF-8')
        body_str = body_str.replace("经营活动产生的现金流量净额<附表>",
                                    "经营活动产生的现金流量净额&lt;附表&gt;")
        body_str = body_str.decode('UTF-8').encode('GBK')
        response = response.replace(body=body_str)
        rows = response.xpath('//*[@id="ProfitStatementNewTable0"]/tbody/tr')
        dates = rows[0].xpath('td/text()').extract()
        cash_flow_sheet = [{"date": date} for date in dates]

        for row in rows[1:]:
            key = row.xpath('(td/a|td/strong/a)/text()').extract()
            if (len(key) == 0):
                continue
            data = row.xpath('td/text()').extract()
            assert len(dates) == len(
                data), "Date column number and data column number not match."
            for count, line in enumerate(data):
                cash_flow_sheet[count][key[0]] = data[count]

        yield {
            "code": match.group(1),
            "time": self.year,
            "cash_flow_sheet": cash_flow_sheet
        }
