load subject_ts_tp_sync_cont_040319_20reps.mat

%% Calculate the slope for each subject (observed)
% Intervals for ts
durs = durs * 1000;
color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;

%% Calculate slopes for subjects

% Corresponding tp
tp_first_all = squeeze(bias_arr_all(:,1,:)) * 1000 + durs;
tp_second_all = squeeze(bias_arr_all(:,2,:)) * 1000 + durs;
tp_third_all = squeeze(bias_arr_all(:,3,:)) * 1000 + durs;
tp_seventh_all = squeeze(bias_arr_all(:,7,:)) * 1000 + durs;

% Calculate regression slope
slopes_first = zeros(1, 6);
slopes_second = zeros(1, 6);
slopes_third = zeros(1, 6);
slopes_seventh = zeros(1, 6);
for i = 1:6
    tp_first = tp_first_all(i,:)';
    tp_second = tp_second_all(i,:)';
    tp_third = tp_third_all(i,:)';
    tp_seventh = tp_seventh_all(i,:)';
    
    tp_first_ones = [tp_first ones(5, 1)]; 
    tp_second_ones = [tp_second ones(5, 1)]; 
    tp_third_ones = [tp_third ones(5, 1)]; 
    tp_seventh_ones = [tp_seventh ones(5, 1)];
    ts = durs';
    ts_ones = [ts ones(5, 1)];
    
    regression_coefs_first = ts_ones\tp_first;
    regression_coefs_second = ts_ones\tp_second;
    regression_coefs_third = ts_ones\tp_third;
    regression_coefs_seventh = ts_ones\tp_seventh;
    
    slopes_first(i) = regression_coefs_first(1);
    slopes_second(i) = regression_coefs_second(1);
    slopes_third(i) = regression_coefs_third(1);
    slopes_seventh(i) = regression_coefs_seventh(1);
end

%% Extract the middle interval
shift_first = tp_first_all(:, 3);
shift_second = tp_second_all(:, 3);
shift_third = tp_third_all(:, 3);
shift_seventh = tp_seventh_all(:, 3);

%% Statistical test
p_slope = signrank(slopes_third, slopes_seventh, 'tail', 'right');
p_shift = signrank(shift_third, shift_seventh, 'tail', 'right');
fprintf('P slope value is %.4f\n P shift value is %.4f\n', p_slope, p_shift);

%% Plot slope and shift
% Plot bias for all subjects
figure;
subplot(121);
l1 = plot(ones(1, 6) * 0.9, slopes_third, 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 6) * 1.1, slopes_seventh,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);
for i = 1:6
    plot([0.9 1.1], [slopes_third(i) slopes_seventh(i)], 'k');
    %plot([1.9 2.1], [shift_third(i) shift_seventh(i)], 'k');
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
plot(ones(1, 6) * 2.1, shift_seventh,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

for i = 1:6
    %plot([0.9 1.1], [slopes_third(i) slopes_seventh(i)], 'k');
    plot([1.9 2.1], [shift_third(i) shift_seventh(i)], 'k');
end
xlim([1.8, 2.2])
%xlabel('ISI (ms)')
%ylabel('Shift (ms)')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'', 'Shift (ms)'})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.32,0.95,0.44,0.07], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')

%% Plot slope and shift for 1,2,3, and 7
% Plot bias for all subjects
slopes_all = [slopes_first; slopes_second; slopes_third; slopes_seventh];
shift_all = [shift_first'; shift_second'; shift_third'; shift_seventh'];
figure;
subplot(121);
plot(slopes_all);
hold on
errorbar([1,2,3,4], mean(slopes_all, 2), std(slopes_all, [], 2)/sqrt(6), 'k--');
xlim([0,5])
xticks([1, 2, 3, 4])
xticklabels([1, 2, 3, 7])
ylabel('Slope')
xlabel('IPI #')


subplot(122);
plot(shift_all);
hold on
errorbar([1,2,3,4], mean(shift_all, 2), std(shift_all, [], 2)/sqrt(6), 'k--');
xlim([0,5])
ylabel('Shift');
xlabel('IPI #')
xticks([1, 2, 3, 4])
xticklabels([1, 2, 3, 7])

%% Plot ts-tp for an example subject
id = 6;
tp_first = tp_first_all(id,:);
tp_second = tp_second_all(id,:);
tp_third = tp_third_all(id, :);
tp_seventh = tp_seventh_all(id, :);

% Plot
figure;
hold on
l1 = plot(tp_first);
l2 = plot(tp_second);
l3 = plot(tp_third);
l4 = plot(tp_seventh);

legend([l1, l2, l3, l4], {'1st', '2nd', '3rd', '7th'})


