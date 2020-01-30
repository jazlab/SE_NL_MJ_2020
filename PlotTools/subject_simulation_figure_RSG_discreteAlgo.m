close all;

load subject_biasvar_discreteAlgo.mat

purple = [164, 101, 168] / 255;

id = 2; %SWE = 6, GB = 2
tss = tss * 1000;
durations = tss;

mtp_in = squeeze(mtp_in_all(id,:,:));
stdtp_in = squeeze(stdtp_in_all(id,:,:));

prod_time_lst = prod_time_lst_all(id,:) * 1000;
prod_var_lst = prod_std_lst_all(id,:) * 1000;
prod_time_lst2 = prod_time_lst2_all(id,:) * 1000;
prod_var_lst2 = prod_std_lst2_all(id,:) * 1000;

figure('Position', [100, 200, 800, 500]);
h1 = subplot('121');
errorbar(tss, mtp_in(:,1), stdtp_in(:,1),...
    'k', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'k', 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
errorbar(durations + 5, prod_time_lst,...
    prod_var_lst, 'Color', purple, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', purple, 'MarkerSize', 4,...
    'LineWidth', 1.5)
plot(durations + 5, prod_time_lst, 'Color', purple)
plot(durations, mtp_in(:,1), 'k')
xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-Go', ...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex', 'font_size', 20)

axis square

h2 = subplot('122');
l1 = errorbar(tss, mtp_in(:,2), stdtp_in(:,2),...
    'k', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'k', 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
l2 = errorbar(durations + 5, prod_time_lst2,...
    prod_var_lst2, 'Color', purple, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', purple, 'MarkerSize', 4,...
    'LineWidth', 1.5);

l3 = plot(durations + 5, prod_time_lst2, 'Color', purple);
l4 = plot(durations, mtp_in(:,2), 'k');


xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-3-Go',...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex', 'font_size', 20)
legend1 = legend([l1, l2], {'Model', 'Observed', ''});

set(legend1,...
    'Position',[0.83 0.42 0.05 0.05],...
    'EdgeColor',[0.94 0.94 0.94],...
    'Color',[0.941 0.941 0.94],...
    'FontSize', 18);
axis square

set(h1, 'Position', [0.05, 0.11, 0.43, 0.82]);
set(h2, 'Position', [0.5, 0.11, 0.43, 0.82]);

