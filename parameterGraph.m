% % Power = Energy./DurationII;
% % pow = unique(Power);
% % mem = unique(Memory);
% % dura = unique(DurationII);
% ParameterMetrics(:,9) = ParameterMetrics(:,9)./ParameterMetrics(:,12);
% % Parameter = [nKeypointsMaxUser image_width parallelismLevel AspectRatioDenominator delayRead delayDisplay NumeratorFrequency imgDouble];
% nbParam = size(Parameter,2);
% order = nbParam:-1:1;
% A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
% order = order*A;
% ParameterMetrics = sortrows(ParameterMetrics, order);
% 
% %%
% %plot first memory results as a function of nKeypointsMaxUser
% % first set constant but some aren't (after 28)
% 
% figure(), 
% Leg = {};
% a = 1:9;
% for ids = 1:28
%     semilogy(ParameterMetrics(a,1), ParameterMetrics(a,12)), hold on;
%     a = a+size(a,2)*ones(size(a))
%     Leg{ids,1} = ['Image_width = ',int2str(ParameterMetrics(a(1),2)), ' Parallelism = ',int2str(ParameterMetrics(a(1),3)), ' AspectRatio = ',int2str(ParameterMetrics(a(1),4))];
% end
% xlabel('nKeypointsMaxUser');
% ylabel('Memory (log)');
% title('Memory as a function of nKeypointsMaxUser for a given values of other parameters');
% legend(Leg)
% 
% %%
% %generalisation of previous section to check a metric as a function of a given parameter 
% %nKeypointsMaxUser = 1 image_width = 2 parallelismLevel = 3 
% %AspectRatioDenominator = 4 delayRead = 5 
% %delayDisplay = 6 NumeratorFrequency = 7 imgDouble = 8
% 
% testParam = 5;
% 
% while(order(8) ~= testParam)
%     order = order*A;
% end
% 
% %Power = 9 Latency = 10 DurationII = 11 Memory = 12 Energy = 13
% 
% testMetric = 12;
% 
% ParameterMetrics = sortrows(ParameterMetrics, order);
% nbTimesSameValue = size(find(ParameterMetrics(:,testParam)==ParameterMetrics(1,testParam)),1);
% %compute the number of possible value for the parameter
% a = 1:(4320/nbTimesSameValue);
% 
% parameterImpact = 2*ones(size(ParameterMetrics,1),1);
% 
% for idx = 1:nbTimesSameValue
%     parameterImpact(a,1) = all(ParameterMetrics(a,testMetric)==ParameterMetrics(a(1),testMetric));
%     a = a+size(a,2)*ones(size(a));
% end
% same = find(parameterImpact(:,1) == 1);
% diff = find(parameterImpact(:,1) == 0);
% 
% same_2 = ParameterMetrics(same,:);
% diff_2 = ParameterMetrics(diff,:);

%%
%Test for all parameter and all metrics

% matrixSameBool = false(nbParam,4); 
% matrixSame = cell(nbParam,4);
% matrixDiffBool = false(nbParam,4); 
% matrixDiff = cell(nbParam,4);
% 
% orderSave = nbParam:-1:1;
% A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
% for param = 1:8
%     order = orderSave*A^(param-1);
% %     fprintf('last element of order : %d \n',order(8));
%     for metric = 9:13
%         ParameterMetrics = sortrows(ParameterMetrics, order);
%         nbTimesSameValue = size(find(ParameterMetrics(:,param)==ParameterMetrics(1,param)),1);
%         %compute the number of possible value for the parameter
%         a = 1:(4320/nbTimesSameValue);
% 
%         parameterImpact = 2*ones(size(ParameterMetrics,1),1);
% 
%         for idx = 1:nbTimesSameValue
%             parameterImpact(a,1) = all(ParameterMetrics(a,metric)==ParameterMetrics(a(1),metric));
%             a = a+size(a,2)*ones(size(a));
%         end
%         same = find(parameterImpact(:,1) == 1);
%         matrixSameBool(param,(metric-8)) = (size(same,1) == 4320);
%         matrixSame{param,(metric-8)} = same;
%         
%         diff = find(parameterImpact(:,1) == 0);
%         matrixDiffBool(param,(metric-8)) = (size(diff,1) == 4320);
%         matrixDiff{param,(metric-8)} = diff;
%     
%      end
% end
% ParameterMetrics = sortrows(ParameterMetrics, orderSave);
% 
% %%
% %Test to check how a parameter influence a metric : always increase, always
% %decrease, not a constant variation
% 
% matrixCroissBool = false(nbParam,5); 
% matrixCroiss = cell(nbParam,5);
% matrixDecroissBool = false(nbParam,5); 
% matrixDecroiss = cell(nbParam,5);
% matrixInconsistentBool = false(nbParam,5); 
% matrixInconsistent = cell(nbParam,5);
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
%     for metric = 9:13
%         nbValuesToCheck = size(matrixDiff{param,(metric-8)},1);
%         if(nbValuesToCheck ~= 0)
%            
%             a = 1:(4320/nbTimesSameValue);
% 
%             parameterImpact = 2*zeros(nbValuesToCheck,1);
%             it = size(matrixDiff{param, metric-8},1)/a(end);
%             
%             for idx = 1:it
%                 AllSup = all(ParameterMetrics(matrixDiff{param, metric-8}(a(2:end)),metric) > ParameterMetrics(matrixDiff{param, metric-8}(a(1:end-1)),metric));
%                 AllInf = all(ParameterMetrics(matrixDiff{param, metric-8}(a(2:end)),metric) < ParameterMetrics(matrixDiff{param, metric-8}(a(1:end-1)),metric));
%                 if AllSup == 1
%                   parameterImpact(a,1) = 1;
%                 elseif AllInf == 1
%                     parameterImpact(a,1) = -1;
%                 end
%                 a = a+size(a,2)*ones(size(a));
%             end
%             croissant = find(parameterImpact(:,1) == 1);
%             matrixCroissBool(param,(metric-8)) = (size(croissant,1) == 4320);
%             matrixCroiss{param,(metric-8)} = croissant;
% 
%             inconsistent = find(parameterImpact(:,1) == 0);
%             matrixInconsistentBool(param,(metric-8)) = (size(inconsistent,1) == 4320);
%             matrixInconsistent{param,(metric-8)} = inconsistent;
%             
%             decroissant = find(parameterImpact(:,1) == -1);
%             matrixDecroissBool(param,(metric-8)) = (size(decroissant,1) == 4320);
%             matrixDecroiss{param,(metric-8)} = decroissant;
%                         
%         end
%      end
% end
% ParameterMetrics = sortrows(ParameterMetrics, orderSave);

