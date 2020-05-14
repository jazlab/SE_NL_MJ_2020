% For comparing the BIAS and VAR fit to subject behavior of different
% models, i.e. CircuitModel vs. Dual Process or Discrete Algo

%% Load model fits
folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\NoisyMutualInhibition_Dec2019\MatlabAnalyses';

% Dual process
load(fullfile(folder, 'biasvar_dualProcess_013020c.mat'));
all_subject_files_DP = all_subject_files;
collated_bias_var_DP = collated_bias_var;

% CircuitModel
load(fullfile(folder, 'biasvar_021119_thres0_7_constant_stage0_750ms_Krange1to8_Irange77to79_sigma005to04.mat'));
all_subject_files_CM = all_subject_files(1:9,:);
collated_bias_var_CM = collated_bias_var(1:9,:);

%% Comparison
% Deviations
dev1DP = collated_bias_var_DP(:,1) - collated_bias_var_DP(:,2);
dev1CM = collated_bias_var_CM(:,1) - collated_bias_var_CM(:,2);

dev2DP = collated_bias_var_DP(:,3) - collated_bias_var_DP(:,4);
dev2CM = collated_bias_var_CM(:,3) - collated_bias_var_CM(:,4);

dev3DP = collated_bias_var_DP(:,5) - collated_bias_var_DP(:,6);
dev3CM = collated_bias_var_CM(:,5) - collated_bias_var_CM(:,6);

dev4DP = collated_bias_var_DP(:,7) - collated_bias_var_DP(:,8);
dev4CM = collated_bias_var_CM(:,7) - collated_bias_var_CM(:,8);


%% Display stats
% pval1 = signrank(abs(dev1DP), abs(dev1CM), 'tail', 'left');
% pval2 = signrank(abs(dev2DP), abs(dev2CM), 'tail', 'left');
% pval3 = signrank(abs(dev3DP), abs(dev3CM), 'tail', 'left');
% pval4 = signrank(abs(dev4DP), abs(dev4CM), 'tail', 'left');

[pval1, ~, stats1] = signrank((dev1DP), (dev1CM), 'tail', 'left', 'method', 'approximate');
[pval2, ~, stats2] = signrank((dev2DP), (dev2CM), 'tail', 'left', 'method', 'approximate');
[pval3, ~, stats3] = signrank((dev3DP), (dev3CM), 'tail', 'left', 'method', 'approximate');
[pval4, ~, stats4] = signrank((dev4DP), (dev4CM), 'tail', 'left', 'method', 'approximate');

disp([pval1, pval2, pval3, pval4])
disp([stats1.zval, stats2.zval, stats3.zval, stats4.zval])


%% Plot
figure;

color_sync_mean = [31,120,180] / 255; % For DP
color_cont_mean = [178,223,138] / 255; % For CM
randfactor = 0;

% Plot bias for all subjects
l1 = plot(ones(1, 9) * 0.9 + rand(1, 9) * randfactor, dev1DP(1:9), 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 9) * 1.1 + rand(1, 9) * randfactor, dev1CM(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% Plot model bias
plot(ones(1, 9) * 1.9+ rand(1, 9) * randfactor, dev2DP(1:9),  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 9) * 2.1+ rand(1, 9) * randfactor, dev2CM(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% Plot model bias
plot(ones(1, 9) * 2.9+ rand(1, 9) * randfactor, dev3DP(1:9),  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 9) * 3.1+ rand(1, 9) * randfactor, dev3CM(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% Plot model bias
plot(ones(1, 9) * 3.9+ rand(1, 9) * randfactor, dev4DP(1:9),  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 9) * 4.1+ rand(1, 9) * randfactor, dev4CM(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% for i = 1:9
%     plot([0.9 1.1], [dev1DP(i) dev1CM(i)], 'k');
%     plot([1.9 2.1], [dev2DP(i) dev2CM(i)], 'k');
%     plot([2.9 3.1], [dev3DP(i) dev3CM(i)], 'k');
%     plot([3.9 4.1], [dev4DP(i) dev4CM(i)], 'k');
% end

%xlabel('ISI (ms)')
ylabel({'(Model - Human) difference in',  'BIAS or (VAR)^{1/2} (ms)'})
mymakeaxis(gca, 'xticks', [1, 2, 3, 4], 'xticklabels', {'BIAS\newline 1-2-Go', ' BIAS\newline 1-2-3-Go',...
    '(VAR)^{1/2}\newline 1-2-Go', '(VAR)^{1/2}\newline 1-2-3-Go'},...
    'yticks', [-20 0 20])
legend([l1 l2], {'Algorithm', 'Circuit Model'}, 'Orientation', 'vertical',...
    'Position', [0.615, 0.859, 0.207, 0.114], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')



function rms = find_rms_diff(arr1, arr2)
% Find the rms difference between 2 arrays
diff = arr1 - arr2;
rms = sqrt(sum(diff.^2) / numel(diff));
end


