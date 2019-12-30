addpath('C:\Users\Le\Documents\MIT\Jazayeri\Seth_Noisy_Mutual_Inhibition\NoisyMutualInhibition\PlotTools')
%% TwoNeuronDynamics
%
%   TwoNeuronDynamics()
%
%   Simulates the 2-neuron model from Wang et. al. 2017
%
%%

dt = 10;

threshold = 0.7;
u0s = [0.73 0.73];
v0s = [0.48 0.48];
I0s = [1.1 1.5];

colors = [218 112 146;
           65 185 235;
          218 112 146;
           65 185 235]/255;

%h1 = figure('Name','Two neuron','Position',[204 160 528 918]);
h2 = figure('Name','Two neuron','Position',[204 160 999 918]);
lines = {};
for i = 1:length(I0s)
    %% Parameters
    u0 = u0s(i);
    v0 = v0s(i);
    
    params.w = 6;
    params.epsi = 0.01;
    params.I0 = params.w * I0s(i);
%     params.I0 = I0s(i);
    params.tau = 100;
    
%     niter = 1001;
    niter = 101;
    
    vvals = linspace(0,1.2,100);
    
    %% Run simulation
    [u,v,y] = simulate_u_v(u0,v0,params,niter,dt);
    
    
    %% Find null clines
    uvals = find_null_clines(vvals,params);
    
    %% Plot
    %subplot(3,3,[1 4 7])

    figure(h2)
    if i < 3
        subplot(1,2,1)
    else
        subplot(1,2,2)
    end
%    subplot(ceil(sqrt(length(I0s))),ceil(sqrt(length(I0s))),i)
%     plot(u,v,'-','Color',colors(i,:))
    hold on
%     plot(u(1:50:end),v(1:50:end),'.','Color',colors(i,:))
    ind = numel(u);
    plot(u(1:ind),v(1:ind),'.','Color',colors(i,:))
    plot(u(1),v(1),'ko','MarkerFaceColor',[1 1 1],'MarkerSize',7,'Color',colors(i,:))
    plot(u(end),v(end),'ko','MarkerFaceColor',colors(i,:),'MarkerSize',7,'Color','k')
    
    l = plot(vvals,uvals(:,1),'Color',colors(i,:));
    lines{i} = l;
    plot(uvals(:,2),vvals,'--','Color',colors(i,:))
    
    ind = find(vvals == uvals(:,1));
    plot(vvals(ind),uvals(ind,1),'o','Color',[0 0 0],'MarkerFaceColor',[0 0 0])
    
    axis([0 1.2 0 1.2])
%     axis([0 0.5 0 0.5])
    axis square
    plotUnity;
    xlabel('u')
    ylabel('v')
    mymakeaxis(gca)


end
figure(h2)
legend([lines{1}, lines{2}], {'$I_0 = 1.1$', '$I_0 = 1.5$'}, 'Interpreter', 'latex');


%% Functions

%% Activation function
function out = thresh_exp(x)
    out = 1 ./ (1 + exp(-x));
end    
%% find_u_dot
function du = find_u_dot(u,v,params)
    w = params.w;
    epsi = params.epsi;
    I0 = params.I0;
    tau = params.tau;
    
    du = ( -u + thresh_exp( I0 - w*v ) )/tau;
end    
%% find_v_dot
function dv = find_v_dot(u,v,params)
    w = params.w;
    epsi = params.epsi;
    I0 = params.I0;
    tau = params.tau;
    
    dv = ( -v + thresh_exp( I0 - w*u ) )/tau;
end    
%% find_y_dot
function dy = find_y_dot(u,v,y,params)
    tau = params.tau;
    dy = ( -y + (u-v) )/tau;
end
%% simulate_u_v
function [u, v, y] = simulate_u_v(u0,v0,params,niter,dt)
    
    u = nan(1,niter);
    v = nan(1,niter);
    
    u(1) = u0;
    v(1) = v0;
    y(1) = u0-v0;
    for i = 2:niter
        u(i) = u(i-1) + find_u_dot(u(i-1),v(i-1),params)*dt;
        v(i) = v(i-1) + find_v_dot(u(i-1),v(i-1),params)*dt;
        y(i) = y(i-1) + find_y_dot(u(i-1),v(i-1),y(i-1),params)*dt;
    end
end  
%% find_null_clines
function uvals = find_null_clines(vvals,params)
    w = params.w;
    I0 = params.I0;
    epsi = params.epsi;
    
    uvals(:,1) = 1 ./ (1 + exp(-I0 + w*vvals ) );
    uvals(:,2) = 1 ./ (1 + exp(-I0 + w*vvals ) );
    
end