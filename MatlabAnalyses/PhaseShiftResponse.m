function PhaseShiftResponse(varargin)
%% PeriodStepResponse
%
%
%%

%% Defaults
datafile_default = 'Synch_PhaseChange.mat';


%% Parse inputs
Parser = inputParser;

addParameter(Parser,'datafile',datafile_default)
addParameter(Parser,'dt',10)
addParameter(Parser,'nStepsBack',3)
addParameter(Parser,'nIPIs',13)

parse(Parser,varargin{:})

datafile = Parser.Results.datafile;
dt = Parser.Results.dt;
nStepsBack = Parser.Results.nStepsBack;
nIPIs = Parser.Results.nIPIs;

%% Load data
data = load(datafile);

%% Calculate mean asynchronies
Asynch = mean(data.asynchLst,2);


%% Plot phase response curve
stepInd = 49;
tsteps = -4:6;
alphas = [0.15, 0.2];
pResponse = squeeze(Asynch((stepInd+tsteps(1)):(stepInd+tsteps(end)),:,[3:4]));
pResponse = pResponse - repmat(mean(pResponse(1:3,:),1),[size(pResponse,1) 1]);
isis = data.isiLst(stepInd+tsteps(1)+2:stepInd+tsteps(end)+2,1);

figure('Name','Phase shift response')
for i = 1:size(pResponse,2)
    [a, ~] = dualProcess(0,isis(1),0.15,alphas(i),length(tsteps),isis);
    plot(tsteps,a,'-',...
        'Color',[1 1 1] - i*[0.3 0.3 0.3])
    hold on
    plot(tsteps,pResponse(:,i),'o',...
        'Color',[1 1 1] - i*[0.3 0.3 0.3],...
        'MarkerFaceColor',[1 1 1] - i*[0.3 0.3 0.3])
end
plotHorizontal(0);
plotVertical(0);
xlabel('Position relative to perturbation')
ylabel('Asynchrony (ms)')
mymakeaxis(gca)
