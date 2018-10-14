% myrgb.m
%
%	by: mehrdad jazayeri
%	last update: May 2008
%    purpose: gets the number of colors (n) needed 
% 	for a plot and returns their RGB values in a h([nx3]) matrix
% 	By default, it generates n graylevels. But it can also be
%	set to return rgb values if the "ratio" parameter is set.
%
%	argin:
%	n : number of colors/graylevels
%	ratio1, ratio2 : 3-vectors with [red green blue] values. Values ae between 0 and 1.
%
%	If ratio is specified, the colors will be set accoding to rgb values in ratio1 and ratio2
%
%    example: h = myrgb(10)						% generates 10 graylevels from black to white
%    example: h = myrgb(10, [1 0 0])			% generates 10 red-levels from black to red
%    example: h = myrgb(10, [1 0 0], [0 1 0])	% generates 10 colors going from red to green
%	
	
function h = myrgb(n, ratio1, ratio2)

if nargin < 1, help myrgb;, return;, end

grays = linspace(0,1,n);
h = [grays' grays' grays'];


if nargin ==1			% go from [0 0 0] to [1 1 1]
	h = [linspace(0,1,n)' linspace(0,1,n)' linspace(0,1,n)'];

elseif nargin ==2		% go from [0 0 0] to [ratio1(1) ratio1(2) ratio1(3)]
	h = [linspace(0,ratio1(1),n)' linspace(0,ratio1(2),n)' linspace(0,ratio1(3),n)'];

elseif nargin ==3		% go from [ratio1(1) ratio1(2) ratio1(3)] to [ratio2(1) ratio2(2) ratio2(3)]
	h = [linspace(ratio1(1),ratio2(1),n)' linspace(ratio1(2),ratio2(2),n)' linspace(ratio1(3),ratio2(3),n)'];
	
end
