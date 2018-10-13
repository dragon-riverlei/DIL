# -*- coding: utf-8 -*-
#
# 上海，深圳证券代码

import demjson

import scrapy


class StockCodeListChinaSpider(scrapy.Spider):
    name = "StockCodeListChinaSpider"
    allowed_domains = ["stock.gtimg.cn"]
    url_tpl = "http://stock.gtimg.cn/data/index.php?appn=rank&t=ranka/chr&p={}&o=0&l=40&v=list_data"

    custom_settings = {
        'ITEM_PIPELINES': {
            'crawl.pipelines.StockCodeListChinaPipeline': 400
        }
    }

    def start_requests(self):
        self.logger.info("Start to scrape stock code list china...")
        yield scrapy.Request(url=self.url_tpl.format(1), callback=self.parse)

    def parse(self, response):
        result = demjson.decode(response.body[14:-1])
        pages = result['total']
        page = result['p']
        yield result
        if int(page) < int(pages):
            link = self.url_tpl.format(int(page) + 1)
            yield scrapy.Request(link)
