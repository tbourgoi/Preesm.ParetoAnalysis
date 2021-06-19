function [ ParamFilter ] = ParamPrint(ParameterMetrics, matrix, param, metric )
%PARAMPRINT Summary of this function goes here
%   permet de récupérer le ParameterMetric pour les coordonnées stockées
%   dans cellUsed(param, metric)
% ParameterMetrics : tableau de données
% matrix : Cell qui contient l'ensemble des indices que l'on veut extraire de ParameterMetrics
% param : paramètre que l'on sélection pour le trie(pour
% metric : coix 
if param > 8 || param < 0 || metric > 5 || metric < 0
    error('index out of bound') ;
end
nbParam = size(matrix,1);
Atemp = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
sort = nbParam:-1:1;

while(sort(8) ~= param)
    sort = sort*Atemp;
end

ParameterMetricsTemp = sortrows(ParameterMetrics, sort);
ParamFilter = ParameterMetricsTemp(matrix{param,metric},:);

end

