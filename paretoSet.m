% sln = [Energy./DurationII , Latency, DurationII, Memory];
% a=paretoSet_func(sln);
% indPar = find(a == 1);
% 
% paretoTest = [Energy1./DurationII1, Latency1, DurationII1, Memory1];

%%
%graph3d avec seulement les pareto sets pour les 3 latences différentes
%il faut éditer les ticks et les tickes labels car beaucoups se superposent
lat = unique(paretoTest(:,2));

for b = 1:size(lat)
    bln = find(paretoTest(:,2)==lat(b));
    figure(), scatter3(paretoTest(bln,1),paretoTest(bln,3),paretoTest(bln,4),[],paretoTest(bln,4)),
    cBar = colorbar('Ticks', unique(paretoTest(bln,4)));
    cBar.Ticks=unique(paretoTest(bln,4));
    cBar.Label.String = 'Memory';
    cBar.Location = 'southoutside';
    title(['Latency = ', int2str(lat(b))]);
    xlabel('power'),
    ylabel('DurationII'),
    zlabel('Memory');
end

%%
% orthogonal projection of 3d plots in the plane of power and durationII
% set(gca, 'ColorOrder', ColorOdrDef);
% Marker = ['x';'o';'*';'s';'d'];
% MarkerSelect = Marker(1,1);

lat = unique(paretoTest(:,2));
for l = 1:size(lat)
    indice = 1;
    fig = figure();
    LatRed = find(paretoTest(:,2)==lat(l));
    mem = unique(paretoTest(LatRed,4));
    LegendBuilder=cell(size(mem,1),1);
    cMap = parula(size(mem,1));
    for m = 1:size(mem)
        c = find(and(paretoTest(:,2)==lat(l), paretoTest(:,4)==mem(m)));
%         if ceil(indice/(size(get(gca,'ColorOrder'),1)))< size(Marker,1)
%             MarkerSelect = Marker(ceil(indice/(size(get(gca,'ColorOrder'),1))),1);
%         else 
%             MarkerSelect = '+';
%         end
        MarkerColor = cMap(m,:);
        plot(paretoTest(c,1),paretoTest(c,3),'*','MarkerEdgeColor',MarkerColor),hold on;
        LegendBuilder{indice,1} = ['latency : ',int2str(lat(l)),', memory : ', int2str(mem(m))];
        indice = indice + 1;
    end
    colormap(fig, cMap);
    cBar = colorbar;
    cBar.Ticks = 1/(2*size(mem,1)):1/(size(mem,1)):1;
    cBar.TickLabels = mem;
    cBar.Label.String = 'Memory';
    xlabel('Power');
    ylabel('DurationII');
    title(['DurationII plotted against Power for the latency of ',int2str(lat(l))]);
    leg = legend(LegendBuilder);
    leg.Visible = 'off';
end

clearvars fig;

%%
%latency = 1 special colors plus trop utiles car y'a les colors map
%maintenant
indice = 1;
l=1;
LegendBuilder={};
fig = figure(),
set(gca, 'ColorOrder', ColorOdrDef4, 'NextPlot', 'replacechildren');

LatRed = find(paretoTest(:,2)==lat(l));
mem = unique(paretoTest(LatRed,4));
cMap = parula(size(mem,1));

for m = 1:size(mem,1)
    c = find(and(paretoTest(:,2)==lat(l), paretoTest(:,4)==mem(m)));
%     if ceil(indice/(size(get(gca,'ColorOrder'),1)))< size(Marker,1)
%         MarkerSelect = Marker(ceil(indice/(size(get(gca,'ColorOrder'),1))),1);
%     else 
%         MarkerSelect = '+';
%     end
    MarkerColor = cMap(m,:);
    plot(paretoTest(c,1),paretoTest(c,3),'*','MarkerEdgeColor',MarkerColor),hold on;
    LegendBuilder{indice,1} = ['latency : ',int2str(lat(l)),', memory : ', int2str(mem(m))];
    indice = indice + 1;
    
end
colormap(fig, cMap);
cBar = colorbar;
cBar.Ticks = 1/(2*size(mem,1)):1/(size(mem,1)):1;
cBar.TickLabels = mem;
cBar.Label.String = 'Memory';
% cBar.Limits = [min(mem), max(mem)];
% 

xlabel('Power');
ylabel('DurationII');
title(['DurationII plotted against Power for the latency of ',int2str(lat(l))]);
leg = legend(LegendBuilder);
leg.Visible ='off';
%%
%print all points and pareto Set for a given Memory and latency
latencySelected = 1;
memorySelected = 14400;
e = find(and(Latency == latencySelected, Memory== memorySelected));
e1 = find(and(paretoTest(:,2) == latencySelected, paretoTest(:,4) == memorySelected));
E1 = sortrows(paretoTest(e1,:),1);
figure(),plot(Power(e),DurationII(e),'bx'), hold on;
plot(E1(:,1),E1(:,3),'-rx');

xlabel('power'),
ylabel('DurationII'),
legend(['all point tested'],['pareto set']);
title(['Latency = ', int2str(latencySelected), ' ; Memory = ', int2str(memorySelected)]);
%%
%All points tested + pareto set for all latency and memory in 2D (lot of pictures)
Path = 'Graph_Metric/AllptsAndParetoSet/';
PathImg = [Path, 'pngSave/'];
lat = unique(paretoTest(:,2));
for l = 1:size(lat)
    LatRed = find(paretoTest(:,2)==lat(l));
    mem = unique(paretoTest(LatRed,4));
    
     for m = 1:size(mem)
        f  = find(and(Memory         == mem(m),Latency        == lat(l)));
        f1 = find(and(paretoTest(:,4)== mem(m),paretoTest(:,2)== lat(l)));
        
        F1 = sortrows(paretoTest(f1,:),1);

        fig = figure();
        plot(Power(f),DurationII(f),'bx'), hold on;
        plot(F1(:,1),F1(:,3),'-rx');
        xlabel('power'),
        ylabel('DurationII'),
        legend(['all point tested'],['pareto set']);
        title(['Latency = ', int2str(lat(l)), ' ; Memory = ', int2str(mem(m))]);
        saveas(fig,[Path,'All_Points+ParetoSet_','Latency = ', int2str(lat(l)), '_Memory = ', int2str(mem(m)),'.fig']);
        saveas(fig,[PathImg,'All_Points+ParetoSet_','Latency = ', int2str(lat(l)), '_Memory = ', int2str(mem(m)),'.png']);
     end
end
clearvars fig;
%%
%pareto Set for all latency and memory in 2D (lot of pictures)

lat = unique(paretoTest(:,2));
for l = 1:size(lat)
    LatRed = find(paretoTest(:,2)==lat(l));
    mem = unique(paretoTest(LatRed,4));
    
     for m = 1:size(mem)
        c = find(paretoTest(LatRed,4)==mem(m));
        figure(),
        plot(paretoTest(c,1),paretoTest(c,3),'x'),
        xlabel('power'),
        ylabel('DurationII'),
        title(['Latency = ', int2str(lat(l)), ' ; Memory = ', int2str(mem(m))]);
     end
end