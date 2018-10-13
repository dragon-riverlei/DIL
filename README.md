
# Table of Contents

1.  [DIL](#orgc6c3487)
    1.  [Directory layout](#orgb56127b)
        1.  [crawl](#orgcdd32cf)
        2.  [db](#org419d2e2)
        3.  [feeds](#org434799a)
        4.  [sh](#org079fb8a)
        5.  [tmp](#org60343ac)
    2.  [Data](#org3ed7e7d)
        1.  [Storage](#org90b1a43)
        2.  [A stock in Shanghai and Shenzhen](#orgc9d23e0)


<a id="orgc6c3487"></a>

# DIL

DIL stands for Data Intelligence Log.


<a id="orgb56127b"></a>

## Directory layout


<a id="orgcdd32cf"></a>

### crawl

The scrapy project


<a id="org419d2e2"></a>

### db

The SQL scripts


<a id="org434799a"></a>

### feeds

The downloaded data


<a id="org079fb8a"></a>

### sh

The bash scripts


<a id="org60343ac"></a>

### tmp

The temporary directory to place some intermediary files


<a id="org3ed7e7d"></a>

## Data


<a id="org90b1a43"></a>

### Storage

data retrieved by scrapy crawler is stored as files under **feeds**
data parsed from the above files are stored in a *postgres* database named **securities**, /usr/local/var/postgres


<a id="orgc9d23e0"></a>

### A stock in Shanghai and Shenzhen

1.  normalization of units

    CMB:  元
    股本: 万股 

2.  inception

    1.  stock code list: retrieve all available stock codes, json files from stock.gtimg.cn
    
    2.  stock list: retrieve all available stocks based on the above code list, json files from qt.gtimg.cn

3.  initial

    1.  stock day quote: retrieve day quote of all available stocks, json files from qt.gtimg.cn
    
        cap, 市值, 元
    
    2.  balance sheet: with all available reporting date, csv file from sina
    
        元
    
    3.  cash flow sheet: with all available reporting date, csv file from sina
    
        元
    
    4.  profit sheet: with all available reporting date, csv file from sina
    
        元
    
    5.  dividend: since 2011-6-30, json file from eastmoney
    
        元
    
    6.  stock structure: json file from eastmoney
    
        万股

4.  delta

    1.  stock code list: yearly at least, json files from stock.gtimg.cn
    
    2.  stock list: yearly at least, json files from qt.gtimg.cn
    
    3.  stock day quote: weekly at least, json files from qt.gtimg.cn
    
        cap, 市值, 万元
    
    4.  balance sheet: quarterly aligned with the reporting date, parsed html
    
        万元
    
    5.  cash flow sheet: quarterly aligned with the reporting date, parsed html
    
        万元
    
    6.  profit sheet: quarterly aligned with the reporting date, parsed html
    
        万元
    
    7.  dividend: 2 times per year, json file from eastmoney
    
        元
    
    8.  stock structure: 2 times per year, json file from eastmoney
    
        万股

5.  Workflow

    The data workflow is `staged`.
    `Stage 0`: stock code list and stock list
    `Stage 1`: scrape, clean, validate
    `Stage 2`: write to DB
    `stage 3`: more rigorous validation of data at DB side
    `Stage 4`: analyze from DB
    The latter stage depends and only depends on the final output of the former stage.
    
    1.  Stage 0: stock code list and stock list
    
        1.  1st: scrape stock code list. It will be used by the other spiders to decide what stock to crawl.
        
            1.  [StockCodeListChinaSpider](crawl/crawl/spiders/securities/china/StockCodeListChinaSpider.py)
            
                This spider writes stock codes to [feeds/stock<sub>code</sub><sub>list</sub><sub>china.jl</sub>](feeds/stock_code_list_china.jl).
                The source of this spider is supposed to exclude stock codes that exited market.
            
            2.  [StockListChinaSpider](crawl/crawl/spiders/securities/china/StockListChinaSpider.py)
            
                This spider scrape more profile info based on the above stock codes, such as name, market, country.
                And it writes to [feeds/stock<sub>list</sub><sub>china.jl</sub>](feeds/stock_list_china.jl).
    
    2.  Stage 1: scrape, clean, validate
    
        1.  1nd: scrape initial regular reports (balance, cash flow and profit)
        
            The following 3 spiders scrape initial regular reports of balance, cash flow and profit for the list of stock codes determined
            by the output of [find<sub>regular</sub><sub>report</sub><sub>not</sub><sub>scraped.sh</sub>](sh/find_regular_report_not_scraped.sh). This bash script calls [find<sub>stock</sub><sub>list</sub><sub>china</sub><sub>with</sub><sub>absence</sub><sub>regular</sub><sub>report.sh</sub>](sh/find_stock_list_china_with_absence_regular_report.sh)
            to find out list of codes that don't have initial regular reports for the given time (a sign of market exit)
            and exclude these codes from being scraped.
            
            [StockFdmtBalanceSheetChinaInitialSpider](crawl/crawl/spiders/securities/china/StockFdmtBalanceSheetChinaInitialSpider.py)
            [StockFdmtCashflowSheetChinaInitialSpider](crawl/crawl/spiders/securities/china/StockFdmtCashflowSheetChinaInitialSpider.py) 
            [StockFdmtProfitSheetChinaInitialSpider](crawl/crawl/spiders/securities/china/StockFdmtProfitSheetChinaInitialSpider.py)
            
            After the execution of 3 spiders scraping initial sheets and before proceeding further,
            [find<sub>regular</sub><sub>report</sub><sub>not</sub><sub>scraped.sh</sub>](sh/find_regular_report_not_scraped.sh) should be called to ensure there is no valid code missing initial sheets, and
            [clean<sub>regular</sub><sub>report</sub><sub>exit</sub><sub>market.sh</sub>](sh/clean_regular_report_exit_market.sh) is better to be called to clean codes that are known to have exited market.
        
        2.  2rd: process initial regular reports (balance, cash flow and profit)
        
            1.  [classify<sub>regular</sub><sub>report.sh</sub>](sh/classify_regular_report.sh)
            
                This bash script compares the list of fields in the initial regular reports and groups the code with the same list.
                In the mean time, a schema of fields list for each group is also generated.
                This is the basis for further group specific processing.
        
        3.  3th: scrape delta regular reports (balance, cash flow and profit)
        
            The following 3 spiders scrape delta regular reports of balance, cash flow and profit for the list of stock codes determined
            by the output of [find<sub>regular</sub><sub>report</sub><sub>not</sub><sub>scraped.sh</sub>](sh/find_regular_report_not_scraped.sh). 
            
            [StockFdmtBalanceSheetChinaDeltaSpider](crawl/crawl/spiders/securities/china/StockFdmtBalanceSheetChinaDeltaSpider.py)
            [StockFdmtCashflowSheetChinaDeltaSpider](crawl/crawl/spiders/securities/china/StockFdmtCashflowSheetChinaDeltaSpider.py)
            [StockFdmtProfitSheetChinaDeltaSpider](crawl/crawl/spiders/securities/china/StockFdmtProfitSheetChinaDeltaSpider.py)
            
            After the execution of 3 spiders scraping delta sheets and before proceeding further,
            [find<sub>regular</sub><sub>report</sub><sub>not</sub><sub>scraped.sh</sub>](sh/find_regular_report_not_scraped.sh) should be called to ensure there is no valid code missing delta sheets.
        
        4.  4th: process delta regular reports (balance, cash flow and profit)
        
            1.  [check<sub>regular</sub><sub>report</sub><sub>delta</sub><sub>fields.sh</sub>](sh/check_regular_report_delta_fields.sh)
            
                Report if there is any difference of list of fields between the initial and delta regular report.
            
            2.  [check<sub>regular</sub><sub>report</sub><sub>delta</sub><sub>values.sh</sub>](sh/check_regular_report_delta_values.sh)
            
                Return an enumeration of values of all the fields that appear in the regular report.
                For the value that is numeric, a "yes" is returned.
                For the value that is NOT numeric, it is returned literally.
                Thus, we can have a summary of all the possible values in the regular report.
                And this knowledge can be used to verify the logic when extracting data from the regular reports.
        
        5.  5th: scrape other regular reports (dividend, stock structure&#x2026;)
        
            The following spiders scrape delta regular reports other than balance, cash flow and profit for the list of stock codes determined
            by the output of [find<sub>regular</sub><sub>report</sub><sub>not</sub><sub>scraped.sh</sub>](sh/find_regular_report_not_scraped.sh). 
            
            [StockStructureChinaSpider](crawl/crawl/spiders/securities/china/StockStructureChinaSpider.py) for stock structure,
            [StockDividendChinaSpider](crawl/crawl/spiders/securities/china/StockDividendChinaSpider.py) for dividend.
            
            [check<sub>regular</sub><sub>stock</sub><sub>structure</sub><sub>values.sh</sub>](sh/check_regular_stock_structure_values.sh) for sanity check of values of stock structure.
    
    3.  Stage 2: write to DB
    
        1.  1st: table definition for the regular reports
        
            1.  tables whose fields are defined manually
            
                securities<sub>code</sub>
                securities<sub>dividend</sub>
                securities<sub>day</sub><sub>quote</sub>
                securities<sub>kpi</sub>
                securities<sub>transaction</sub>
                securities<sub>holding</sub>
                cash<sub>holding</sub>
            
            2.  tables whose fields are defined programmatic-ally
            
                securities<sub>balance</sub><sub>sheet</sub><sub>bank</sub>
                securities<sub>balance</sub><sub>sheet</sub><sub>general</sub>
                securities<sub>balance</sub><sub>sheet</sub><sub>securities</sub>
                securities<sub>balance</sub><sub>sheet</sub><sub>insurance</sub>
                securities<sub>cash</sub><sub>flow</sub><sub>sheet</sub><sub>bank</sub>
                securities<sub>cash</sub><sub>flow</sub><sub>sheet</sub><sub>general</sub>
                securities<sub>cash</sub><sub>flow</sub><sub>sheet</sub><sub>securities</sub>
                securities<sub>cash</sub><sub>flow</sub><sub>sheet</sub><sub>insurance</sub>
                securities<sub>profit</sub><sub>sheet</sub><sub>bank</sub>
                securities<sub>profit</sub><sub>sheet</sub><sub>general</sub>
                securities<sub>profit</sub><sub>sheet</sub><sub>securities</sub>
                securities<sub>profit</sub><sub>sheet</sub><sub>insurance</sub>
                securities<sub>stock</sub><sub>structure</sub>
                
                [print<sub>regular</sub><sub>report</sub><sub>fields.sh</sub>](sh/print_regular_report_fields.sh) is used to generate the fields for all balance, cash flow and profit tables.
                [print<sub>stock</sub><sub>structure</sub><sub>sql</sub><sub>fields.sh</sub>](sh/print_stock_structure_sql_fields.sh) is used to generate the fields for table `securities_stock_structure`.
        
        2.  2nd: prepare data for writing to DB
        
            The data to be loaded into DB should be of CSV formatted.
            
            1.  prepare initial/delta regular reports data (balance, cash flow and profit)
            
                [prepare<sub>regular</sub><sub>report</sub><sub>csv</sub><sub>values.sh</sub>](sh/prepare_regular_report_csv_values.sh) is used to:
                for initial regular report in csv format, transpose the row and column.
                for delta regular report in json format, convert from json format to csv format.
            
            2.  prepare other regular reports data
            
                [load<sub>json</sub><sub>values</sub><sub>to</sub><sub>db.sh</sub>](sh/load_json_values_to_db.sh)
                  [convert<sub>regular</sub><sub>dividend</sub><sub>json</sub><sub>to</sub><sub>csv.jq</sub>](sh/convert_regular_dividend_json_to_csv.jq)
                  [convert<sub>regular</sub><sub>stock</sub><sub>structure</sub><sub>json</sub><sub>to</sub><sub>csv.sh</sub>](sh/convert_regular_stock_structure_json_to_csv.sh) 
        
        3.  3rd: write to DB
        
            The following scripts are used to load CSV formatted data into DB.
            [load<sub>regular</sub><sub>report</sub><sub>csv</sub><sub>values</sub><sub>to</sub><sub>db.sh</sub>](sh/load_regular_report_csv_values_to_db.sh)
            [load<sub>json</sub><sub>values</sub><sub>to</sub><sub>db.sh</sub>](sh/load_json_values_to_db.sh)
            
            [load<sub>values</sub><sub>to</sub><sub>db.sh</sub>](sh/load_values_to_db.sh) and
            [load<sub>delta</sub><sub>values</sub><sub>to</sub><sub>db.sh</sub>](sh/load_delta_values_to_db.sh) are the facades of preparing / loading data into DB.
    
    4.  Stage 3: more rigorous validation of data at DB side
    
        consistency of units
    
    5.  Stage 4: analyze from DB

