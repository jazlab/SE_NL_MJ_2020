load subject_ts_tp_sync_cont_021619.mat

figure('Position', [100, 200, 1000, 600]);

subject_id = 5;
durs = durs * 1000;

color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;

%% Subject ts-tp
bias_third = squeeze(bias_arr_all(subject_id, 3, :)) * 1000;
std_third = squeeze(std_arr_all(subject_id, 3, :)) * 1000;
bias_fifth = squeeze(bias_arr_all(subject_id, 7, :)) * 1000;
std_fifth = squeeze(std_arr_all(subject_id, 7, :)) * 1000;

subplot('121')
errorbar(durs, durs + bias_third', std_third, 'Color', color_sync_mean, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', color_sync_mean, 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
errorbar(durs + 5, durs + bias_fifth', std_fifth, 'Color', color_cont_mean, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', color_cont_mean, 'MarkerSize', 4,...
    'LineWidth', 1.5);

l3 = plot(durs, durs + bias_third', 'Color', color_sync_mean);
l4 = plot(durs + 5, durs + bias_fifth', 'Color', color_cont_mean);
xlim([500, 900])
ylim([500, 950])
xlabel('ISI (ms)')
ylabel('IPI (ms)')
plotUnity;
mymakeaxis(gca, 'xytitle', 'Observed',...
    'xticks', [500, 700, 900], 'yticks', [500, 700, 900],...
    'font_size', 20)
%legend1 = legend([l1, l2], {'Model', 'Observed', ''});


%% Model ts-tp
bias_thirdM = squeeze(meanITI_model(subject_id, :, 3)) - durs;
std_thirdM = squeeze(stdITI_model(subject_id, :, 3));
bias_fifthM = squeeze(meanITI_model(subject_id, :, 7)) - durs;
std_fifthM = squeeze(stdITI_model(subject_id, :, 7));

subplot('122')
l1 = errorbar(durs, durs + bias_thirdM, std_thirdM, 'Color', color_sync_mean, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', color_sync_mean, 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
l2 = errorbar(durs + 5, durs + bias_fifthM, std_fifthM, 'Color', color_cont_mean, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', color_cont_mean, 'MarkerSize', 4,...
    'LineWidth', 1.5);

l3 = plot(durs, durs + bias_thirdM, 'Color', color_sync_mean);
l4 = plot(durs + 5, durs + bias_fifthM, 'Color', color_cont_mean);
xlim([500, 900])
ylim([500, 950])
xlabel('ISI (ms)')
ylabel('IPI (ms)')
plotUnity;
mymakeaxis(gca, 'xytitle', 'Model',...
    'xticks', [500, 700, 900], 'yticks', [500, 700, 900],...
    'font_size', 20)
legend1 = legend([l1, l2], {'Synchronization', 'Continuation'},...
    'FontSize', 16,...
    'Color', 'none',...
    'EdgeColor', 'none',...
    'Position', [0.75,0.38,0.24,0.075]);



