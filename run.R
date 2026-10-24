# Run from the repository root. Use --out=learning/output --pause for practice.
args <- commandArgs(trailingOnly=TRUE)
if (.Platform$OS.type == 'windows') invisible(Sys.setlocale('LC_CTYPE','English_United States.utf8'))
if (!file.exists('R/helpers.R')) stop('Open a terminal in the repository root before running run.R')
if(dir.exists('.Rlibrary')) .libPaths(c(normalizePath('.Rlibrary'),.libPaths()))
options(stringsAsFactors=FALSE,contrasts=c('contr.treatment','contr.poly'))
out_arg <- grep('^--out=',args,value=TRUE)
out <- if(length(out_arg)) sub('^--out=','',out_arg[1]) else 'reports'
dir.create(out,recursive=TRUE,showWarnings=FALSE)
source('config.R',encoding='UTF-8')
set.seed(config$seed)
source('R/helpers.R',encoding='UTF-8')
for(module in sort(list.files('R',pattern='^[0-9].*\\.R$',full.names=TRUE))) {
  source(module,encoding='UTF-8')
  checkpoint(basename(module))
}
finish(config$packages)
