%% [CRASHES ON WINDOWS] TESTS BIIPS_SMC_SAMPLES with matrices 
% crashes on Windows
clear variables
close all

addpath ..

t_max = 10; mean_x_init = 0; prec_x_init = 1; prec_x = 1; prec_y = 10;
data = struct('t_max', t_max, 'mean_x_init', mean_x_init, 'prec_x_init', prec_x_init,...
    'prec_x', prec_x,  'prec_y', prec_y);
model = biips_model('hmm_1d_lin2.bug', data);
variables = {'x' 'x[1:2,1]'}; % Variables to be monitored
out_smc = biips_smc_samples(model, variables, 20, 'type', 'fs');
