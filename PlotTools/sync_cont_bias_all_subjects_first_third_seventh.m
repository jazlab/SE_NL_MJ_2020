load('subject_ts_tp_sync_cont_040319_20reps.mat', 'bias_arr_all');
load 'subject_ts_tp_sync_cont_dualProcess_011620.mat'
%load dualProcess_ts_tp_sync_cont_nospeedup_191230_tstpfitting_20reps.mat

durs = durs' * 1000;
figure('Position', [100, 200, 1000, 600]);

human_color = 'k';
dual_color = 'r';
circuit_color = 'b';
color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;


bias_first_all = zeros(1, 6);
bias_third_all = zeros(1, 6);
bias_firstM_all = zeros(1, 6);
bias_thirdM_all = zeros(1, 6);

%% Find subject bias
for subject_id = 1:6
    bias_first = squeeze(bias_arr_all(subject_id, 1, :)) * 1000;
    bias_third = squeeze(bias_arr_all(subject_id, 3, :)) * 1000;
    bias_seventh = squeeze(bias_arr_all(subject_id, 7, :)) * 1000;

    bias_first = sqrt(sum(bias_first .^ 2) / 5);
    bias_third = sqrt(sum(bias_third .^ 2) / 5);
    bias_seventh = sqrt(sum(bias_seventh .^ 2) / 5);
    
    bias_first_all(subject_id) = bias_first;
    bias_third_all(subject_id) = bias_third;
    bias_seventh_all(subject_id) = bias_seventh;
end




%% Find dual process model bias
for subject_id = 1:6
    bias_firstM = squeeze(meanITI_model(subject_id, :, 1)) - durs;
    bias_thirdM = squeeze(meanITI_model(subject_id, :, 3)) - durs;
    bias_seventhM = squeeze(meanITI_model(subject_id, :, 7)) - durs;
    
    bias_firstM = sqrt(sum(bias_firstM .^ 2) / 5);
    bias_thirdM = sqrt(sum(bias_thirdM .^ 2) / 5);
    bias_seventhM = sqrt(sum(bias_seventhM .^ 2) / 5);
    
    bias_firstM_all(subject_id) = bias_firstM;
    bias_thirdM_all(subject_id) = bias_thirdM;
    bias_seventhM_all(subject_id) = bias_seventhM;
end
    
% Plot bias for all subjects
l1 = plot(ones(1, 6) * 0.9, bias_first_all, 'o', 'MarkerFaceColor', human_color,...
    'MarkerEdgeColor', human_color);
hold on;
plot(ones(1, 6) * 1.9, bias_third_all,  'o', 'MarkerFaceColor', human_color,...
    'MarkerEdgeColor', human_color);
plot(ones(1, 6) * 2.9, bias_seventh_all,  'o', 'MarkerFaceColor', human_color,...
    'MarkerEdgeColor', human_color);

% Plot model bias
l3 = plot(ones(1, 6) * 1.1, bias_firstM_all,  'o', 'MarkerFaceColor', dual_color,...
    'MarkerEdgeColor', dual_color);
hold on;
plot(ones(1, 6) * 2.1, bias_thirdM_all,  'o', 'MarkerFaceColor', dual_color,...
    'MarkerEdgeColor', dual_color);
plot(ones(1, 6) * 3.1, bias_seventhM_all,  'o', 'MarkerFaceColor', dual_color,...
    'MarkerEdgeColor', dual_color);

% for i = 1:6
%     plot([0.9 1.1], [bias_first_all(i) bias_third_all(i)], 'k');
%     plot([1.9 2.1], [bias_firstM_all(i) bias_thirdM_all(i)], 'k');
% end




%% Find circuit model bias
load subject_ts_tp_sync_cont_040319_20reps.mat
durs = durs * 1000;
for subject_id = 1:6
    bias_firstM = squeeze(meanITI_model(subject_id, :, 1)) - durs;
    bias_thirdM = squeeze(meanITI_model(subject_id, :, 3)) - durs;
    bias_seventhM = squeeze(meanITI_model(subject_id, :, 7)) - durs;
    
    bias_firstM = sqrt(sum(bias_firstM .^ 2) / 5);
    bias_thirdM = sqrt(sum(bias_thirdM .^ 2) / 5);
    bias_seventhM = sqrt(sum(bias_seventhM .^ 2) / 5);
    
    bias_firstM_all(subject_id) = bias_firstM;
    bias_thirdM_all(subject_id) = bias_thirdM;
    bias_seventhM_all(subject_id) = bias_seventhM;
end

% Plot model bias
l2 = plot(ones(1, 6) * 1, bias_firstM_all,  'o', 'MarkerFaceColor', circuit_color,...
    'MarkerEdgeColor', circuit_color);
hold on;
plot(ones(1, 6) * 2, bias_thirdM_all,  'o', 'MarkerFaceColor', circuit_color,...
    'MarkerEdgeColor', circuit_color);
plot(ones(1, 6) * 3, bias_seventhM_all,  'o', 'MarkerFaceColor', circuit_color,...
    'MarkerEdgeColor', circuit_color);

% for i = 1:6
%     %plot([0.9 1.1], [bias_first_all(i) bias_third_all(i)], 'k');
%     plot([2.9 3.1], [bias_firstM_all(i) bias_thirdM_all(i)], 'k');
% end

xlabel('IPI #')
ylabel('Bias (ms)')
mymakeaxis(gca, 'xticks', [1, 2, 3], 'xticklabels', {'1','3','7'})
legend([l1 l2 l3], {'Human', 'Circuit model', 'Dual process'}, 'Orientation', 'horizontal',...
    'Position', [0.44,0.89,0.44,0.04], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')