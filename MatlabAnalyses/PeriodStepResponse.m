function PeriodStepResponse(varargin)
%% PeriodStepResponse
%
%
%%

%% Defaults
K3datafile_default = 'Synch_StepChange_K3.mat';
K2datafile_default = 'Synch_StepChange_K2.mat';
K1datafile_default = 'Synch_StepChange_K1.mat';


%% Parse inputs
Parser = inputParser;

addParameter(Parser,'K3datafile',K3datafile_default)
addParameter(Parser,'K2datafile',K2datafile_default)
addParameter(Parser,'K1datafile',K1datafile_default)
addParameter(Parser,'dt',10)
addParameter(Parser,'nStepsBack',3)
addParameter(Parser,'nIPIs',13)
addParameter(Parser,'nstd',1.25)

parse(Parser,varargin{:})

K3datafile = Parser.Results.K3datafile;
K2datafile = Parser.Results.K2datafile;
K1datafile = Parser.Results.K1datafile;
dt = Parser.Results.dt;
nStepsBack = Parser.Results.nStepsBack;
nIPIs = Parser.Results.nIPIs;
nstd = Parser.Results.nstd;

%% Load optimization results
data = load(K3datafile);

%% Identify point of step change
mISI = mean(data.isiLst,2);
intervalNumber = 1:length(mISI);
changeNumber = find(diff(mISI) > 0)+1;

%% Calculate mean step response
ISI = data.isiLst;
IPI = data.ipiLst;

ISItemp = [ISI(1:changeNumber-1,:); ISI(1,:); ISI(changeNumber+1:end,:)];
IPI(IPI > 1.5*ISItemp) = NaN;
IPI(IPI == 0) = NaN;
mIPI = nanmean(IPI,2);


%% 
q = find(data.Slst(:,1));
stepInd = find(diff(diff(q)));
t = 0:dt:(size(data.Slst,1)-1)*dt;
P = data.Plst(q(stepInd-nStepsBack):end,:);
S = data.Slst(q(stepInd-nStepsBack):end,:);
for triali = 1:1000
    tPs = t(~~P(:,triali));
    tSs = t(~~S(:,triali));
    ISIs = diff(tSs);
    IPIs = diff(tPs);
    ipis(:,triali) = IPIs(1:nIPIs);
    isis(:,triali) = ISIs(1:nIPIs);
end
ipis(ipis>1.3*max(ISI(:))) = NaN;
preIPI = ipis(1:nStepsBack+1,:);
preIPIstd = nanstd(preIPI(:));
preIPIm = nanmean(preIPI(:));
temp = find(ipis(nStepsBack+2,:) < preIPIm +nstd*preIPIstd);
ipis = ipis(:,temp);

%% Dual process
[a, ipIPI] = dualProcess(0,isis(1,1),0.35,0.6,13,isis(:,1));

%% Plot mean step response
figure('Name','Mean step response')
StepVec = -nStepsBack:nIPIs-nStepsBack-1;
lineProps.Color = projectColorMaps('ts','samples',3,'sampleDepth',5);
lineProps.LineWidth = 2;
plotHorizontal(isis(1,1),'MinMax',[-nStepsBack 0],'lineProperties',lineProps);
lineProps.Color = projectColorMaps('ts','samples',5,'sampleDepth',5);
hold on
plotHorizontal(isis(end,1),'MinMax',[1 nIPIs-nStepsBack-1],'lineProperties',lineProps);
plot(StepVec,ipIPI,'-','Color',[0.4 0.4 0.4])
plot(StepVec,nanmean(ipis,2),'o','Color',[0.4 0.4 0.4],'MarkerFaceColor',[0.4 0.4 0.4])

%% Load optimization results
data = load(K2datafile);

%% Identify point of step change
mISI = mean(data.isiLst,2);
intervalNumber = 1:length(mISI);
changeNumber = find(diff(mISI) > 0)+1;

%% Calculate mean step response
ISI = data.isiLst;
IPI = data.ipiLst;

ISItemp = [ISI(1:changeNumber-1,:); ISI(1,:); ISI(changeNumber+1:end,:)];
IPI(IPI > 1.5*ISItemp) = NaN;
IPI(IPI == 0) = NaN;
mIPI = nanmean(IPI,2);


%% 
q = find(data.Slst(:,1));
stepInd = find(diff(diff(q)));
t = 0:dt:(size(data.Slst,1)-1)*dt;
P = data.Plst(q(stepInd-nStepsBack):end,:);
S = data.Slst(q(stepInd-nStepsBack):end,:);
for triali = 1:1000
    tPs = t(~~P(:,triali));
    tSs = t(~~S(:,triali));
    ISIs = diff(tSs);
    IPIs = diff(tPs);
    ipis(:,triali) = IPIs(1:nIPIs);
    isis(:,triali) = ISIs(1:nIPIs);
end
ipis(ipis>1.3*max(ISI(:))) = NaN;
preIPI = ipis(1:nStepsBack+1,:);
preIPIstd = nanstd(preIPI(:));
preIPIm = nanmean(preIPI(:));
temp = find(ipis(nStepsBack+2,:) < preIPIm +nstd*preIPIstd);
ipis = ipis(:,temp);

%% Dual process
[a, ipIPI] = dualProcess(0,isis(1,1),0.25,0.6,13,isis(:,1));

%% Finsh plot
plot(StepVec,ipIPI,'-','Color',[0.6 0.6 0.6])
plot(StepVec,nanmean(ipis,2),'o','Color',[0.6 0.6 0.6],'MarkerFaceColor',[0.6 0.6 0.6])

%% Load optimization results
data = load(K1datafile);

%% Identify point of step change
mISI = mean(data.isiLst,2);
intervalNumber = 1:length(mISI);
changeNumber = find(diff(mISI) > 0)+1;

%% Calculate mean step response
ISI = data.isiLst;
IPI = data.ipiLst;

ISItemp = [ISI(1:changeNumber-1,:); ISI(1,:); ISI(changeNumber+1:end,:)];
IPI(IPI > 1.5*ISItemp) = NaN;
IPI(IPI == 0) = NaN;
mIPI = nanmean(IPI,2);


%% 
q = find(data.Slst(:,1));
stepInd = find(diff(diff(q)));
t = 0:dt:(size(data.Slst,1)-1)*dt;
P = data.Plst(q(stepInd-nStepsBack):end,:);
S = data.Slst(q(stepInd-nStepsBack):end,:);
for triali = 1:1000
    tPs = t(~~P(:,triali));
    tSs = t(~~S(:,triali));
    ISIs = diff(tSs);
    IPIs = diff(tPs);
    ipis(:,triali) = IPIs(1:nIPIs);
    isis(:,triali) = ISIs(1:nIPIs);
end
ipis(ipis>1.3*max(ISI(:))) = NaN;
preIPI = ipis(1:nStepsBack+1,:);
preIPIstd = nanstd(preIPI(:));
preIPIm = nanmean(preIPI(:));
temp = find(ipis(nStepsBack+2,:) < preIPIm +nstd*preIPIstd);
ipis = ipis(:,temp);

%% Dual process
[a, ipIPI] = dualProcess(0,isis(1,1),0.15,0.6,13,isis(:,1));

%% Finsh plot
plot(StepVec,ipIPI,'-','Color',[0.8 0.8 0.8])
plot(StepVec,nanmean(ipis,2),'o','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8])
axis tight
xlabel('Position relative to perturbation')
ylabel('ISI/IPI (ms)')
mymakeaxis(gca)


