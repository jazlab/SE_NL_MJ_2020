%% 1-2-Go
load SAM_MPM_time_comparisons_1-2-Go.mat
figure;
subplot(121);
errorbar(durations, meansSAM, stdsSAM)
hold on
errorbar(durations, meansMPM, stdsMPM)
ylim([30 110])

% 1-2-3-Go
load SAM_MPM_time_comparisons_1-2-3-Go.mat
subplot(122);
errorbar(durations, meansSAM, stdsSAM)
hold on
errorbar(durations, meansMPM, stdsMPM)
ylim([30 110])


%% Simulation states
load SAM_MPM_time_simulation_states_1-2-Go.mat
T = size(Ilst_MPM, 1);
tpoints = (1:T) * 10 / 1000;
subplot(411)
plot(tpoints, ulstMPM, 'b')
hold on
plot(tpoints, ulstSAM, 'r')

subplot(412)
plot(tpoints, vlstMPM, 'b')
hold on
plot(tpoints, vlstSAM, 'r')

subplot(413)
plot(tpoints, ylstMPM, 'b')
hold on
plot(tpoints, ylstSAM, 'r')

subplot(414)
plot(Ilst_MPM, 'b')
hold on
plot(Ilst_SAM, 'r')
