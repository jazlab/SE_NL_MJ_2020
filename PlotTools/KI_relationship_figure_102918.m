load IK_sim_relationship.mat


%%
% Start plotting
figure;
for i = 1:numel(sigma_lst)
    Ksorted = KLST(i,:);
    Isorted = ILST(i,:);
    Imeans(i) = mean(Isorted);
    Kmeans(i) = mean(Ksorted);
    s1 = subplot('121');
    scatter(ones(1, numel(Ksorted)) * sigma_lst(i), Ksorted, 'bo', ...
        'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.4, ...
        'MarkerEdgeColor', 'none');
    hold on;
    s2 = subplot('122');
    h1 = scatter(ones(1, numel(Isorted)) * sigma_lst(i), Isorted, 'bo',...
        'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.4,...
        'MarkerEdgeColor','none');
    hold on;
end

subplot('121')
plot(sigma_lst, Kmeans, 'b--', 'LineWidth', 2)


subplot('122')
plot(sigma_lst, Imeans, 'b--', 'LineWidth', 2)



%% Subject data
sigma = [0.009, 0.018, 0.023, 0.007, 0.021, 0.009, 0.020, 0.025, 0.027];
Iinit = [0.781, 0.780, 0.780, 0.782, 0.781, 0.782, 0.781, 0.779, 0.777];
K = [2.55, 1.10, 1.28, 2.76, 1.65, 2.89, 0.78, 0.67, 0.75];
subplot('121')
scatter(sigma, K, 'ro', 'filled');
mymakeaxis(gca,'y_label', '$K$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
    'xticks', [0, 0.05], 'font_size', 20)

subplot('122')
h2 = scatter(sigma, Iinit, 'ro', 'filled');
%ylim([0.77, 0.79])
mymakeaxis(gca,'y_label', '$I_0$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
     'xticks', [0, 0.05], 'font_size', 20)
l1 = legend([h1, h2], {'Optimal, model', 'Observed'});

set(s1, 'Position', [0.1 -0.05 0.4 0.9]);
set(s2, 'Position', [0.57 -0.05 0.4 0.9]);
set(l1,...
    'Position',[0.329029738161646 0.865092817223505 0.46361501312032 0.058267714986651],...
    'Orientation','horizontal',...
    'FontSize',20,...
    'EdgeColor','none',...
    'Color','none');