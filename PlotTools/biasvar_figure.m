load biasvar_021119_thres0_7_constant_stage0_750ms_Krange1to8_Irange77to79_sigma005to04.mat

bias1 = collated_bias_var(:,1);
biasmodel1 = collated_bias_var(:,2);
bias2 = collated_bias_var(:,3);
biasmodel2 = collated_bias_var(:,4);

var1 = collated_bias_var(:,5);
varmodel1 = collated_bias_var(:,6);
var2 = collated_bias_var(:,7);
varmodel2 = collated_bias_var(:,8);


plotBiasVarNhat([bias1 bias2], [var1 var2], ...
    [biasmodel1 biasmodel2], [varmodel1 varmodel2]);

