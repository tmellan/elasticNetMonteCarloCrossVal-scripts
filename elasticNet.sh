#!/bin/bash

#Uncomment if module environment
module load mathematica

dir=`pwd`
jName="1-L1-L2"

mkdir -p Jobs
cd Jobs
mkdir -p $jName
cd $jName

sed -e 's|'sampleJobUsage'|'$jName'|g' $dir/1-elasticNet-crossVal-initialparameters.m > $dir/Jobs/r1-elasticNet-crossVal-initialparameters.m
#sed -e 's|'sampleJobUsage'|'Jobs/''$jName'|g' $dir/1-elasticNet-crossVal-initialparameters.m > $dir/Jobs/r1-elasticNet-crossVal-initialparameters.m
#cat $dir/Jobs/r1-elasticNet-crossVal-initialparameters.m
#pwd
#f  [ "$sysName" == "Linux" ]; then echo yes ; fi


wolfram -script ../r1-elasticNet-crossVal-initialparameters.m > $jName.out &
wait

cd $dir
#pwd

echo "Finished"
