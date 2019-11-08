function fullCircuitSkipAnalysis(varargin)
%% fullCircuitSkipAnalysis
%
%   fullCircuitSkipAnalysis()
%
%       Plots the probability of skipping as a function of the noise.
%
%
%%

%% Defaults
filebase_default = '~/Projects/TimingCircuit/Data/Synchronization_sigmaMisses_alpha';

%% Parse inputs
Parser = inputParser;

addParameter(Parser,'filebase',filebase_default)
addParameter(Parser,'alphas',[0.1,0.2,0.4])
addParameter(Parser,'alphaNames',{'01','02','04'})

parse(Parser,varargin{:})

filebase = Parser.Results.filebase;
alphas = Parser.Results.alphas;
alphaNames = Parser.Results.alphaNames;

%% Find fraction misses for each alpha
for ai = 1:length(alphas)
    filename = [filebase alphaNames{ai} '.mat'];
    load(filename,'ipiLst','sigLst')
    
    Nipi(:,:,ai) = sum(ipiLst>0,1);
    Nmean(:,ai) = mean(Nipi(:,:,ai),2);
    Nste(:,ai) = sqrt(var(Nipi(:,:,ai),[],2)/size(ipiLst,3));
    baseipi(ai) = Nmean(1,ai);
    
    fractMissed(:,:,ai) = Nipi(:,:,ai)/baseipi(ai);
    fractMean(:,ai) = mean(fractMissed(:,:,ai),2);
    fractSTE(:,ai) = sqrt(var(fractMissed(:,:,ai),[],2)/size(ipiLst,3));
end

%% Plot the results
figure('Name','Missed ipis','Position',[147 338 990 385])
colors = colormap('lines');
subplot(1,2,1)
for ai = 1:length(alphas)
    errorbar(sigLst,Nmean(:,ai),Nste(:,ai),'-','Color',colors(ai,:))
    hold on
    plot(sigLst,Nmean(:,ai),'o','Color',colors(ai,:),'MarkerFaceColor',colors(ai,:))
end
xlabel('$\sigma_n$')
ylabel('N IPI')
mymakeaxis(gca,'interpreter','latex')

subplot(1,2,2)
for ai = 1:length(alphas)
    errorbar(sigLst,fractMean(:,ai),fractSTE(:,ai),'-','Color',colors(ai,:))
    hold on
end
legend(cellstr(num2str(alphas(:))))
for ai = 1:length(alphas)
    plot(sigLst,fractMean(:,ai),'o','Color',colors(ai,:),'MarkerFaceColor',colors(ai,:))
end
plotHorizontal(1);
xlabel('$\sigma_n$')
ylabel('Fraction produced')
mymakeaxis(gca,'interpreter','latex')

%% Plot example
ai = 3;
filename = [filebase alphaNames{ai} '.mat'];
load(filename,'yplst','yslst','isiLst')

switch ai
    case 2
        sigInd = 4;
        expInd = 2;
        ax = [1225 1475 0.5 0.71];
    case 3
        sigInd = 4;
        expInd = 2;
        ax = [1850 2100 0.5 0.71];
end
t = ax(1)*10:10:ax(2)*10;

figure('Name','Skip example','Position',[281 456 940 299])
plot(t,yplst(ax(1):ax(2),sigInd,expInd))
hold on
plot(t,yslst(ax(1):ax(2),sigInd,expInd))
stimTrain = cumsum(isiLst(:,sigInd,expInd));
xlim([t(1) t(end)])
% xlim([0 ax(2)-ax(1)])
ylim(ax(3:4))
plotVertical(stimTrain(stimTrain >= t(1) & stimTrain <= t(end)))
plotHorizontal(0.7);
xlabel('Time (ms)')
ylabel('y_p or y_s')
mymakeaxis(gca)
