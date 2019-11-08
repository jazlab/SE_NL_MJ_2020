function SynchronizationPeriodPhase(varargin)
%%

%%

%% Defaults
noalphafile_default = '~/Projects/TimingCircuit/Data/Synchronization_random_drift_alpha00.mat';
alphafile_default = '~/Projects/TimingCircuit/Data/Synchronization_random_drift_alpha01.mat';

%% Parse inputs
Parser = inputParser;

addParameter(Parser,'noalphafile',noalphafile_default)
addParameter(Parser,'alphafile',alphafile_default)
addParameter(Parser,'dt',10)

parse(Parser,varargin{:})

noalphafile = Parser.Results.noalphafile;
alphafile = Parser.Results.alphafile;
dt = Parser.Results.dt;

%% Load data
alpha00 = load(noalphafile);

alpha01 = load(alphafile);

%% Time
t = 0:dt:(size(alpha00.yplst,1)-1)*dt;

%% Example synchronization, alpha = 0

%% ysim, y_p
ExTrial = 11;
tStart = 42000;
tEnd = 52000;
figure('Name','Example, y_p and y_sim over time')
y_p = alpha00.yplst(:,ExTrial);
ysim = alpha00.yslst(:,ExTrial);
pOn = alpha00.Plst(:,ExTrial);
sOn = alpha00.Slst(:,ExTrial);

subplot(3,1,1)
plot(t(t >= tStart & t<= tEnd),y_p(t >= tStart & t<= tEnd),...
    'Color',[229 34 37]/255)
hold on
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if pOn(ti)
        plotVertical(t(ti));
    end
end
ax = axis;
axis([42000 52000 ax(3:4)])
xlabel('Time')
ylabel('y_p')
mymakeaxis(gca)

subplot(3,1,2)
plot(t(t >= tStart & t<= tEnd),ysim(t >= tStart & t<= tEnd),...
    'Color',[255 179 23]/255)
hold on
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if sOn(ti)
        plotVertical(t(ti));
    end
end
ax = axis;
axis([42000 52000 ax(3:4)])
xlabel('Time')
ylabel('y_s')
mymakeaxis(gca)

subplot(3,1,3)
plot(t(t >= tStart & t<= tEnd),y_p(t >= tStart & t<= tEnd)-ysim(t >= tStart & t<= tEnd),...
    'Color',[0 0 0]/255)
hold on
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if sOn(ti)
        plotVertical(t(ti));
    end
end
ax = axis;
axis([tStart tEnd ax(3:4)])
xlabel('Time')
ylabel('$\Delta I$')
mymakeaxis(gca,'interpreter','latex')

%% Period is successfully tracked
figure('Name','Stimulis and response period','Position',[443 82 454 734])
ExTrials = randsample(size(alpha00.isiLst,2),3);
ind = 0;
for i = 1:length(ExTrials)
    subplot(length(ExTrials),1,i)
    colors = projectColorMaps('ts',...
        'samples',alpha00.isiLst(alpha00.isiLst(:,ExTrials(i))~=0,ExTrials(i))/100 - 5,...
        'sampleDepth',5);
    scatter(1:length(alpha00.isiLst(alpha00.isiLst(:,ExTrials(i))~=0,ExTrials(i))),...
        alpha00.isiLst(alpha00.isiLst(:,ExTrials(i))~=0,ExTrials(i)),50,...
        colors,'filled')
    hold on
    scatter(1:length(alpha00.isiLst(alpha00.isiLst(:,ExTrials(i))~=0,ExTrials(i))),...
        alpha00.ipiLst(alpha00.isiLst(:,ExTrials(i))~=0,ExTrials(i)),50,[0 0 0],'filled')
    ax = axis;
    axis([ax(1:2) 500 1200])
    
    xlabel('ISI #')
    ylabel('ISI/IPI (ms)')
    mymakeaxis(gca)
end

%% ISI vs IPI
figure('Name','ISI v IPI')
h = scatter(alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),...
    alpha00.ipiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),...
    50,[0 0 0],'filled');
