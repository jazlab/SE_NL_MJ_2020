function alphaOptimization(varargin)
%%
%
%
%%

%% Defaults
datafile_default = 'Synchronization_K_alpha.mat';


%% Parse inputs
Parser = inputParser;

addParameter(Parser,'datafile',datafile_default)

parse(Parser,varargin{:})

datafile = Parser.Results.datafile;

%% Load optimization results
data = load(datafile);

%% Plot period, phase, and summed error as a function of K, alpha
figure('Name','Period, phase, and total errors','Position',[72 402 1323 346])
subplot(1,3,1)
for Ki = 1:length(data.Klst)
    plot(data.alpha_lst,sqrt(data.mPeriodError(Ki,:)),'-',...
        'Color',projectColorMaps('tp','samples',Ki,'sampleDepth',length(data.Klst)))
    hold on
end
xlabel('$\alpha$')
ylabel('$\sqrt{\textrm{Period error}}$')
mymakeaxis(gca,'interpreter','latex')

subplot(1,3,2)
for Ki = 1:length(data.Klst)
    plot(data.alpha_lst,sqrt(data.mAsynch(Ki,:)),'-',...
        'Color',projectColorMaps('tp','samples',Ki,'sampleDepth',length(data.Klst)))
    hold on
end
xlabel('$\alpha$')
ylabel('$\sqrt{\textrm{Asynchrony}}$')
mymakeaxis(gca,'interpreter','latex')

subplot(1,3,3)
for Ki = 1:length(data.Klst)
    plot(data.alpha_lst,sqrt(data.mPeriodError(Ki,:)+data.mAsynch(Ki,:)),'-',...
        'Color',projectColorMaps('tp','samples',Ki,'sampleDepth',length(data.Klst)))
    hold on
end
xlabel('$\alpha$')
ylabel('$\sqrt{\textrm{Period error} + \textrm{Asynchrony}}$')
mymakeaxis(gca,'interpreter','latex')