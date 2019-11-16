load uv_init_times_v_0to0.6_u_0.3to1.5.mat

%% Keeping u = 0.7, vary v
figure;
upos = find(uinit_lst == 0.7);
vmeans = means(upos, :);
vstds = stds(upos, :);
errorbar(vinit_lst, vmeans, vstds)

%% Keeping v = 0.2, vary u
figure;
vpos = find(abs(vinit_lst - 0.2) < 0.01);
umeans = means(:, vpos);
ustds = stds(:, vpos);
errorbar(uinit_lst, umeans, ustds)

%% Vary both u and v
load uv_init_times_v_0to0.6_u_0.3to1.5_fine.mat
imagesc(means)
xtickid = 5:5:30;
ytickid = 5:5:40;
xticklabels(vinit_lst(xtickid))
yticklabels(uinit_lst(ytickid))
colormap hot
colorbar
