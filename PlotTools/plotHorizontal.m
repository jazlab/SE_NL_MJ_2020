function h = plotHorizontal(y,varargin)
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

addRequired(Parser,'y')
addParameter(Parser,'axesHandle',gca)
addParameter(Parser,'lineProperties',lineProperties_default)
addParameter(Parser,'MinMax',[NaN NaN])

parse(Parser,y,varargin{:});

y = Parser.Results.y;
axesHandle = Parser.Results.axesHandle;
lineProperties = Parser.Results.lineProperties;
MinMax = Parser.Results.MinMax;

if any(isnan(MinMax))
    MinMax(1) = axesHandle.XLim(1);
    MinMax(2) = axesHandle.XLim(2);
end

% Plot the unity line
h = plot(axesHandle,MinMax,repmat(y(:)',2,1));
if isstruct(lineProperties)
    set(h,lineProperties)
elseif iscell(lineProperties)
    set(h,lineProperties{1},lineProperties{2})
else
    error('lineProperties input not recognized!')
end


