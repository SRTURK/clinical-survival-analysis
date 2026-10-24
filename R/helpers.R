# Shared presentation and audit helpers; no statistical estimators hidden here.
checks <- data.frame(check=character(),passed=logical(),detail=character())
check <- function(name, ok, detail='') {
  checks <<- rbind(checks, data.frame(check=name,passed=isTRUE(ok),detail=as.character(detail)))
  if (!isTRUE(ok)) stop(paste('Quality check failed:',name,detail))
}
save_table <- function(x,name) {
  write.csv(x,file.path(out,paste0(name,'.csv')),row.names=FALSE,na='',fileEncoding='UTF-8')
  invisible(x)
}
checkpoint <- function(label) {
  cat('\n',label,'\n',sep='')
  if ('--pause' %in% args) {cat('Press Enter to continue (Ctrl+C stops): '); readLines('stdin',n=1)}
}
input_snapshot <- function(x,name,pkg) {
  dir.create('data/raw',recursive=TRUE,showWarnings=FALSE)
  path <- file.path('data/raw',paste0(name,'.csv'))
  write.csv(x,path,row.names=FALSE,na='',fileEncoding='UTF-8',eol='\n')
  hash <- unname(tools::md5sum(path))
  expected <- read.csv('data/expected_md5.csv',stringsAsFactors=FALSE)
  check('input snapshot MD5',hash==expected$md5[expected$dataset==name],hash)
  save_table(data.frame(dataset=name,package=pkg,version=as.character(packageVersion(pkg)),md5=hash),'input_provenance')
}
baseline_table <- function(d,group,continuous,categorical) {
  result <- list(); arms <- levels(factor(d[[group]]))
  for (v in c(continuous,categorical)) {
    if (v %in% continuous) {
      rows <- data.frame(variable=v,level='mean (SD); observed n; missing n')
      for (a in arms) {x <- d[d[[group]]==a,v]; rows[[a]] <- sprintf('%.2f (%.2f); n=%d; missing=%d',mean(x,na.rm=TRUE),sd(x,na.rm=TRUE),sum(!is.na(x)),sum(is.na(x)))}
    } else {
      lev <- c(sort(unique(as.character(d[[v]][!is.na(d[[v]])]))),'Missing')
      rows <- data.frame(variable=v,level=lev)
      for (a in arms) {x <- as.character(d[d[[group]]==a,v]); counts <- sapply(lev,function(l) if(l=='Missing')sum(is.na(x)) else sum(x==l,na.rm=TRUE));rows[[a]] <- sprintf('%d (%.1f%%)',counts,100*counts/length(x))}
    }
    result[[v]] <- rows
  }
  do.call(rbind,result)
}
esc <- function(x) {x<-gsub('&','&amp;',as.character(x),fixed=TRUE);x<-gsub('<','&lt;',x,fixed=TRUE);gsub('>','&gt;',x,fixed=TRUE)}
format_table <- function(x) {
  x<-as.data.frame(x);for(n in names(x))if(is.numeric(x[[n]]))x[[n]]<-format(x[[n]],digits=5,trim=TRUE)
  x[is.na(x)] <- '';x
}
html_table <- function(x) {
 x<-format_table(x);paste0('<div class="tablewrap"><table><thead><tr>',paste0('<th>',esc(names(x)),'</th>',collapse=''),'</tr></thead><tbody>',paste(apply(x,1,function(r)paste0('<tr>',paste0('<td>',esc(r),'</td>',collapse=''),'</tr>')),collapse=''),'</tbody></table></div>')
}
md_table <- function(x) {
 x<-format_table(x);paste(c(paste0('| ',paste(names(x),collapse=' | '),' |'),paste0('| ',paste(rep('---',ncol(x)),collapse=' | '),' |'),apply(x,1,function(r)paste0('| ',paste(r,collapse=' | '),' |'))),collapse='\n')
}
write_report <- function(title,intro,sections) {
 md<-c(paste0('# ',title),'',intro,'');ht<-c(paste0('<h1>',esc(title),'</h1>'),paste0('<p>',esc(intro),'</p>'))
 for(s in sections){md<-c(md,paste0('## ',s$title),'',s$text,'');ht<-c(ht,paste0('<h2>',esc(s$title),'</h2><p>',esc(s$text),'</p>'))
  if(!is.null(s$table)){md<-c(md,md_table(s$table),'');ht<-c(ht,html_table(s$table))}
  if(!is.null(s$image)){md<-c(md,paste0('![',s$title,'](',s$image,')'),'');ht<-c(ht,paste0('<img alt="',esc(s$title),'" src="',s$image,'">'))}}
 while(length(md) && tail(md,1)=='') md<-head(md,-1)
 writeLines(enc2utf8(md),file.path(out,'REPORT.md'),useBytes=TRUE)
 css<-'body{font:16px/1.8 "Microsoft YaHei",system-ui,sans-serif;color:#223747;background:#f3f6f9;margin:0}main{max-width:1100px;margin:32px auto;background:white;padding:40px;border-top:6px solid #186b82}h1{font-size:30px}h2{margin-top:35px;color:#176b87}img{max-width:100%}.tablewrap{overflow:auto}table{border-collapse:collapse;width:100%;font-size:13px}th,td{padding:9px;text-align:left;border-bottom:1px solid #dde5eb;white-space:nowrap}th{background:#eef4f7}p{white-space:pre-line}'
 writeLines(enc2utf8(paste0('<!doctype html><html lang="zh-CN"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>',esc(title),'</title><style>',css,'</style></head><body><main>',paste(ht,collapse='\n'),'</main></body></html>')),file.path(out,'REPORT.html'),useBytes=TRUE)
}
finish <- function(packages) {
 save_table(checks,'validation_checks')
 writeLines(trimws(capture.output(sessionInfo()),which='right'),file.path(out,'sessionInfo.txt'))
 save_table(data.frame(package=packages,version=sapply(packages,function(p)as.character(packageVersion(p)))),'package_versions')
 cat(sprintf('\nCompleted: %d checks; outputs: %s\n',nrow(checks),out))
}
open_png <- function(name,width=1500,height=950) {
 png(file.path(out,name),width=width,height=height,res=150,type='cairo');par(mar=c(5,5,3,2),las=1,col.axis='#304859',col.lab='#304859')
}
