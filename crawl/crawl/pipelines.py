# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

from scrapy.exporters import JsonLinesItemExporter

from xlrd import open_workbook

from crawl.mysettings import ITEM_EXPORTER_PATH, FILE_STOCK_CODE_LIST_CHINA, FILE_STOCK_LIST_CHINA, FILE_STOCK_DAY_QUOTE_CHINA, FILE_STOCK_DIVIDEND_CHINA


class CrawlPipeline(object):
    def __init__(self):
        self.exporters = {}

    def open_spider(self, spider):
        self.exporters = {}

    def close_spider(self, spider):
        for exporter in self.exporters.values():
            exporter.finish_exporting()
            exporter.file.close()

    @staticmethod
    def get_exporter_file(path_key, name, prefix='', suffix='', ext=''):
        assert path_key is not None, "path_key cannot be None."
        assert name is not None, "name cannot be None."
        path = ITEM_EXPORTER_PATH[path_key]
        assert path is not None, "path cannot be None."
        if prefix != '':
            name = prefix + "_" + name
        if suffix != '':
            name = name + "_" + suffix
        if ext != '':
            name = name + "." + ext
        return path + name

    def get_exporter(self, path_key, name, prefix='', suffix='', ext=''):
        path = self.get_exporter_file(path_key, name, prefix, suffix, ext)
        if path not in self.exporters:
            self.exporters[path] = JsonLinesItemExporter(
                open(path, "wb"), encoding="utf-8")
        return self.exporters[path]

    def process_item(self, item, spider):
        return item


class StockCodeListChinaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(self.__class__.__name__[:-8],
                                     FILE_STOCK_CODE_LIST_CHINA)
        for code in item['data'].split(","):
            exporter.export_item({"code": code})
        return item


class StockListChinaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(self.__class__.__name__[:-8],
                                     FILE_STOCK_LIST_CHINA)
        exporter.export_item(item)
        return item


class StockDayQuoteChinaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(self.__class__.__name__[:-8],
                                     FILE_STOCK_DAY_QUOTE_CHINA)
        exporter.export_item(item)
        return item


class StockFdmtBalanceSheetChinaInitialPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        path = ITEM_EXPORTER_PATH[self.__class__.__name__[:-8]]
        balance_sheet_file = open(path + item['code'] + ".csv", "wb")
        balance_sheet_file.write(item['balance_sheet'])
        balance_sheet_file.close()
        return item


class StockFdmtBalanceSheetChinaDeltaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(
            self.__class__.__name__[:-8],
            item['code'],
            suffix=item['time'],
            ext="jl")
        for balance_sheet in item['balance_sheet']:
            exporter.export_item(balance_sheet)
        exporter.finish_exporting()
        exporter.file.close()
        return item


class StockFdmtCashflowSheetChinaInitialPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        path = ITEM_EXPORTER_PATH[self.__class__.__name__[:-8]]
        cash_flow_sheet_file = open(path + item['code'] + ".csv", "wb")
        cash_flow_sheet_file.write(item['cash_flow_sheet'])
        cash_flow_sheet_file.close()
        return item


class StockFdmtCashflowSheetChinaDeltaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(
            self.__class__.__name__[:-8],
            item['code'],
            suffix=item['time'],
            ext="jl")
        for cash_flow_sheet in item['cash_flow_sheet']:
            exporter.export_item(cash_flow_sheet)
        exporter.finish_exporting()
        exporter.file.close()
        return item


class StockFdmtProfitSheetChinaInitialPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        path = ITEM_EXPORTER_PATH[self.__class__.__name__[:-8]]
        profit_sheet_file = open(path + item['code'] + ".csv", "wb")
        profit_sheet_file.write(item['profit_sheet'])
        profit_sheet_file.close()
        return item


class StockFdmtProfitSheetChinaDeltaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(
            self.__class__.__name__[:-8],
            item['code'],
            suffix=item['time'],
            ext="jl")
        for profit_sheet in item['profit_sheet']:
            exporter.export_item(profit_sheet)
        exporter.finish_exporting()
        exporter.file.close()
        return item


class StockDividendChinaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        exporter = self.get_exporter(
            self.__class__.__name__[:-8],
            FILE_STOCK_DIVIDEND_CHINA,
            suffix=item['time'],
            ext="jl")
        dividend = item['dividend']
        for div in dividend:
            exporter.export_item(div)


class StockStructureChinaPipeline(CrawlPipeline):
    def process_item(self, item, spider):
        path = ITEM_EXPORTER_PATH[self.__class__.__name__[:-8]]
        stock_structure_file = open(path + item['code'] + ".jl", "wb")
        stock_structure_file.write(item['result'])
        stock_structure_file.close()
        return item
