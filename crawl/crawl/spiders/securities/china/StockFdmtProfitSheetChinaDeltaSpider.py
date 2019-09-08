# -*- coding: utf-8 -*-

# Example:
# scrapy crawl StockFdmtProfitSheetChinaDeltaSpider -a year=2017 -a month=<3|6|9|12>
# scrapy crawl StockFdmtProfitSheetChinaDeltaSpider -a year=2017 -a month=<3|6|9|12> -a codes=601318,601336

import json

import re

import subprocess

import scrapy

from crawl.mysettings import DIL_ROOT


class StockFdmtProfitSheetChinaDeltaSpider(scrapy.Spider):
    year = None
    month = None
    codes = None
    name = "StockFdmtProfitSheetChinaDeltaSpider"
    allowed_domains = ["money.finance.sina.com.cn"]
    profit_sheet_url_tpl = "http://money.finance.sina.com.cn/corp/go.php/vFD_ProfitStatement/stockid/{}/ctrl/{}/displaytype/4.phtml"
    code_rexp = re.compile(
        r"http://money.finance.sina.com.cn/corp/go.php/vFD_ProfitStatement/stockid/([0-9]{6})/ctrl/([0-9]{4})/displaytype/4.phtml"
    )

    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockFdmtProfitSheetChinaDeltaPipeline': 300
        }
    }

    def start_requests(self):
        assert self.year is not None, "Profit sheet year not given."
        assert self.year is not None, "Profit sheet month not given."
        if self.codes is not None:
            missings = self.codes.split(',')
        else:
            cmd = subprocess.Popen(
                args=[
                    DIL_ROOT + '/sh/find_regular_report_not_scraped_delta.sh',
                    'ps', self.year, self.month
                ],
                stdout=subprocess.PIPE)
            out, err = cmd.communicate()
            missings = out.decode().split('\n')

        self.logger.info(
            "Start to scrape stock fundamental delta profit sheet for year " +
            self.year + " on codes: " + ",".join(missings))

        for missing in missings:
            if len(missing) > 0:
                url = self.profit_sheet_url_tpl.format(missing, self.year)
                yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):
        match = self.code_rexp.match(response.request.url)
        assert match is not None, response.request.url + " does not match " + str(
            self.code_rexp)
        rows = response.xpath('//*[@id="ProfitStatementNewTable0"]/tbody/tr')
        dates = rows[0].xpath('td/text()').extract()
        profit_sheet = [{"date": date} for date in dates]

        for row in rows[1:]:
            key = row.xpath('td/a/text()').extract()
            if (len(key) == 0):
                continue
            data = row.xpath('td/text()').extract()
            assert len(dates) == len(
                data), "Date column number and data column number not match."
            for count, line in enumerate(data):
                profit_sheet[count][key[0]] = data[count]

        yield {
            "code": match.group(1),
            "time": self.year,
            "profit_sheet": profit_sheet
        }