h.MarkerFaceAlpha = 0.025;
h.MarkerEdgeAlpha = 0;
hold on
axis([400 1200 400 1200])
plotUnity;
axis square
xlabel('ISI (ms)')
ylabel('IPI (ms)')
mymakeaxis(gca)

[B,BINT,Res,ResINT,STATS] = regress(alpha00.ipiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),...
    [alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0)...
    ones(size(alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0)))]);
[R,Pval] = corrcoef(alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),...
    alpha00.ipiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0));
    
%% Period error histogram
figure
edges = linspace(-501,501,51);
n = histcounts(alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0) - ...
    alpha00.ipiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),edges);
barProps.FaceColor = [1 0.5 0.5];
barProps.EdgeColor = 'none';
barProps.FaceAlpha = 0.5;
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)

%% Phase histogram
figure
edges = -271:20:271;
n = histcounts(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360,edges);
barProps.FaceColor = [1 0.5 0.5];
barProps.EdgeColor = 'none';
barProps.FaceAlpha = 0.5;
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)
hold on
axis([-270 270 0 0.2])
plotVertical(0);
plotVertical(-180);
plotVertical(180);
xlabel('Phase (deg)')
ylabel('Relative frequency')
mymakeaxis(gca,'xticks',[-180 0 180])


%% Now with alpha = 0.1

%% ysim, y_p
ExTrial = 47;
tStart = 42000;
tEnd = 52000;
figure('Name','Example, y_p and y_sim over time','Position',[440 301 560 497])
y_p = alpha01.yplst(:,ExTrial);
ysim = alpha01.yslst(:,ExTrial);
pOn = alpha01.Plst(:,ExTrial);
sOn = alpha01.Slst(:,ExTrial);

subplot(3,1,1)
plot(t(t >= tStart & t<= tEnd),y_p(t >= tStart & t<= tEnd),...
    'Color',[229 34 37]/255)
hold on
ax = axis;
axis([tStart tEnd 0.55 0.75])
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if pOn(ti)
        plotVertical(t(ti));
    end
end
xlabel('Time')
ylabel('y_p')
mymakeaxis(gca)

subplot(3,1,2)
plot(t(t >= tStart & t<= tEnd),ysim(t >= tStart & t<= tEnd),...
    'Color',[255 179 23]/255)
hold on
ax = axis;
axis([tStart tEnd 0.55 0.75])
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if sOn(ti)
        plotVertical(t(ti));
    end
end
xlabel('Time')
ylabel('y_s')
mymakeaxis(gca)

subplot(3,1,3)
plot(t(t >= tStart & t<= tEnd),y_p(t >= tStart & t<= tEnd)-ysim(t >= tStart & t<= tEnd),...
    'Color',[0 0 0]/255)
hold on
for ti = floor(tStart/dt):ceil(tEnd/dt)
    if sOn(ti)
        plotVertical(t(ti));
    end
end
ax = axis;
axis([tStart tEnd ax(3:4)])
xlabel('Time')
ylabel('$\Delta I$')
mymakeaxis(gca,'interpreter','latex')

%% Period is successfully tracked
figure('Name','Stimulis and response period','Position',[443 82 454 734])
ExTrials = randsample(size(alpha01.isiLst,2),3);
ind = 0;
for i = 1:length(ExTrials)
    subplot(length(ExTrials),1,i)
    colors = projectColorMaps('ts',...
        'samples',alpha01.isiLst(alpha01.isiLst(:,ExTrials(i))~=0,ExTrials(i))/100 - 5,...
        'sampleDepth',5);
    scatter(1:length(alpha01.isiLst(alpha01.isiLst(:,ExTrials(i))~=0,ExTrials(i))),...
        alpha01.isiLst(alpha01.isiLst(:,ExTrials(i))~=0,ExTrials(i)),50,...
        colors,'filled')
    hold on
    scatter(1:length(alpha01.isiLst(alpha01.isiLst(:,ExTrials(i))~=0,ExTrials(i))),...
        alpha01.ipiLst(alpha01.isiLst(:,ExTrials(i))~=0,ExTrials(i)),50,[0 0 0],'filled')
    ax = axis;
    axis([ax(1:2) 500 1200])
    
    xlabel('ISI #')
    ylabel('ISI/IPI (ms)')
    mymakeaxis(gca)
