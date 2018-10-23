load uv_simulation_data101518.mat

dt = double(PARAMS.dt);
[nsteps, ntrials] = size(ulst);

tstamps = double(1:nsteps) * double(dt) / 1000;

figure;
subplot(4,1,1)
h1 = plot(tstamps, ulst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h1(i).Color = [0,0,0,0.1];
end

ylim([0.7, 1]);
alpha(0.5)
mymakeaxis(gca, 'yticks',[0.7, 1], 'y_label', 'u')
plotFlashes(dt, 3)

subplot(4,1,2)
h2 = plot(tstamps, vlst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h2(i).Color = [0,0,0,0.1];
end
alpha(0.05)
ylim([0.2, 0.5])
mymakeaxis(gca,'y_label', 'v', 'yticks', [0.2, 0.5])
plotFlashes(dt, 3)
%plotVertical(80);

subplot(4,1,3)
h3 = plot(tstamps, ylst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
for i = 1:10
    h3(i).Color = [0,0,0,0.1];
end
ylim([0.5, 0.8])
hold on;
plotHorizontal(0.7);
mymakeaxis(gca,'y_label', 'y', 'yticks', [0.5, 0.7])
plotFlashes(dt, 3)
%plotVertical(80);

subplot(4,1,4)
h4 = plot(tstamps, Ilst(:,1:10), 'Color',projectColorMaps('epoch','samples',1,'sampleDepth',1),...
    'LineWidth',2);
ylim([0.77, 0.79])
for i = 1:10
    h4(i).Color = [0,0,0,0.1];
end
alpha(0.5)
mymakeaxis(gca,'y_label', 'I', 'x_label', 'Time (ms)')
plotFlashes(dt, 3)

function plotFlashes(dt, nFlash)
    for i = 1:nFlash
        plotVertical(dt * 80 * i / 1000)
    end
end