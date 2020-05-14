load('C:\Users\Le\Dropbox (MIT)\Jazayeri\NoisyMutualInhibition_Dec2019\PlotTools\IK_relationship_multi_020719_thres0_7_constant_stage0_750ms_optimized3_Krange1to7B.mat');
%close all
colors = [247,251,255
    222,235,247
    198,219,239
    158,202,225
    107,174,214
    66,146,198
    33,113,181
    8,81,156
    8,48,107] / 255;



mean_K = mean(Kresults, 3);
mean_I = mean(Iresults, 3);

std_K = std(Kresults, [], 3);
std_I = std(Iresults, [], 3);

%% Plot IK simulation
% figure;
% hold on;
% for i = [8]
%     KLST = squeeze(Kresults(i,:,:));
%     ILST = squeeze(Iresults(i,:,:));
%     subplot(121)
%     plot(sigma_lst, KLST, 'b.', 'MarkerSize', 15)
% 
%     subplot(122)
%     plot(sigma_lst, ILST, 'b.', 'MarkerSize', 15)
% end
% 
% %% Plot IK simulation
% for i = [2]
%     KLST = squeeze(Kresults(i,:,:));
%     ILST = squeeze(Iresults(i,:,:));
%     subplot(121)
%     hold on;
%     plot(sigma_lst, KLST, 'g.', 'MarkerSize', 15)
% 
%     subplot(122)
%     hold on;
%     plot(sigma_lst, ILST, 'g.', 'MarkerSize', 15)
% end




%% Plot IK simulation
% Start plotting
figure;
pairings = [3, 4, 3, 3, 6, 6, 6, 7, 6, 6, 9, 9, 9];
nstages_plot = [1, 2, 5, 8];
color_plot = [4, 5, 8, 9];

ebars = [];

for i = 1:4
    nstages = nstages_plot(i);
    meanI_single = mean_I(nstages,:);
    meanK_single = mean_K(nstages,:);
    
    stdI_single = std_I(nstages,:);
    stdK_single = std_K(nstages,:);
    
    s1 = subplot('121');
    h = errorbar(sigma_lst + i * 0.001 - 0.002, meanI_single, stdI_single, ...
        'LineStyle', 'none', 'LineWidth', 1.5, ...
        'Marker', 'o', 'MarkerFaceColor', 'auto', 'MarkerSize', 4, ...
        'Color', colors(color_plot(i),:), 'CapSize', 5);
    hold on;
    
    ebars = [ebars h];
    
    s2 = subplot('122');
    errorbar(sigma_lst, meanK_single, stdK_single, ...
        'LineStyle', 'none', 'LineWidth', 1.5, ...
        'Marker', 'o', 'MarkerFaceColor', 'auto', 'MarkerSize', 4, ...
        'Color', colors(color_plot(i),:), 'CapSize', 5);
    hold on;
    plot(sigma_lst, meanK_single, 'Color', colors(color_plot(i),:));
    
end


%% Plot subject fit
% load IK_subject_fit_021119_thres0_7_constant_stage0_750ms_Krange1to8_Irange77to79_sigma005to04.mat
% 
% sigma = combi_arr(:,1);
% Iinit = combi_arr(:,2);
% K = combi_arr(:,3);
subplot('122')
% hold on;
% h2 = scatter(sigma, K, 'ro', 'filled');
mymakeaxis(gca,'y_label', '$K$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
    'xticks', [0, 0.04], 'font_size', 20)
% 
subplot('121')
% hold on
% h2 = scatter(sigma, Iinit, 'ro', 'filled');
% %ylim([0.77, 0.79])
mymakeaxis(gca,'y_label', '$I_0$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
      'xticks', [0, 0.04], 'font_size', 20)
l1 = legend(ebars, {'2', '3', '6', '9'});
title(l1, 'Number of stimuli')
%l1.Title.NodeChildren.Position = [0.5000, 1.3, 0];

%set(s1, 'Position', [0.05 -0.05 0.35 1.3]);
%set(s2, 'Position', [0.5 -0.05 0.35 1.3]);
set(l1,...
    'Position',[0.62 0.75 0.46 0.18],...
    'Orientation','vertical',...
    'FontSize',15,...
    'EdgeColor','none',...
    'Color','none');