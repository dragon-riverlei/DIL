# -*- coding: utf-8 -*-
# Extra settings for crawl project besides settings.

import os
DIL_ROOT = os.environ['DIL_ROOT']
assert os.path.exists(
    DIL_ROOT), "DIL_ROOT set to '" + DIL_ROOT + "', but it does not exists."

# Item exporter settings
# yapf: disable
ITEM_EXPORTER_PATH = {
    "StockCodeListChina": DIL_ROOT + "/feeds/",
    "StockIpoInfoChina": DIL_ROOT + "/feeds/",
    "StockListChinaExcel": DIL_ROOT + "/feeds/",
    "StockListChina": DIL_ROOT + "/feeds/",
    "StockDayQuoteChina": DIL_ROOT + "/feeds/",
    "StockFdmtBalanceSheetChinaInitial": DIL_ROOT + "/feeds/fdmt_balance_sheet_initial/data/",
    "StockFdmtBalanceSheetChinaDelta": DIL_ROOT + "/feeds/fdmt_balance_sheet_delta/data/",
    "StockFdmtCashflowSheetChinaInitial": DIL_ROOT + "/feeds/fdmt_cash_flow_sheet_initial/data/",
    "StockFdmtCashflowSheetChinaDelta": DIL_ROOT + "/feeds/fdmt_cash_flow_sheet_delta/data/",
    "StockFdmtProfitSheetChinaInitial": DIL_ROOT + "/feeds/fdmt_profit_sheet_initial/data/",
    "StockFdmtProfitSheetChinaDelta": DIL_ROOT + "/feeds/fdmt_profit_sheet_delta/data/",
    "StockDividendChina": DIL_ROOT + "/feeds/fdmt_dividend/data/",
    "StockStructureChina": DIL_ROOT + "/feeds/stock_structure/data/",
    "StockStructureTotalShareChina": DIL_ROOT + "/feeds/stock_structure/data/"
}
# yapf: ensable

# yapf: disable
FILE_STOCK_CODE_LIST_CHINA = "stock_code_list_china.jl"
FILE_STOCK_IPO_INFO_CHINA = "stock_ipo_info_china.jl"
FILE_STOCK_LIST_CHINA = "stock_list_china.jl"
FILE_STOCK_DAY_QUOTE_CHINA = "stock_day_quote_china.jl"
FILE_STOCK_DIVIDEND_CHINA = "stock_dividend_china"
FILE_STOCK_STRUDTURE_TOTO_SHARE_CHINA = "stock_structure_total_share_china.jl"
# yapf: ensable
