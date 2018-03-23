clear -variables
close all

addpath ..
biips_clear

% define data
t_max = 10;
data.t_max = t_max;
data.mean_x_init = [0 0 1 0]';
data.prec_x_init = diag(1000*ones(4,1));
data.x_pos = [-10  0];
data.mean_v = zeros(2, 1);
data.prec_v = diag(1*ones(2,1));
data.prec_y = diag([10 100]);
data.delta_t = 1;

% build evalutations functions
biips_add_function('funcmat',2, 'myfuncdim', 'myfunceval')
model = biips_model('hmm_4d_nonlin_funcmat.bug', data);
data = model.data;
x_true = data.x_true(1:2,:);

% run SMC
n_part = 100;
x_name = ['x[1:2,1:' int2str(t_max) ']'];
% y_name = ['y[1,1:' int2str(t_max) ']'];
% out_smc = biips_smc_samples(model, {x_name, y_name}, n_part, 'type', 'fsb');
out_smc = biips_smc_samples(model, {x_name}, n_part, 'type', 'fsb');

% filtering stats
x_summ = biips_summary(out_smc, 'type', 'fs');

% compute densities
% x_dens = biips_density(out_smc, 'fsb', 'fs'); 
