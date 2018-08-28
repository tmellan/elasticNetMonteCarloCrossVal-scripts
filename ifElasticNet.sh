#!/bin/bash

#Uncomment if module environment
module load mathematica

dir=`pwd`
jName="if-L1-L2"

cd $dir; mkdir -p Jobs

c=0
for i in {1..5}; do 

  cd $dir/Jobs ; mkdir -p $i'-'$jName

  cd $i'-'$jName

#Get basic script and set any parameters
  sed -e 's|'sampleJobUsage'|'$i'-'$jName'|g' $dir/1-elasticNet-crossVal-initialparameters.m > $dir/Jobs/'r'$i'-elasticNet-crossVal-initialparameters.m'
#Setting number of folds in cross val
  sleep 1s
  nf=$(echo $i*5 | bc -l)
  sed -i 's|nFold=10|nFold='$nf'|g' ../'r'$i'-elasticNet-crossVal-initialparameters.m' 

  echo 'r'$i'-elasticNet-crossVal-initialparameters.m'
  echo "script submitted"
  wolfram -script ../'r'$i'-elasticNet-crossVal-initialparameters.m' > $i'-'$jName.out &

  let c=c+1
  if (( $c % 3 == 0 )); then wait; fi
  
#  wait
#  sleep 5m

  cd $dir
done

wait 
sleep 5m

echo "Finished"
