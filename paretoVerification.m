sln = [Energy./DurationII , Latency, DurationII, Memory];
a=paretoSet_func(sln);
indPar = find(a == 1);
pareto = sln(indPar,:);

paretoTest = [Energy1./DurationII1, Latency1, DurationII1, Memory1];

test = all(pareto(:,:) == paretoTest(:,:));

fprintf('v�rification que le pareto set calcul� est correcte : ');
if test == 1
    fprintf('True\n');
else
    fprintf('False\n');
end

