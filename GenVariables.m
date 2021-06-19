%Import required data from CSV 
% names of parameter import with a 1 at the correspond at the pareto front
% names of parameter import without a 1 at the correspond at the data of
% all tested points

% directory in which the csv file are saved
directorySave = 'EzSift_Data\';

% import data for all tested points
ImportAllPoints
% import data of the pareto front
ImportParetoSet

%compute the Power and launch the script checking if the pareto front is
%correct
Power = Energy./DurationII;
sln = [Power , Latency, DurationII, Memory];
paretoVerification

%create a matrix with the data of the pareto front
paretoTest = [Energy1./DurationII1, Latency1, DurationII1, Memory1];

% compute the number of parameter of the application
Parameter = [nKeypointsMaxUser image_width parallelismLevel AspectRatioDenominator delayRead delayDisplay NumeratorFrequency imgDouble];
nbParam = size(Parameter,2);

%call script to create the variable ParameterMetrics
% this matrix holds the value of the 4 metrics for each configuration
% tested
% the power is computed and added to the matrix
ImportParameterMetric
ParameterMetrics(:,13) = ParameterMetrics(:,9);
ParameterMetrics(:,9) = ParameterMetrics(:,9)./ParameterMetrics(:,11);

%permutation matrix
order = nbParam:-1:1;
A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];

% create array of all possible value for some metrics 
pow = unique(Power);
mem = unique(Memory);
dura = unique(DurationII);