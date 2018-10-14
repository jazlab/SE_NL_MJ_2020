function h = plotUnity(varargin)
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

addParameter(Parser,'axesHandle',gca)
addParameter(Parser,'lineProperties',lineProperties_default)
addParameter(Parser,'MinMax',[NaN NaN])

parse(Parser,varargin{:});

axesHandle = Parser.Results.axesHandle;
lineProperties = Parser.Results.lineProperties;
MinMax = Parser.Results.MinMax;

if any(isnan(MinMax))
    MinMax(1) = min([axesHandle.XLim(1); axesHandle.YLim(1)]);
    MinMax(2) = max([axesHandle.XLim(2); axesHandle.YLim(2)]);
end

% Plot the unity line
h = plot(axesHandle,MinMax,MinMax);
if isstruct(lineProperties)
    set(h,lineProperties)
elseif iscell(lineProperties)
    set(h,lineProperties{1},lineProperties{2})
else
    error('lineProperties input not recognized!')
end


