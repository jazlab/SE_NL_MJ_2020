load('sync_cont_figure_021619.mat', 'bias_all_lst', 'bias_means');

% For circuit model
%load ('sync_cont_subject_fit_040319_5reps.mat', 'Bias_sim_mean');

% For dual process
%load ('dualProcess_params_subjects_011620.mat', 'Bias_sim_mean');
%load('dualProcess_synccont_withspeedup_randomsearch_params_011620.mat', 'Bias_sim_mean');
% load ('dualProcess_params_subjects_tstp_011620.mat', 'Bias_sim_mean');
% figure;

% For algorithmic
load ('sync_cont_figure_algorithmic_circuit_012120c.mat', 'Bias_sim_mean');
figure;

color_sync_mean = [188,95,211]/255;
color_sync = [color_sync_mean 0.7];
color_cont_mean = [255,85,85]/255; 
color_cont = [color_cont_mean 0.7];
color_sim = projectColorMaps('epoch','samples',1,'sampleDepth',1);


plot(bias_all_lst(:,1:3)', 'Color', color_sync,...
    'LineWidth', 1)
hold on;
plot(3:20, bias_all_lst(:,3:end)', 'Color', color_cont,...
    'LineWidth', 1)

h3 = plot(3:20, bias_means(:,3:20), 'Color', color_cont_mean,...
    'LineWidth', 2);
plotVertical(3);
mymakeaxis(gca,'x_label', 'IPI count', 'y_label', 'BIAS (ms)')

%% Plot individual subject fits
plot(mean(Bias_sim_mean, 1), 'Color', 'b', 'LineWidth', 2);
hold on;
mean_sim = mean(Bias_sim_mean, 1);
std_sim = std(Bias_sim_mean, [], 1);

% For error bars
upper = mean_sim + std_sim / sqrt(6);
lower = mean_sim - std_sim / sqrt(6);
xvals = 1:20;
fx = [xvals, fliplr(xvals)];
fy = [upper, fliplr(lower)];
fill(fx, fy, [.5 .5 .5], 'FaceAlpha', 0.6, 'EdgeColor', 'none')
h1 = plot(mean_sim, 'Color', 'k', 'LineWidth', 2);
h2 = plot(bias_means(:,1:3), 'Color', color_sync_mean,...
    'LineWidth', 2);

l1 = legend([h2, h3, h1], {'Human Synch.', 'Human Cont.', 'Discrete algorithm model'});
set(l1,...
    'Position',[0.770250001109825 0.400252140591297 0.101041664447015 0.110962563737191],...
    'FontSize',12,...
    'EdgeColor','none',...
    'Color','none');


