colors = [247,251,255
    222,235,247
    198,219,239
    158,202,225
    107,174,214
    66,146,198
    33,113,181
    8,81,156
    8,48,107] / 255;


%% Keeping u = 0.7, vary v
load uv_init_times_v_0to0.6_u_0.3to1.5_400ms.mat
figure;
upos = find(uinit_lst == 0.7);
vmeans = means(upos, :);
vstds = stds(upos, :);
l1 = errorbar(vinit_lst, vmeans * 10, vstds * 10, 'LineWidth', 2, 'Color', colors(5,:), ...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(5,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on
plot(vinit_lst, vmeans * 10, 'Color', colors(5,:));


load uv_init_times_v_0to0.6_u_0.3to1.5_1000ms.mat
upos = find(uinit_lst == 0.7);
vmeans = means(upos, :);
vstds = stds(upos, :);
l2 = errorbar(vinit_lst, vmeans * 10, vstds * 10, 'LineWidth', 2, 'Color', colors(8,:),...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(8,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);

plot(vinit_lst, vmeans * 10, 'Color', colors(8,:));


mymakeaxis('x_label', '$v_0$', 'y_label', '$t_p$ (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
legend([l1, l2], {'400 ms', '1000 ms'})


%% Keeping v = 0.2, vary u
load uv_init_times_v_0to0.6_u_0.3to1.5_400ms.mat
figure;
vpos = find(abs(vinit_lst - 0.2) < 0.01);
vmeans = means(:, vpos);
vstds = stds(:, vpos);
l1 = errorbar(uinit_lst, vmeans * 10, vstds * 10, 'LineWidth', 2, 'Color', colors(5,:), ...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(5,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);
hold on
plot(uinit_lst, vmeans * 10, 'Color', colors(5,:));


load uv_init_times_v_0to0.6_u_0.3to1.5_1000ms.mat
vpos = find(abs(vinit_lst - 0.2) < 0.01);
vmeans = means(:, vpos);
vstds = stds(:, vpos);
l2 = errorbar(uinit_lst, vmeans * 10, vstds * 10, 'LineWidth', 2, 'Color', colors(8,:),...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(8,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);

plot(uinit_lst, vmeans * 10, 'Color', colors(8,:));
mymakeaxis('x_label', '$v_0$', 'y_label', '$t_p$ (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
legend([l1, l2], {'400 ms', '1000 ms'})

%% Vary both u and v, ts = 1000 ms
load uv_init_times_v_0to0.6_u_0.3to1.5_fine_1000ms.mat

im = imagesc(means * 10, 'YData', [min(uinit_lst), max(uinit_lst)],...
    'XData', [min(vinit_lst), max(vinit_lst)]);

% Make colorbar
colormap hot

c = colorbar;
c.Label.String = 't_p';
axis xy
%caxis([20 60])
caxis([800, 1200])
%xlabel('$K$', 'interpreter', 'latex')
%ylabel('$I$', 'interpreter', 'latex')

set(gca, 'YDir', 'normal');
set(gca, 'XDir', 'normal');
set(gca, 'Visible', 'on')
axis square

% Change x and yticks
% Find the minimum point
[~,Nx0] = min(abs(uinit_lst - 0.7));
[~,Ny0] = min(abs(vinit_lst - 0.2));
x0 = 0.7;
y0 = 0.2;
% [Nx0, Ny0] = find(normmse1 == min(normmse1(:)));
% y0 = min(Klst) + (max(Klst) - min(Klst)) * Ny0 / size(normmse1, 1);
% x0 = min(Ilst) + (max(Ilst) - min(Ilst)) * Nx0 / size(normmse1, 2);
% 
hold on;
plot(y0, x0, 'kx', 'MarkerSize', 15);

plot([y0, y0], [min(uinit_lst), max(uinit_lst)], 'k--');
plot([min(vinit_lst), max(vinit_lst)], [x0, x0], 'k--');
% 
% % Label optimal point
% text(y0 + 0.2, x0, '$(u_0, v_0)$', 'interpreter', 'latex',...
%     'Color', 'w', 'FontSize', 20, 'FontWeight', 'bold')

mymakeaxis('x_label', '$v_0$', 'y_label', '$u_0$', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
% 
% % Resize the figure
set(gcf, 'Position', [89 105 550 420]);
set(gca, 'Position', [0 0.03 0.8 0.9]);
set(c, 'Position', [0.8 0.2859 0.04 0.643], 'FontSize', 16,...
    'Ticks', 800:200:1200, 'FontAngle', 'italic');

%% Vary both u and v, ts = 400 ms
load uv_init_times_v_0to0.6_u_0.3to1.5_fine_400ms.mat

im = imagesc(means * 10, 'YData', [min(uinit_lst), max(uinit_lst)],...
    'XData', [min(vinit_lst), max(vinit_lst)]);

% Make colorbar
colormap hot

c = colorbar;
c.Label.String = 't_p';
axis xy
caxis([200 600])
%xlabel('$K$', 'interpreter', 'latex')
%ylabel('$I$', 'interpreter', 'latex')

set(gca, 'YDir', 'normal');
set(gca, 'XDir', 'normal');
set(gca, 'Visible', 'on')
axis square

% Change x and yticks
% Find the minimum point
[~,Nx0] = min(abs(uinit_lst - 0.7));
[~,Ny0] = min(abs(vinit_lst - 0.2));
x0 = 0.7;
y0 = 0.2;
% [Nx0, Ny0] = find(normmse1 == min(normmse1(:)));
% y0 = min(Klst) + (max(Klst) - min(Klst)) * Ny0 / size(normmse1, 1);
% x0 = min(Ilst) + (max(Ilst) - min(Ilst)) * Nx0 / size(normmse1, 2);
% 
hold on;
plot(y0, x0, 'kx', 'MarkerSize', 15);

plot([y0, y0], [min(uinit_lst), max(uinit_lst)], 'k--');
plot([min(vinit_lst), max(vinit_lst)], [x0, x0], 'k--');
% 
% % Label optimal point
% text(y0 + 0.2, x0, '$(u_0, v_0)$', 'interpreter', 'latex',...
%     'Color', 'w', 'FontSize', 20, 'FontWeight', 'bold')

mymakeaxis('x_label', '$v_0$', 'y_label', '$u_0$', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
% 
% % Resize the figure
set(gcf, 'Position', [89 105 550 420]);
set(gca, 'Position', [0 0.03 0.8 0.9]);
set(c, 'Position', [0.8 0.2859 0.04 0.643], 'FontSize', 16,...
    'Ticks', 200:200:600, 'FontAngle', 'italic');


%% Dependence on initialization period
load initialization_dependence_400ms.mat
figure;
hold on
l1 = errorbar(window_lst, means * 10, stds * 10, 'LineWidth', 2, 'Color', colors(5,:),...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(5,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);
plot(window_lst, means * 10, 'Color', colors(5,:));

load initialization_dependence_1000ms.mat
l2 = errorbar(window_lst, means * 10, stds * 10, 'LineWidth', 2, 'Color', colors(8,:),...
    'Marker', 'o', 'LineStyle', 'none',...
    'MarkerFaceColor', colors(8,:), 'MarkerSize', 4,...
    'LineWidth', 1.5);
plot(window_lst, means * 10, 'Color', colors(8,:));

mymakeaxis('x_label', 'Initialization period (ms)', 'y_label', '$t_p$ (ms)', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)
legend([l1, l2], {'400 ms', '1000 ms'})
