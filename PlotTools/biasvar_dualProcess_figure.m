if strcmp(getenv('computername'), 'LMN')
    load('C:\Users\Le\Documents\MIT\Jazayeri\Seth_Noisy_Mutual_Inhibition\NoisyMutualInhibition\MatlabAnalyses\biasvar_dualProcess_013020c.mat');
else
    load('C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\MatlabAnalyses\biasvar_dualProcess_013020.mat');
end

bias1 = collated_bias_var(:,2);
biasmodel1 = collated_bias_var(:,1);
bias2 = collated_bias_var(:,4);
biasmodel2 = collated_bias_var(:,3);

var1 = collated_bias_var(:,6);
varmodel1 = collated_bias_var(:,5);
var2 = collated_bias_var(:,8);
varmodel2 = collated_bias_var(:,7);


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


