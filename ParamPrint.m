function [ ParamFilter ] = ParamPrint(ParameterMetrics, matrix, param, metric )
%PARAMPRINT Summary of this function goes here
%   permet de r�cup�rer le ParameterMetric pour les coordonn�es stock�es
%   dans cellUsed(param, metric)
% ParameterMetrics : tableau de donn�es
% matrix : Cell qui contient l'ensemble des indices que l'on veut extraire de ParameterMetrics
% param : param�tre que l'on s�lection pour le trie(pour
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

