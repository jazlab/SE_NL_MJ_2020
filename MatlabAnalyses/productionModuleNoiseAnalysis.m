function productionModuleNoiseAnalysis(varargin)
%% productionModule
%
%
%
%%

%% Defaults
dt = 10;

%% Parse inputs
Parser = inputParser;

addParameter(Parser,'FileName','productionData_varySig.mat')
addParameter(Parser,'plotExamples',true)

parse(Parser,varargin{:})

FileName = Parser.Results.FileName;
plotExamples = Parser.Results.plotExamples;

%% Load data
load(FileName)

%% Assigne t
t = (0:size(ulst,2)-1)*dt;


cipi = cumsum(ipi,2);

%% Plot examples of u, v, and y over time
if plotExamples
    for sigi = 1:length(siglst)
        h(sigi) = figure('Name','state variables over time','Position',[180 223 361 420]);
        subplot(3,1,1)
        plot(t,ulst(sigi,:),'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
        hold on
        ax = axis;
        
        xlabel('t (ms)')
        ylabel('u')
        axis tight
        ax1(sigi,:) = axis;
        
        subplot(3,1,2)
        plot(t,vlst(sigi,:),'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
        hold on
        ax = axis;
        xlabel('t (ms)')
        ylabel('v')
        axis tight
        ax2(sigi,:) = axis;
        
        subplot(3,1,3)
        plot(t,ylst(sigi,:),'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
        hold on
        ax = axis;
        for i = 1:size(pressT,2)
            if pressT(sigi,i) > 0
                plotVertical(pressT(sigi,i),'MinMax',ax(3:4));
                hold on
            end
        end
        xlabel('t (ms)')
        ylabel('y')
        axis tight
        ax3(sigi,:) = axis;
        
    end
    
    for sigi = 1:length(siglst)
        figure(sigi)
        subplot(3,1,1)
        axis([min(t) max(t) min(ax1(:,3)) max(ax1(:,4))])
        for i = 1:size(pressT,2)
            if pressT(sigi,i) > 0
                plotVertical(pressT(sigi,i));
                hold on
            end
        end
        mymakeaxis(gca)
        
        subplot(3,1,2)
        axis([min(t) max(t) min(ax2(:,3)) max(ax2(:,4))])
        for i = 1:size(pressT,2)
            if pressT(sigi,i) > 0
                plotVertical(pressT(sigi,i));
                hold on
            end
        end
        mymakeaxis(gca)
        
        subplot(3,1,3)
        axis([min(t) max(t) min(ax3(:,3)) max(ax3(:,4))])
        for i = 1:size(pressT,2)
            if pressT(sigi,i) > 0
                plotVertical(pressT(sigi,i));
                hold on
            end
        end
        mymakeaxis(gca)
    end
end

%% Regression
indx = sum(ipi == 0,1) == 0;
ipiTemp = ipi(:,indx)';
Itemp = repmat(siglst',[1 size(ipiTemp,1)])';
[B,BINT,R,RINT,STATS] = regress(ipiTemp(:),[Itemp(:) ones(size(Itemp(:)))]);

%% Analysis of variability
ipiTemp = ipi;
ipiTemp(ipi == 0) = NaN;
ipiTemp(sum(~isnan(ipiTemp),2) < 3,:) = NaN;
mIPI = nanmean(ipiTemp,2);
varIPI = nanvar(ipiTemp,[],2);
[Bvar, BINTvar, Rvar, RINTvar, STATSvar] = regress(varIPI,[mIPI ones(size(mIPI))]);

for i = 1:size(ipiTemp,1)
    for j = 1:size(ipiTemp,1)
        [~, pVar(i,j), ~, statsVar(i,j)] = vartest2(ipiTemp(i,:),ipiTemp(j,:),'Tail','right');
        fstat(i,j) = statsVar(i,j).fstat;
    end
end

%% ipis
figure('Name','ipis','Position',[274 369 1351 271])
subplot(1,3,1)
for sigi = 1:length(siglst)
    plot(ipi(sigi,ipi(sigi,:) > 0),'o',...
        'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
    hold on
end
ax = axis;
axis([0 40 ax(3:4)])
xlabel('Interval #')
ylabel('IPI (ms)')
mymakeaxis(gca)

subplot(1,3,2)
for sigi = 1:length(siglst)
    errorbar(siglst(sigi)/I,mIPI(sigi),...
        sqrt(varIPI(sigi)),...
        'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
    hold on
    plot(siglst(sigi)/I,mIPI(sigi),'o',...
        'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
end
plot(siglst/I,mIPI,'k')
xlabel('$\sigma_n/I_0$')
ylabel('$\langle \textrm{IPI} \rangle$')
mymakeaxis(gca,'interpreter','latex')

subplot(1,3,3)
for sigi = 1:length(siglst)
    plot(siglst(sigi)/I,...
        sqrt(varIPI(sigi)),'o',...
        'Color',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',sigi,'sampleDepth',length(siglst)))
    hold on
end
axis square
plotVertical(0.25);
xlabel('$\sigma_n/I_0$')
ylabel('Standard deviation')
mymakeaxis(gca,'interpreter','latex')