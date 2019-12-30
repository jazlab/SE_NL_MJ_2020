%% Left panel: 400 ms interval simulation
load uv_simulation_data191119_K5_00_I0_77_s0_01_400ms_regime2.mat

duration = 400;
dt = double(PARAMS.dt);
[nsteps, ntrials] = size(ulst);
duration = double(duration);

tstamps = double(1:nsteps) * double(dt) / 1000;
orange = [255 204 0]/255;
pink = projectColorMaps('ts','samples',2,'sampleDepth',2);
blue = projectColorMaps('ts','samples',1,'sampleDepth',2);
%figure('Name','Residual \sqrt{VAR}','Position',[200 296 800 372])

f = figure;
set(f, 'Position', [1 1 800 600]);

l1 = subplot(4,2,1);
h1 = plot(tstamps, ulst, 'Color',blue,...
    'LineWidth',2.0);
% for i = 1:100
%     h1(i).Color(4) = 0.1;
% end

xlim([0, 4.2])
ylim([0.7, 1.0]);
hold on;
plotFlashes(dt, duration/10, 3)
mymakeaxis(gca, 'yticks',[0.7, 1.0], 'y_label', '$u$', 'interpreter', ...
    'latex')

% Title
title_handle = text(2,1.2,...
    'ISI = 400 ms','interpreter','tex', 'FontName', 'helvetica-narrow', ...
    'FontAngle', 'italic');
set(title_handle,'HorizontalAlignment','center');
set(title_handle,'VerticalAlignment', 'top');
set(title_handle,'FontSize',16);


l2 = subplot(4,2,3);
h2 = plot(tstamps, vlst, 'Color', blue,...
    'LineWidth',2.0);
% for i = 1:100
%     h2(i).Color(4) = 0.1;
% end
xlim([0, 4.2])
ylim([0.2, 0.8])
hold on;
plotFlashes(dt, duration/10, 3)
mymakeaxis(gca,'y_label', '$v$', 'interpreter', 'latex', 'yticks', [0.2, 0.8])

l3 = subplot(4,2,5);
h3 = plot(tstamps, ylst, 'Color',blue,...
    'LineWidth',2.0);
% for i = 1:100
%     h3(i).Color(4) = 0.1;
% end
xlim([0, 4.2])
ylim([0.1, 0.5])
hold on;
plotHorizontal(PARAMS.y0);
plotFlashes(dt, duration/10, 3)
mymakeaxis(gca,'y_label', '$y$', 'interpreter', 'latex', 'yticks', [0.1, 0.5])
% Add a text
txt = '$y_0$';
text(3,0.3,txt,'interpreter', 'latex', 'FontSize', 16)


l4 = subplot(4,2,7);
h4 = plot(tstamps, Ilst, 'Color',blue,...
    'LineWidth',2.0);
% for i = 1:100
%     h4(i).Color(4) = 0.1;
% end
xlim([0, 4.2])
ylim([0.95, 1.05]);
hold on;
plotHorizontal(Ilst(1));
txt = '$I_0$';
text(3,1.0,txt, 'interpreter', 'latex', 'FontSize', 16)
plotFlashes(dt, duration/10, 3)
mymakeaxis(gca,'y_label', '$I$', 'interpreter', 'latex')

% x-axis label
thandle = text(2,0.85,...
    'Time (ms)','interpreter','tex', 'FontName', 'helvetica-narrow', ...
    'FontAngle', 'italic');
set(thandle,'HorizontalAlignment','center');
set(thandle,'VerticalAlignment', 'baseline');
set(thandle,'FontSize',16);



%% Right panel: 1000 ms interval simulation
load uv_simulation_data191119_K5_00_I0_77_s0_01_1000ms_regime2.mat

duration = 1000;
dt = double(PARAMS.dt);
[nsteps, ntrials] = size(ulst);
duration = double(duration);

tstamps = double(1:nsteps) * double(dt) / 1000;

r1 = subplot(4,2,2);
h1 = plot(tstamps, ulst, 'Color',pink,...
    'LineWidth',2.0);
% for i = 1:100
%     h1(i).Color(4) = 0.1;
% end

xlim([0, 4.2])
ylim([0.7, 1.0]);
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca, 'yticks',[0.7, 1.0], 'y_label', '$u$', 'interpreter', 'latex')

% Title
title_handle2 = text(2,1.2,...
    'ISI = 1000 ms','interpreter','tex', 'FontName', 'helvetica-narrow', ...
    'FontAngle', 'italic');
set(title_handle2,'HorizontalAlignment','center');
set(title_handle2,'VerticalAlignment', 'top');
set(title_handle2,'FontSize',16);


r2 = subplot(4,2,4);
h2 = plot(tstamps, vlst, 'Color',pink,...
    'LineWidth',2.0);
% for i = 1:100
%     h2(i).Color(4) = 0.1;
% end
xlim([0, 4.2])
ylim([0.2, 0.8])
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$v$', 'interpreter', 'latex', 'yticks', [0.2, 0.8])

r3 = subplot(4,2,6);
h3 = plot(tstamps, ylst, 'Color',pink,...
    'LineWidth',2.0);
% for i = 1:100
%     h3(i).Color(4) = 0.1;
% end
xlim([0, 4.2])
ylim([0.1, 0.5])
hold on;
plotHorizontal(PARAMS.y0);
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$y$', 'interpreter', 'latex', 'yticks', [0.1 0.5])
txt = '$y_0$';
text(3.4,0.3,txt, 'interpreter', 'latex', 'FontSize', 16)

r4 = subplot(4,2,8);
h4 = plot(tstamps, Ilst, 'Color',pink,...
    'LineWidth',2.0);
hold on
% for i = 1:100
%     h4(i).Color(4) = 0.1;
% end
plotHorizontal(Ilst(1));
txt = '$I_0$';
text(3.4,1.0,txt, 'interpreter', 'latex', 'FontSize', 16)

xlim([0, 4.2])
ylim([0.95, 1.05]);
%xlab = xlabel('Time (ms)');
%set(xlab, 'Position', [2,0.7,0]);

hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$I$', 'interpreter', 'latex')

% x-axis label
thandle2 = text(2,0.85,...
    'Time (ms)','interpreter','tex', 'FontName', 'helvetica-narrow', ...
    'FontAngle', 'italic');
set(thandle2,'HorizontalAlignment','center');
set(thandle2,'VerticalAlignment', 'baseline');
set(thandle2,'FontSize',16);


% xlab = xlabel('Time (ms)');
% set(xlab, 'Position', [2,0.7,0]);
print(gcf, '-painters', '-dpdf', 'uv-simulation-regime2.pdf')


%% Link axes
linkaxes([l1 r1], 'x')
linkaxes([l2 r2], 'x')
linkaxes([l3 r3], 'x')
linkaxes([l4 r4], 'x')

print(gcf, '-painters', '-dpdf', 'Figures/uv-simulation_figure_regime2.pdf')

function plotFlashes(dt, target, nFlash)
    % First flash is at 750 ms
    plotVertical(750 / 1000)

    % Then plot the remaining flashes
    for i = 1:nFlash
        disp(dt * target * i / 1000)
        plotVertical(0.75 + dt * target * i / 1000)
    end
end

