load IK_vars.mat

% Sort the MSE list
sorted_all = MSELST * 0;
argsorted_all = MSELST * 0;

for i = 1:size(MSELST, 1)
    lst = MSELST(i,:);
    [sorted, idx] = sort(lst);
    sorted_all(i,:) = sorted;
    argsorted_all(i,:) = idx;
end

% Start plotting
figure;
for i = 1:size(MSELST, 1)
    Ksorted = Klst(argsorted_all(i,1:20));
    Isorted = initIlst(argsorted_all(i,1:20));
    Imeans(i) = mean(Isorted);
    Kmeans(i) = mean(Ksorted);
    subplot('121')
    plot(ones(1, numel(Ksorted)) * sigma_lst(i), Ksorted, 'b.');
    hold on;
    subplot('122')
    plot(ones(1, numel(Isorted)) * sigma_lst(i), Isorted, 'b.');
    hold on;
end

subplot('121')
plot(sigma_lst, Kmeans, 'r', 'LineWidth', 2)
mymakeaxis(gca,'y_label', '$K$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
    'xticks', [0, 0.05, 0.1])

subplot('122')
plot(sigma_lst, Imeans, 'r', 'LineWidth', 2)
mymakeaxis(gca,'y_label', '$I_0$', 'x_label', '$\sigma$', 'interpreter', 'latex',...
     'xticks', [0, 0.05, 0.1])
