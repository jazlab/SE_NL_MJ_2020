load('subject_ts_tp_sync_cont_040319_20reps.mat', 'bias_arr_all');
load ('sync_cont_figure_algorithmic_circuit_012120c.mat', 'Bias_sim_mean');
load('subject_ts_tp_sync_cont_dualProcess_011620.mat', 'durs');

durs = durs' * 1000;
figure('Position', [100, 200, 1000, 600]);

color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;


bias_third_all = zeros(1, 6);
bias_fifth_all = zeros(1, 6);
bias_thirdM_all = zeros(1, 6);
bias_fifthM_all = zeros(1, 6);

%% Find subject bias
for subject_id = 1:6
    bias_third = squeeze(bias_arr_all(subject_id, 3, :)) * 1000;
    bias_fifth = squeeze(bias_arr_all(subject_id, 7, :)) * 1000;

    bias_third = sqrt(sum(bias_third .^ 2) / 5);
    bias_fifth = sqrt(sum(bias_fifth .^ 2) / 5);
    
    bias_third_all(subject_id) = bias_third;
    bias_fifth_all(subject_id) = bias_fifth;
end




%% Find model bias
for subject_id = 1:6
    bias_thirdM = Bias_sim_mean(subject_id, 3);
    bias_fifthM = Bias_sim_mean(subject_id, 7);
    
    bias_thirdM_all(subject_id) = bias_thirdM;
    bias_fifthM_all(subject_id) = bias_fifthM;
end
    
% Plot bias for all subjects
l1 = plot(ones(1, 6) * 0.9, bias_third_all, 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 6) * 1.1, bias_fifth_all,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% Plot model bias
plot(ones(1, 6) * 1.9, bias_thirdM_all,  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 6) * 2.1, bias_fifthM_all,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

for i = 1:6
    plot([0.9 1.1], [bias_third_all(i) bias_fifth_all(i)], 'k');
    plot([1.9 2.1], [bias_thirdM_all(i) bias_fifthM_all(i)], 'k');
end

%xlabel('ISI (ms)')
ylabel('Bias (ms)')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'Observed', 'Model'})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.44,0.89,0.44,0.04], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')

