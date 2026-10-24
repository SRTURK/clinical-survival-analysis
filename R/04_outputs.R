open_png('km_overall_survival.png')
layout(matrix(c(1,2),2,1),heights=c(4,1.1));par(mar=c(4.2,5,3,2))
plot(km,col=c('#68798A','#176B87'),lwd=2,xscale=365.25,xlim=c(0,config$tau),
     xlab='Years since trial entry',ylab='Overall survival probability',conf.int=TRUE,mark.time=TRUE)
legend('bottomleft',legend=config$primary_arms,col=c('#68798A','#176B87'),lwd=2,bty='n')
title('Historical colon trial: overall survival')
par(mar=c(1,5,1,2));plot.new();plot.window(xlim=c(0,config$tau),ylim=c(.5,2.6))
for(i in 1:2){text(-90,3-i,config$primary_arms[i],adj=1,cex=.75,xpd=TRUE);rows<-km_table[km_table$arm==paste0('rx=',config$primary_arms[i]),];text(rows$day,3-i,rows$at_risk,cex=.85)}
text(config$tau/2,2.5,'Number at risk (0, 1, 3, 5 years)',cex=.85);dev.off()
open_png('ph_diagnostic.png');plot(ph);abline(h=coef(unadjusted),lty=2,col='#176B87');title('Scaled Schoenfeld residuals: primary treatment');dev.off()
summary_table <- cox_table
write_report('结肠癌历史试验：生存分析与统计报表',
 '公开历史数据复核项目，非新开展的临床试验。比较原分配Lev+5FU与观察组；总体生存为主终点。数据、口径、代码和结果可追溯。',
 list(
 list(title='1. 分析集和质量控制',text=sprintf('1858条记录对应929位患者，每人复发/死亡各一条。先筛选etype=2，再保留两组，共619人。Lev单药组不进入主要对比。数据包存在%d例nodes与node4不一致，单列核查且不擅自更正。主分析不因基线缺失排除患者。',nrow(node_disagreement)),table=flow),
 list(title='2. 基线描述',text='连续变量均值(SD)，分类百分比分母为本治疗组全部受试者，缺失单列；不对随机化基线做显著性筛选。',table=read.csv(file.path(out,'table1_baseline.csv'),check.names=FALSE)),
 list(title='3. Kaplan-Meier与风险集',text='删失表示观察结束时未见死亡，不能编码为终生存活。依赖独立删失假设；这里没有脱落原因和详细治疗依从资料。5年截断图不等于丢弃更长期数据。',table=km_table,image='km_overall_survival.png'),
 list(title='4. 治疗对比与敏感性',text=sprintf('主分析log-rank p=%.5g。Cox HR为瞬时风险之比，不是5年死亡风险之比。调整模型加入年龄、性别、nodes与分期，因缺失排除%d人，仅作敏感性。主模型PH全局p=%.4f；结合残差图解释，未拒绝PH不等于证明PH成立。',logrank_p,nrow(analysis)-nrow(cc),ph$table['GLOBAL','p']),table=summary_table,image='ph_diagnostic.png'),
 list(title='5. 限制平均生存时间',text=sprintf('预设tau=5年，计算KM曲线下面积；按治疗组内重抽患者%d次得到百分位95%%区间。RMST差以天计，可在PH不理想时提供另一种描述；与HR是不同目标量，不按显著性择优报告。',config$bootstrap),table=rmst_table),
 list(title='6. 研究边界',text='这是对公开分析记录的回顾性再分析，无法重新确认全体原始随机化名单、治疗中断和追踪细节，不能声称完整监管级ITT或安全性评价。无AE信息，不生成虚构安全性表。公开历史方案不支持当代临床用药决策。该项目不宣称CDISC/ADaM合规。数据来源及字段见docs/DATA.md；冻结方案见ANALYSIS_PLAN.md。')
 ))
