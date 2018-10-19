close all;

load SWE_sim_results.mat

figure;
subplot('121')
errorbar(tss, mtp_in(:,1), stdtp_in(:,1),...
    'r')
hold on;
errorbar(durations + 5, prod_time_lst * 10,...
    prod_var_lst * 10, 'b')
xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-Go', ...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex')


subplot('122')
errorbar(tss, mtp_in(:,2), stdtp_in(:,2),...
    'r')
hold on;
errorbar(durations + 5, prod_time_lst2 * 10,...
    prod_var_lst2 * 10, 'b')
xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-3-Go',...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex')