end

%% Period error histogram
figure
edges = linspace(-501,501,51);
n = histcounts(alpha00.isiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0) - ...
    alpha00.ipiLst(alpha00.isiLst~=0 & alpha00.ipiLst~=0),edges);
barProps.FaceColor = [1 0.5 0.5];
barProps.EdgeColor = 'none';
barProps.FaceAlpha = 0.5;
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)
hold on

n = histcounts(alpha01.isiLst(alpha01.isiLst~=0 & alpha01.ipiLst~=0) - ...
    alpha01.ipiLst(alpha01.isiLst~=0 & alpha01.ipiLst~=0),edges);
barProps.FaceColor = [0.5 0.5 1];
barProps.EdgeColor = 'none';
barProps.FaceAlpha = 0.5;
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)


%% Relative Phase histogram
figure
edges = -271:20:271;
n = histcounts(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360,edges);
barProps.FaceColor = [1 0.5 0.5];
barProps.EdgeColor = 'none';
barProps.FaceAlpha = 0.5;
hold on
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)

barProps.FaceColor = [0.5 0.5 1];
n = histcounts(alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360,edges);
mybargraph(edges(2:end)-(edges(2)-edges(1)),n/sum(n),'barProperties',barProps)
axis([-270 270 0 0.19])
plotVertical(0)
plotVertical(-180);
plotVertical(180);
xlabel('Phase (deg)')
ylabel('Relative frequency')
mymakeaxis(gca,'xticks',[-180 0 180])

%% Summary stats on phase
alpha00.meanPhase = mean(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360);
alpha00.stdPhase = std(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360);
alpha00.stePhase = std(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360)/sqrt(sum(alpha00.isiLst(:)~=0));

alpha01.meanPhase = mean(alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360);
alpha01.stdPhase = std(alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360);
alpha01.stePhase = std(alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360)/sqrt(sum(alpha01.isiLst(:)~=0));

Fstat = alpha00.stdPhase.^2./alpha01.stdPhase.^2;
[H,P,CI,STATS] = vartest2(alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360,...
    alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360,...
    'tail','right');


%% Test for uniformity (Rayleigh test)
% Adapted from Philipp Berens, 2009
% berens@tuebingen.mpg.de - www.kyb.mpg.de/~berens/circStat.html
%   H0: the population is uniformly distributed around the circle
%   HA: the populatoin is not distributed uniformly around the circle
%   Assumption: the distribution has maximally one mode and the data is 
%   sampled from a von Mises distribution!

% Compute Rayleigh's r
phi00 = alpha00.asynchLst(alpha00.isiLst~=0)./...
    alpha00.isiLst(alpha00.isiLst~=0)*360;
phi00(phi00>180) = phi00(phi00>180) - 360;
phi00(phi00<-180) = phi00(phi00<-180) + 360;
R00 = abs(sum(exp(1i*phi00)));
n00 = sum(sum(alpha00.isiLst~=0));

phi01 = alpha01.asynchLst(alpha01.isiLst~=0)./...
    alpha01.isiLst(alpha01.isiLst~=0)*360;
phi01(phi01>180) = phi01(phi01>180) - 360;
phi01(phi01<-180) = phi01(phi01<-180) + 360;
R01 = abs(sum(exp(1i*phi01)));
n01 = sum(sum(alpha01.isiLst~=0));

% compute p value using approxation in Zar, p. 617
pval00 = exp(sqrt(1+4*n00+4*(n00^2-R00^2))-(1+2*n00));
pval01 = exp(sqrt(1+4*n01+4*(n01^2-R01^2))-(1+2*n01));