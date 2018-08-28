(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
Print["Getting training data"]
(*If running as script, run module 1 first to import data and save as mx file, then Get with*)
dirMXimport=StringJoin[ToString@DirectoryName[$InputFileName]]
Get["trainingData.mx",trainingData]

(*If running as a script set dir as*)
dir=StringJoin[ToString@DirectoryName[$InputFileName],"/sampleJobUsage"];
SetDirectory[dir];


Print["Setting global parameters"]
(*Global parameters*)
eraTotalNumber=120; (*Numer of eras in training data. This should be automatic in case it changes*)
RegSize=6 ;(*L1 L2 regularisation domain size (square)*)
intialRegParameters={1,1}; (*Initial L1=L2=1*)


Print["Splitting data era-wise"]
(*Get number of points in each era*)
eraLabels=Table[StringJoin["era",ToString@i],{i,1,eraTotalNumber}];
erasNames=Transpose[trainingData][[2]];
eraLengths=Table[Cases[erasNames,eraLabels[[i]]]//Length,{i,1,Length@eraLabels}];
eraLengthsCumulative=Join[{0},Table[Total@eraLengths[[1;;i]],{i,1,Length@eraLengths}]];

(*Split data era-wise*)
fullTrainingSet=(Join[{StringDelete[#[[2]],"era"]},#[[4;;-6]]]->#[[-5;;-5]][[1]])&/@trainingData[[2;;-1]];
fullTrainingSplit=Table[fullTrainingSet[[eraLengthsCumulative[[era]]+1;;eraLengthsCumulative[[era+1]]]],{era,1,Length@eraLabels}];
fullTrainingSetDataOnly=(#[[1]]&/@fullTrainingSet);


Print["Starting cross-validation"]
(*Elastic net parameters determined by Monte Carlo cross validation, and a Gaussian process fitted to the log loss in L1-L2 parameter space*)
(*Test parameters = 2 10 10 5 2 5*)
(*Reasonable parameters 10 500 1000 10 1 25*)
boLogistic=With[
{nFold=10,kSubSamplesT=1000,kSubSamplesV=1000,mErasT=25,mErasV=1,gaussianResolution=25},
randomEraSample=Table[RandomSample[Range[eraTotalNumber],mErasT+mErasV],{n,1,nFold}];
{eraSplitTrain,eraSplitVal}={Table[randomEraSample[[n]][[1;;mErasT]],{n,1,nFold}],Table[randomEraSample[[n]][[mErasT+1;;mErasT+mErasV]],{n,1,nFold}]};
{eraSplitSubsampleIndexTrain,eraSplitSubsampleIndexVal}={Table[Table[RandomSample[Range[eraLengths[[eraSplitTrain[[n]][[split]]]]],kSubSamplesT],{split,1,mErasT}],{n,1,nFold}],Table[Table[RandomSample[Range[eraLengths[[eraSplitVal[[n]][[split]]]]],kSubSamplesV],{split,1,mErasV}],{n,1,nFold}]};
{trainingSplits,valSplits}={Table[Flatten@Table[fullTrainingSplit[[eraSplitTrain[[n]][[era]]]][[eraSplitSubsampleIndexTrain[[n]][[era]]]],{era,1,mErasT}],{n,1,nFold}],Table[Flatten@Table[fullTrainingSplit[[eraSplitVal[[n]][[era]]]][[eraSplitSubsampleIndexVal[[n]][[era]]]],{era,1,mErasV}],{n,1,nFold}]};
crossVal[n_,{\[Lambda]1_,\[Lambda]2_}]:=Module[{class},class=Classify[trainingSplits[[n]],PerformanceGoal->"Quality",Method->{"LogisticRegression","OptimizationMethod"->"StochasticGradientDescent","L1Regularization"->Exp[\[Lambda]1],"L2Regularization"->Exp[\[Lambda]2]}];
-ClassifierMeasurements[class,valSplits[[n]],"LogLikelihoodRate"]];
lossOptimiserFunction[{\[Lambda]1_,\[Lambda]2_}]:=Mean[Table[crossVal[n,{\[Lambda]1,\[Lambda]2}],{n,1,
nFold}]];
regSpace[init_,size_]:=Rectangle[{init[[1]]-size,init[[2]]-size},{init[[1]]+size,init[[2]]+size}];
BayesianMinimization[lossOptimiserFunction,regSpace[intialRegParameters,RegSize],MaxIterations->gaussianResolution,AssumeDeterministic->False]
]

Print["Cross-validation finished, making predictor function, and getting output data"]
(*Get best log-loss actually calculated, and best log-loss from Gaussian process over log-loss, and plot of logloss surface*)
pLogistic=boLogistic["PredictorFunction"]
minConfigValue=Append[boLogistic["MinimumConfiguration"], boLogistic["MinimumValue"]]
minConfigFunction=Quiet@FindArgMin[pLogistic[{x,y}],{{x},{y}}]
pNet=Plot3D[pLogistic[{x,y}],{x,intialRegParameters[[1]]-RegSize,intialRegParameters[[1]]+RegSize},{y,intialRegParameters[[2]]-RegSize,intialRegParameters[[2]]+RegSize},PlotRange->All,ImageSize->1000,AxesLabel->{"Logloss","Exp[L1]","Exp[L2]"}]
pNetTable=Table[pLogistic[{x,y}],{x,intialRegParameters[[1]]-RegSize,intialRegParameters[[1]]+RegSize},{y,intialRegParameters[[2]]-RegSize,intialRegParameters[[2]]+RegSize}]

Print["Exporting"]
(*Export image of L1-L2 logloss surface, and L1-L2 values with best logloss*)
Export[StringJoin[dir,"/pNet.pdf"],pNet];
Export[StringJoin[dir,"/minConfigValue.txt"],minConfigValue];
Export[StringJoin[dir,"/minConfigFunction.txt"],minConfigFunction];
Export[StringJoin[dir,"/pNetTable.txt"],pNetTable];

Print["Closing Kernels"]
(*Problem closing and restarting parallel kernels under linux, hence...*)
CloseKernels[]
Pause[60]



