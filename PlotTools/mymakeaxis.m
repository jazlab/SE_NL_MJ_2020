% makeaxis.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to make phyplot like axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      usage: makeaxis.m()
%         by: mehrdad jazayeri
%       date: Oct 2006
%
function mymakeaxis(ax, varargin)

if nargin==0
	ax = gca;
	argin = {};
elseif ~mod(nargin,2)
	argin = {ax, varargin{:}};
	ax = gca;
else
	axes(ax);
	argin = varargin;
end

eval(evalargs(argin));

if ~exist('majorTickRatio','var'), majorTickRatio = 0.02;, end
if ~exist('minorTickRatio','var'), minorTickRatio = 0.01/2;, end
if ~exist('offsetRatio','var'), offsetRatio = 0.05;, end
if ~exist('x_label','var'), x_label=ax.XLabel.String;, end
if ~exist('y_label','var'), y_label=ax.YLabel.String;, end
if ~exist('xytitle','var'), xytitle=ax.Title.String;, end

if ~exist('xticks','var') && ~exist('xticklabels','var')
    xticks=ax.XTick(1:2:end);
    xticklabels=ax.XTickLabel(1:2:end);
elseif exist('xticks','var') && ~exist('xticklabels','var')
    xticklabels = cellstr(num2str(xticks(:)));
elseif ~exist('xticks','var') && exist('xticklabels','var')
    xticks = str2num(cell2mat(xticklabels(:)))';
end
if ~exist('yticks','var') && ~exist('yticklabels','var')
    yticks=ax.YTick(1:2:end);
    yticklabels=ax.YTickLabel(1:2:end);
elseif exist('yticks','var') && ~exist('yticklabels','var')
    yticklabels = cellstr(num2str(yticks(:)));
elseif ~exist('yticks','var') && exist('yticklabels','var')
    yticks = str2num(cell2mat(yticklabels(:)))';
end

% if ~exist('xticks','var'), xticks=ax.XTick(1:2:end); end
% if ~exist('yticks','var'), yticks=ax.YTick(1:2:end); end
% if ~exist('xticklabels','var'), xticklabels=ax.XTickLabel(1:2:end); end
% if ~exist('yticklabels','var'), yticklabels=ax.YTickLabel(1:2:end); end

if ~exist('xaxisOn','var'), xaxisOn = true; end
if ~exist('yaxisOn','var'), yaxisOn = true; end

if ~exist('font_name','var'), font_name = 'helvetica';, end
if ~exist('font_size','var'), font_size = 16;, end
if ~exist('font_angle','var'), font_angle = 'italic';, end
if ~exist('interpreter','var'), interpreter = 'tex'; end

% turn off current axis
%axis tight;
axis off;
hold on;
% get the current x and y limits
xlims = xlim;
ylims = ylim;

% get the current x and y labels
xaxis.label = x_label;
yaxis.label = y_label;
% get the current axis title
xaxis.xytitle = xytitle;

% set majotTickLen
xaxis.majorTickLen = majorTickRatio*(ylims(2)-ylims(1));
yaxis.majorTickLen = majorTickRatio*(xlims(2)-xlims(1));

% set minorTickLen
xaxis.minorTickLen = minorTickRatio*(ylims(2)-ylims(1));
yaxis.minorTickLen = minorTickRatio*(xlims(2)-xlims(1));

% set offset
xaxis.offset = offsetRatio*(ylims(2)-ylims(1));
yaxis.offset = offsetRatio*(xlims(2)-xlims(1));

axis([xlims ylims]+[-yaxis.offset-20*yaxis.majorTickLen 0 -xaxis.offset-20*xaxis.majorTickLen 0]);

% draw horizontal axis lines 
if xaxisOn
    plotXAx(ax,xlims,ylims,xaxis,yaxis,xticks,yticks,xticklabels,yticklabels,...
    font_size,font_name,font_angle)
end

% draw vertical axis lines 
if yaxisOn
    plotYAx(ax,xlims,ylims,xaxis,yaxis,xticks,yticks,xticklabels,yticklabels,...
    font_size,font_name,font_angle)
end  
    

% add x axis label
thandle = text(mean(xlims(:)),ylims(1)-xaxis.offset-15*xaxis.majorTickLen,xaxis.label,'interpreter',interpreter);
set(thandle,'HorizontalAlignment','center');
set(thandle,'VerticalAlignment','top');
set(thandle,'FontSize',font_size);
set(thandle,'FontName',font_name);
set(thandle,'FontAngle',font_angle);
  
