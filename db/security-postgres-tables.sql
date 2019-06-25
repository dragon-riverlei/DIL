-- ====================================
-- Table definitions
-- ====================================
create table if not exists securities_code (
  code varchar(6) primary key, -- 证券代码
  name varchar(10) not null, -- 证券名称
  market varchar(10) not null, -- 证券市场名称
  country varchar(5) not null  -- 证券市场所在国家
);

create table if not exists securities_ipo (
  code varchar(6) primary key, -- 证券代码
  found_time date not null, -- 成立日期
  ipo_time date not null, -- 上市日期
  ipo_price numeric(10,4) not null, -- 发行价
  ipo_volume numeric(20,4) not null, -- 发行量
  ipo_cap numeric(20,4) not null, -- 发行市值
  ipo_per numeric(10,4) -- 发行市盈率
);

create table if not exists securities_dividend (
  code varchar(6) not null, -- 证券代码
  time date not null,   -- 财务年度
  预案公告日 date not null,
  股权登记日 date,
  除权除息日 date,
  方案进度 varchar(10) not null,
  送转总比例 numeric(6,2),
  送股比例 numeric(6,2), -- 每10股送股（股）
  转股比例 numeric(6,2), -- 每10股转增（股）
  现金分红 numeric(6,2), -- 每10股现金分红（元）
  股息率 numeric(6,2),
  预案公告日后10日涨幅 numeric(6,2),
  股权登记日前10日涨幅 numeric(6,2),
  除权除息日后30日涨幅 numeric(6,2),
  primary key (code, time)
);

create table if not exists securities_day_quote (
  time date not null, -- 日期
  code varchar(6) not null, -- 证券代码
  price numeric(10,4) not null, -- 价格（元）
  cap numeric(20,4) not null, -- 市值（元）
  per numeric(10,4) not null, -- 市盈率
  pbr numeric(10,4) not null  , -- 市净率
  primary key (code, time)
);

create table if not exists securities_day_price (
  time date not null, -- 日期
  code varchar(6) not null, -- 证券代码
  open_price numeric(10,4) not null, -- 开盘价格（元）
  close_price numeric(10,4) not null, -- 收盘价格（元）
  high_price numeric(10,4) not null, -- 最高价格（元）
  low_price numeric(10,4) not null, -- 最低价格（元）
  primary key (code, time)
);

