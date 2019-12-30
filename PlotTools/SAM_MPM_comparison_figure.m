%% 1-2-Go
load SAM_MPM_time_comparisons_1-2-Go.mat
ys_color = [177, 80, 158]/255;
yp_color = [230, 35, 40]/255;
figure;
subplot(121);
offset = 5;
errorbar(durations + offset, meansSAM * 10, stdsSAM * 10, 'Color', ys_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', ys_color, 'MarkerSize', 4,...
    'LineWidth', 1.5)
hold on
plot(durations + offset, meansSAM * 10, 'Color', ys_color)

errorbar(durations, meansMPM * 10, stdsMPM * 10, 'Color', yp_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', yp_color, 'MarkerSize', 4,...
    'LineWidth', 1.5)
plot(durations, meansMPM * 10, 'Color', yp_color)
ylim([300 1100])
mymakeaxis('xytitle', '$N = 2$', 'x_label', 'ISI (s)', 'y_label', '$t_p$ (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)


% 1-2-3-Go
load SAM_MPM_time_comparisons_1-2-3-Go.mat
subplot(122);
l1 = errorbar(durations + offset, meansSAM * 10, stdsSAM * 10, 'Color', ys_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', ys_color, 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on
plot(durations + offset, meansSAM * 10, 'Color', ys_color)

l2 = errorbar(durations, meansMPM * 10, stdsMPM * 10, 'Color', yp_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', yp_color, 'MarkerSize', 4,...
    'LineWidth', 1.5);
plot(durations, meansMPM * 10, 'Color', yp_color)
ylim([300 1100])


mymakeaxis('xytitle', '$N = 3$', 'x_label', 'ISI (s)', 'y_label', '$t_p$ (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
legend([l1, l2], {'SAM only', 'SAM + MPM'}, 'Location', 'southeast')

%% Inset for phase difference 
%1-2-Go
load SAM_MPM_time_comparisons_1-2-Go.mat
ys_color = [177, 80, 158]/255;
yp_color = [230, 35, 40]/255;
figure;
subplot(121);
offset = 5;
errorbar(durations + offset, meansSAM * 10 - durations, stdsSAM * 10, 'Color', ys_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', ys_color, 'MarkerSize', 4,...
    'LineWidth', 1.5)
hold on
plot(durations + offset, meansSAM * 10 - durations, 'Color', ys_color)

errorbar(durations, meansMPM * 10 - durations, stdsMPM * 10, 'Color', yp_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', yp_color, 'MarkerSize', 4,...
    'LineWidth', 1.5)
plot(durations, meansMPM * 10 - durations, 'Color', yp_color)
plotHorizontal(0)
ylim([-250 250])
mymakeaxis('xytitle', '$N = 2$', 'x_label', 'ISI (s)', 'y_label', '$t_p$ - ISI (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)


% 1-2-3-Go
load SAM_MPM_time_comparisons_1-2-3-Go.mat
subplot(122);
l1 = errorbar(durations + offset, meansSAM * 10 - durations, stdsSAM * 10, 'Color', ys_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', ys_color, 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on
plot(durations + offset, meansSAM * 10 - durations, 'Color', ys_color)

l2 = errorbar(durations, meansMPM * 10 - durations, stdsMPM * 10, 'Color', yp_color, 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', yp_color, 'MarkerSize', 4,...
    'LineWidth', 1.5);
plot(durations, meansMPM * 10 - durations, 'Color', yp_color)
plotHorizontal(0)

ylim([-250 250])


mymakeaxis('xytitle', '$N = 3$', 'x_label', 'ISI (s)', 'y_label', '$t_p$ - ISI (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
%legend([l1, l2], {'SAM only', 'SAM + MPM'}, 'Location', 'southeast')

%% Simulation states
ys_color = [177, 80, 158]/255;
yp_color = [230, 35, 40]/255;

load SAM_MPM_time_simulation_states_1-2-Go.mat
duration = 1000;
dt = 10;
[nsteps, ntrials] = size(ulstMPM);
duration = double(duration);

gap = 3;

T = size(Ilst_MPM, 1);
tpoints = (1:T) * 10 / 1000;
subplot(411)
h1 = plot(tpoints, ulstMPM(:, 1:50), 'Color', yp_color);
for i = 1:50
    h1(i).Color(4) = 0.1;
end
hold on
plot(tpoints, ulstSAM(:, 1:50), '--' , 'Color', ys_color)
xlim([0, 4.2])
ylim([0.8, 1]);
plotFlashes(dt, duration/10, 3)
mymakeaxis(gca, 'yticks',[0.8, 1], 'y_label', '$u$', 'interpreter', ...
    'latex')

subplot(412)
plot(tpoints, vlstMPM(:, 1:50), 'Color', yp_color)
hold on
plot(tpoints, vlstSAM(:, 1:50), '--', 'Color', ys_color)
xlim([0, 4.2])
ylim([0.2, 0.4])
plotFlashes(dt, duration/10, 3)


mymakeaxis(gca,'y_label', '$v$', 'interpreter', 'latex', 'yticks', [0.2, 0.4])

subplot(413)
l1 = plot(tpoints, ylstMPM(:, 1:50), 'Color', yp_color);
hold on
l2 = plot(tpoints, ylstSAM(:, 1:50), '--', 'Color', ys_color);
xlim([0, 4.2])
ylim([0.5, 0.72])
plotFlashes(dt, duration/10, 3)

plotHorizontal(0.7);
txt = '$y_0$';
text(3,0.72,txt, 'interpreter', 'latex', 'FontSize', 16)


mymakeaxis(gca,'y_label', '$y$', 'interpreter', 'latex', 'yticks', [0.6, 0.7])


subplot(414)
plot(tpoints, Ilst_MPM(:, 1:50), 'Color', yp_color)
hold on
plot(tpoints, Ilst_SAM(:, 1:50), '--', 'Color', ys_color)
xlim([0, 4.2])
ylim([0.76, 0.8]);
plotFlashes(dt, duration/10, 3)

plotHorizontal(Ilst_MPM(1));
txt = '$I_0$';
text(0.5,0.78,txt, 'interpreter', 'latex', 'FontSize', 16)

mymakeaxis(gca,'y_label', '$I$', 'interpreter', 'latex')
legend([l1(1), l2(1)], {'MPM', 'SAM'});
% x-axis label
thandle2 = text(2,0.7,...
    'Time (s)','interpreter','tex', 'FontName', 'helvetica-narrow', ...
    'FontAngle', 'italic');
set(thandle2,'HorizontalAlignment','center');
set(thandle2,'VerticalAlignment', 'baseline');
set(thandle2,'FontSize',16);

print(gcf, '-painters', '-dpdf', 'SAM_MPM_comparison.pdf')


function plotFlashes(dt, target, nFlash)
    % First flash is at 750 ms
    plotVertical(750 / 1000)

    % Then plot the remaining flashes
    for i = 1:nFlash
        disp(dt * target * i / 1000)
        plotVertical(0.75 + dt * target * i / 1000)
    end
end