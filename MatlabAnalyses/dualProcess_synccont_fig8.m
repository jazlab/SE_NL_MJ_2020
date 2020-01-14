%% Define folder to use
global folder
switch getenv('computername')
    case 'DESKTOP-FN1P6HD'
        folder = 'C:\Users\Sur lab\Dropbox (MIT)\Jazayeri\SyncContData';
    otherwise
        folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
end

%IPI = dualProcessNoiseSyncCont(600,0.2,0.1,3,20,[400 400 400], 50);
%mse = find_error([600 0.2 0.1], 'AL_2_20170719_SynCon_ITIs.mat');
        
%% Parameter fitting for sync-cont using fminsearch
% params = [600, 0.2, 0.1];
% rng(123);
% options = optimset('PlotFcns',@optimplotfval);
% all_subject_files = {'AL_2_20170719_SynCon_ITIs.mat',...
%     'ER_2_20170718_SynCon_ITIs.mat',...
%     'FK_2_20170721_SynCon_ITIs.mat',...
%     'KL_2_20170721_SynCon_ITIs.mat',...
%     'MW_2_20170720_SynCon_ITIs.mat',...
%     'RC_2_20170721_SynCon_ITIs.mat'};
% 
% sigma = 50;
% nSteps = 3;
% ncont = 17;
% ntrials = 100;
% tmax = 20;
% 
% params_opt_all_subjects = nan(numel(all_subject_files), 3);
% for i = 1:6
%     filename = all_subject_files{i};
%     params_opt = fminsearch(@(x) find_error(x, filename), params, options);
%     params_opt_all_subjects(i,:) = params_opt;
% end




%% Simulate and compare
load dualProcess_params_subjects_011320.mat
figure;
tmax = 20;
target_biases = nan(numel(all_subject_files), tmax);
model_biases = nan(numel(all_subject_files), tmax);
%params_opt_all_subjects = params_all_subjects;
sigma = 50;
nSteps = 3;
ncont = 17;
ntrials = 100;
tmax = 20;
figure;
for i = 1:numel(all_subject_files)
    IPI0 = params_opt_all_subjects(i, 1);
    Beta = params_opt_all_subjects(i, 2);
    alpha = params_opt_all_subjects(i, 3);

    % Calculate the target
