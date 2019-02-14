function plotBiasVarNhat(BIAS,sqrtVAR,modelBIAS,modelSqrVAR,varargin)
%% plotBiasBarNhat
%
%   plotBiasVarNat(BIAS,sqrtVAR,modelBIAS,modelSqrtVAR)
%
%   Plots the BIAS vs \sqrt{VAR} of the human data vs circuit model output.
%   BIAS should be a matrix with rows corresponding to subject and columns
%   corresponding to number of intervals (e.g. column 1 is 1-2-Go, column 2
%   is 1-2-3-Go). sqrtVAR should correpond to human standard deviation,
%   modelBIAS circuit model BIAS, and modelSqrVAR circuit model \sqrt{VAR}.
%
%%

%% Defaults
PlotOpts_default.colors = [0 0 1; 1 0 0];

%% Parse inputs
Parser = inputParser;

addRequired(Parser,'BIAS')
addRequired(Parser,'sqrtVAR')
addRequired(Parser,'modelBIAS')
addRequired(Parser,'modelSqrVAR')
addParameter(Parser,'PlotOpts',PlotOpts_default)

parse(Parser,BIAS,sqrtVAR,modelBIAS,modelSqrVAR,varargin{:})

BIAS = Parser.Results.BIAS;
sqrtVAR = Parser.Results.sqrtVAR;
modelBIAS = Parser.Results.modelBIAS;
modelSqrVAR = Parser.Results.modelSqrVAR;
PlotOpts = Parser.Results.PlotOpts;

%% Compute stats on biases
residualBias = BIAS-modelBIAS;
residualVar = sqrtVAR - modelSqrVAR;
for n = 1:size(BIAS,2)
    [~, pvalBias(:,n), ~, STATSbias(:,n)]= ttest(residualBias(:,n));
    [~, pvalVar(:,n), ~, STATSvar(:,n)]= ttest(residualVar(:,n));
end

%% BIAS/VAR of subjects vs models
fh = figure;
fh.Units = 'normalized';
fh.Position = [0.1677 0.5067 0.6479 0.3992];

N = 2;
for n = 1:N
    plot(BIAS(:,n),modelBIAS(:,n),'o','Color',PlotOpts.colors(n,:),'MarkerFaceColor',PlotOpts.colors(n,:))
    hold on
end
for n = 1:N
    plot(sqrtVAR(:,n),modelSqrVAR(:,n),'x','Color',PlotOpts.colors(n,:),...
        'MarkerSize', 10, 'MarkerFaceColor',PlotOpts.colors(n,:))
    hold on
end
% for n = 1:N
%     q = find(strcmp('CV',slist));
%     plot(BIAS(q,n),modelBIAS(q,n),'o','Color',colors(q,:))
%     q = find(strcmp('SM',slist));
%     plot(BIAS(q,n),modelBIAS(q,n),'o','Color',colors(q,:))
%     q = find(strcmp('CV',slist));
%     plot(sqrtVAR(q,n),modelSqrVAR(q,n),'s','Color',colors(q,:))
%     q = find(strcmp('SM',slist));
%     plot(sqrtVAR(q,n),modelSqrVAR(q,n),'s','Color',colors(q,:))
% end
axis square
plotUnity;
xlabel('Observed BIAS & VAR^{1/2} (ms)')
ylabel('Model BIAS & VAR^{1/2} (ms)')
xticks = 0:50:150;
xticklabels = {'0','50','100','150'};
yticks = xticks;
yticklabels = xticklabels;
mymakeaxis(gca,...
    'xticks',xticks,'xticklabels',xticklabels,'yticks',yticks,'yticklabels',yticklabels)
l = legend({'RSG BIAS','RSSG BIAS','RSG sqrtVAR','RSSG sqrtVAR'},...
    'Location','southeast');
set(l, 'Position', [0.6,0.38,0.16,0.13]);

%% Residual BIAS
figure('Name','Residual BIAS','Position',[200 296 800 372])
edges = linspace(-10,10,8);
x = edges + (edges(2) - edges(1))/2;
ncount = histcounts(residualBias(:,1),edges);
barProperties.FaceColor = PlotOpts.colors(1,:);
barProperties.EdgeColor = 'none';
barProperties.ShowBaseLine = 'off';
barProperties.BarWidth = 0.8;
barProperties.FaceAlpha = 0.3;
h = mybargraph(x(1:end-1),ncount,'barProperties',barProperties);
hold on
%text(-8,5.8,['p-val = ' num2str(pvalBias(:,1))],'Color',PlotOpts.colors(1,:));

ncount = histcounts(residualBias(:,2),edges);
barProperties.FaceColor = PlotOpts.colors(2,:);
barProperties.EdgeColor = 'none';
barProperties.ShowBaseLine = 'off';
barProperties.BarWidth = 0.8;
barProperties.FaceAlpha = 0.3;
mybargraph(x(1:end-1),ncount,'barProperties',barProperties);
%text(-8,5.5,['p-val = ' num2str(pvalBias(:,2))],'Color',PlotOpts.colors(2,:));

axis([-10 10 0 6])

ylabel('Count')
xlabel('Residual BIAS (ms)')
mymakeaxis(gca,...
    'xticks',[-10 0 10],'xticklabels',{'-10','0','10'});

%% Residual VAR
figure('Name','Residual \sqrt{VAR}','Position',[200 296 800 372])
edges = linspace(-10,10,8);
x = edges + (edges(2) - edges(1))/2;
ncount = histcounts(residualVar(:,1),edges);
barProperties.FaceColor = PlotOpts.colors(1,:);
barProperties.EdgeColor = 'none';
barProperties.ShowBaseLine = 'off';
barProperties.BarWidth = 0.8;
barProperties.FaceAlpha = 0.3;
h = mybargraph(x(1:end-1),ncount,'barProperties',barProperties);
hold on
%text(-8,5.8,['p-val = ' num2str(pvalVar(:,1))],'Color',PlotOpts.colors(1,:));

ncount = histcounts(residualVar(:,2),edges);
barProperties.FaceColor = PlotOpts.colors(2,:);
barProperties.EdgeColor = 'none';
barProperties.ShowBaseLine = 'off';
barProperties.BarWidth = 0.8;
barProperties.FaceAlpha = 0.3;
mybargraph(x(1:end-1),ncount,'barProperties',barProperties);
%text(-8,5.5,['p-val = ' num2str(pvalVar(:,2))],'Color',PlotOpts.colors(2,:));

axis([-10 10 0 6])

ylabel('Count')
xlabel('Residual VAR (ms)')
mymakeaxis(gca,...
    'xticks',[-10 0 10],'xticklabels',{'-10','0','10'});