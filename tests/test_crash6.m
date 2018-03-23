% [CRASHES ON WINDOWS] Test SMC with matrices
clear variables
close all

addpath ..
biips_clear


data.t_max = 2;
model = biips_model('hmm.bug', data);
biips_smc_samples(model, {'x[1:2,1]'}, 1);
biips_smc_samples(model, {'x[1:2,1]'}, 1);
biips_smc_samples(model, {'x[1:2,1]'}, 1);
