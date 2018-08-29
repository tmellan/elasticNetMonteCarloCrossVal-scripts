#!/bin/bash

#Uncomment if module environment
module load mathematica

dir=`pwd`
jName="if-L1-L2"
runDir="Jobs"
c=0

echo `date` >> date_pid.txt
cd $dir; mkdir -p $runDdir

echo "Importing and saving mx file training data"
wolfram -script 0-elasticNet-importData.m
wait

echo "Starting main loop" `date`
for i in {1..10}; do 
  let c=c+1
  cd $dir/Jobs ; mkdir -p $i'-'$jName
  cd $i'-'$jName

#Get basic script and set any parameters
  sed -e 's|'sampleJobUsage'|'$i'-'$jName'|g' $dir/1-elasticNet-crossVal-initialparameters.m > $dir/Jobs/'r'$i'-elasticNet-crossVal-initialparameters.m'
#Setting number of folds in cross val
  sleep 1s
  nf=$(echo $i*3 | bc -l)
  sed -i 's|nFold=10|nFold='$nf'|g' ../'r'$i'-elasticNet-crossVal-initialparameters.m' 

  echo 'r'$i'-elasticNet-crossVal-initialparameters.m'
  echo "script submitted"
  nohup  wolfram -script  ../'r'$i'-elasticNet-crossVal-initialparameters.m' > $i'-'$jName.out 2>&1 &
  echo $c  $! >> $dir/save_pid.txt

#  if (( $c % 3 == 0 )); then wait; fi
  cd $dir
done

echo "Finishing main loop" `date`
