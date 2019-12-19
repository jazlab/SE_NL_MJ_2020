
%% Plot and compare
ISIs = tss;
id = 3;
IPI0 = Iopt_lst(id);
Beta = Kopt_lst(id);
sigma = sigma_opt_lst(id);
behav_file = fullfile('C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\', all_subject_files{id});
load(behav_file, 'tss', 'mtp_in', 'stdtp_in');

ntrials = 100;
RSG_productions = simulateRSG(IPI0,Beta,2,ISIs, sigma, ntrials);
RSSG_productions = simulateRSG(IPI0,Beta,3,ISIs, sigma, ntrials);

figure('Position', [100, 200, 1000, 600]);
h1 = subplot('121');
errorbar(tss, mtp_in(:,1), stdtp_in(:,1),...
    'r', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'r', 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
errorbar(tss + 5, mean(RSG_productions),...
    std(RSG_productions), 'b', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'b', 'MarkerSize', 4,...
    'LineWidth', 1.5)
plot(tss + 5, mean(RSG_productions), 'b')
plot(tss, mtp_in(:,1), 'r')
xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-Go', ...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex', 'font_size', 20)

axis square

h2 = subplot('122');
l1 = errorbar(tss, mtp_in(:,2), stdtp_in(:,2),...
    'r', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'r', 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on;
l2 = errorbar(tss + 5, mean(RSSG_productions),...
    std(RSSG_productions), 'b', 'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', 'b', 'MarkerSize', 4,...
    'LineWidth', 1.5);

l3 = plot(tss + 5, mean(RSSG_productions), 'b');
l4 = plot(tss, mtp_in(:,2), 'r');


xlim([500, 1100])
ylim([500, 1100])
xlabel('$t_s (ms)$')
ylabel('$t_p (ms)$')
plotUnity;
mymakeaxis(gca, 'xytitle', '1-2-3-Go',...
    'xticks', [600, 800, 1000], 'yticks', [600 800 1000],...
    'interpreter', 'latex', 'font_size', 20)
legend1 = legend([l1, l2], {'Model', 'Observed', ''});

set(legend1,...
    'Position',[0.83 0.42 0.05 0.05],...
    'EdgeColor',[0.94 0.94 0.94],...
    'Color',[0.941 0.941 0.94],...
    'FontSize', 18);
axis square

set(h1, 'Position', [0.05, 0.11, 0.43, 0.82]);
set(h2, 'Position', [0.5, 0.11, 0.43, 0.82]);

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

all_subject_files = {'SWE_EKF_ObsAct0_20171105.mat', 'CV_EKF_ObsAct0_20171105.mat',...
                    'GB_EKF_ObsAct0_20171105.mat', 'LB_EKF_ObsAct0_20171105.mat',...
                    'PG_EKF_ObsAct0_20171105.mat', 'SM_EKF_ObsAct0_20171105.mat',...
                    'TA_EKF_ObsAct0_20171105.mat', 'VD_EKF_ObsAct0_20171105.mat',...
                    'VR_EKF_ObsAct0_20171105.mat'};
                
% Fit to all subjects
Iopt_lst = [];
Kopt_lst = [];
sigma_opt_lst = [];
for i = 1:numel(all_subject_files)
    fprintf('Fitting subject: %s...\n', all_subject_files{i});
    behav_file = fullfile('C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\',...
        all_subject_files{i});
    [Iopt, Kopt, sigma_opt] = subject_fitting(behav_file, nsamples, ntrials, Klow, Khigh, Ilow, Ihigh,...
    sigma_low, sigma_high, niter);
    Iopt_lst(i) = Iopt;
    Kopt_lst(i) = Kopt;
    sigma_opt_lst(i) = sigma_opt;
end

%% Subject and model BIAS and VAR
collated_bias_var = [];
for i = 1:numel(all_subject_files)
    behav_file = fullfile('C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\',...
        all_subject_files{i});
    load(behav_file, 'tss', 'mtp_in', 'stdtp_in');
    Ival = Iopt_lst(i);
    Kval = Kopt_lst(i);
    sigma = sigma_opt_lst(i);
    RSG_productions = simulateRSG(Ival,Kval,2,tss, sigma, ntrials);
    RSSG_productions = simulateRSG(Ival,Kval,3,tss, sigma, ntrials);
    
    mtp_model = [mean(RSG_productions) mean(RSSG_productions)];
    std_model = [std(RSG_productions) std(RSSG_productions)];
    
    
    
    % Bias
    bias_model1 = sum((mean(RSG_productions) - tss').^2) / numel(tss);
    bias_model2 = sum((mean(RSSG_productions) - tss').^2) / numel(tss);
    bias_subject1 = sum((mtp_in(:,1) - tss).^2) / numel(tss);
    bias_subject2 = sum((mtp_in(:,2) - tss).^2) / numel(tss);
    
    % Variance
    var_model1 = sum(std(RSG_productions).^2) / numel(tss);
    var_model2 = sum(std(RSSG_productions).^2) / numel(tss);
    var_subject1 = sum(stdtp_in(:,1).^2) / numel(tss);
    var_subject2 = sum(stdtp_in(:,2).^2) / numel(tss);
    
    % Collate
    collated_bias_var(i,:) = [bias_model1, bias_subject1, bias_model2, bias_subject2,...
        var_model1, var_subject1, var_model2, var_subject2];
    
end
collated_bias_var = sqrt(collated_bias_var);

save('biasvar_dualProcess_191219.mat', 'collated_bias_var', 'all_subject_files');


%% Fit one example file
behav_file = 'C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\SWE_EKF_ObsAct0_20171105.mat';
nsamples = 100;
ntrials = 100;
Klow = 0;
Khigh = 1.5;
Ilow = 700;
Ihigh = 900;
sigma_low = 0;
sigma_high = 100;
niter = 10;
[Iopt, Kopt, sigma_opt] = subject_fitting(behav_file, nsamples, ntrials, Klow, Khigh, Ilow, Ihigh,...
    sigma_low, sigma_high, niter);

%% Parameter fitting using fminsearch
find_error([800, 0.5])
x = fminsearch(@(x) find_error(x), [800, 0.5])

function [Iopt, Kopt, sigma_opt] = subject_fitting(behav_file, nsamples, ntrials, Klow, Khigh, Ilow, Ihigh,...
    sigma_low, sigma_high, niter)

Iopt = 800;
Kopt = 0.5;
sigma_opt = 70;

for i = 1:niter
    fprintf('Iteration %d: I = %.4f, K = %.4f, sigma = %.4f\n', i, Iopt, Kopt, sigma_opt);
    [Iopt, Kopt] = do_IK_fitting(behav_file, sigma_opt, nsamples, ntrials, Klow, Khigh,...
        Ilow, Ihigh);
    sigma_opt = do_sigma_fitting(behav_file, Iopt, Kopt, nsamples, ntrials, ...
        sigma_low, sigma_high);
end

end


function mse = find_error(x)
Ival = x(1);
Kval = x(2);
sigma = 70;
ntrials = 100;
all_subject_files = {'SWE_EKF_ObsAct0_20171105.mat', 'CV_EKF_ObsAct0_20171105.mat',...
                    'GB_EKF_ObsAct0_20171105.mat', 'LB_EKF_ObsAct0_20171105.mat',...
                    'PG_EKF_ObsAct0_20171105.mat', 'SM_EKF_ObsAct0_20171105.mat',...
                    'TA_EKF_ObsAct0_20171105.mat', 'VD_EKF_ObsAct0_20171105.mat',...
                    'VR_EKF_ObsAct0_20171105.mat'};
behav_file = fullfile('C:\Users\Sur lab\Documents\Noisy_mutual_inhibition\NoisyMutualInhibition\', all_subject_files{1});
load(behav_file, 'mtp_in', 'stdtp_in', 'tss');

RSG_productions = simulateRSG(Ival,Kval,2,tss, sigma, ntrials);
RSSG_productions = simulateRSG(Ival,Kval,3,tss, sigma, ntrials);

error1 = (mean(RSG_productions) - mtp_in(:,1)').^2;
error2 = (mean(RSSG_productions) - mtp_in(:,2)').^2;

mse = sum(error1) + sum(error2);
end

function [Iopt, Kopt] = do_IK_fitting(behav_file, sigma, nsamples, ntrials, Klow, Khigh,...
    Ilow, Ihigh)
% Inputs:
% - subject_file: .mat file with the behavioral results of the subject
% - sigmaval: sigma value to be used
% - nsamples: number of random (I, K) combinations to sample
% - Klow, Khigh, Ilow, Ihigh: ranges of I and K for sampling
% 
% Outputs:
% I, K: the optimal combination to minimize the mse between the mean simulated times
% and the mean behavioral times of the subject'''


load(behav_file, 'mtp_in', 'stdtp_in', 'tss');

Klst = randrange(Klow, Khigh, [nsamples 1]);
Ilst = randrange(Ilow, Ihigh, [nsamples 1]);

for i = 1:nsamples
    Ival = Ilst(i);
    Kval = Klst(i);
    
    RSG_productions = simulateRSG(Ival,Kval,2,tss, sigma, ntrials);
    RSSG_productions = simulateRSG(Ival,Kval,3,tss, sigma, ntrials);
    
    error1 = (mean(RSG_productions) - mtp_in(:,1)').^2;
    error2 = (mean(RSSG_productions) - mtp_in(:,2)').^2;
    
    errors(i) = sum(error1) + sum(error2);
end

Iopt = Ilst(errors == min(errors));
Kopt = Klst(errors == min(errors));

end

function sigma_opt = do_sigma_fitting(behav_file, Ival, Kval, nsamples, ntrials, ...
    sigma_low, sigma_high)
%% Do sigma fitting
load(behav_file, 'mtp_in', 'stdtp_in', 'tss');

sigma_lst = randrange(sigma_low, sigma_high, [nsamples 1]);

for i = 1:nsamples
    sigma = sigma_lst(i);
    
    RSG_productions = simulateRSG(Ival,Kval,2,tss, sigma, ntrials);
    RSSG_productions = simulateRSG(Ival,Kval,3,tss, sigma, ntrials);
    
    error1 = (std(RSG_productions) - stdtp_in(:,1)').^2;
    error2 = (std(RSSG_productions) - stdtp_in(:,2)').^2;
    
    errors(i) = sum(error1) + sum(error2);
end

sigma_opt = sigma_lst(errors == min(errors));

end



function IPI_cell = simulateRSG(IPI0, Beta, nSteps, ISI_lst, sigma, ntrials)
    IPI_cell = nan(ntrials, numel(ISI_lst));
    for nS = 1:numel(ISI_lst)
        ISIs = ones(1, nSteps) * ISI_lst(nS);
        IPI_lst =  dualProcessNoiseMultiple(IPI0,Beta,nSteps,ISIs, sigma, ntrials);
        IPI_cell(:,nS) = IPI_lst(end, :)';
    end

end


function IPI_lst = dualProcessNoiseMultiple(IPI0,Beta,nSteps,ISIs, sigma, ntrials)
    IPI_lst = nan(numel(ISIs), ntrials);
    for i = 1:ntrials
        IPI = dualProcessNoise(IPI0,Beta,nSteps,ISIs, sigma);
        IPI_lst(:,i) = IPI;
    end
end


function IPI = dualProcessNoise(IPI0,Beta,nSteps,ISIs, sigma)
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
IPI(1) = IPI0;
T(1) = IPI(1);
t(2) = t(1) + IPI(1);
for stepi = 2:nSteps
    T(stepi) = T(stepi-1) - Beta*(T(stepi-1)-ISIs(stepi-1));
    noise = randn() * sigma;
    t(stepi+1) = t(stepi) + T(stepi) + noise;
end
IPI = diff(t);

end