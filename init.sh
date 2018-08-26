#!/bin/bash
dir=`pwd`

echo $PATH
path=`echo "PATH=$PATH:"$dir`
echo $PATH

echo "As necessary:"
echo "mkdir -p Jobs"
echo "chmod 755 *.sh *.m"
echo "alias mathematica='/Applications/Mathematica.app/Contents/MacOS/MathKernel'"
echo "alias math="mathematica""
echo "cd sampleJobUsage ; math -script ../directoryTest.m"
echo "math -script ../1-elasticNet-crossVal-initialparameters.m > job1.out"
