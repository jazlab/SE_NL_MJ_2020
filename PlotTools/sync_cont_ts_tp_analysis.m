load subject_ts_tp_sync_cont_040319_20reps.mat

%% Calculate the slope for each subject (observed)
% Intervals for ts
durs = durs * 1000;
color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;

% % Corresponding tp
% bias_third_all = squeeze(bias_arr_all(:,3,:)) * 1000;
% bias_fifth_all = squeeze(bias_arr_all(:,7,:)) * 1000;
% tp_third_all = bias_third_all + durs;
% tp_fifth_all = bias_fifth_all + durs;
% 
% % Calculate regression slope
% slopes_third = zeros(1, 6);
% slopes_fifth = zeros(1, 6);
% for i = 1:6
%     tp_third = tp_third_all(i,:)';
%     tp_fifth = tp_fifth_all(i,:)';
%     tp_third_ones = [tp_third ones(5, 1)]; 
%     tp_fifth_ones = [tp_fifth ones(5, 1)];
%     ts = durs';
%     
%     regression_coefs_third = ts\tp_third_ones;
%     regression_coefs_fifth = ts\tp_fifth_ones;
%     slopes_third(i) = regression_coefs_third(1);
%     slopes_fifth(i) = regression_coefs_fifth(1);
% end

%% Calculate slopes for model

% Corresponding tp
tp_third_all = squeeze(meanITI_model(:,:,3));
tp_fifth_all = squeeze(meanITI_model(:,:,7));

% Calculate regression slope
slopes_third = zeros(1, 6);
slopes_fifth = zeros(1, 6);
for i = 1:6
    tp_third = tp_third_all(i,:)';
    tp_fifth = tp_fifth_all(i,:)';
    tp_third_ones = [tp_third ones(5, 1)]; 
    tp_fifth_ones = [tp_fifth ones(5, 1)];
    ts = durs';
    
    regression_coefs_third = ts\tp_third_ones;
    regression_coefs_fifth = ts\tp_fifth_ones;
    slopes_third(i) = regression_coefs_third(1);
    slopes_fifth(i) = regression_coefs_fifth(1);
end

%% Extract the middle interval
shift_third = tp_third_all(:, 3);
shift_fifth = tp_fifth_all(:, 3);

%% Statistical test
p_slope = signrank(slopes_third, slopes_fifth, 'tail', 'right');
p_shift = signrank(shift_third, shift_fifth, 'tail', 'right');
fprintf('P slope value is %.4f\n P shift value is %.4f\n', p_slope, p_shift);

%% Plot slope and shift
% Plot bias for all subjects
subplot(121);
l1 = plot(ones(1, 6) * 0.9, slopes_third, 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 6) * 1.1, slopes_fifth,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);
for i = 1:6
    plot([0.9 1.1], [slopes_third(i) slopes_fifth(i)], 'k');
    %plot([1.9 2.1], [shift_third(i) shift_fifth(i)], 'k');
end
xlim([0.8, 1.2])
%ylabel('Slope')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'Slope', ''})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.44,0.89,0.44,0.04], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')


% Plot model bias
subplot(122)
plot(ones(1, 6) * 1.9, shift_third,  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 6) * 2.1, shift_fifth,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

for i = 1:6
    %plot([0.9 1.1], [slopes_third(i) slopes_fifth(i)], 'k');
    plot([1.9 2.1], [shift_third(i) shift_fifth(i)], 'k');
end
xlim([1.8, 2.2])
%xlabel('ISI (ms)')
%ylabel('Shift (ms)')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'', 'Shift (ms)'})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.32,0.95,0.44,0.07], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')