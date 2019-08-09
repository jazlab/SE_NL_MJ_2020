load sync_cont_figure.mat

figure;
% color_sync = [166,206,227,128]/256;
% color_cont = [251,154,153,128]/256;
color_sync_mean = [188,95,211]/255;%[projectColorMaps('ts','samples',1,'sampleDepth',20)];
color_sync = [color_sync_mean 0.7];
color_cont_mean = [255,85,85]/255; %[projectColorMaps('ts','samples',20,'sampleDepth',20)];
color_cont = [color_cont_mean 0.7];
color_sim = projectColorMaps('epoch','samples',1,'sampleDepth',1);


plot(bias_all_lst(:,1:3)', 'Color', color_sync,...
    'LineWidth', 1)
hold on;
plot(3:20, bias_all_lst(:,3:end)', 'Color', color_cont,...
    'LineWidth', 1)
h1 = plot(bias_sim, 'Color', color_sim,...
    'LineWidth', 2);
h2 = plot(bias_means(:,1:3), 'Color', color_sync_mean,...
    'LineWidth', 2);
h3 = plot(3:20, bias_means(:,3:20), 'Color', color_cont_mean,...
    'LineWidth', 2);
plotVertical(3);
% To add error bar...
mymakeaxis(gca,'x_label', 'Count', 'y_label', 'Bias (ms)')
l1 = legend([h2, h3, h1], {'Synchronization, obs.', 'Continuation, obs.', 'Simulation'});
set(l1,...
    'Position',[0.770250001109825 0.400252140591297 0.101041664447015 0.110962563737191],...
    'FontSize',12,...
    'EdgeColor','none',...
    'Color','none');