% add y axis label
thandle = text(xlims(1)-yaxis.offset-15*yaxis.majorTickLen,mean(ylims(:)),yaxis.label,'interpreter',interpreter);
set(thandle,'HorizontalAlignment','center');
set(thandle,'VerticalAlignment','bottom');
set(thandle,'FontSize',font_size);
set(thandle,'FontName',font_name);
set(thandle,'FontAngle',font_angle);
set(thandle,'Rotation',90);

% add title
thandle = text(mean(xlims(:)),ylims(2)+0.05*(ylims(2)-ylims(1)),xaxis.xytitle,'interpreter',interpreter);
set(thandle,'HorizontalAlignment','center');
set(thandle,'VerticalAlignment','bottom');
set(thandle,'FontSize',font_size);
set(thandle,'FontName',font_name);
set(thandle,'FontAngle',font_angle);



%% Functions

%% evalargs
function evalstr = evalargs(args)

    evalstr='';

    if mod(length(args),2)
        if isstruct(args{1})
            fromstruct = [fieldnames(args{1}) struct2cell(args{1})]';
            args = [fromstruct(:)' args{2:end}];
        else
            help evalargs;
            display('variables/values are not in pairs!');
            display('will attempt to assign those in pairs. press any key to continue..');
            args = args(1:end-1);
            pause;
        end
    end

    for i = 1:2:length(args)
        % dealing with errors; var names must be strings
        if ~isstr(args{i})
            help evalargs;
            return
        else
            varName = args{i};
        end
        varVal = args{i+1};
        % dealing with cell arrays
        if iscell(varVal)
            cellVal = args{i+1};
            % dealing with cell array of strings
            if isstr(cellVal{1})
                xx = sprintf('''%s''',cellVal{1});
                for j = 2:length(cellVal)
                    if isstr(cellVal{j})
                        xx = sprintf('%s,''%s''',xx,cellVal{j});
                    else
                        xx = sprintf('%s,[%s]',xx,num2str(cellVal{j}));
                    end 
                end
                xx = ['{' xx '}'];
                assignment = sprintf('%s=%s;',varName, xx);
                evalstr = sprintf('%s%s',evalstr,assignment);
            % dealing with cell array of number vectors
            else
                xx = sprintf('[%s]',num2str(cellVal{1}));
                for j = 2:length(cellVal)
                    xx = sprintf('%s,[%s]',xx,num2str(cellVal{j}));
                end
                xx = ['{' xx '}'];
                assignment = sprintf('%s=%s;',varName, xx);
                evalstr = sprintf('%s%s',evalstr,assignment);
            end
        % dealing with strings
        elseif isstr(varVal)
            strVal = args{i+1};
            assignment = sprintf('%s=''%s'';',varName, strVal);
            evalstr = sprintf('%s%s',evalstr,assignment);
        %dealing with number vectors    
        else
            numVal = args{i+1};
            assignment = sprintf('%s=[%s];',varName, num2str(numVal));
            evalstr = sprintf('%s%s',evalstr,assignment);
        end
    %    display(sprintf('%s',assignment));
    end

%% plotXAx
function plotXAx(ax,xlims,ylims,xaxis,yaxis,xticks,yticks,xticklabels,yticklabels,...
    font_size,font_name,font_angle)
%%
	xLoc = get(ax,'XAxisLocation');
    yDir = get(ax,'YDir');
    if strcmp(xLoc,'bottom') && strcmp(yDir,'normal')
            plot(xlims,[ylims(1)-xaxis.offset ylims(1)-xaxis.offset],'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = xticks
                thisticklabel = xticklabels{find(xticks==i)};
                % draw major tick
                plot([i i],[ylims(1)-xaxis.offset ylims(1)-xaxis.majorTickLen-xaxis.offset],'k');
                % put label
                thandle = text(i,ylims(1)-xaxis.offset-1.5*xaxis.majorTickLen,thisticklabel);
                %  get(thandle)
                % and format the text
                set(thandle,'HorizontalAlignment','center');
                set(thandle,'VerticalAlignment','top');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
            
    elseif strcmp(xLoc,'bottom') && strcmp(yDir,'reverse')
            plot(xlims,[ylims(2)+xaxis.offset ylims(2)+xaxis.offset],'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = xticks
                thisticklabel = xticklabels{find(xticks==i)};
                % draw major tick
                plot([i i],[ylims(1)+xaxis.offset ylims(1)+xaxis.majorTickLen-xaxis.offset],'k');
                % put label
                thandle = text(i,ylims(1)-xaxis.offset-1.5*xaxis.majorTickLen,thisticklabel);
                %  get(thandle)
                % and format the text
                set(thandle,'HorizontalAlignment','center');
                set(thandle,'VerticalAlignment','top');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
            
    elseif strcmp(xLoc,'top') && strcmp(yDir,'normal')
            plot(xlims,[ylims(2)+xaxis.offset ylims(2)+xaxis.offset],'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = xticks
                thisticklabel = xticklabels{find(xticks==i)};
                % draw major tick
                plot([i i],[ylims(1)+xaxis.offset ylims(1)+xaxis.majorTickLen-xaxis.offset],'k');
                % put label
                thandle = text(i,ylims(1)-xaxis.offset-1.5*xaxis.majorTickLen,thisticklabel);
                %  get(thandle)
                % and format the text
                set(thandle,'HorizontalAlignment','center');
                set(thandle,'VerticalAlignment','top');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
            
    elseif strcmp(xLoc,'bottom') && strcmp(yDir,'reverse')
            plot(xlims,[ylims(1)-xaxis.offset ylims(1)-xaxis.offset],'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = xticks
                thisticklabel = xticklabels{find(xticks==i)};
                % draw major tick
                plot([i i],[ylims(1)-xaxis.offset ylims(1)-xaxis.majorTickLen-xaxis.offset],'k');
                % put label
                thandle = text(i,ylims(1)-xaxis.offset-1.5*xaxis.majorTickLen,thisticklabel);
                %  get(thandle)
                % and format the text
                set(thandle,'HorizontalAlignment','center');
                set(thandle,'VerticalAlignment','top');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
    end
    
    
%% plotYAx
function plotYAx(ax,xlims,ylims,xaxis,yaxis,xticks,yticks,xticklabels,yticklabels,...
    font_size,font_name,font_angle)
%%
	yLoc = get(ax,'YAxisLocation');
    xDir = get(ax,'XDir');
    if strcmp(yLoc,'left') && strcmp(xDir,'normal')
            plot([xlims(1)-yaxis.offset xlims(1)-yaxis.offset],ylims,'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = yticks
                thisticklabel = yticklabels{find(yticks==i)};
                % draw major tick
                plot([xlims(1)-yaxis.offset xlims(1)-yaxis.offset-yaxis.majorTickLen],[i i],'k');
                % draw text
                thandle = text(xlims(1)-yaxis.offset-2*yaxis.majorTickLen,i,thisticklabel);
                % and format the text
                set(thandle,'HorizontalAlignment','right');
                set(thandle,'VerticalAlignment','middle');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
    elseif strcmp(yLoc,'left') && strcmp(xDir,'reverse')
            plot([xlims(2)+yaxis.offset xlims(2)+yaxis.offset],ylims,'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = yticks
                thisticklabel = yticklabels{find(yticks==i)};
                % draw major tick
                plot([xlims(2)+yaxis.offset xlims(2)+yaxis.offset+yaxis.majorTickLen],[i i],'k');
                % draw text
                thandle = text(xlims(2)+yaxis.offset+2*yaxis.majorTickLen,i,thisticklabel);
                % and format the text
                set(thandle,'HorizontalAlignment','right');
                set(thandle,'VerticalAlignment','middle');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
    elseif strcmp(yLoc,'right') && strcmp(xDir,'normal')
            plot([xlims(2)+yaxis.offset xlims(2)+yaxis.offset],ylims,'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = yticks
                thisticklabel = yticklabels{find(yticks==i)};
                % draw major tick
                plot([xlims(2)+yaxis.offset xlims(2)+yaxis.offset+yaxis.majorTickLen],[i i],'k');
                % draw text
                thandle = text(xlims(2)+yaxis.offset+2*yaxis.majorTickLen,i,thisticklabel);
                % and format the text
                set(thandle,'HorizontalAlignment','left');
                set(thandle,'VerticalAlignment','middle');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
    elseif strcmp(yLoc,'right') && strcmp(xDir,'reverse')
            plot([xlims(1)-yaxis.offset xlims(1)-yaxis.offset],ylims,'k');hold on
            
            % draw major tick on horizontal axis with approporiate labels
            for i = yticks
                thisticklabel = yticklabels{find(yticks==i)};
                % draw major tick
                plot([xlims(1)-yaxis.offset xlims(1)-yaxis.offset-yaxis.majorTickLen],[i i],'k');
                % draw text
                thandle = text(xlims(1)-yaxis.offset-2*yaxis.majorTickLen,i,thisticklabel);
                % and format the text
                set(thandle,'HorizontalAlignment','left');
                set(thandle,'VerticalAlignment','middle');
                set(thandle,'FontSize',font_size);
                set(thandle,'FontName',font_name);
                set(thandle,'FontAngle',font_angle);
            end
    end