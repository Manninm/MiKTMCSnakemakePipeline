mytable<-fromJSON('samples.json')
data<-as.data.frame(mytable)
data <- lapply(json_file, function(x) {
  x[sapply(x, is.null)] <- NA
  unlist(x)
})
data<-do.call("rbind",data)
Samples<-as.vector(row.names(data))
Disease<-rep('Sample',length(Samples))
groups<-cbind(Samples,Disease)
write.table(groups,'groups.txt',quote=FALSE, sep='\t')