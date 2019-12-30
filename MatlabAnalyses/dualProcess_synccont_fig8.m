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
ntrials = 100;
Klow = 0;
Khigh = 3;
Ilow = 700;
Ihigh = 900;
sigma_low = 0;
sigma_high = 100;
niter = 10;

%folder = 'C:\Users\Le\Dropbox (MIT)\Jazayeri\SyncContData';
all_subject_files = {'AL_2_20170719_SynCon_ITIs.mat',...
    'ER_2_20170718_SynCon_ITIs.mat',...
    'FK_2_20170721_SynCon_ITIs.mat',...
    'KL_2_20170721_SynCon_ITIs.mat',...
    'MW_2_20170720_SynCon_ITIs.mat',...
    'RC_2_20170721_SynCon_ITIs.mat'};


tmax = 20;

% Find bias
for i = 1:6
    load(fullfile(folder, all_subject_files{i}));
    IPIs_all = cell2mat(allDur_mean');
    IPIs_all = IPIs_all(:, 1:tmax);
    bias = IPIs_all - durs;
    mean_bias = nanmean(bias.^2);
    plot(sqrt(mean_bias) * 1000)
    hold on
end

               
%% Parameter fitting for sync-cont using fminsearch
params = [900, 0.8, 0.9];
rng(123);
options = optimset('PlotFcns',@optimplotfval);
all_subject_files = {'AL_2_20170719_SynCon_ITIs.mat',...
    'ER_2_20170718_SynCon_ITIs.mat',...
    'FK_2_20170721_SynCon_ITIs.mat',...
    'KL_2_20170721_SynCon_ITIs.mat',...
    'MW_2_20170720_SynCon_ITIs.mat',...
    'RC_2_20170721_SynCon_ITIs.mat'};

sigma = 50;
nSteps = 3;
ncont = 17;
ntrials = 100;
tmax = 20;

params_opt_all_subjects = nan(numel(all_subject_files), 3);
for i = 1:6
    filename = all_subject_files{i};
    params_opt = fminsearch(@(x) find_error(x, filename), params, options);
    params_opt_all_subjects(i,:) = params_opt;
end




%% Simulate and compare
figure;

target_biases = nan(numel(all_subject_files), tmax);
model_biases = nan(numel(all_subject_files), tmax);

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
subject_id = 6;
IPI0 = params_opt_all_subjects(subject_id, 1);
Beta = params_opt_all_subjects(subject_id, 2);
alpha = params_opt_all_subjects(subject_id, 3);

IPI_thirds = nan(ntrials, numel(durs));
IPI_sevenths = nan(ntrials, numel(durs));

for i = 1:numel(durs)
    ISIs = ones(1, nSteps + 1) * durs(i) * 1000;
    IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,alpha,nSteps,ncont,ISIs, sigma, ntrials);
    IPI_thirds(:,i) = IPI_lst(3,:);
    IPI_sevenths(:,i) = IPI_lst(7,:);
end

% Plot
errorbar(durs, mean(IPI_thirds), std(IPI_thirds))
hold on
errorbar(durs, mean(IPI_sevenths), std(IPI_sevenths))

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