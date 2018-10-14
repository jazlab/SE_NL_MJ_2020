%% DemoScript
%
%   Provides examples of how to use plot tools developed by SWE
%
%%

%% Data
typeN = 5;
trialN = 100;
Betas = linspace(0,1,typeN);
noisePow = 0.1;
x = randn(trialN,1);
for i = 1:typeN
    y(:,i) = Betas(i)*x + noisePow*randn(trialN,1);
end

%% Plot the data

figure('Name','Demo plot')
% LaTeX version
subplot(1,2,1)
for i = 1:typeN
    plot(x,y(:,i),'o',...
        'Color',projectColorMaps('ts','samples',i,'sampleDepth',typeN),...
        'MarkerFaceColor',projectColorMaps('ts','samples',i,'sampleDepth',typeN))
    hold on
end
axis square
plotUnity;
plotVertical(0);
plotHorizontal(0);
xlabel('x')
ylabel('$\beta x + \epsilon$')
mymakeaxis(gca,'xytitle','$t_s$ colors','interpreter','latex',...
    'xticks',[-3 0 3],'yticks',[-3 0 3])    % 'interpreter','latex' option specifies LaTeX rendering of text 

subplot(1,2,2)
% Standard version
for i = 1:typeN
    plot(x,y(:,i),'o',...
        'Color',projectColorMaps('epoch','samples',i,'sampleDepth',typeN),...
        'MarkerFaceColor',projectColorMaps('epoch','samples',i,'sampleDepth',typeN))
    hold on
end
axis square
plotUnity;
plotVertical(0);
plotHorizontal(0);
xlabel('x')
ylabel('y')
mymakeaxis(gca,'xytitle','Epoch colors',...
    'xticks',[-3 0 3],'yticks',[-3 0 3])    % Itallic (default) rendering of text