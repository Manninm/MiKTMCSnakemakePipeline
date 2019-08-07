
maindir=`pwd`
for i in $( ls -d Sample* ); do
 cd $i
 DIR=`pwd`
 for j in $( find . -wholename "*R1*" -type f ); do
 cd `dirname $j`
 mv `basename $j` `basename $i`.R1.fq.gz
 cd $DIR
 done;
 cd $maindir
done


maindir=`pwd`
for i in $( ls -d Sample* ); do
 cd $i
 DIR=`pwd`
 for j in $( find . -wholename "*R2*" -type f ); do
 cd `dirname $j`
 mv `basename $j` `basename $i`.R2.fq.gz
 cd $DIR
 done;
 cd $maindir
done