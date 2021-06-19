% compute labels 
% set the value of all parameter except one and check the evolution of each
% metrics
% for each metric and each parameter impacts are saved in an array of the size the number of configuration tested
% (here 4320)
% 
% check all the possible configuration of the other parameters
% at the end, if the evolution for a parameter is the same independently of
% others parameter the boolean matrix is set to 1. (ex if the impact is
% Same => the matrix is matrixSmaeBool)
% the index of parameterMetric are saved in an other cell (matrixSame)
% a line for the boolean matrix and the cell of index represent a parameter
% a column represents a metric

%pay attention that the index in the matrix correspond to the index with a
% different sorting of parameterMetric (for each parameter). Therefore the code parameterMetric(matrixSame{1,1}) does not print the right data
% the function paramPrint prints the correct data according to the matrix placed in parameter


matrixSameBool = false(nbParam,5); 
matrixSame = cell(nbParam,5);
matrixDiffBool = false(nbParam,5); 
matrixDiff = cell(nbParam,5);
matrixCroissBool = false(nbParam,5); 
matrixCroiss = cell(nbParam,5);
matrixDecroissBool = false(nbParam,5); 
matrixDecroiss = cell(nbParam,5);
matrixInconsistentBool = false(nbParam,5); 
matrixInconsistent = cell(nbParam,5);

matrixLabel = cell(nbParam,5);
matrixLabelSameDiff = cell(nbParam,5);

orderSave = nbParam:-1:1;
A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];

for param = 1:8
    order = orderSave*A^(param-1);
%     fprintf('last element of order : %d \n',order(8));
    
    ParameterMetrics = sortrows(ParameterMetrics, order);
    nbTimesSameValue = size(find(ParameterMetrics(:,param)==ParameterMetrics(1,param)),1);
 
    for metric = 9:13
        %compute the number of possible value for the parameter
        a = 1:(4320/nbTimesSameValue);

        matrixLabel{param,(metric-8)} = zeros(4320,1);
        matrixLabelSameDiff{param,(metric-8)} = zeros(4320,1);
        
        parameterImpact = 2*ones(size(ParameterMetrics,1),1);

        for idx = 1:nbTimesSameValue
            parameterImpact(a,1) = all(ParameterMetrics(a,metric)==ParameterMetrics(a(1),metric));
            AllSup = all(ParameterMetrics(a(2:end),metric)>ParameterMetrics(a(1:end-1),metric));
            AllInf = all(ParameterMetrics(a(2:end),metric)<ParameterMetrics(a(1:end-1),metric));
            if parameterImpact(a(1),1) == 0
                if AllSup == 1
                  parameterImpact(a,1) = 2;
                elseif AllInf == 1
                    parameterImpact(a,1) = -2;
                else
                    parameterImpact(a,1) = -1;
                end
            end
            a = a+size(a,2)*ones(size(a));
        end
        %get index 
        same = find(parameterImpact(:,1) == 1);
        % if the size of the index is 4320 the impact is independant of
        % other parameter
        matrixSameBool(param,(metric-8)) = (size(same,1) == 4320);
        % save the index in the cell
        matrixSame{param,(metric-8)} = same;

        croissant = find(parameterImpact(:,1) == 2);
        matrixCroissBool(param,(metric-8)) = (size(croissant,1)== 4320);
        matrixCroiss{param,(metric-8)} = croissant;

        inconsistent = find(parameterImpact(:,1) == -1);
        matrixInconsistentBool(param,(metric-8)) = (size(inconsistent,1) == 4320);
        matrixInconsistent{param,(metric-8)} = inconsistent;

        decroissant = find(parameterImpact(:,1) == -2);
        matrixDecroissBool(param,(metric-8)) = (size(decroissant,1) == 4320);
        matrixDecroiss{param,(metric-8)} = decroissant;

        matrixLabel{param,(metric-8)}(croissant) = 1;
        matrixLabel{param,(metric-8)}(decroissant) = -1;
        matrixLabel{param,(metric-8)}(inconsistent) = 2;
            
        
     end
end

ParameterMetrics = sortrows(ParameterMetrics, orderSave);

M = 2*ones(nbParam,5);
M(matrixCroissBool==1)=1;
M(matrixDecroissBool==1)=-1;
M(matrixSameBool==1)=0;
%M(matrixInconsistentBool==1)=2;

%%

% Labelisation 
% summarizing the label in one cell instead of 4

% -1 the metric decrease if you change the parameter and fix others
% 0  the metric doesn't change if the value of the paramater change
% 1  the metric increase if you change the parameter and fix others
% 2  the evolution of metric isn't stable (decrease and increase) if you change the parameter and fix others
matrixLabel = cell(nbParam,5);

for param = 1:8
    for metric = 9:13 
        matrixLabel{param,(metric-8)} = zeros(4320,1);
        nbValuesToCheck = size(matrixDiff{param,(metric-8)},1);
        if(nbValuesToCheck ~= 0)
            
            matrixLabel{param,(metric-8)}(matrixCroiss{param,(metric-8)}) = 1;
            matrixLabel{param,(metric-8)}(matrixDecroiss{param,(metric-8)}) = -1;
            matrixLabel{param,(metric-8)}(matrixInconsistent{param,(metric-8)}) = 2;
            
        end
     end
end


%%
%test if dimension are correct 
TestDiff = false(size(matrixInconsistent));
for idL=1:8
    for idC=1:5
        TestDiff(idL,idC)  = ( size(matrixCroiss{idL, idC},1)...
            + size(matrixInconsistent{idL, idC},1)...
            + size(matrixDecroiss{idL, idC},1)...
            + size(matrixSame{idL, idC},1))...
            == 4320;
    end

end
disp(TestDiff)
%%
%graph of accuracy in classification according to the number of parameter
%testes in script paramSearchlessPoints

nbPointArray = 2:9;
iterationSearch = 5;
VectErrSum = zeros(1,nbPointArray(end));
VectptsTested = zeros(1,nbPointArray(end));
for nbPts = nbPointArray
   for idxSearch = 1:iterationSearch ;
    paramSearchlessPoints;
    VectErrSum(nbPts) = VectErrSum(nbPts)+ (nbErr/size(Label,1));
   end
   
   VectptsTested(nbPts) = nbPtsTested;
end
VectErrSum = VectErrSum*(1/iterationSearch);
figure,
plot(nbPointArray,VectErrSum(nbPointArray));
figure,
plot(nbPointArray, VectptsTested(nbPointArray))








