# Elastic net 

Elastic net with L1 and L2 regularisation parameters determined using Monte Carlo crossvalidation and Gaussian process fitted to logloss parameterrs.

./elasticNet.sh > job.out & disown -a && exit

To do:
* Separate initial parsing and store as compressed file
* At each fold print variance logloss as well as mean logloss
* Iterate over nFold, Monte Carlo training and validation era selection sizes
* Add production model training 

Contents:
* Setup -- init.sh
* Bash wrapper for mathematic elastic net package (.m file) -- elasticNet.sh
* Elastic net -- 1-elasticNet-crossVal-initialparameters.m
* Ouput -- jobs run in /Jobs/1-xx but this is gitignored between notebook/script envinronments