%%
matrixSameBool = false(nbParam,4); 
matrixSame = cell(nbParam,4);
matrixDiffBool = false(nbParam,4); 
matrixDiff = cell(nbParam,4);
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
tic;
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
        parameterImpactDiff = 2*ones(nbValuesToCheck,1);

        for idx = 1:nbTimesSameValue
            parameterImpact(a,1) = all(ParameterMetrics(a,metric)==ParameterMetrics(a(1),metric));
            AllSup = all(ParameterMetrics(a(2:end),metric)>ParameterMetrics(a(1:end-1),metric));
            AllInf = all(ParameterMetrics(a(2:end),metric)<ParameterMetrics(a(1:end-1),metric));
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
        matrixSameBool(param,(metric-8)) = (size(same,1) == 4320);
        matrixSame{param,(metric-8)} = same;
        
        diff = find(parameterImpact(:,1) == 0);
        matrixDiffBool(param,(metric-8)) = (size(diff,1) == 4320);
        matrixDiff{param,(metric-8)} = diff;
        matrixLabelSameDiff{param,(metric-8)}(diff) = -1;

        croissant = find(parameterImpactDiff(:,1) == 1);
        matrixCroissBool(param,(metric-8)) = (size(croissant,1)== 4320);
        matrixCroiss{param,(metric-8)} = croissant;

        inconsistent = find(parameterImpactDiff(:,1) == 0);
        matrixInconsistentBool(param,(metric-8)) = (size(inconsistent,1) == 4320);
        matrixInconsistent{param,(metric-8)} = inconsistent;

        decroissant = find(parameterImpactDiff(:,1) == -1);
        matrixDecroissBool(param,(metric-8)) = (size(decroissant,1) == 4320);
        matrixDecroiss{param,(metric-8)} = decroissant;

        matrixLabel{param,(metric-8)}(croissant) = 1;
        matrixLabel{param,(metric-8)}(decroissant) = -1;
        matrixLabel{param,(metric-8)}(inconsistent) = 2;
            
        
     end
end
toc
ParameterMetrics = sortrows(ParameterMetrics, orderSave);





M = 2*ones(nbParam,5);
M(matrixCroissBool==1)=1;
M(matrixDecroissBool==1)=-1;
M(matrixSameBool==1)=0;
%M(matrixInconsistentBool==1)=2;

%%
% -1 the metric change if the value of the parameter change for the given
% configuration(when others parameters are fixed)
% 0  the metric doesn't change if the value of the paramater change
matrixLabelSameDiff = cell(nbParam,5);

for param = 1:8
    for metric = 9:13 
        matrixLabelSameDiff{param,(metric-8)} = zeros(4320,1);
        nbValuesToCheck = size(matrixDiff{param,(metric-8)},1);
        if(nbValuesToCheck ~= 0)
            
            matrixLabelSameDiff{param,(metric-8)}(matrixDiff{param,(metric-8)}) = -1;
            
        end
     end
end


% Labelisation 
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








