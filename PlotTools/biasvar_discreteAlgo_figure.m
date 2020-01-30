%load('C:\Users\Le\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\MatlabAnalyses\biasvar_dualProcess_191219.mat');
load subject_biasvar_discreteAlgo.mat

%% Calculate bias and variance
% Calculate bias and variance for model
sqbias1 = (prod_time_lst_all - tss).^2;
sqbias2 = (prod_time_lst2_all - tss).^2;
biasmodel1 = sqrt(sum(sqbias1, 2) / numel(tss)) * 1000;
biasmodel2 = sqrt(sum(sqbias2, 2) / numel(tss)) * 1000;

sqstd1 = (prod_std_lst_all).^2;
sqstd2 = (prod_std_lst2_all).^2;
varmodel1 = sqrt(sum(sqstd1, 2) / numel(tss)) * 1000;
varmodel2 = sqrt(sum(sqstd2, 2) / numel(tss)) * 1000;

% Calculate bias and variance for subjects
mtp_in1 = mtp_in_all(:,:,1);
mtp_in2 = mtp_in_all(:,:,2);
sqbias1 = (mtp_in1 - tss * 1000).^2;
sqbias2 = (mtp_in2 - tss * 1000).^2;
bias1 = sqrt(sum(sqbias1, 2) / numel(tss));
bias2 = sqrt(sum(sqbias2, 2) / numel(tss));

sqstd1 = (stdtp_in_all(:,:,1)).^2;
sqstd2 = (stdtp_in_all(:,:,2)).^2;
var1 = sqrt(sum(sqstd1, 2) / numel(tss));
var2 = sqrt(sum(sqstd2, 2) / numel(tss));








%% Plot
plotBiasVarNhat([bias1 bias2], [var1 var2], ...
    [biasmodel1 biasmodel2], [varmodel1 varmodel2]);

color_sync_mean = [0 0 255]/255;
color_cont_mean = [255,0,0]/255;


%% Compare bias for 1-2-Go and 1-2-3-Go (model)
figure;
% Plot bias for all subjects
l1 = plot(ones(1, 9) * 0.9, bias1(1:9), 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 9) * 1.1, bias2(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

% Plot model bias
plot(ones(1, 9) * 1.9, biasmodel1(1:9),  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 9) * 2.1, biasmodel2(1:9),  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

for i = 1:9
    plot([0.9 1.1], [bias1(i) bias2(i)], 'k');
    plot([1.9 2.1], [biasmodel1(i) biasmodel2(i)], 'k');
end

%xlabel('ISI (ms)')
ylabel('Bias (ms)')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'Observed', 'Model'},...
    'yticks', [0 50 100 150])
legend([l1 l2], {'1-2-Go', '1-2-3-Go'}, 'Orientation', 'horizontal',...
    'Position', [0.44,0.89,0.44,0.04], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')


