%test to find back matrixLabel with less points
%compute all matrices (matrixSameLess, matrixDiffLess, matrixCroissLess,
%matrixDecroissLess and matrixInconsistentLess
%number of point used : nbPts = 5
% if nbPts < 3 impossible to determine if a parameter have an inconsistent impact
nbPts = 2;
nbPtsTested = 1;

matrixSameBoolLess = false(nbParam,4); 
matrixSameLess = cell(nbParam,4);
matrixDiffBoolLess = false(nbParam,4); 
matrixDiffLess = cell(nbParam,4);
matrixCroissBoolLess = false(nbParam,5); 
matrixCroissLess = cell(nbParam,5);
matrixDecroissBoolLess = false(nbParam,5); 
matrixDecroissLess = cell(nbParam,5);
matrixInconsistentBoolLess = false(nbParam,5); 
matrixInconsistentLess = cell(nbParam,5);

matrixLabelLess = cell(nbParam,5);
matrixLabelSameDiffLess = cell(nbParam,5);

orderSave = nbParam:-1:1;
A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
tic;
for param = 1:8
    order = orderSave*A^(param-1);
%     fprintf('last element of order : %d \n',order(8));
    
    ParameterMetrics = sortrows(ParameterMetrics, order);
    nbTimesSameValue = size(find(ParameterMetrics(:,param)==ParameterMetrics(1,param)),1);
        
    if (4320/nbTimesSameValue) > nbPts
        % select nbPts index randomly in the number of possible values of
        % the parameter
       aSelect =sort(randsample(1:(4320/nbTimesSameValue),nbPts));
       disp(['index used for parameter n° ', num2str(param), ' : ' , num2str(aSelect(:).')])
    else
        % else use all the indexes
       aSelect = 1:(4320/nbTimesSameValue);
    end  
    nbPtsTested = nbPtsTested*size(aSelect,2);
    for metric = 9:13
        %compute the number of possible value for the parameter
        a = 1:(4320/nbTimesSameValue);

        matrixLabelLess{param,(metric-8)} = zeros(4320,1);
        matrixLabelSameDiffLess{param,(metric-8)} = zeros(4320,1);
        
        parameterImpact = 2*ones(size(ParameterMetrics,1),1);
        parameterImpactDiff = 2*ones(size(ParameterMetrics,1),1);

        for idx = 1:nbTimesSameValue
            aShort = a(aSelect);
            parameterImpact(a,1) = all(ParameterMetrics(aShort,metric)==ParameterMetrics(aShort(1),metric));
            AllSup = all(ParameterMetrics(aShort(2:end),metric)>ParameterMetrics(aShort(1:end-1),metric));
            AllInf = all(ParameterMetrics(aShort(2:end),metric)<ParameterMetrics(aShort(1:end-1),metric));
            if parameterImpact(a(1),1) == 0
                if AllSup == 1
                  parameterImpactDiff(a,1) = 1;
                elseif AllInf == 1
                    parameterImpactDiff(a,1) = -1;
                else
                    parameterImpactDiff(a,1) = 0;
                end
            end
            a = a+size(a,2)*ones(size(a));
        end
        same = find(parameterImpact(:,1) == 1);
        matrixSameBoolLess(param,(metric-8)) = (size(same,1) == 4320);
        matrixSameLess{param,(metric-8)} = same;
        
        diff = find(parameterImpact(:,1) == 0);
        matrixDiffBoolLess(param,(metric-8)) = (size(diff,1) == 4320);
        matrixDiffLess{param,(metric-8)} = diff;
        matrixLabelSameDiffLess{param,(metric-8)}(diff) = -1;
        
        croissant = find(parameterImpactDiff(:,1) == 1);
        matrixCroissBoolLess(param,(metric-8)) = (size(croissant,1)== 4320);
        matrixCroissLess{param,(metric-8)} = croissant;

        inconsistent = find(parameterImpactDiff(:,1) == 0);
        matrixInconsistentBoolLess(param,(metric-8)) = (size(inconsistent,1) == 4320);
        matrixInconsistentLess{param,(metric-8)} = inconsistent;

        decroissant = find(parameterImpactDiff(:,1) == -1);
        matrixDecroissBoolLess(param,(metric-8)) = (size(decroissant,1) == 4320);
        matrixDecroissLess{param,(metric-8)} = decroissant;

        matrixLabelLess{param,(metric-8)}(croissant) = 1;
        matrixLabelLess{param,(metric-8)}(decroissant) = -1;
        matrixLabelLess{param,(metric-8)}(inconsistent) = 2;
        
     end
end
toc
ParameterMetrics = sortrows(ParameterMetrics, orderSave);

matrixError = zeros(nbParam,5);
for param = 1:8
    for metric = 9:13 
        VectErr = (matrixLabelLess{param,(metric-8)} ~= matrixLabel{param,(metric-8)});
        
        matrixError(param,(metric-8)) = size(find(VectErr==1),1)/4320;
     end
end
fprintf('Matrice d erreur : \n')
disp(matrixError)
% global error computed differently with nbErr/size(Label,1)
% err = (ones(1,size(matrixError,1))*matrixError*ones(size(matrixError,2),1))/(size(matrixError,1)*size(matrixError,2));

% confusion matrix for same/diff classification
Label = reshape([matrixLabelSameDiff{1:end,1:end}], [],1);
Predict = reshape([matrixLabelSameDiffLess{1:end,1:end}], [],1);
fprintf('Confusion matrix of classification same-diff\n');
disp(confusionmat(Label,Predict));
nbErr = size(find(Label ~= Predict),1);
fprintf('\nErreur Classification Same-Diff : \n\tNb de points erreur : %d\n\ttaux d erreur : %f\n', nbErr, nbErr/size(Label,1));

    % confusion matrix for same, croissante, decroissante, inconsistant
% classification
Label = [matrixLabel{1:end,1:end}];
Predict = [matrixLabelLess{1:end,1:end}];
Label = reshape(Label, [], 1);
Predict = reshape(Predict, [], 1);

C = confusionmat(Label, Predict);
fprintf('\nConfusion matrix of classification same-croissant-decroissant-inconsistant\n');
disp(C);
nbErr = size(find(Label ~= Predict),1);
fprintf('Erreur Classification Same-Croissant-Decroissant-Inconsistant : \n\tNb de points erreur : %d\n\ttaux d erreur : %f\n', nbErr, nbErr/size(Label,1));
fprintf('nombre de point utilisés : %d\n', nbPtsTested);

%error matrix for blocks
LabelBlock = double.empty;
PredictBlock = double.empty;

for idxI=1:1:8
    blocElement = 1:VectNbParam(idxI):4320;
    for idxJ=1:1:5
    LabelBlock   =  cat(1,LabelBlock  ,matrixLabel{idxI,idxJ}(blocElement));
    PredictBlock =  cat(1,PredictBlock,matrixLabelLess{idxI,idxJ}(blocElement));
    end
end

C = confusionmat(LabelBlock, PredictBlock);
fprintf('\nConfusion matrix of classification pour les blocks same-croissant-decroissant-inconsistant\n');
disp(C);
nbErrBlock = size(find(LabelBlock ~= PredictBlock),1);
fprintf('Erreur Classification Same-Croissant-Decroissant-Inconsistant : \n\tNb de block erreur : %d\n\ttaux d erreur : %f\n', nbErrBlock, nbErrBlock/size(LabelBlock,1));


fprintf('\nMatrix of classification for the global impact of the parameter on the metric\n');
Mless = 2*ones(nbParam,5);
Mless(matrixCroissBoolLess==1)=1;
Mless(matrixDecroissBoolLess==1)=-1;
Mless(matrixSameBoolLess==1)=0;
disp(Mless);
%%
%test to find back matrixLabel with less points and using matrixDiff
%already computed

%number of point used 3
% nbPts = 10;
% 
% matrixCroissBoolLess = false(nbParam,5); 
% matrixCroissLess = cell(nbParam,5);
% matrixDecroissBoolLess = false(nbParam,5); 
% matrixDecroissLess = cell(nbParam,5);
% matrixInconsistentBoolLess = false(nbParam,5); 
% matrixInconsistentLess = cell(nbParam,5);
% 
% matrixLabelLess = cell(nbParam,5);
% 
% 
% orderSave = nbParam:-1:1;
% A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
% for param = 1:8
%     order = orderSave*A^(param-1);
% %     fprintf('last element of order : %d \n',order(8));
%     ParameterMetrics = sortrows(ParameterMetrics, order);
%       %compute the number of times the first value occurs the parameter
%       %(allow to determine the number of possible value for the parameter)
%     nbTimesSameValue = size(find(ParameterMetrics(:,param)==ParameterMetrics(1,param)),1);
%     if (4320/nbTimesSameValue) > nbPts
%         % select nbPts index randomly in the number of possible values of
%         % the parameter
%        aSelect =sort(randsample(1:(4320/nbTimesSameValue),nbPts));
%        disp(['index used for parameter n° ', num2str(param), ' : ' , num2str(aSelect(:).')])
%     else
%         % else use all the indexes
%        aSelect = 1:(4320/nbTimesSameValue);
%     end  
%     for metric = 9:13
%         nbValuesToCheck = size(matrixDiff{param,(metric-8)},1);
%         matrixLabelLess{param,(metric-8)} = zeros(4320,1);
%        
%         if(nbValuesToCheck ~= 0)
%             
%             a = 1:(4320/nbTimesSameValue);
%             
%             parameterImpact = 2*zeros(nbValuesToCheck,1);
%             it = size(matrixDiff{param, metric-8},1)/a(end);
%             
%             for idx = 1:it
%                 aShort = a(aSelect);
%                 AllSup = all(ParameterMetrics(matrixDiff{param, metric-8}(aShort(2:end)),metric) > ParameterMetrics(matrixDiff{param, metric-8}(aShort(1:end-1)),metric));
%                 AllInf = all(ParameterMetrics(matrixDiff{param, metric-8}(aShort(2:end)),metric) < ParameterMetrics(matrixDiff{param, metric-8}(aShort(1:end-1)),metric));
%                 if AllSup == 1
%                   parameterImpact(a,1) = 1;
%                 elseif AllInf == 1
%                     parameterImpact(a,1) = -1;
%                 end
%                 a = a+size(a,2)*ones(size(a));
%             end
%             croissant = find(parameterImpact(:,1) == 1);
%             matrixCroissBoolLess(param,(metric-8)) = (size(croissant,1) == size(matrixDiff{param, metric-8},1));
%             matrixCroissLess{param,(metric-8)} = croissant;
% 
%             inconsistent = find(parameterImpact(:,1) == 0);
%             matrixInconsistentBoolLess(param,(metric-8)) = (size(inconsistent,1) == size(matrixDiff{param, metric-8},1));
%             matrixInconsistentLess{param,(metric-8)} = inconsistent;
%             
%             decroissant = find(parameterImpact(:,1) == -1);
%             matrixDecroissBoolLess(param,(metric-8)) = (size(decroissant,1) == size(matrixDiff{param, metric-8},1));
%             matrixDecroissLess{param,(metric-8)} = decroissant;
%             
%             matrixLabelLess{param,(metric-8)}(croissant) = 1;
%             matrixLabelLess{param,(metric-8)}(decroissant) = -1;
%             matrixLabelLess{param,(metric-8)}(inconsistent) = 2;
%             
%         end
%      end
% end
% ParameterMetrics = sortrows(ParameterMetrics, orderSave);
% 
% %Evaluate result matrixLabelLess
% 
% matrixError = zeros(nbParam,5);
% for param = 1:8
%     for metric = 9:13 
%         VectErr = (matrixLabelLess{param,(metric-8)} ~= matrixLabel{param,(metric-8)});
%         
%         matrixError(param,(metric-8)) = size(find(VectErr==1),1)/4320;
%      end
% end
% 
% fprintf('Matrice d erreur : \n')
% disp(matrixError)
% 
% % Confusion matrix
% Label = [matrixLabel{1:end,1:end}];
% Predict = [matrixLabelLess{1:end,1:end}];
% 
% Label = reshape(Label, [], 1);
% Predict = reshape(Predict, [], 1);
% 
% C = confusionmat(Label, Predict);
% disp(C);
% nbErr = size(find(Label ~= Predict),1);
% fprintf('Erreur Classification Same-Croissant-Decroissant-Inconsistant : \n\tNb de points erreur : %d\n\ttaux d erreur : %f\n', nbErr, nbErr/size(Label,1));
% 


