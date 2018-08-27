# Elastic net 

Elastic net with L1 and L2 regularisation parameters determined using Monte Carlo crossvalidation and Gaussian process fitted to logloss parameterrs.

./elasticNet.sh > job.out & disown -a && exit

Contents:
* Setup -- init.sh
* Bash wrapper for mathematic elastic net package (.m file) -- elasticNet.sh
* Elastic net -- 1-elasticNet-crossVal-initialparameters.m
* Ouput -- jobs run in /Jobs/1-xx but this is gitignored between test and production envinronments

