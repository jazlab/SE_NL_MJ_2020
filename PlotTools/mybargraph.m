function h = mybargraph(x,y,varargin)
%% mybargrpah
%
%   h = mybargraph(x,y)
%
%   Plots a bar graph of the data at each point x with height y. Returns a
%   graphics handle.
%
%%

%% Defaults
barProperties_default.FaceColor = [0 0 0];
barProperties_default.EdgeColor = 'none';
barProperties_default.ShowBaseLine = 'off';
barProperties_default.BarWidth = 0.8;


%% Parse inputs
Parser = inputParser;

addRequired(Parser,'x')
addRequired(Parser,'y')
addParameter(Parser,'barProperties',barProperties_default)

parse(Parser,x,y,varargin{:})

x = Parser.Results.x;
y = Parser.Results.y;
barProperties = Parser.Results.barProperties;

if ~isfield(barProperties,'ShowBaseLine')
    barProperties.ShowBaseLine = 'off';
end
if ~isfield(barProperties,'BarWidth')
    barProperties.BarWidth = barProperties_default.BarWidth;
end

%% Plot the data
h = bar(x,y,'BarWidth',barProperties.BarWidth);
set(h,barProperties);