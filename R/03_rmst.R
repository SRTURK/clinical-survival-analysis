source('R/rmst.R',encoding='UTF-8')
arm_data <- split(analysis,analysis$rx)
point <- sapply(arm_data,function(d)rmst(d$time,d$status,config$tau))
reference <- sapply(arm_data,function(d)unname(summary(survfit(Surv(time,status)~1,data=d),rmean=config$tau)$table['rmean']))
check('RMST agrees with survival integration',max(abs(point-reference))<1e-7)
bootstrap <- replicate(config$bootstrap,{
 values<-sapply(arm_data,function(d){b<-d[sample.int(nrow(d),replace=TRUE),];rmst(b$time,b$status,config$tau)})
 values[2]-values[1]
})
interval <- quantile(bootstrap,c(.025,.975))
rmst_table <- data.frame(tau_days=config$tau,control_days=point[1],treatment_days=point[2],
                        difference_days=point[2]-point[1],ci_low_days=interval[1],ci_high_days=interval[2],bootstrap_replicates=config$bootstrap,row.names=NULL)
save_table(rmst_table,'rmst_5year')
save_table(data.frame(replicate=seq_along(bootstrap),difference_days=bootstrap),'rmst_bootstrap')
check('RMST is between zero and tau',all(point>=0&point<=config$tau))
check('all bootstrap draws finite',length(bootstrap)==config$bootstrap&&all(is.finite(bootstrap)))
print(rmst_table)