%     folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
    filename = all_subject_files{i};
    load(fullfile(folder, filename), 'allDur_mean', 'durs');
    IPIs_all = cell2mat(allDur_mean');
    IPIs_all = IPIs_all(:, 1:tmax);
    bias = IPIs_all - durs;
    target = sqrt(nanmean(bias.^2)) * 1000;

    % Simulation
    mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, durs' * 1000, sigma, ntrials);
    mse = nanmean(sum(mean_bias - target').^2);

    % Plot
    subplot(121)
    plot(target);
    ylim([0 300])
    hold on
    subplot(122);
    plot(mean_bias);
    ylim([0 300])
    hold on
    
    target_biases(i,:) = target;
    model_biases(i,:) = mean_bias;
end

%% Fig. 8c
subject_id = 2;
IPI0 = params_opt_all_subjects(subject_id, 1);
Beta = params_opt_all_subjects(subject_id, 2);
alpha = params_opt_all_subjects(subject_id, 3);

IPI_firsts = nan(ntrials, numel(durs));
IPI_seconds = nan(ntrials, numel(durs));
IPI_thirds = nan(ntrials, numel(durs));
IPI_sevenths = nan(ntrials, numel(durs));

for i = 1:numel(durs)
    ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
    IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma, ntrials);
    IPI_firsts(:,i) = IPI_lst(4,:);
    IPI_seconds(:,i) = IPI_lst(5,:);
    IPI_thirds(:,i) = IPI_lst(6,:);
    IPI_sevenths(:,i) = IPI_lst(8,:);
end

% Plot
figure;
hold on
l1 = errorbar(durs, mean(IPI_firsts), std(IPI_firsts));
l2 = errorbar(durs, mean(IPI_seconds), std(IPI_seconds));
l3 = errorbar(durs, mean(IPI_thirds), std(IPI_thirds));
l4 = errorbar(durs, mean(IPI_sevenths), std(IPI_sevenths));

legend([l1, l2, l3, l4], {'1st', '2nd', '3rd', '7th'})


%% Slope and midpoint
slopes_first = zeros(1, 6);
slopes_second = zeros(1, 6);
slopes_third = zeros(1, 6);
slopes_seventh = zeros(1, 6);

shift_first = zeros(1, 6);
shift_second = zeros(1, 6);
shift_third = zeros(1, 6);
shift_seventh = zeros(1, 6);


for subject_id = 1:6
    IPI0 = params_opt_all_subjects(subject_id, 1);
    Beta = params_opt_all_subjects(subject_id, 2);
    alpha = params_opt_all_subjects(subject_id, 3);

    IPI_firsts = nan(ntrials, numel(durs));
    IPI_seconds = nan(ntrials, numel(durs));
    IPI_thirds = nan(ntrials, numel(durs));
    IPI_sevenths = nan(ntrials, numel(durs));

    for i = 1:numel(durs)
        ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
        IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma, ntrials);
        IPI_firsts(:,i) = IPI_lst(2,:);
        IPI_seconds(:,i) = IPI_lst(3,:);
        IPI_thirds(:,i) = IPI_lst(4,:);
        IPI_sevenths(:,i) = IPI_lst(8,:);
    end

    tp_first = mean(IPI_firsts)';
    tp_second = mean(IPI_seconds)';
    tp_third = mean(IPI_thirds)';
    tp_seventh = mean(IPI_sevenths)';
    
    tp_first_ones = [tp_first ones(5, 1)]; 
    tp_second_ones = [tp_second ones(5, 1)]; 
    tp_third_ones = [tp_third ones(5, 1)]; 
    tp_seventh_ones = [tp_seventh ones(5, 1)];
    ts = durs * 1000;
    ts_ones = [ts ones(5,1)];

    regression_coefs_first = ts_ones\tp_first;
    regression_coefs_second = ts_ones\tp_second;
    regression_coefs_third = ts_ones\tp_third;
    regression_coefs_fifth = ts_ones\tp_seventh;
    
    slopes_first(subject_id) = regression_coefs_first(1);
    slopes_second(subject_id) = regression_coefs_second(1);
    slopes_third(subject_id) = regression_coefs_third(1);
    slopes_seventh(subject_id) = regression_coefs_fifth(1);
    
    shift_first(subject_id) = tp_first(3);
    shift_second(subject_id) = tp_second(3);
    shift_third(subject_id) = tp_third(3);
    shift_seventh(subject_id) = tp_seventh(3);
    
end

color_sync_mean = [188,95,211]/255;
color_cont_mean = [255,85,85]/255;
% Plot bias for all subjects
figure;
subplot(121);
l1 = plot(ones(1, 6) * 0.9, slopes_third, 'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
l2 = plot(ones(1, 6) * 1.1, slopes_seventh,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);
for i = 1:6
    plot([0.9 1.1], [slopes_third(i) slopes_seventh(i)], 'k');
    %plot([1.9 2.1], [shift_third(i) shift_fifth(i)], 'k');
end
xlim([0.8, 1.2])
%ylabel('Slope')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'Slope', ''})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.44,0.89,0.44,0.04], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')

% Plot model bias
subplot(122)
plot(ones(1, 6) * 1.9, shift_third,  'o', 'MarkerFaceColor', color_sync_mean,...
    'MarkerEdgeColor', color_sync_mean);
hold on;
plot(ones(1, 6) * 2.1, shift_seventh,  'o', 'MarkerFaceColor', color_cont_mean,...
    'MarkerEdgeColor', color_cont_mean);

for i = 1:6
    %plot([0.9 1.1], [slopes_third(i) slopes_fifth(i)], 'k');
    plot([1.9 2.1], [shift_third(i) shift_seventh(i)], 'k');
end
xlim([1.8, 2.2])
%xlabel('ISI (ms)')
%ylabel('Shift (ms)')
mymakeaxis(gca, 'xticks', [1, 2], 'xticklabels', {'', 'Shift (ms)'})
legend([l1 l2], {'Synchronization', 'Continuation'}, 'Orientation', 'horizontal',...
    'Position', [0.32,0.95,0.44,0.07], 'FontSize', 15, 'Color', 'none',...
    'EdgeColor', 'none')


