#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file<-args[1]
exp<-read.tabe(file,header=TRUE,sep='\t',row.names=1,check.names=FALSE)
noProcs<-args[2]
clustering<-"ward"	
dist<-"euclidian"
bootstrapping=args[3]
outname<-gsub(file,'.txt', '')

library(snow)
library(pvclust)
library(tools)	
library(corrplot)
dim(exp)
length(which(rowSums(exp)>0))
read.table('HtSeqCounts/CountsGt0_voom.txt',header=TRUE,sep='\t',row.names=1,check.names=FALSE)

cl<-makeCluster(noProcs,type="SOCK")
res<-parPvclust(cl,exp,method.hclust="ward.D", method.dist=dist,nboot=bootstrapping)
pdf(paste(outname,bootstrapping,".pdf",sep=""), width=30, height=20)
plot(res)
dev.off()

res<-parPvclust(cl,exp,method.hclust="ward.D2", method.dist=dist,nboot=bootstrapping)
pdf(paste(outname,bootstrapping,".pdf",sep=""), width=30, height=20)
plot(res)
dev.off()

stopCluster(cl)

co<-cor(exp)
pdf(paste(outname".pdf",sep=""), width=40, height=40)
corrplot.mixed(co,upper="circle", lower="number", order="hclust",tl.pos="lt")
dev.off()