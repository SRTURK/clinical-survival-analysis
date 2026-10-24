# 数据来源与字段

来源：R `survival` 3.8-6 的 `colon`，1858条终点记录、929位患者。原始文件由本机安装包导出到忽略目录`data/raw/colon.csv`，MD5对照`data/expected_md5.csv`。升级包后若校验失败，先核对来源，不直接改哈希。MD5在此用于意外变化检测，不是对来源真实性的证明。

[维护者数据文档](https://stat.ethz.ch/R-manual/R-devel/library/survival/html/colon.html)；[survival官方源码与引用](https://github.com/therneau/survival)。数据说明引用Laurie 1989、Moertel 1990/1991等原始报告；本项目未重新核验每份病例或重建原始试验数据库。

| 字段 | 含义 | 本项目处理 |
|---|---|---|
| id / etype | 患者标识 / 1复发、2死亡记录 | 联合键；OS只取etype=2 |
| rx | Obs、Lev、Lev+5FU | 主要对比Obs与Lev+5FU，明确参照组 |
| time / status | 事件或删失天数 / 0删失、1事件 | 配合所选终点解释；不把0当终生存活 |
| age / sex | 年龄 / 1男、0女 | 基线描述与敏感性调整 |
| nodes / node4 | 阳性淋巴结数量 / 是否超过4个 | 原文明确存在不一致，不擅自覆盖 |
| extent | 局部侵犯程度1-4 | 分类变量，不假设等距 |
| differ | 肿瘤分化程度1-3 | 保留及缺失审计；未进入预设调整式 |
| obstruct / perfor / adhere | 梗阻、穿孔、邻近粘连 | 保留原字段，不按结局挑选协变量 |
| surg | 手术至登记间隔类别 | 基线表；不冒充精确天数 |
| study | 数据集研究标识 | 数据包中均为1 |

包许可为LGPL(>=2)，本项目代码MIT不改变第三方数据/包权利。仓库不复制原始包文件；衍生分析表来自公开教学数据，不含自采或非公开医疗数据。临床结论只能描述这个历史数据集，不能用于个体治疗推荐。
