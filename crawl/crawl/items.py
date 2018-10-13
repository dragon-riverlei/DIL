# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class SecurityIdItem(scrapy.Item):
    """
    The composite id to uniquely identify a security.
    """
    code = scrapy.Field()
    name = scrapy.Field()
    market = scrapy.Field()
    country = scrapy.Field()


class StockDayQuoteItem(scrapy.Item):
    """
    The data that changes daily.
    """
    date = scrapy.Field()
    code = scrapy.Field()
    price = scrapy.Field()
    cap = scrapy.Field()  # 单位：元
    pe_ratio = scrapy.Field()
    pb_ratio = scrapy.Field()


class StockFdmtKpiItem(scrapy.Item):
    """
    The fundamental KPIs of a stock.
    They change on quarterly.
    """

    date = scrapy.Field()
    code = scrapy.Field()

    # 资产负债表

    current_assets = scrapy.Field()
    """流动资产合计"""

    total_fixed_assets = scrapy.Field()
    """固定资产合计"""

    total_assets = scrapy.Field()
    """总资产"""

    current_liabilities = scrapy.Field()
    """流动负债合计"""

    non_current_liabilities = scrapy.Field()
    """非流动负债合计"""

    total_liabilities = scrapy.Field()
    """总负债"""

    equity_parent_company = scrapy.Field()
    """归属于母公司所有者权益合计"""

    total_equity = scrapy.Field()
    """
    股东权益合计。
    所有者权益合计是指企业投资人对企业净资产的所有权。
    企业净资产等于企业全部资产减去全部负债后的余额，
    其中包括企业投资人对企业的最初投入以及资本公积金、
    盈余公积金和未分配利润。
    对股份制企业，所有者权益即为股东权益
    """

    # 利润表

    revenue = scrapy.Field()
    """营业总收入，公司经营所取得的收入总额"""

    operating_revenue = scrapy.Field()
    """营业收入，公司经营主要业务所取得的收入总额"""

    total_expense = scrapy.Field()
    """营业总成本"""

    operating_expense = scrapy.Field()
    """营业成本"""

    profit_before_tax = scrapy.Field()
    """利润总额，税前利润"""

    net_profit = scrapy.Field()
    """净利润"""

    net_profit_parent_company = scrapy.Field()
    """归属于母公司所有者的净利润"""

    total_income = scrapy.Field()
    """综合收益总额"""

    total_income_parent_company = scrapy.Field()
    """归属于母公司所有者的综合收益总额"""

    # 现金流量表

    cash_flow_from_operating_activities = scrapy.Field()
    """经营活动产生的现金流量净额"""

    cash_flow_from_investing_activities = scrapy.Field()
    """
    投资活动产生的现金流量净额。
    指企业长期资产的购建和对外投资活动（不包括现金等价物范围的投资）的现金流入和流出量。
    包括：
        收回投资、取得投资收益、处置长期资产等活动收到的现金；
        购建固定资产、在建工程、无形资产等长期资产和对外投资等到活动所支付的现金等。
    """

    cash_flow_from_financing_activities = scrapy.Field()
    """
    筹资活动产生的现金流量净额。
    指企业接受投资和借入资金导致的现金流入和流出量。
    包括：
        接受投资、借入款项、发行债券等到活动收到的现金；
        偿还借款、偿还债券、支付利息、分配股利等活动支付的现金等。
    """