%% Plot slope and shift for 1,2,3, and 7
% Plot bias for all subjects
slopes_all = [slopes_first; slopes_second; slopes_third; slopes_seventh];
shift_all = [shift_first; shift_second; shift_third; shift_seventh];
figure;
subplot(121);
plot(slopes_all);
hold on
errorbar([1,2,3,4], mean(slopes_all, 2), std(slopes_all, [], 2)/sqrt(6), 'k--');
xlim([0,5])
xticks([1, 2, 3, 4])
xticklabels([1, 2, 3, 7])
ylabel('Slope')
xlabel('IPI #')


subplot(122);
plot(shift_all);
hold on
errorbar([1,2,3,4], mean(shift_all, 2), std(shift_all, [], 2)/sqrt(6), 'k--');
xlim([0,5])
ylabel('Shift');
xlabel('IPI #')
xticks([1, 2, 3, 4])
xticklabels([1, 2, 3, 7])
%% Statistical tests
p_slope = signrank(slopes_third, slopes_seventh, 'tail', 'right');
p_shift = signrank(shift_third, shift_seventh, 'tail', 'right');
fprintf('P slope value is %.4f\n P shift value is %.4f\n', p_slope, p_shift);



%% For saving
% save('dualProcess_synccont_nospeedup_params_191229.mat', 'params_opt_all_subjects',...
%     'all_subject_files', 'sigma', 'nSteps', 'ncont', 'tmax', 'ntrials', 'target_biases',...
%     'model_biases');

function mse = find_error(params, filename)
global folder
IPI0 = params(1);
Beta = params(2);
alpha = params(3);
sigma = 50;
nSteps = 3;
ncont = 17;
ntrials = 100;
tmax = 20;

% Calculate the target
% folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
load(fullfile(folder, filename), 'allDur_mean', 'durs');
IPIs_all = cell2mat(allDur_mean');
IPIs_all = IPIs_all(:, 1:tmax);
bias = IPIs_all - durs;
target = sqrt(nanmean(bias.^2)) * 1000;

% Simulation
mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, durs' * 1000, sigma, ntrials);
mse = nanmean(sum(mean_bias - target').^2);

end



function mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, ISI_lst, sigma, ntrials)
    IPI_cell = nan(nSteps + ncont, numel(ISI_lst));
    for nS = 1:numel(ISI_lst)
        ISIs = ones(1, nSteps + 1) * ISI_lst(nS);
        IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma, ntrials);
        mean_IPI = mean(IPI_lst, 2);
        IPI_cell(:,nS) = mean_IPI(2:end);
    end
    bias = IPI_cell - ISI_lst;
    mean_bias = sqrt(nanmean(bias.^2, 2));

end


function IPI_lst = dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont, ISIs, sigma, ntrials)
    IPI_lst = nan(numel(ISIs) + ncont, ntrials);
    for i = 1:ntrials
        IPI = dualProcessNoiseSyncCont(IPI0,Beta,alpha,nSteps+1,ncont,ISIs, sigma);
        IPI_lst(:,i) = IPI;
    end
end


function IPI = dualProcessNoiseSyncCont(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma)
%% Dual-process (Repp, 2005)
%[
%   [a, T] = dualProcess(a0,IPI0,Beta,alpha,nSteps,ISIs)
%
%%

% Calc time points of metronome
m(1) = 0;
for stepi = 2:nSteps
    m(stepi) = m(stepi-1) + ISIs(stepi-1);
end

% Calc time points of presses, IPIs
t(1) = 0;
a(1) = 0;
IPI(1) = IPI0;
T(1) = IPI(1);
t(2) = t(1) + IPI(1);

% Synchronization
for stepi = 2:nSteps
    a(stepi) = t(stepi) - m(stepi);
    T(stepi) = T(stepi-1) - Beta*(T(stepi-1)-ISIs(stepi-1));
    %fprintf('Told = %.4f, ISI = %.4f, Tnew = %.4f\n', T(stepi-1), ISIs(stepi-1), T(stepi));
    noise = randn() * sigma;
    t(stepi+1) = t(stepi) + T(stepi) - alpha * a(stepi) + noise;
end

% Continuation
for icont = 1:ncont
    %disp(t)
    noise = randn() * sigma;
    t(nSteps + icont + 1) = t(nSteps + icont) + T(nSteps) + noise;
end
IPI = diff(t);


end