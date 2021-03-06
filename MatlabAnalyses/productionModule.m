function productionModule(varargin)
%% productionModule
%
%
%
%%

%% Defaults
dt = 10;

%% Parse inputs
Parser = inputParser;

addParameter(Parser,'FileName','productionData_many.mat')
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
    for Ii = 1:length(Ilst)
        h(Ii) = figure('Name','state variables over time','Position',[180 223 361 420]);
        subplot(3,1,1)
        plot(t,ulst(Ii,:,1),'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
        hold on
        ax = axis;
        
        xlabel('t (ms)')
        ylabel('u')
        axis tight
        ax1(Ii,:) = axis;
        
        subplot(3,1,2)
        plot(t,vlst(Ii,:,1),'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
        hold on
        ax = axis;
        xlabel('t (ms)')
        ylabel('v')
        axis tight
        ax2(Ii,:) = axis;
        
        subplot(3,1,3)
        plot(t,ylst(Ii,:,1),'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
        hold on
        ax = axis;
        for i = 1:size(pressT,2)
            if pressT(Ii,i) > 0
                plotVertical(pressT(Ii,i),'MinMax',ax(3:4));
                hold on
            end
        end
        xlabel('t (ms)')
        ylabel('y')
        axis tight
        ax3(Ii,:) = axis;
        
    end
    
    for Ii = 1:length(Ilst)
        figure(Ii)
        subplot(3,1,1)
        axis([min(t) max(t) min(ax1(:,3)) max(ax1(:,4))])
        for i = 1:size(pressT,2)
            if pressT(Ii,i) > 0
                plotVertical(pressT(Ii,i));
                hold on
            end
        end
        mymakeaxis(gca)
        
        subplot(3,1,2)
        axis([min(t) max(t) min(ax2(:,3)) max(ax2(:,4))])
        for i = 1:size(pressT,2)
            if pressT(Ii,i) > 0
                plotVertical(pressT(Ii,i));
                hold on
            end
        end
        mymakeaxis(gca)
        
        subplot(3,1,3)
        axis([min(t) max(t) min(ax3(:,3)) max(ax3(:,4))])
        for i = 1:size(pressT,2)
            if pressT(Ii,i) > 0
                plotVertical(pressT(Ii,i));
                hold on
            end
        end
        mymakeaxis(gca)
    end
end

%% Regression
indx = sum(ipi == 0,1) == 0;
ipiTemp = ipi(:,indx)';
Itemp = repmat(Ilst',[1 size(ipiTemp,1)])';
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
for Ii = 1:length(Ilst)
    plot(ipi(Ii,ipi(Ii,:,1) > 0),'o',...
        'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
    hold on
end
ax = axis;
axis([0 40 ax(3:4)])
xlabel('Interval #')
ylabel('IPI (ms)')
mymakeaxis(gca)

subplot(1,3,2)
for Ii = 1:length(Ilst)
    errorbar(Ilst(Ii),mIPI(Ii,:,1),...
        sqrt(varIPI(Ii,:,1)),...
        'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
    hold on
    plot(Ilst(Ii),mIPI(Ii,:,1),'o',...
        'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
        'MarkerFaceColor',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
end
plot(Ilst,mIPI(:,:,1),'k')
xlabel('Input level')
ylabel('$\langle \textrm{IPI} \rangle$')
mymakeaxis(gca,'interpreter','latex')

subplot(1,3,3)
for triali = 1:size(mIPI,3)
    for Ii = 1:length(Ilst)
        plot(mIPI(Ii,:,triali),...
            sqrt(varIPI(Ii,:,triali)),'o',...
            'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
            'MarkerFaceColor',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)))
        hold on
    end
end

% for Ii = 1:length(Ilst)
%     mIPIall = nanmean(mIPI(Ii,:,:),3);
%     std_mIPIall = nanstd(mIPI(Ii,:,:),[],3);
%     msqrtVARall = nanmean(sqrt(varIPI(Ii,:,:)),3);
%     std_msqrtVARall = nanstd(sqrt(varIPI(Ii,:,:)),[],3);
%     lineProps.Color = [0 0 0];
%     plotVertical(mIPIall,...
%         'MinMax',[msqrtVARall + 1.96*std_msqrtVARall, msqrtVARall - 1.96*std_msqrtVARall],...
%         'lineProperties',lineProps);
%     hold on
%     plotHorizontal(msqrtVARall,...
%         'MinMax',[mIPIall + 1.96*std_mIPIall, mIPIall - 1.96*std_mIPIall],...
%         'lineProperties',lineProps);
%     plot(mIPIall,...
%         msqrtVARall,'o',...
%         'Color',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
%         'MarkerFaceColor',projectColorMaps('ts','samples',Ii,'sampleDepth',length(Ilst)),...
%         'MarkerSize',1)
% end
axis square
xlabel('$\langle \textrm{IPI} \rangle$')
ylabel('Standard deviation')
mymakeaxis(gca,'interpreter','latex')