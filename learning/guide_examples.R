# Extracted from the tutorial; run from repository root.
if (.Platform$OS.type == 'windows') invisible(Sys.setlocale('LC_CTYPE','English_United States.utf8'))
options(stringsAsFactors=FALSE,contrasts=c('contr.treatment','contr.poly'))
args <- character()
out <- 'learning/my_output'
dir.create(out,recursive=TRUE,showWarnings=FALSE)
source('config.R',encoding='UTF-8')
source('R/helpers.R',encoding='UTF-8')
set.seed(config$seed)
library(survival)


raw_preview <- survival::colon
dim(raw_preview)
table(raw_preview$etype)
length(unique(raw_preview$id))
head(raw_preview[c('id','rx','time','status','etype')])


source('R/01_data.R',encoding='UTF-8')
table(analysis$rx)
sum(analysis$status)
print(flow)
print(missingness[missingness$missing>0,])
print(node_disagreement)


my_km <- survfit(Surv(time,status) ~ rx, data=analysis, conf.type='log-log')
print(summary(my_km,times=c(365.25,1095.75,1826.25)))


my_lr <- survdiff(Surv(time,status) ~ rx, data=analysis)
my_lr_p <- pchisq(my_lr$chisq,df=1,lower.tail=FALSE)
my_cox <- coxph(Surv(time,status) ~ rx,data=analysis,x=TRUE)
print(my_lr_p)
print(exp(cbind(HR=coef(my_cox),confint(my_cox))))


source('R/02_survival.R',encoding='UTF-8')
print(cox_table)
print(ph$table)
print(c(n_primary=nrow(analysis),n_adjusted=nrow(cc)))


source('R/rmst.R',encoding='UTF-8')
toy_value <- rmst(c(1,2,3),c(1,0,1),tau=3)
print(toy_value)
stopifnot(abs(toy_value-7/3)<1e-10)


set.seed(config$seed)
source('R/03_rmst.R',encoding='UTF-8')
print(rmst_table)


source('R/04_outputs.R',encoding='UTF-8')
finish(config$packages)
