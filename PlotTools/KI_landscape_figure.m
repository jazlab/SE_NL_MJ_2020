load IK_relationship_sigma_0-02_102918_1000trials.mat
mselst1 = MSELST;

load mselst_grid_sigma0-05.mat
mselst2 = MSELST;

%mselst1 = log(mselst1);
normmse1 = squeeze(mselst1(1,:,:))./ max(mselst1(:));

normmse2 = squeeze(mselst2(1,:,:));
normmse2 = normmse2 / max(normmse2(:));
%normmse2(11,1) = nan;
%normmse2 = log(normmse2) ./ max(log(mselst2(:)));

surf(normmse2);
xlabel('$I$', 'interpreter', 'latex');
ylabel('$K$', 'interpreter', 'latex');
zlabel('RMSE')


%% Plot the heatmap
normmse2 = imresize(normmse2, 10);
normmse1 = imresize(normmse1, 10);

im = imshow(normmse1, 'InitialMagnification', 'fit', 'XData', [min(Klst), max(Klst)],...
    'YData', [min(Ilst), max(Ilst)]);

% Make colorbar
colormap hot
c = colorbar;
c.Label.String = 'Normalized RMSE';
set(c, 'Position', [0.847 0.3433 0.04 0.5805], 'FontSize', 12,...
    'Ticks', 0.2:0.2:1);



axis xy
caxis([0.15, 1.0])
%xlabel('$K$', 'interpreter', 'latex')
%ylabel('$I$', 'interpreter', 'latex')

set(gca, 'YDir', 'normal');
set(gca, 'XDir', 'normal');
set(gca, 'Visible', 'on')
axis square

% Change x and yticks


% Find the minimum point
[Nx0, Ny0] = find(normmse1 == min(normmse1(:)));
y0 = min(Klst) + (max(Klst) - min(Klst)) * Ny0 / size(normmse1, 1);
x0 = min(Ilst) + (max(Ilst) - min(Ilst)) * Nx0 / size(normmse1, 2);

hold on;
plot(y0, x0, 'wx', 'MarkerSize', 15);
plot([y0, y0], [min(Ilst), x0], 'w--');
plot([min(Klst), y0], [x0, x0], 'w--');

% Label optimal point
text(2.3, 0.7853, '$(K^*, I_0^*)$', 'interpreter', 'latex',...
    'Color', 'w', 'FontSize', 20, 'FontWeight', 'bold')

mymakeaxis('x_label', '$K$', 'y_label', '$I_0$', 'interpreter', 'latex',...
    'offsetRatio', 0, 'font_size', 20)

% Resize the figure
set(gcf, 'Position', [89 105 550 420]);
set(gca, 'Position', [0 0.03 0.8 0.9]);
set(c, 'Position', [0.8 0.2859 0.04 0.643], 'FontSize', 20,...
    'Ticks', 0.2:0.2:1);

% figure;
% subplot('121')
% imshow(normmse1 * 0.7, 'InitialMagnification','fit')
% subplot('122')
% %imshow(squeeze(mselst2(1,:,:))./ max(mselst2(:)), 'InitialMagnification','fit')
% %daspect('auto')
% colormap('hot')
% % mymakeaxis('x_label', 'K')
