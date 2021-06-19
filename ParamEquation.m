%find line equation for parameter evolution
% use fit

orderSave = nbParam:-1:1;
A = [zeros(nbParam-1,1) eye(nbParam-1);ones zeros(1,nbParam-1)];
CellParam = cell(8,1);

for param = 1:8
    order = orderSave*A^(param-1);
%     fprintf('last element of order : %d \n',order(8));
    ParameterMetrics = sortrows(ParameterMetrics, order);
    
%compute the number of time a value for a parameter is used <=> nb
%d'ensemble à tester avec la boucle
    sizeParameterImpact = size(find(ParameterMetrics(:,param)==ParameterMetrics(1,param)),1);
    CoeffPolynomes = cell(sizeParameterImpact,4);
    
%compute the number of possible value for the parameter <=>
%size(unique(ParameterMetrics(:,param)),1);
    
    for metric = 9:12
        indice = 1;
        a = 1:(4320/sizeParameterImpact);
        for idx = 1:sizeParameterImpact
            %parameterImpact(a,1) = all(ParameterMetrics(a,metric)==ParameterMetrics(a(1),metric));
            CoeffPolynomes{indice, metric-8} = polyfit(ParameterMetrics(a,1), ParameterMetrics(a,metric),1);
            a = a+size(a,2)*ones(size(a));
            indice = indice+1;
        end
        
    end
    CellParam{param} = CoeffPolynomes;
end
ParameterMetrics = sortrows(ParameterMetrics, orderSave);



