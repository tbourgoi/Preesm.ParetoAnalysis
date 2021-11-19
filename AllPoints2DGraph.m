%All points tested for all latency and memory in 2D (lot of pictures)
%for each value of the latency, iterate through the posible value of the
%memory and generate a figure with all the points tested in blue
% axis : 
%   X : Power
%   Y : DurationII
%   color map : Memory
%   Latency fixed 


lat = unique(Latency);
for l = 1:size(lat)
    indice = 1;
    
    fig = figure()
    LatRed = find(Latency==lat(l));
    MemLatRed = Memory(LatRed);
    mem = unique(MemLatRed);
    LegendBuilder=cell(size(mem,1),1);
    cMap = parula(size(mem,1));
    
    for m = 1:size(mem)
        c = find(MemLatRed==mem(m));
        MarkerColor = cMap(m,:);
        plot(Power(c),DurationII(c),'x','MarkerEdgeColor',MarkerColor),hold on;
        LegendBuilder{indice,1} = ['latency : ',int2str(lat(l)),', memory : ', int2str(mem(m))];
        indice = indice + 1;
    end
    colormap(fig, cMap);
    cBar = colorbar;
    precisionCbar = 25;
    if(size(mem,1)>= precisionCbar)
        t = floor(1:(size(mem,1)-1)/precisionCbar:size(mem,1));
        cBar.Ticks = 1/(2*precisionCbar):1/precisionCbar:1; 
        cBar.TickLabels = mem(t);
    else
        cBar.Ticks = 1/(2*size(mem,1)):1/(size(mem,1)):1;
        cBar.TickLabels = mem;
    end
    cBar.Label.String = 'Memory';
    xlabel('Power');
    ylabel('DurationII');
    title(['DurationII plotted against Power for the latency of ',int2str(lat(l))]);
    leg = legend(LegendBuilder);
    leg.Visible = 'off';
end

clearvars fig;

%%
% lat = unique(pareto(:,2));
% for l = 1:size(lat)
%     LatRed = find(pareto(:,2)==lat(l));
%     mem = unique(pareto(LatRed,4));
%      for m = 1:size(mem)
%         c = find(pareto(LatRed,4)==mem(m));
%         figure(),
%         plot(pareto(c,1),pareto(c,3),'x')
%      end
% end