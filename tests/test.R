# Meaningful tests on independent constructed data and generated output.
library(survival)
out <- 'reports';args<-character();source('R/helpers.R')
source('R/rmst.R')
stopifnot(abs(rmst(c(1,2,3),c(1,0,1),3)-7/3)<1e-10)
stopifnot(rmst(c(2,4),c(0,0),3)==3)
toy<-data.frame(id=c(1,1,2,2),etype=c(1,2,1,2),status=c(1,0,0,1))
stopifnot(sum(toy$status[toy$etype==2])==1,length(unique(toy$id[toy$etype==2]))==2)
d<-read.csv('reports/analysis_dataset.csv');stopifnot(nrow(d)==619,!anyDuplicated(d$id),all(d$etype==2))
f<-survfit(Surv(time,status)~rx,data=d);land<-summary(f,times=1826.25)
saved<-read.csv('reports/km_landmarks.csv');saved<-saved[saved$day==1826.25,]
saved<-saved[match(as.character(land$strata),saved$arm),]
stopifnot(max(abs(land$surv-saved$survival))<1e-10)
r<-read.csv('reports/rmst_5year.csv');stopifnot(abs(r$treatment_days-r$control_days-r$difference_days)<1e-9)
stopifnot(all(read.csv('reports/validation_checks.csv')$passed))
cat('PASS: hand-calculated RMST; no-event RMST; endpoint grain; population; KM independent rerun; difference identity; pipeline audit\n')
