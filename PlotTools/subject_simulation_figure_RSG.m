close all;

load SWE_sim_results.mat

figure('Position', [100, 200, 1000, 600]);
h1 = subplot('121');
errorbar(tss, mtp_in(:,1), stdtp_in(:,1),...
    'r', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'r', 'MarkerSize', 4,...
    'LineWidth', 1.2);
hold on;
errorbar(durations + 5, prod_time_lst * 10,...
    prod_var_lst * 10, 'b', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'b', 'MarkerSize', 4,...
    'LineWidth', 1.2)
plot(durations + 5, prod_time_lst * 10, 'b')
plot(durations, mtp_in(:,1), 'r')
xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-Go', ...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex')

axis square

h2 = subplot('122');
errorbar(tss, mtp_in(:,2), stdtp_in(:,2),...
    'r', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'r', 'MarkerSize', 4,...
    'LineWidth', 1.2)
hold on;
errorbar(durations + 5, prod_time_lst2 * 10,...
    prod_var_lst2 * 10, 'b', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'b', 'MarkerSize', 4,...
    'LineWidth', 1.2)

plot(durations + 5, prod_time_lst2 * 10, 'b')
plot(durations, mtp_in(:,2), 'r')

xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-3-Go',...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex')

axis square

set(h1, 'Position', [0.05, 0.11, 0.43, 0.82]);
set(h2, 'Position', [0.5, 0.11, 0.43, 0.82]);

