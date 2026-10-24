# 结肠癌临床试验生存分析与统计报表

**R · survival · KM · Cox · RMST**

从1858条终点记录区分929位患者，主要两组分析619人、291例死亡。未调整HR为0.689（95%CI 0.546-0.869）；5年RMST差111.47天，1000次组内bootstrap区间17.37-200.67天。

阅读 [中文图文报告](reports/REPORT.html) / [Markdown报告](reports/REPORT.md)，或从 [手把手重做指南](项目重做指南.md) 开始（[浏览版](项目重做指南.html)）。

## 项目回答什么

这是公开历史试验记录的再分析。没有原始完整试验数据库、AE或依从信息，不声称监管级ITT、ADaM/CDISC合规或当代临床疗效。

本项目面向生物统计/统计编程实习作品集，使用真实公开历史数据，不生成虚构患者、试验或研究成果。方法与代码用于学习、复核和报告，不是医疗建议。

## 独立复现

```powershell
git clone https://github.com/SRTURK/clinical-survival-analysis.git
Set-Location clinical-survival-analysis
Rscript run.R
Rscript tests/test.R
```

在RStudio中将工作目录设为仓库根目录。Windows若Rscript不在PATH，用`& 'C:\Program Files\R\R-4.6.0\bin\Rscript.exe' run.R`。依赖R标准推荐包，无需联网下载病历。若安装R时未包含推荐包，先补装survival或MASS。

```powershell
Rscript run.R --out=learning/output --pause
Rscript learning/guide_examples.R
```

第一条分四阶段暂停，第二条按指南逐段重做。分别输出`learning/output`与`learning/my_output`；正式分析写`reports`。不需要其他作品集仓库，也不需要Python来运行分析。

## 交付结构

| 文件 | 用途 |
|---|---|
| [ANALYSIS_PLAN.md](ANALYSIS_PLAN.md) | 固定分析集、终点/效应量、模型与敏感性；非前瞻预注册 |
| [docs/DATA.md](docs/DATA.md) | 来源、字段、单位、编码、许可与局限 |
| config.R | 分析参数与固定种子 |
| R/01至04模块 | 数据、主分析、诊断/敏感性、图文报告 |
| reports/*.csv | 结果表、输入MD5、检查记录、版本 |
| tests/test.R | 手算例子、方向/单位不变性或独立复算 |
| learning/guide_examples.R | 指南所有R代码块的连续可执行版 |

## 验证

实际运行通过 **18项质量断言、7组测试**。参考环境、版本和输出见[环境说明](ENVIRONMENT.md)。数据快照MD5不同即停止，避免默默使用变化的数据；升级后应重新复核。MD5只用于变更检测，不是来源真实性保证。

## 数据与许可

代码为MIT许可，第三方R包与数据仍遵循原许可与引用，详见[数据说明](docs/DATA.md)。`data/raw`由安装包导出且不入Git；仓库保留衍生分析表用于核对。
