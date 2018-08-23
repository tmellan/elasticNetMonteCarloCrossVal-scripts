#!/bin/bash

module load mathematica

dir=`pwd`

mkdir 1-L1-L2
cd 1-L1-L2
wolfram -script 1-elasticNet-crossVal-initialparameters.m
cd $dir

echo "Fin"
