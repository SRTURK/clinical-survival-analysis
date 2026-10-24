# Integral of the right-continuous Kaplan-Meier step function, in days.
rmst <- function(time,event,tau) {
 if(tau>max(time)) stop('tau exceeds observed follow-up')
 fit<-survival::survfit(survival::Surv(time,event)~1)
 inside<-fit$time<tau
 sum(diff(c(0,fit$time[inside],tau))*c(1,fit$surv[inside]))
}
