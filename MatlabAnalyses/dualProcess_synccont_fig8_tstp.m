%IPI = dualProcessNoiseSyncCont(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma);
%% Define folder to use
global folder
switch getenv('computername')
    case 'DESKTOP-FN1P6HD'
        folder = 'C:\Users\Sur lab\Dropbox (MIT)\Jazayeri\SyncContData';
    otherwise
        folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
end
%% Fit all behavioral files
nsamples = 100;
ntrials = 1000;
Klow = 0;
Khigh = 3;
Ilow = 700;
Ihigh = 900;
sigma_low = 0;
sigma_high = 100;
niter = 10;

% folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
all_subject_files = {'AL_2_20170719_SynCon_ITIs.mat',...
    'ER_2_20170718_SynCon_ITIs.mat',...
    'FK_2_20170721_SynCon_ITIs.mat',...
    'KL_2_20170721_SynCon_ITIs.mat',...
    'MW_2_20170720_SynCon_ITIs.mat',...
    'RC_2_20170721_SynCon_ITIs.mat'};


tmax = 20;

% Plot subjects
for i = 1:6
    load(fullfile(folder, all_subject_files{i}));
    IPIs_all = cell2mat(allDur_mean');
    IPIs_all = IPIs_all(:, 1:tmax);
    bias = IPIs_all - durs;
    mean_bias = nanmean(bias.^2);
    plot(sqrt(mean_bias) * 1000, 'b')
    hold on
end

% Plot models
for i = 1:6
    load(fullfile(folder, all_subject_files{i}), 'allDur_mean', 'durs');
    IPI0 = params_all_subjects(i, 1);
    Beta = params_all_subjects(i, 2);
    alpha = params_all_subjects(i, 3);
    speedup = params_all_subjects(i, 4);
    sigma = 50;
    nSteps = 3;
    ncont = 17;
    ntrials = 100;
    tmax = 20;

    % Simulation
    mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, ...
        durs' * 1000, sigma, speedup, ntrials);

    % Plot
    plot(mean_bias, 'r');
end

               
%% Parameter fitting for sync-cont using fminsearch
params = [900, 0.8, 0.9, 50];
rng(123);
options = optimset('PlotFcns',@optimplotfval);
all_subject_files = {'AL_2_20170719_SynCon_ITIs.mat',...
    'ER_2_20170718_SynCon_ITIs.mat',...
    'FK_2_20170721_SynCon_ITIs.mat',...
    'KL_2_20170721_SynCon_ITIs.mat',...
    'MW_2_20170720_SynCon_ITIs.mat',...
    'RC_2_20170721_SynCon_ITIs.mat'};

params_all_subjects = nan(numel(all_subject_files), numel(params));
nsamples = 1000;
Ilow = 600;
Ihigh = 1200;
Blow = 0;
Bhigh = 2;
alow = 0;
ahigh = 1;
slow = 0;
shigh = 0;

for i = 1:6
    fprintf('Fitting subject %d of %d\n', i, numel(all_subject_files));
    filename = all_subject_files{i};
    [Iopt, Bopt, aopt, sopt] = do_fitting(all_subject_files, i, nsamples,...
        Ilow, Ihigh, Blow, Bhigh, alow, ahigh, slow, shigh);
    params_all_subjects(i,:) = [Iopt, Bopt, aopt, sopt];
end

%x = [650, 0.8, 0.7];
%x = [650    0.7320    0.9489];


%% Simulate and compare
figure;
tmax = 20;
target_biases = nan(numel(all_subject_files), tmax);
Bias_sim_mean = nan(numel(all_subject_files), tmax);
IPIs_all_allsubjects = cell(1, numel(all_subject_files));

for i = 1:6
    IPI0 = params_all_subjects(i, 1);
    Beta = params_all_subjects(i, 2);
    alpha = params_all_subjects(i, 3);
    speedup = params_all_subjects(i, 4);
    sigma = 50;
    nSteps = 3;
    ncont = 17;
    ntrials = 100;
    tmax = 20;

    % Calculate the target
%     folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
    load(fullfile(folder, all_subject_files{i}), 'allDur_mean', 'durs');
    IPIs_all = cell2mat(allDur_mean');
    IPIs_all = IPIs_all(:, 1:tmax);
    IPIs_all_allsubjects{i} = IPIs_all;
    bias = IPIs_all - durs;
    target = sqrt(nanmean(bias.^2)) * 1000;

    % Simulation
    disp(speedup)
    mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, ...
        durs' * 1000, sigma, speedup, ntrials);
    mse = nanmean(sum(mean_bias - target').^2);

    % Plot
    subplot(121)
    plot(target);
    ylim([0 200])
    xlabel('IPI count (subjects)')
    ylabel('BIAS (ms)')
    hold on
    subplot(122);
    plot(mean_bias);
    ylim([0 200])
    xlabel('IPI count (model)')
    hold on
    
    target_biases(i,:) = target;
    Bias_sim_mean(i,:) = mean_bias;
end

subplot(121);
l1 = plot(mean(Bias_sim_mean), 'r');
legend(l1, {'Model mean'})

%% Save
save('dualProcess_synccont_nospeedup_randomsearch_tstp_params_191229.mat', 'params_all_subjects',...
    'all_subject_files', 'sigma', 'nSteps', 'ncont', 'tmax', 'ntrials', 'target_biases',...
    'model_biases', 'durs');

%% Fig. 8c
%load dualProcess_synccont_withspeedup_randomsearch_tstp_params_191229.mat
subject_id = 6;
IPI0 = params_all_subjects(subject_id, 1);
Beta = params_all_subjects(subject_id, 2);
alpha = params_all_subjects(subject_id, 3);
speedup = params_all_subjects(subject_id, 4);

IPI_thirds = nan(ntrials, numel(durs));
IPI_sevenths = nan(ntrials, numel(durs));

for i = 1:numel(durs)
    ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
    IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,...
            ISIs, sigma, speedup, ntrials);
    IPI_thirds(:,i) = IPI_lst(3,:);
    IPI_sevenths(:,i) = IPI_lst(7,:);
end

% Plot
errorbar(durs * 1000, mean(IPI_thirds), std(IPI_thirds))
hold on
plotUnity;
errorbar(durs * 1000, mean(IPI_sevenths), std(IPI_sevenths))


%% For saving
%load dualProcess_synccont_withspeedup_randomsearch_params_191229.mat
meanITI_model = nan(numel(all_subject_files), numel(durs), tmax);
stdITI_model = nan(numel(all_subject_files), numel(durs), tmax);

for subject_id = 1:6
    fprintf('Simulating subject %d\n', subject_id);
    IPI0 = params_all_subjects(subject_id, 1);
    Beta = params_all_subjects(subject_id, 2);
    alpha = params_all_subjects(subject_id, 3);
    speedup = 0;

    for i = 1:numel(durs)
        ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
        IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,...
                ISIs, sigma, speedup, ntrials);
        meanITI_model(subject_id, i, :) = mean(IPI_lst(2:end,:),2);
        stdITI_model(subject_id, i, :) = std(IPI_lst(2:end,:), [], 2);
    end
end

save('dualProcess_ts_tp_sync_cont_nospeedup_191230_tstpfitting_20reps.mat', 'meanITI_model', 'stdITI_model');
%%
find_error_tstp([1000 1 1 50], all_subject_files, 2)

function [Iopt, Bopt, aopt, sopt] = do_fitting(files, order, nsamples,...
    Ilow, Ihigh, Blow, Bhigh, alow, ahigh, slow, shigh)
% Performs fitting by a random search
Ilst = randrange(Ilow, Ihigh, [nsamples 1]);
Blst = randrange(Blow, Bhigh, [nsamples 1]);
alst = randrange(alow, ahigh, [nsamples 1]);
slst = randrange(slow, shigh, [nsamples 1]);

for i = 1:nsamples
    Ival = Ilst(i);
    Bval = Blst(i);
    aval = alst(i);
    sval = slst(i);
    params = [Ival, Bval, aval, sval];
    
    errors(i) = find_error_tstp(params, files, order);
end

Iopt = Ilst(errors == min(errors));
Bopt = Blst(errors == min(errors));
aopt = alst(errors == min(errors));
sopt = slst(errors == min(errors));

end



function mse = find_error(params, filename)
global folder
IPI0 = params(1);
Beta = params(2);
alpha = params(3);
speedup = params(4);
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
mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, ...
    durs' * 1000, sigma, speedup, ntrials);
mse = nanmean(sum(mean_bias - target').^2);

end


function mse = find_error_tstp(params, files, order)
global folder

filename = files{order};
IPI0 = params(1);
Beta = params(2);
alpha = params(3);
speedup = params(4);
sigma = 50;
nSteps = 3;
ncont = 17;
ntrials = 100;
tmax = 20;

% Calculate the target
% folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
load(fullfile(folder, filename), 'allDur_mean', 'durs');
switch getenv('computername')
    case 'LMN'
        load('C:\Users\Le\Dropbox (MIT)\Jazayeri\NoisyMutualInhibition\PlotTools\subject_ts_tp_sync_cont_040319_20reps.mat',...
            'bias_arr_all');
    otherwise
        load('C:\Users\Sur lab\Dropbox (MIT)\Jazayeri\NoisyMutualInhibition\PlotTools\subject_ts_tp_sync_cont_040319_20reps.mat',...
            'bias_arr_all');
end
        

target_third = durs + squeeze(bias_arr_all(order, 3, :));
target_seventh = durs + squeeze(bias_arr_all(order, 7, :));

for i = 1:numel(durs)
    ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
    IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,...
            ISIs, sigma, speedup, ntrials);
    model_third(i) = mean(IPI_lst(4,:));
    model_seventh(i) = mean(IPI_lst(8,:));
    %stdITI_model(subject_id, i, :) = std(IPI_lst(2:end,:), [], 2);
end

diff = [target_third' target_seventh'] - [model_third model_seventh] / 1000;
mse = mean(diff.^2);

end


function mean_bias = simulateSyncCont(IPI0, Beta, alpha, nSteps, ncont, ...
    ISI_lst, sigma, speedup, ntrials)
    IPI_cell = nan(nSteps + ncont, numel(ISI_lst));
    for nS = 1:numel(ISI_lst)
        ISIs = ones(1, nSteps + 1) * ISI_lst(nS);
        IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,...
            ISIs, sigma, speedup, ntrials);
        mean_IPI = mean(IPI_lst, 2);
        IPI_cell(:,nS) = mean_IPI(2:end);
    end
    bias = IPI_cell - ISI_lst;
    mean_bias = sqrt(nanmean(bias.^2, 2));

end


function IPI_lst = dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,...
    ISIs, sigma, speedup, ntrials)
    IPI_lst = nan(numel(ISIs) + ncont, ntrials);
    for i = 1:ntrials
        IPI = dualProcessNoiseSyncCont(IPI0,Beta,alpha,nSteps+1,ncont,...
            ISIs, sigma, speedup);
        IPI_lst(:,i) = IPI;
    end
end


function IPI = dualProcessNoiseSyncCont(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma, speedup)
%% Dual-process (Repp, 2005)
%
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

