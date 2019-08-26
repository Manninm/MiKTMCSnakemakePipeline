#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file<-args[1]
exp<-read.tabe(file,header=TRUE,sep='\t',row.names=2,check.names=FALSE)
exp<-exp[,-c(1,2)] #For Transcript level
groups<-read.table('../groups.txt',header=TRUE,sep='\t')
outname<-gsub(file,'.txt', '')
names(groups)<-c('Sample','Disease',"Batch")
groups$Sample<-gsub('*_merged','',groups$Sample)
groups$Sample<-gsub('Sample_','',groups$Sample)
exp[is.na(exp)] <- 0 
tmp<-match(colnames(exp),groups[,1])
if(any(is.na(tmp))){return('Colnames of Expression matrix do not match groupfile samples')}
exp<-exp[,(match(groups$Sample,names(exp)))]
exp.pca<-prcomp(t(exp))
labels<-c(as.vector(groups$Disease))
labels<-gsub('ref','REF',labels)
labels<-gsub('Ref','REF',labels)
na<-c(as.character(groups$Sample))
size<-c(as.character(groups$Batch))
Dis<-(unique(as.vector(labels[!(labels=='REF')])))
LabCol<-rainbow(length(Dis))
labels<-gsub('REF','#000000',labels)
cat('Picking Colors')
print(paste(LabCol))
for (i in 1:length(Dis)){
	print(paste(Dis[i]))
	labels<-gsub(Dis[i],LabCol[i],labels)
}
Dis<-append(Dis,'REF')
LabCol<-append(LabCol,'#000000')
batch<-(unique(size))
shape<-c(sample(0:25,size=length(batch)))
cat('Picking Shapes')
print(paste(shape))
print(length(shape))
print(size)
print(batch)
for (i in 1:length(shape)){
	print(paste(i))
	print(paste(shape[i]))
	print(batch[i])
	size<-gsub(paste(batch[i],'\\>',sep=''),shape[i],size)
}
print(paste(size))
pdf(paste("PCA1v2&2v3&3v4",outname,sep=''), width=15, height=15)
plot(exp.pca$x[,1], exp.pca$x[,2], col=labels,pch=c(as.numeric(size)), main=paste("PCA1vs2Ref",outname,sep=''), xlab = "PCA 1", ylab = "PCA 2")
text(exp.pca$x[,1], exp.pca$x[,2], labels=na, pos= 3) #labels points
legend("bottomright",legend=paste(Dis,sep=''),fill=paste(LabCol,sep=''))
legend("bottomleft",legend=paste(batch,sep=''),pch=as.numeric(shape))
plot(exp.pca$x[,2], exp.pca$x[,3], col=labels, pch=c(as.numeric(size)), main=paste("PCA1vs2Ref",outname,sep=''), xlab = "PCA 2", ylab = "PCA 3")
text(exp.pca$x[,2], exp.pca$x[,3], labels=na, pos= 3) #labels points
legend("bottomright",legend=paste(Dis,sep=''),fill=paste(LabCol,sep=''))
legend("bottomleft",legend=paste(batch,sep=''),pch=as.numeric(shape))
plot(exp.pca$x[,3], exp.pca$x[,4], col=labels, pch=c(as.numeric(size)), main=paste("PCA1vs2Ref",outname,sep=''), xlab = "PCA 3", ylab = "PCA 4")
text(exp.pca$x[,3], exp.pca$x[,4], labels=na, pos= 3) #labels points
legend("bottomright",legend=paste(Dis,sep=''),fill=paste(LabCol,sep=''))
legend("bottomleft",legend=paste(batch,sep=''),pch=as.numeric(shape))
dev.off()