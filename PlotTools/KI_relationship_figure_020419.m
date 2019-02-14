load IK_relationship_multi_020519_thres0_7_constant_stage0_750ms_optimized3_Krange1to7

KLST = squeeze(Kresults(13,:,:));
ILST = squeeze(Iresults(13,:,:));

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
load IK_subject_fit_020519_thres0_7_constant_stage0_500ms_optimized8.mat
sigma = combi_arr(1:9,1);
Iinit = combi_arr(1:9,2);
K = combi_arr(1:9,3);
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