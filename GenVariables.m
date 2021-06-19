directorySave = 'EzSift_V5\';

ImportAllPoints
ImportParetoSet
ImportTabConfig

Power = Energy./DurationII;
sln = [Energy./DurationII , Latency, DurationII, Memory];
a=paretoSet_func(sln);
indPar = find(a == 1);


paretoTest = [Energy1./DurationII1, Latency1, DurationII1, Memory1];
Parameter = [nKeypointsMaxUser image_width parallelismLevel AspectRatioDenominator delayRead delayDisplay NumeratorFrequency imgDouble];

%appele le script pour le parameter metric
ImportParameterMetric
ParameterMetrics(:,13) = ParameterMetrics(:,9);
ParameterMetrics(:,9) = ParameterMetrics(:,9)./ParameterMetrics(:,11);
nbParam = size(Parameter,2);
order = nbParam:-1:1;
%permutation matrix
A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];

Power = Energy./DurationII;
pow = unique(Power);
mem = unique(Memory);
dura = unique(DurationII);