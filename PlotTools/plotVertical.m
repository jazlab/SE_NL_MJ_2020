function h = plotVertical(x,varargin)
%% plotUnity
%
%   h = plotUnity(figureHandle)
%
%   Plots a unity line on the current plot and returns the graphics object
%   handle.
%
%%

% Defaults
lineProperties_default.LineStyle = '--';
lineProperties_default.Color = 'k';


% Parse inputs
Parser = inputParser;

addRequired(Parser,'x')
addParameter(Parser,'axesHandle',gca)
addParameter(Parser,'lineProperties',lineProperties_default)
addParameter(Parser,'MinMax',[NaN NaN])

parse(Parser,x,varargin{:});

x = Parser.Results.x;
axesHandle = Parser.Results.axesHandle;
lineProperties = Parser.Results.lineProperties;
MinMax = Parser.Results.MinMax;

if any(isnan(MinMax))
    MinMax(1) = axesHandle.YLim(1);
    MinMax(2) = axesHandle.YLim(2);
end

% Plot the unity line
h = plot(axesHandle,repmat(x(:)',2,1),MinMax);
if isstruct(lineProperties)
    set(h,lineProperties)
elseif iscell(lineProperties)
    set(h,lineProperties{1},lineProperties{2})
else
    error('lineProperties input not recognized!')
end


