# Primary analysis: supplied OS records, retaining original treatment assignment.
km <- survfit(Surv(time,status)~rx,data=analysis,conf.type='log-log')
times <- c(0,365.25,3*365.25,config$tau)
ks <- summary(km,times=times,extend=FALSE)
km_table <- data.frame(arm=as.character(ks$strata),day=ks$time,at_risk=ks$n.risk,
                       survival=ks$surv,ci_low=ks$lower,ci_high=ks$upper)
save_table(km_table,'km_landmarks')
check('KM probabilities bounded',all(km_table$survival>=0&km_table$survival<=1))
check('followup supports RMST horizon',all(tapply(analysis$time,analysis$rx,max)>=config$tau))
logrank <- survdiff(Surv(time,status)~rx,data=analysis)
logrank_p <- pchisq(logrank$chisq,df=1,lower.tail=FALSE)
unadjusted <- coxph(Surv(time,status)~rx,data=analysis,x=TRUE)
cc <- analysis[complete.cases(analysis[c('age','sex','nodes','extent')]),]
adjusted <- coxph(Surv(time,status)~rx+age+sex+nodes+factor(extent),data=cc,x=TRUE)
cox_row <- function(fit,label) {
 s<-summary(fit);i<-grep('^rx',rownames(s$coefficients))
 data.frame(model=label,n=fit$n,events=fit$nevent,HR=s$conf.int[i,'exp(coef)'],
            ci_low=s$conf.int[i,'lower .95'],ci_high=s$conf.int[i,'upper .95'],p=s$coefficients[i,'Pr(>|z|)'])
}
cox_table <- rbind(cox_row(unadjusted,'Primary unadjusted'),cox_row(adjusted,'Sensitivity complete-case adjusted'))
save_table(cox_table,'cox_effects')
ph <- cox.zph(unadjusted,transform='km')
ph_adjusted <- cox.zph(adjusted,transform='km')
save_table(data.frame(term=rownames(ph$table),ph$table,row.names=NULL),'ph_primary')
save_table(data.frame(term=rownames(ph_adjusted$table),ph_adjusted$table,row.names=NULL),'ph_adjusted')
save_table(data.frame(n=nrow(analysis),deaths=sum(analysis$status),logrank_p=logrank_p,
                      primary_ph_p=ph$table['GLOBAL','p'],adjusted_excluded=nrow(analysis)-nrow(cc)),'primary_summary')
check('all primary patients in Cox model',unadjusted$n==nrow(analysis))
check('complete case denominator reconciles',adjusted$n==sum(complete.cases(analysis[c('age','sex','nodes','extent')])) )
check('finite HR and intervals',all(is.finite(unlist(cox_table[c('HR','ci_low','ci_high')]))))
print(cox_table)