create table if not exists securities_balance_sheet_bank (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 资产
  现金及存放中央银行款项 numeric(20,2) not null,
  存放同业款项 numeric(20,2) not null,
  拆出资金 numeric(20,2) not null,
  贵金属 numeric(20,2) not null,
  交易性金融资产 numeric(20,2) not null,
  衍生金融工具资产 numeric(20,2) not null,
  买入返售金融资产 numeric(20,2) not null,
  应收利息 numeric(20,2) not null,
  发放贷款及垫款 numeric(20,2) not null,
  代理业务资产 numeric(20,2) not null,
  可供出售金融资产 numeric(20,2) not null,
  持有至到期投资 numeric(20,2) not null,
  长期股权投资 numeric(20,2) not null,
  应收投资款项 numeric(20,2) not null,
  固定资产合计 numeric(20,2) not null,
  无形资产 numeric(20,2) not null,
  商誉 numeric(20,2) not null,
  递延税款借项 numeric(20,2) not null,
  投资性房地产 numeric(20,2) not null,
  其他资产 numeric(20,2) not null,
  资产总计 numeric(20,2) not null,
  -- 负债
  向中央银行借款 numeric(20,2) not null,
  同业存入及拆入 numeric(20,2) not null,
  其中：同业存放款项 numeric(20,2) not null,
  拆入资金 numeric(20,2) not null,
  衍生金融工具负债 numeric(20,2) not null,
  交易性金融负债 numeric(20,2) not null,
  卖出回购金融资产款 numeric(20,2) not null,
  客户存款（吸收存款） numeric(20,2) not null,
  应付职工薪酬 numeric(20,2) not null,
  应交税费 numeric(20,2) not null,
  应付利息 numeric(20,2) not null,
  应付账款 numeric(20,2) not null,
  代理业务负债 numeric(20,2) not null,
  应付债券 numeric(20,2) not null,
  递延所得税负债 numeric(20,2) not null,
  预计负债 numeric(20,2) not null,
  其他负债 numeric(20,2) not null,
  负债合计 numeric(20,2) not null,
  -- 所有者权益
  股本 numeric(20,2) not null,
  其他权益工具 numeric(20,2) not null,
  其中：优先股 numeric(20,2) not null,
  资本公积 numeric(20,2) not null,
  减：库藏股 numeric(20,2) not null,
  其他综合收益 numeric(20,2) not null,
  盈余公积 numeric(20,2) not null,
  未分配利润 numeric(20,2) not null,
  一般风险准备 numeric(20,2) not null,
  外币报表折算差额 numeric(20,2) not null,
  其他储备 numeric(20,2) not null,
  归属于母公司股东的权益 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  股东权益合计 numeric(20,2) not null,
  负债及股东权益总计 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_balance_sheet_general (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 流动资产
  货币资金 numeric(20,2) not null,
  交易性金融资产 numeric(20,2) not null,
  衍生金融资产 numeric(20,2) not null,
  应收票据 numeric(20,2) not null,
  应收账款 numeric(20,2) not null,
  预付款项 numeric(20,2) not null,
  应收利息 numeric(20,2) not null,
  应收股利 numeric(20,2) not null,
  其他应收款 numeric(20,2) not null,
  买入返售金融资产 numeric(20,2) not null,
  存货 numeric(20,2) not null,
  划分为持有待售的资产 numeric(20,2) not null,
  一年内到期的非流动资产 numeric(20,2) not null,
  待摊费用 numeric(20,2) not null,
  待处理流动资产损益 numeric(20,2) not null,
  其他流动资产 numeric(20,2) not null,
  流动资产合计 numeric(20,2) not null,
  -- 非流动资产
  发放贷款及垫款 numeric(20,2) not null,
  可供出售金融资产 numeric(20,2) not null,
  持有至到期投资 numeric(20,2) not null,
  长期应收款 numeric(20,2) not null,
  长期股权投资 numeric(20,2) not null,
  投资性房地产 numeric(20,2) not null,
  固定资产净额 numeric(20,2) not null,
  在建工程 numeric(20,2) not null,
  工程物资 numeric(20,2) not null,
  固定资产清理 numeric(20,2) not null,
  生产性生物资产 numeric(20,2) not null,
  公益性生物资产 numeric(20,2) not null,
  油气资产 numeric(20,2) not null,
  无形资产 numeric(20,2) not null,
  开发支出 numeric(20,2) not null,
  商誉 numeric(20,2) not null,
  长期待摊费用 numeric(20,2) not null,
  递延所得税资产 numeric(20,2) not null,
  其他非流动资产 numeric(20,2) not null,
  非流动资产合计 numeric(20,2) not null,
  资产总计 numeric(20,2) not null,
  -- 流动负债
  短期借款 numeric(20,2) not null,
  交易性金融负债 numeric(20,2) not null,
  应付票据 numeric(20,2) not null,
  应付账款 numeric(20,2) not null,
  预收款项 numeric(20,2) not null,
  应付手续费及佣金 numeric(20,2) not null,
  应付职工薪酬 numeric(20,2) not null,
  应交税费 numeric(20,2) not null,
  应付利息 numeric(20,2) not null,
  应付股利 numeric(20,2) not null,
  其他应付款 numeric(20,2) not null,
  预提费用 numeric(20,2) not null,
  一年内的递延收益 numeric(20,2) not null,
  应付短期债券 numeric(20,2) not null,
  一年内到期的非流动负债 numeric(20,2) not null,
  其他流动负债 numeric(20,2) not null,
  流动负债合计 numeric(20,2) not null,
  -- 非流动负债
  长期借款 numeric(20,2) not null,
  应付债券 numeric(20,2) not null,
  长期应付款 numeric(20,2) not null,
  长期应付职工薪酬 numeric(20,2) not null,
  专项应付款 numeric(20,2) not null,
  预计非流动负债 numeric(20,2) not null,
  递延所得税负债 numeric(20,2) not null,
  长期递延收益 numeric(20,2) not null,
  其他非流动负债 numeric(20,2) not null,
  非流动负债合计 numeric(20,2) not null,
  负债合计 numeric(20,2) not null,
  -- 所有者权益
  实收资本（或股本） numeric(20,2) not null,
  资本公积 numeric(20,2) not null,
  减：库存股 numeric(20,2) not null,
  其他综合收益 numeric(20,2) not null,
  专项储备 numeric(20,2) not null,
  盈余公积 numeric(20,2) not null,
  一般风险准备 numeric(20,2) not null,
  未分配利润 numeric(20,2) not null,
  归属于母公司股东权益合计 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  所有者权益（或股东权益）合计 numeric(20,2) not null,
  负债和所有者权益（或股东权益）总计 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_balance_sheet_securities (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 资产
  货币资金 numeric(20,2) not null,
  其中：客户资金存款 numeric(20,2) not null,
  结算备付金 numeric(20,2) not null,
  其中：客户备付金 numeric(20,2) not null,
  融出资金 numeric(20,2) not null,
  交易性金融资产 numeric(20,2) not null,
  衍生金融资产 numeric(20,2) not null,
  买入返售金融资产 numeric(20,2) not null,
  应收账款 numeric(20,2) not null,
  应收利息 numeric(20,2) not null,
  存出保证金 numeric(20,2) not null,
  可供出售金融资产 numeric(20,2) not null,
  持有至到期投资 numeric(20,2) not null,
  长期股权投资 numeric(20,2) not null,
  固定资产 numeric(20,2) not null,
  无形资产 numeric(20,2) not null,
  其中：交易席位费 numeric(20,2) not null,
  商誉 numeric(20,2) not null,
  递延所得税资产 numeric(20,2) not null,
  投资性房地产 numeric(20,2) not null,
  其他资产 numeric(20,2) not null,
  资产总计 numeric(20,2) not null,
  -- 负债
  短期借款 numeric(20,2) not null,
  其中：质押借款 numeric(20,2) not null,
  应付短期融资款 numeric(20,2) not null,
  拆入资金 numeric(20,2) not null,
  交易性金融负债 numeric(20,2) not null,
  衍生金融负债 numeric(20,2) not null,
  卖出回购金融资产款 numeric(20,2) not null,
  代理买卖证券款 numeric(20,2) not null,
  代理承销证券款 numeric(20,2) not null,
  应付职工薪酬 numeric(20,2) not null,
  应交税费 numeric(20,2) not null,
  应付账款 numeric(20,2) not null,
  应付利息 numeric(20,2) not null,
  长期借款 numeric(20,2) not null,
  应付债券款 numeric(20,2) not null,
  递延所得税负债 numeric(20,2) not null,
  预计负债 numeric(20,2) not null,
  其他负债 numeric(20,2) not null,
  负债合计 numeric(20,2) not null,
  -- 所有者权益
  股本 numeric(20,2) not null,
  其他权益工具 numeric(20,2) not null,
  资本公积金 numeric(20,2) not null,
  减：库存股 numeric(20,2) not null,
  其他综合收益 numeric(20,2) not null,
  盈余公积金金 numeric(20,2) not null,
  未分配利润 numeric(20,2) not null,
  一般风险准备 numeric(20,2) not null,
  交易风险准备 numeric(20,2) not null,
  外币报表折算差额 numeric(20,2) not null,
  归属于母公司所有者权益合计 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  所有者权益合计 numeric(20,2) not null,
  负债及股东权益总计 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_balance_sheet_insurance (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 资产
  货币资金 numeric(20,2) not null,
  拆出资金 numeric(20,2) not null,
  交易性金融资产 numeric(20,2) not null,
  衍生金融资产 numeric(20,2) not null,
  买入返售金融资产 numeric(20,2) not null,
  应收保费 numeric(20,2) not null,
  应收利息 numeric(20,2) not null,
  应收分保账款 numeric(20,2) not null,
  应收分保未到期责任准备金 numeric(20,2) not null,
  应收分保未决赔款准备金 numeric(20,2) not null,
  应收分保寿险责任准备金 numeric(20,2) not null,
  应收分保长期健康险责任准备金 numeric(20,2) not null,
  保户质押贷款 numeric(20,2) not null,
  可供出售金融资产 numeric(20,2) not null,
  持有至到期投资 numeric(20,2) not null,
  长期股权投资 numeric(20,2) not null,
  存出资本保证金 numeric(20,2) not null,
  应收款项类投资 numeric(20,2) not null,
  固定资产 numeric(20,2) not null,
  无形资产 numeric(20,2) not null,
  商誉 numeric(20,2) not null,
  独立账户资产 numeric(20,2) not null,
  递延所得税资产 numeric(20,2) not null,
  投资性房地产 numeric(20,2) not null,
  定期存款 numeric(20,2) not null,
  其他资产 numeric(20,2) not null,
  资产总计 numeric(20,2) not null,
  -- 负债
  短期借款 numeric(20,2) not null,
  拆入资金 numeric(20,2) not null,
  交易性金融负债 numeric(20,2) not null,
  衍生金融负债 numeric(20,2) not null,
  卖出回购金融资产款 numeric(20,2) not null,
  预收账款 numeric(20,2) not null,
  预收保费 numeric(20,2) not null,
  应付手续费及佣金 numeric(20,2) not null,
  应付分保账款 numeric(20,2) not null,
  应付职工薪酬 numeric(20,2) not null,
  应交税费 numeric(20,2) not null,
  应付利息 numeric(20,2) not null,
  应付赔付款 numeric(20,2) not null,
  应付保单红利 numeric(20,2) not null,
  保户储金及投资款 numeric(20,2) not null,
  未到期责任准备金 numeric(20,2) not null,
  未决赔款准备金 numeric(20,2) not null,
  寿险责任准备金 numeric(20,2) not null,
  长期健康险责任准备金 numeric(20,2) not null,
  长期借款 numeric(20,2) not null,
  应付债券 numeric(20,2) not null,
  独立账户负债 numeric(20,2) not null,
  递延所得税负债 numeric(20,2) not null,
  预计负债 numeric(20,2) not null,
  其他负债 numeric(20,2) not null,
  负债合计 numeric(20,2) not null,
  -- 所有者权益
  股本 numeric(20,2) not null,
  资本公积金 numeric(20,2) not null,
  其他综合收益 numeric(20,2) not null,
  盈余公积金金 numeric(20,2) not null,
  未分配利润 numeric(20,2) not null,
  一般风险准备 numeric(20,2) not null,
  外币报表折算差额 numeric(20,2) not null,
  归属于母公司的股东权益合计 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  所有者权益合计 numeric(20,2) not null,
  负债及股东权益总计 numeric(20,2) not null,
  primary key (code, time)
);

-- create table if not exists securities_balance_sheet (
--   time date not null, -- 日期
--   code varchar(6) not null, -- 证券代码
--   current_assets numeric(20,2), -- 流动资产合计
--   total_fixed_assets numeric(20, 4), -- 固定资产合计
--   total_assets numeric(20,2) not null, -- 总资产
--   current_liabilities numeric(20,2), -- 流动负债合计
--   non_current_liabilities numeric(20,2), -- 非流动负债合计
--   total_liabilities numeric(20,2) not null, -- 总负债
--   equity_parent_company numeric(20,2) not null, -- 归属于母公司所有者权益合计
--   total_equity numeric(20,2) not null, -- 股东权益合计
--   primary key (code, time)
-- );

create table if not exists securities_cash_flow_sheet_bank (
  code  varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 一、经营活动产生的现金流量
  客户存款和同业存放款项净增加额 numeric(20,2) not null,
  向央行借款净增加额 numeric(20,2) not null,
  向其他金融机构拆入资金净增加额 numeric(20,2) not null,
  收取利息、手续费及佣金的现金 numeric(20,2) not null,
  收到其他与经营活动有关的现金 numeric(20,2) not null,
  经营活动现金流入小计 numeric(20,2) not null,
  客户贷款及垫款净增加额 numeric(20,2) not null,
  存放中央银行和同业款项净增加额 numeric(20,2) not null,
  支付给职工以及为职工支付的现金 numeric(20,2) not null,
  支付的各项税费 numeric(20,2) not null,
  支付其他与经营活动有关的现金 numeric(20,2) not null,
  支付利息、手续费及佣金的现金 numeric(20,2) not null,
  经营活动现金流出小计 numeric(20,2) not null,
  经营活动产生的现金流量净额 numeric(20,2) not null,
  -- 二、投资活动产生的现金流量
  收回投资收到的现金 numeric(20,2) not null,
  取得投资收益收到的现金 numeric(20,2) not null,
  处置固定资产、无形资产及其他资产而收到的现金 numeric(20,2) not null,
  取得子公司及其他营业单位所收到的现金净额 numeric(20,2) not null,
  收到其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流入小计 numeric(20,2) not null,
  投资支付的现金 numeric(20,2) not null,
  购建固定资产、无形资产和其他长期资产支付的现金 numeric(20,2) not null,
  支付的其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流出小计 numeric(20,2) not null,
  投资活动产生的现金流量净额 numeric(20,2) not null,
  -- 三、筹资活动产生的现金流量
  吸收投资所收到的现金 numeric(20,2) not null,
  发行证券化资产所吸收的现金 numeric(20,2) not null,
  发行债券收到的现金 numeric(20,2) not null,
  增加股本所收到的现金 numeric(20,2) not null,
  收到其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流入小计 numeric(20,2) not null,
  偿还债务所支付的现金 numeric(20,2) not null,
  分配股利、利润或偿付利息支付的现金 numeric(20,2) not null,
  其中：偿付利息所支付的现金 numeric(20,2) not null,
  支付新股发行费用 numeric(20,2) not null,
  支付其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流出小计 numeric(20,2) not null,
  筹资活动产生的现金流量净额 numeric(20,2) not null,
  四、汇率变动对现金及现金等价物的影响 numeric(20,2) not null,
  五、现金及现金等价物净增加额 numeric(20,2) not null,
  加：期初现金及现金等价物余额 numeric(20,2) not null,
  六、期末现金及现金等价物余额 numeric(20,2) not null,
  -- 附注
  净利润 numeric(20,2) not null,
  加：少数股东收益 numeric(20,2) not null,
  计提的资产减值准备 numeric(20,2) not null,
  其中：计提的坏账准备 numeric(20,2) not null,
  计提的贷款损失准备 numeric(20,2) not null,
  冲回存放同业减值准备 numeric(20,2) not null,
  固定资产折旧、油气资产折耗、生产性生物资产折旧 numeric(20,2) not null,
  投资性房地产折旧 numeric(20,2) not null,
  无形资产、递延资产及其他资产的摊销 numeric(20,2) not null,
  其中：无形资产摊销 numeric(20,2) not null,
  长期待摊费用摊销 numeric(20,2) not null,
  长期资产摊销 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期产的损失_（收益） numeric(20,2) not null,
  处置投资性房地产的损失_（收益） numeric(20,2) not null,
  固定资产报废损失 numeric(20,2) not null,
  财务费用 numeric(20,2) not null,
  投资损失（减：收益） numeric(20,2) not null,
  公允价值变动（收益）_损失 numeric(20,2) not null,
  汇兑损益 numeric(20,2) not null,
  衍生金融工具交易净损益 numeric(20,2) not null,
  折现回拔（减值资产利息冲转） numeric(20,2) not null,
  存货的减少 numeric(20,2) not null,
  贷款的减少 numeric(20,2) not null,
  存款的增加 numeric(20,2) not null,
  拆借款项的净增 numeric(20,2) not null,
  金融性资产的减少 numeric(20,2) not null,
  预计负债的增加 numeric(20,2) not null,
  收到已核销款项 numeric(20,2) not null,
  递延所得税资产的减少 numeric(20,2) not null,
  递延所得税负债的增加 numeric(20,2) not null,
  经营性应收项目的增加 numeric(20,2) not null,
  经营性应付项目的增加 numeric(20,2) not null,
  经营性其他资产的减少 numeric(20,2) not null,
  经营性其他负债的增加 numeric(20,2) not null,
  其他 numeric(20,2) not null,
  经营活动现金流量净额 numeric(20,2) not null,
  以固定资产偿还债务 numeric(20,2) not null,
  以投资偿还债务 numeric(20,2) not null,
  以固定资产进行投资 numeric(20,2) not null,
  债务转为资本 numeric(20,2) not null,
  一年内到期的可转换公司债券 numeric(20,2) not null,
  融资租入固定资产 numeric(20,2) not null,
  其他不涉及现金收支的投资和筹资活动金额 numeric(20,2) not null,
  现金的期末余额 numeric(20,2) not null,
  减：现金的期初余额 numeric(20,2) not null,
  现金等价物的期末余额 numeric(20,2) not null,
  减：现金等价物的期初余额 numeric(20,2) not null,
  现金及现金等价物净增加额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_cash_flow_sheet_general (
  code  varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 一、经营活动产生的现金流量
  销售商品、提供劳务收到的现金 numeric(20,2) not null,
  收到的税费返还 numeric(20,2) not null,
  收到的其他与经营活动有关的现金 numeric(20,2) not null,
  经营活动现金流入小计 numeric(20,2) not null,
  购买商品、接受劳务支付的现金 numeric(20,2) not null,
  支付给职工以及为职工支付的现金 numeric(20,2) not null,
  支付的各项税费 numeric(20,2) not null,
  支付的其他与经营活动有关的现金 numeric(20,2) not null,
  经营活动现金流出小计 numeric(20,2) not null,
  经营活动产生的现金流量净额 numeric(20,2) not null,
  -- 二、投资活动产生的现金流量
  收回投资所收到的现金 numeric(20,2) not null,
  取得投资收益所收到的现金 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期资产所收回的现金净额 numeric(20,2) not null,
  处置子公司及其他营业单位收到的现金净额 numeric(20,2) not null,
  收到的其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流入小计 numeric(20,2) not null,
  购建固定资产、无形资产和其他长期资产所支付的现金 numeric(20,2) not null,
  投资所支付的现金 numeric(20,2) not null,
  取得子公司及其他营业单位支付的现金净额 numeric(20,2) not null,
  支付的其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流出小计 numeric(20,2) not null,
  投资活动产生的现金流量净额 numeric(20,2) not null,
  -- 三、筹资活动产生的现金流量
  吸收投资收到的现金 numeric(20,2) not null,
  其中：子公司吸收少数股东投资收到的现金 numeric(20,2) not null,
  取得借款收到的现金 numeric(20,2) not null,
  发行债券收到的现金 numeric(20,2) not null,
  收到其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流入小计 numeric(20,2) not null,
  偿还债务支付的现金 numeric(20,2) not null,
  分配股利、利润或偿付利息所支付的现金 numeric(20,2) not null,
  其中：子公司支付给少数股东的股利、利润 numeric(20,2) not null,
  支付其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流出小计 numeric(20,2) not null,
  筹资活动产生的现金流量净额 numeric(20,2) not null,
  四、汇率变动对现金及现金等价物的影响 numeric(20,2) not null,
  五、现金及现金等价物净增加额 numeric(20,2) not null,
  加：期初现金及现金等价物余额 numeric(20,2) not null,
  六、期末现金及现金等价物余额 numeric(20,2) not null,
  -- 附注
  净利润 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  未确认的投资损失 numeric(20,2) not null,
  资产减值准备 numeric(20,2) not null,
  固定资产折旧、油气资产折耗、生产性物资折旧 numeric(20,2) not null,
  无形资产摊销 numeric(20,2) not null,
  长期待摊费用摊销 numeric(20,2) not null,
  待摊费用的减少 numeric(20,2) not null,
  预提费用的增加 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期资产的损失 numeric(20,2) not null,
  固定资产报废损失 numeric(20,2) not null,
  公允价值变动损失 numeric(20,2) not null,
  递延收益增加（减：减少） numeric(20,2) not null,
  预计负债 numeric(20,2) not null,
  财务费用 numeric(20,2) not null,
  投资损失 numeric(20,2) not null,
  递延所得税资产减少 numeric(20,2) not null,
  递延所得税负债增加 numeric(20,2) not null,
  存货的减少 numeric(20,2) not null,
  经营性应收项目的减少 numeric(20,2) not null,
  经营性应付项目的增加 numeric(20,2) not null,
  已完工尚未结算款的减少（减：增加） numeric(20,2) not null,
  已结算尚未完工款的增加（减：减少） numeric(20,2) not null,
  其他 numeric(20,2) not null,
  经营活动产生现金流量净额 numeric(20,2) not null,
  债务转为资本 numeric(20,2) not null,
  一年内到期的可转换公司债券 numeric(20,2) not null,
  融资租入固定资产 numeric(20,2) not null,
  现金的期末余额 numeric(20,2) not null,
  现金的期初余额 numeric(20,2) not null,
  现金等价物的期末余额 numeric(20,2) not null,
  现金等价物的期初余额 numeric(20,2) not null,
  现金及现金等价物的净增加额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_cash_flow_sheet_securities (
  code  varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 一、经营活动产生的现金流量
  处置交易性金融资产净增加额 numeric(20,2) not null,
  处置可供出售金融资产净增加额 numeric(20,2) not null,
  收取利息、手续费及佣金的现金 numeric(20,2) not null,
  拆入资金净增加额 numeric(20,2) not null,
  回购业务资金净增加额 numeric(20,2) not null,
  收到的其他与经营活动有关的现金 numeric(20,2) not null,
  经营活动现金流入小计 numeric(20,2) not null,
  支付给职工以及为职工支付的现金 numeric(20,2) not null,
  支付的各项税费 numeric(20,2) not null,
  支付其他与经营活动有关的现金 numeric(20,2) not null,
  支付利息、手续费及佣金的现金 numeric(20,2) not null,
  经营活动现金流出小计 numeric(20,2) not null,
  经营活动产生的现金流量净额 numeric(20,2) not null,
  -- 二、投资活动产生的现金流量
  收回投资收到的现金 numeric(20,2) not null,
  取得投资收益收到的现金 numeric(20,2) not null,
  处置固定资产、无形资产及其他长期资产收回的现金净额 numeric(20,2) not null,
  收到其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流入小计 numeric(20,2) not null,
  投资支付的现金 numeric(20,2) not null,
  购建固定资产、无形资产和其他长期资产支付的现金 numeric(20,2) not null,
  支付其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流出小计 numeric(20,2) not null,
  投资活动产生的现金流量净额 numeric(20,2) not null,
  -- 三、筹资活动产生的现金流量
  吸收投资收到的现金 numeric(20,2) not null,
  取得借款收到的现金 numeric(20,2) not null,
  发行债券收到的现金 numeric(20,2) not null,
  收到其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流入小计 numeric(20,2) not null,
  偿还债务支付的现金 numeric(20,2) not null,
  分配股利、利润或偿付利息所支付的现金 numeric(20,2) not null,
  支付其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流出小计 numeric(20,2) not null,
  筹资活动产生的现金流量净额 numeric(20,2) not null,
  四、汇率变动对现金及现金等价物的影响 numeric(20,2) not null,
  五、现金及现金等价物净增加额 numeric(20,2) not null,
  加：期初现金及现金等价物余额 numeric(20,2) not null,
  六、期末现金及现金等价物余额 numeric(20,2) not null,
  -- 附注
  净利润 numeric(20,2) not null,
  加：少数股东损益 numeric(20,2) not null,
  资产减值准备 numeric(20,2) not null,
  风险准备金支出 numeric(20,2) not null,
  固定资产折旧、油气资产折耗、生产性生物资产折旧 numeric(20,2) not null,
  无形资产、递延资产及其他资产摊销 numeric(20,2) not null,
  其中：无形资产摊销 numeric(20,2) not null,
  长期待摊费用摊销 numeric(20,2) not null,
  长期资产摊销 numeric(20,2) not null,
  待摊费用减少（减：增加） numeric(20,2) not null,
  预提费用增加 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期资产的损失 numeric(20,2) not null,
  固定资产报废损失 numeric(20,2) not null,
  金融资产的减少 numeric(20,2) not null,
  各种金融负债的增加 numeric(20,2) not null,
  公允价值变动损失 numeric(20,2) not null,
  财务费用 numeric(20,2) not null,
  投资损失 numeric(20,2) not null,
  汇兑损益_（损失） numeric(20,2) not null,
  递延所得税资产减少 numeric(20,2) not null,
  递延所得税负债增加 numeric(20,2) not null,
  存货的减少 numeric(20,2) not null,
  经营性应收项目的减少 numeric(20,2) not null,
  经营性应付项目的增加 numeric(20,2) not null,
  其他 numeric(20,2) not null,
  经营活动产生的现金流量净额_附表_ numeric(20,2) not null,
  债务转为资本 numeric(20,2) not null,
  融资租入固定资产 numeric(20,2) not null,
  现金的期末余额 numeric(20,2) not null,
  减：现金的期初余额 numeric(20,2) not null,
  加：现金等价物的期末余额 numeric(20,2) not null,
  减：现金等价物的期初余额 numeric(20,2) not null,
  现金及现金等价物净增加额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_cash_flow_sheet_insurance (
  code  varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  -- 一、经营活动产生的现金流量
  收到原保险合同保费取得的现金 numeric(20,2) not null,
  收到再保业务现金净额 numeric(20,2) not null,
  收到其他与经营活动有关的现金 numeric(20,2) not null,
  保户储金净增加额 numeric(20,2) not null,
  经营活动现金流入小计 numeric(20,2) not null,
  支付原保险合同赔付款项的现金 numeric(20,2) not null,
  支付给职工以及为职工支付的现金 numeric(20,2) not null,
  支付手续费的现金 numeric(20,2) not null,
  支付的各项税费 numeric(20,2) not null,
  支付其他与经营活动有关的现金 numeric(20,2) not null,
  支付保单红利的现金 numeric(20,2) not null,
  经营活动现金流出小计 numeric(20,2) not null,
  经营活动产生的现金流量净额 numeric(20,2) not null,
  -- 二、投资活动产生的现金流量
  收回投资收到的现金 numeric(20,2) not null,
  取得投资收益收到的现金 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期资产收回的现金净额 numeric(20,2) not null,
  处置子公司及其他营业单位收到的现金 numeric(20,2) not null,
  收到其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流入小计 numeric(20,2) not null,
  投资支付的现金 numeric(20,2) not null,
  质押贷款净增加额 numeric(20,2) not null,
  购建固定资产、无形资产和其他长期资产支付的现金 numeric(20,2) not null,
  购买子公司及其他营业单位支付的现金净额 numeric(20,2) not null,
  支付其他与投资活动有关的现金 numeric(20,2) not null,
  投资活动现金流出小计 numeric(20,2) not null,
  投资活动产生的现金流量净额 numeric(20,2) not null,
  -- 三、筹资活动产生的现金流量
  吸收投资收到的现金 numeric(20,2) not null,
  取得借款收到的现金 numeric(20,2) not null,
  发行债券收到的现金 numeric(20,2) not null,
  收到其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流入小计 numeric(20,2) not null,
  偿还债务支付的现金 numeric(20,2) not null,
  分配股利、利润或偿付利息所支付的现金 numeric(20,2) not null,
  支付的其他与筹资活动有关的现金 numeric(20,2) not null,
  筹资活动现金流出小计 numeric(20,2) not null,
  筹资活动产生的现金流量净额 numeric(20,2) not null,
  四、汇率变动对现金及现金等价物的影响 numeric(20,2) not null,
  五、现金及现金等价物净增加额 numeric(20,2) not null,
  加：期初现金及现金等价物余额 numeric(20,2) not null,
  六、期末现金及现金等价物余额 numeric(20,2) not null,
  -- 附注
  净利润 numeric(20,2) not null,
  加：计提（转回）资产减值准备 numeric(20,2) not null,
  计提的预计负债 numeric(20,2) not null,
  提取的各项保险责任准备金净额 numeric(20,2) not null,
  提取的未到期的责任准备金 numeric(20,2) not null,
  投资性房地产折旧 numeric(20,2) not null,
  固定资产折旧、油气资产折耗、生产性生物资产折旧 numeric(20,2) not null,
  无形资产、递延资产及其他资产摊销 numeric(20,2) not null,
  其中：无形资产摊销 numeric(20,2) not null,
  长期待摊费用摊销 numeric(20,2) not null,
  长期资产摊销 numeric(20,2) not null,
  预提费用的增加 numeric(20,2) not null,
  处置固定资产、无形资产和其他长期资产的损失（收益） numeric(20,2) not null,
  处置投资性房地产的收益 numeric(20,2) not null,
  投资收益 numeric(20,2) not null,
  公允价值变动损失（收益） numeric(20,2) not null,
  自动垫缴保费收入 numeric(20,2) not null,
  利息收入 numeric(20,2) not null,
  利息支出 numeric(20,2) not null,
  汇兑损失（收益） numeric(20,2) not null,
  保户储金及投资款的增加 numeric(20,2) not null,
  递延所得税费用 numeric(20,2) not null,
  其中：递延所得税资产的减少（增加） numeric(20,2) not null,
  递延所得税负债的减少（增加） numeric(20,2) not null,
  金融资产的减少 numeric(20,2) not null,
  金融负债的增加 numeric(20,2) not null,
  经营性应收项目的减少（增加） numeric(20,2) not null,
  经营性应付项目的增加（减少） numeric(20,2) not null,
  经营活动产生的现金流量净额_附表_ numeric(20,2) not null,
  联营企业以资产抵偿其对本公司的债务 numeric(20,2) not null,
  少数股东以所持子公司股权置换为其对本公司的股权 numeric(20,2) not null,
  现金的期末余额 numeric(20,2) not null,
  减：现金的期初余额 numeric(20,2) not null,
  加：现金等价物的期末余额 numeric(20,2) not null,
  减：现金等价物的期初余额 numeric(20,2) not null,
  现金及现金等价物净增加_（减少）额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_profit_sheet_bank (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  一、营业收入 numeric(20,2) not null,
  利息净收入 numeric(20,2) not null,
  其中：利息收入 numeric(20,2) not null,
  减：利息支出 numeric(20,2) not null,
  手续费及佣金净收入 numeric(20,2) not null,
  其中：手续费及佣金收入 numeric(20,2) not null,
  减：手续费及佣金支出 numeric(20,2) not null,
  汇兑收益 numeric(20,2) not null,
  投资净收益 numeric(20,2) not null,
  其中：对联营公司的投资收益 numeric(20,2) not null,
  公允价值变动净收益 numeric(20,2) not null,
  其他业务收入 numeric(20,2) not null,
  二、营业支出 numeric(20,2) not null,
  营业税金及附加 numeric(20,2) not null,
  业务及管理费用 numeric(20,2) not null,
  资产减值损失 numeric(20,2) not null,
  其他业务支出 numeric(20,2) not null,
  三、营业利润 numeric(20,2) not null,
  加：营业外收入 numeric(20,2) not null,
  减：营业外支出 numeric(20,2) not null,
  四、利润总额 numeric(20,2) not null,
  减：所得税 numeric(20,2) not null,
  五、净利润 numeric(20,2) not null,
  归属于母公司的净利润 numeric(20,2) not null,
  少数股东权益 numeric(20,2) not null,
  -- 六、每股收益
  基本每股收益（元_股） numeric(20,2) not null,
  稀释每股收益（元_股） numeric(20,2) not null,
  七、其他综合收益 numeric(20,2) not null,
  八、综合收益总额 numeric(20,2) not null,
  归属于母公司所有者的综合收益总额 numeric(20,2) not null,
  归属于少数股东的综合收益总额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_profit_sheet_general (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  一、营业总收入 numeric(20,2) not null,
  营业收入 numeric(20,2) not null,
  二、营业总成本 numeric(20,2) not null,
  营业成本 numeric(20,2) not null,
  营业税金及附加 numeric(20,2) not null,
  销售费用 numeric(20,2) not null,
  管理费用 numeric(20,2) not null,
  财务费用 numeric(20,2) not null,
  资产减值损失 numeric(20,2) not null,
  公允价值变动收益 numeric(20,2) not null,
  投资收益 numeric(20,2) not null,
  其中：对联营企业和合营企业的投资收益 numeric(20,2) not null,
  汇兑收益 numeric(20,2) not null,
  三、营业利润 numeric(20,2) not null,
  加：营业外收入 numeric(20,2) not null,
  减：营业外支出 numeric(20,2) not null,
  其中：非流动资产处置损失 numeric(20,2) not null,
  四、利润总额 numeric(20,2) not null,
  减：所得税费用 numeric(20,2) not null,
  五、净利润 numeric(20,2) not null,
  归属于母公司所有者的净利润 numeric(20,2) not null,
  少数股东损益 numeric(20,2) not null,
  -- 六、每股收益
  基本每股收益（元_股） numeric(20,2) not null,
  稀释每股收益（元_股） numeric(20,2) not null,
  七、其他综合收益 numeric(20,2) not null,
  八、综合收益总额 numeric(20,2) not null,
  归属于母公司所有者的综合收益总额 numeric(20,2) not null,
  归属于少数股东的综合收益总额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_profit_sheet_securities (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  一、营业收入 numeric(20,2) not null,
  手续费及佣金净收入 numeric(20,2) not null,
  代理买卖证券业务净收入 numeric(20,2) not null,
  证券承销业务净收入 numeric(20,2) not null,
  受托客户资产管理业务净收入 numeric(20,2) not null,
  利息净收入 numeric(20,2) not null,
  其中：利息收入 numeric(20,2) not null,
  利息支出 numeric(20,2) not null,
  投资收益 numeric(20,2) not null,
  其中：对联营企业和合营企业的投资收益 numeric(20,2) not null,
  公允价值变动损益 numeric(20,2) not null,
  汇兑损益 numeric(20,2) not null,
  其他业务收入 numeric(20,2) not null,
  二、营业支出 numeric(20,2) not null,
  营业税金及附加 numeric(20,2) not null,
  管理费用 numeric(20,2) not null,
  资产减值损失 numeric(20,2) not null,
  其他业务成本 numeric(20,2) not null,
  三、营业利润 numeric(20,2) not null,
  加：营业外收入 numeric(20,2) not null,
  减：营业外支出 numeric(20,2) not null,
  四、利润总额 numeric(20,2) not null,
  减：所得税 numeric(20,2) not null,
  五、净利润 numeric(20,2) not null,
  归属于母公司所有者的净利润 numeric(20,2) not null,
  少数股东损益 numeric(20,2) not null,
  -- 六、每股收益
  基本每股收益（元_股） numeric(20,2) not null,
  稀释每股收益（元_股） numeric(20,2) not null,
  七、其他综合收益 numeric(20,2) not null,
  八、综合收益总额 numeric(20,2) not null,
  归属于母公司所有者的综合收益总额 numeric(20,2) not null,
  归属于少数股东的综合收益总额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_profit_sheet_insurance (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  一、营业收入 numeric(20,2) not null,
  已赚保费 numeric(20,2) not null,
  保费业务收入 numeric(20,2) not null,
  其中：分保费收入 numeric(20,2) not null,
  减：分出保费 numeric(20,2) not null,
  提取未到期责任准备金 numeric(20,2) not null,
  投资净收益 numeric(20,2) not null,
  其中：对联营企业和合营企业的投资损失 numeric(20,2) not null,
  公允价值变动损益 numeric(20,2) not null,
  汇兑损益 numeric(20,2) not null,
  其他业务收入 numeric(20,2) not null,
  二、营业支出 numeric(20,2) not null,
  退保金 numeric(20,2) not null,
  赔付支出 numeric(20,2) not null,
  减：摊回赔付支出 numeric(20,2) not null,
  提取保险责任准备金 numeric(20,2) not null,
  减：摊回保险责任准备金 numeric(20,2) not null,
  保户红利支出 numeric(20,2) not null,
  分保费用 numeric(20,2) not null,
  营业税金及附加 numeric(20,2) not null,
  手续费及佣金支出 numeric(20,2) not null,
  管理费用 numeric(20,2) not null,
  减：摊回分保费用 numeric(20,2) not null,
  其他业务成本 numeric(20,2) not null,
  资产减值损失 numeric(20,2) not null,
  三、营业利润 numeric(20,2) not null,
  加：营业外收入 numeric(20,2) not null,
  减：营业外支出 numeric(20,2) not null,
  四、利润总额 numeric(20,2) not null,
  减：所得税费用 numeric(20,2) not null,
  五、净利润 numeric(20,2) not null,
  归属于母公司股东的净利润 numeric(20,2) not null,
  少数股东损益 numeric(20,2) not null,
  -- 六、每股收益
  基本每股收益（元_股） numeric(20,2) not null,
  稀释每股收益（元_股） numeric(20,2) not null,
  七、其他综合收益 numeric(20,2) not null,
  八、综合收益总额 numeric(20,2) not null,
  归属于母公司所有者的综合收益总额 numeric(20,2) not null,
  归属于少数股东的综合收益总额 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_cash_flow_sheet_running_total (
  code  varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  经营活动产生的现金流量净额 numeric(20,2),
  投资活动产生的现金流量净额 numeric(20,2),
  筹资活动产生的现金流量净额 numeric(20,2),
  现金及现金等价物净增加额 numeric(20,2),
  primary key (code, time)
);

create table if not exists securities_profit_sheet_running_total (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  营业收入 numeric(20,2), -- 一、营业收入
  营业支出 numeric(20,2), -- 二、营业支出
  营业利润 numeric(20,2), -- 三、营业利润
  利润总额 numeric(20,2), -- 四、利润总额
  净利润 numeric(20,2), -- 五、净利润
  归属于母公司股东的净利润 numeric(20,2),
  primary key (code, time)
);

-- create table if not exists securities_cash_flow_sheet (
--   time date not null, -- 日期
--   code varchar(6) not null, -- 证券代码
--   cash_flow_from_operating_activities numeric(20,2), -- 经营活动产生的现金流量净额
--   cash_flow_from_investing_activities numeric(20,2), -- 投资活动产生的现金流量净额
--   cash_flow_from_financing_activities numeric(20,2), -- 筹资活动产生的现金流量净额
--   primary key (code, time)
-- );
-- create table if not exists securities_profit_sheet (
--   time date not null, -- 日期
--   code varchar(6) not null, -- 证券代码
--   revenue numeric(20,2), -- 营业总收入，公司经营所取得的收入总额
--   operating_revenue numeric(20,2), -- 营业收入，公司经营主要业务所取得的收入总额
--   total_expense numeric(20,2), -- 营业总成本
--   operating_expense numeric(20,2), -- 营业成本
--   profit_before_tax numeric(20,2), -- 利润总额，税前利润
--   net_profit numeric(20,2), -- 净利润
--   net_profit_parent_company numeric(20,2), -- 归属于母公司所有者的净利润
--   total_income numeric(20,2), -- 综合收益总额
--   total_income_parent_company numeric(20,2), -- 归属于母公司所有者的综合收益总额
--   primary key (code, time)
-- );

create table if not exists securities_kpi (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 报告期
  -- MFRation28 numeric(10,4), -- 基本每股收益（元）
  -- MFRation18 numeric(10,4), -- 每股净资产（元）
  -- MFRation20 numeric(10,4), -- 每股经营活动产生的现金流量净额（元）
  营业利润vs营业收入 numeric(20,4), -- 营业利润/营业收入
  净利润vs营业收入 numeric(20,4), -- 净利润/营业收入
  净利润vs利润总额 numeric(20,4), -- 净利润/利润总额
  净利润vs股东权益合计 numeric(20,4), -- 五、净资产收益率（全面摊薄）：净利润/股东权益合计，均为期末值
  营业收入同比 numeric(20,4),
  营业利润同比 numeric(20,4),
  净利润同比 numeric(20,4),
  归属于母公司股东的净利润同比 numeric(20,4),
  营业收入环比 numeric(20,4),
  营业利润环比 numeric(20,4),
  净利润环比 numeric(20,4),
  归属于母公司股东的净利润环比 numeric(20,4),
  经营活动产生的现金流量净额同比 numeric(20,4),
  投资活动产生的现金流量净额同比 numeric(20,4),
  筹资活动产生的现金流量净额同比 numeric(20,4),
  现金及现金等价物净增加额同比 numeric(20,4),
  经营活动产生的现金流量净额环比 numeric(20,4),
  投资活动产生的现金流量净额环比 numeric(20,4),
  筹资活动产生的现金流量净额环比 numeric(20,4),
  现金及现金等价物净增加额环比 numeric(20,4),
  primary key (code, time)
);

create table if not exists securities_transaction (
  id SERIAL not null primary key,
  time date not null, -- 成交日期
  code varchar(6), -- 证券代码
  price numeric(10,4), -- 成交价格（元）
  vol numeric(20,2), -- 成交量(股)
  tname varchar(10), -- 业务名称
  amount numeric(20,4), -- 发生金额（元）
  balance numeric(20,4) -- 剩余金额（元）
);

create table if not exists securities_holding (
  id SERIAL not null primary key,
  time date not null, -- 日期
  code varchar(6), -- 证券代码
  price numeric(10,4), -- 价格（元）
  cost numeric(10,4), -- 成本价格（元）
  vol numeric(20,2) -- 存量(股)
);

create table if not exists cash_holding (
  id SERIAL not null primary key,
  time date not null, -- 日期
  amount numeric(20,4) -- 金额（元）
);

create table if not exists securities_stock_structure (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  已上市流通A股 numeric(20,2) not null,
  已流通股份 numeric(20,2) not null,
  变动原因 varchar(30) not null,
  总股本 numeric(20,2) not null,
  流通受限股份 numeric(20,2) not null,
  其他内资持股（受限） numeric(20,2) not null,
  国有法人持股（受限） numeric(20,2) not null,
  境内自然人持股（受限） numeric(20,2) not null,
  国家持股（受限） numeric(20,2) not null,
  国家持股 numeric(20,2) not null,
  境外法人持股（受限） numeric(20,2) not null,
  境内法人持股（受限） numeric(20,2) not null,
  外资持股（受限） numeric(20,2) not null,
  境外上市流通股 numeric(20,2) not null,
  已上市流通B股 numeric(20,2) not null,
  未流通股份 numeric(20,2) not null,
  发起人股份 numeric(20,2) not null,
  境外自然人持股（受限） numeric(20,2) not null,
  自然人持股 numeric(20,2) not null,
  境内法人持股 numeric(20,2) not null,
  募集法人股 numeric(20,2) not null,
  国有法人持股 numeric(20,2) not null,
  其他未流通股 numeric(20,2) not null,
  内部职工股 numeric(20,2) not null,
  其他流通股 numeric(20,2) not null,
  优先股 numeric(20,2) not null,
  primary key (code, time)
);

create table if not exists securities_stock_structure_sina (
  code varchar(6) not null, -- 证券代码
  time date not null, -- 日期
  总股本 numeric(20,2) not null,
  primary key (code, time)
);
