function [a, IPI] = dualProcess(a0,IPI0,Beta,alpha,nSteps,ISIs)
%% Dual-process (Repp, 2005)
%
%   [a, T] = dualProcess(a0,IPI0,Beta,alpha,nSteps,ISIs)
%
%%

% Calc time points of metronome
m(1) = 0;
for stepi = 2:nSteps
    m(stepi) = m(stepi-1) + ISIs(stepi-1);
end

% Calc time points of presses, IPIs
t(1) = a0;
a(1) = a0;
IPI(1) = IPI0;
T(1) = IPI(1);
t(2) = t(1) + IPI(1);
for stepi = 2:nSteps
    a(stepi) = t(stepi) - m(stepi);
    T(stepi) = T(stepi-1) - Beta*(T(stepi-1)-ISIs(stepi-1));
    t(stepi+1) = t(stepi) -alpha*a(stepi) + T(stepi);
end
IPI = diff(t);

