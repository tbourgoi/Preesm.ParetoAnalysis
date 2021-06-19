a=paretoSet_func(sln);
indPar = find(a == 1);
pareto = sln(indPar,:);

paretoTest = [Energy1./DurationII1, Latency1, DurationII1, Memory1];

test = all(pareto(:,:) == paretoTest(:,:));

fprintf('Checking if the pareto front is correct : ');
if test == 1
    fprintf('Pareto front imported is correct\n');
else
    fprintf('Pareto front imported is incorrect\n');
end

