%% Left panel: 400 ms interval simulation
load uv_simulation_data102618_sigma0-01_K3_I0-765_400ms.mat

dt = double(PARAMS.dt);
[nsteps, ntrials] = size(ulst);
duration = double(duration);

tstamps = double(1:nsteps) * double(dt) / 1000;

figure;

l1 = subplot(4,2,1);
h1 = plot(tstamps, ulst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h1(i).Color = [0,0,0,0.1];
end

xlim([0, 4.2])
ylim([0.8, 1]);
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca, 'yticks',[0.8, 1], 'y_label', '$u$', 'interpreter', ...
    'latex', 'xytitle', '$\Delta T = 400 ms$')


l2 = subplot(4,2,3);
h2 = plot(tstamps, vlst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h2(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.2, 0.4])
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$v$', 'interpreter', 'latex', 'yticks', [0.2, 0.4])

l3 = subplot(4,2,5);
h3 = plot(tstamps, ylst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h3(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.5, 0.72])
hold on;
plotHorizontal(0.7);
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$y$', 'interpreter', 'latex', 'yticks', [0.6, 0.7])


l4 = subplot(4,2,7);
h4 = plot(tstamps, Ilst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h4(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.735, 0.78]);
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$I$', 'interpreter', 'latex', 'x_label', ...
    'Time (s)')

%% Right panel: 800 ms interval simulation
load uv_simulation_data102618_sigma0-01_K3_I0-765_800ms.mat

dt = double(PARAMS.dt);
[nsteps, ntrials] = size(ulst);
duration = double(duration);

tstamps = double(1:nsteps) * double(dt) / 1000;

r1 = subplot(4,2,2);
h1 = plot(tstamps, ulst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h1(i).Color = [0,0,0,0.1];
end

xlim([0, 4.2])
ylim([0.8, 1]);
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca, 'yticks',[0.8, 1], 'y_label', '$u$', 'interpreter', 'latex',...
    'xytitle', '$\Delta T = 800 ms$')


r2 = subplot(4,2,4);
h2 = plot(tstamps, vlst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h2(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.2, 0.4])
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$v$', 'interpreter', 'latex', 'yticks', [0.2, 0.4])

r3 = subplot(4,2,6);
h3 = plot(tstamps, ylst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h3(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.5, 0.72])
hold on;
plotHorizontal(0.7);
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$y$', 'interpreter', 'latex', 'yticks', [0.6, 0.7])


r4 = subplot(4,2,8);
h4 = plot(tstamps, Ilst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h4(i).Color = [0,0,0,0.1];
end
xlim([0, 4.2])
ylim([0.735, 0.78]);
hold on;
plotFlashes(dt, duration/10, 5)
mymakeaxis(gca,'y_label', '$I$', 'interpreter', 'latex', 'x_label', 'Time (s)')

%% Link axes
linkaxes([l1 r1], 'x')
linkaxes([l2 r2], 'x')
linkaxes([l3 r3], 'x')
linkaxes([l4 r4], 'x')

function plotFlashes(dt, target, nFlash)
    for i = 1:nFlash
        disp(dt * target * i / 1000)
        plotVertical(dt * target * i / 1000)
    end
end