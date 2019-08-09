load uv_simulation_data102718_long_smallK.mat
ylst_smallK = ylst;

load uv_simulation_data102718_long.mat
ylst_bigK = ylst;

green2 = [65,171,93]/255;
green1 = [0,69,41]/255;

% Get num trials and num time steps
[nsteps, ntrials] = size(ylst);

% Get the state of y at the end of each time step
terminal_ys_bigK = ylst_bigK(80:81:end,:);
terminal_ys_smallK = ylst_smallK(80:81:end,:);

nstages = 15; %size(terminal_ys, 1);

idlst = meshgrid(1:nstages, 1:ntrials)';
terminal_ys_bigK = terminal_ys_bigK(1:nstages,:);
terminal_ys_smallK = terminal_ys_smallK(1:nstages,:);


scatter(idlst(:), terminal_ys_bigK(:), 'b', 'filled', 'MarkerFaceAlpha', 0.05)
hold on
scatter(idlst(:), terminal_ys_smallK(:), 'r', 'filled', 'MarkerFaceAlpha', 0.05)
hold on;
plotHorizontal(0.7)

mymakeaxis('x_label', 'Iteration number', 'y_label', '$y$ state at flash',...
    'interpreter', 'latex')


% Get mean and standard deviation
figure;
ymeans_bigK = mean(terminal_ys_bigK, 2);
ymeans_smallK = mean(terminal_ys_smallK, 2);

ystd_bigK = std(terminal_ys_bigK, [], 2);
ystd_smallK = std(terminal_ys_smallK, [], 2);
text(0, 0.701, '$y_0$', 'interpreter','latex');
hold on;
l2 = errorbar(1:nstages, ymeans_bigK, ystd_bigK, 'Color', green1, 'LineStyle', 'none',...
    'MarkerSize', 5, 'Marker', 'o', 'MarkerFaceColor', green1);
plotHorizontal(0.7)

l1 = errorbar((1:nstages) + 0.2, ymeans_smallK, ystd_smallK, 'Color', green2, 'LineStyle', 'none',...
    'MarkerSize', 5, 'Marker', 'o', 'MarkerFaceColor', green2);
mymakeaxis('x_label', 'Iteration number', 'y_label', '$y$ state at flash',...
    'interpreter', 'latex')
legend1 = legend([l1, l2], {'$K = 2.0$', '$K = 3.0$'}, 'Interpreter', 'latex');
set(legend1,'Location', 'best',...
    'EdgeColor',[0.94 0.94 0.94],...
    'Color',[0.941 0.941 0.94]);
hold on;

