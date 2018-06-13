% Read in file  
T = readtable('output.txt','Delimiter', ',');

figure; hold('on')

x = 1:1:2;

% Get the mean RTs and round, then multiply by 1000 to turn into ms.
RT_0 = [T.RT0];
y0 = mean(RT_0)*1000; 
err = RepMeasErr(RT_0)*1000;
% p1 = errorbar(x, y0, err, '-s', 'MarkerSize',12, 'MarkerEdgeColor',[0,.5,.8], 'MarkerFaceColor',[0,.5,.8]);
% set(p1,'Color',[0,.5,.8],'LineWidth', 2);

RT_1 = [T.RT1];
y1 = mean(RT_1)*1000; 
err = RepMeasErr(RT_1)*1000;
% p2 = errorbar(x, y1, err, '-s', 'MarkerSize',12, 'MarkerEdgeColor',[.5,0,.5], 'MarkerFaceColor',[.5,0,.5]);
% set(p2,'Color',[.5,0,.5],'LineWidth', 2);

RT_2 = [T.RT2];
y2 = mean(RT_2)*1000; 
err = RepMeasErr(RT_2)*1000;
% p3 = errorbar(x, y2, err, '-s', 'MarkerSize',12, 'MarkerEdgeColor',[.5,0,.5], 'MarkerFaceColor',[.5,0,.5]);
% set(p3,'Color',[.5,0,.5],'LineWidth', 2);



% legend('Neutral','Positive','Negative')
% set(gca, 'xtick', 1:2,...
%     'xticklabels',{'Intact','50% degraded'})
xlabel('Valence')
ylabel('RT(ms)')

return