clear -variables
close all

addpath ..
biips_clear

% TESTS BIIPS_PMMH
% Test model with cell data structure
data.t_max = 20;
data.mean_x_init = 0;
data.prec_x_init = 1;
data.prec_x = 1;
data.mean0 = [0;0];
data.prec0 = eye(2);
%%% Compile BUGS model and sample data
model_filename = 'hmm_1d_nonlin_param.bug'; % BUGS model filename
sample_data = true; % Boolean
model = biips_model(model_filename, data, 'sample_data', sample_data);
data = model.data;

param_names = {'log_prec_y[1:2]', 'alpha[1:1]'};
inits = {[0, 0], 5};
latent_names = {};
n_burn = 50;
n_part = 50;
n_iter = 50;

% *Init PMMH*
obj_pmmh = biips_pmmh_init(model, param_names, 'inits', inits, 'latent_names', latent_names); % creates a pmmh object

% *Run PMMH*
obj_pmmh = biips_pmmh_update(obj_pmmh, n_burn, n_part); % adaptation and burn-in iterations
[obj_pmmh, out_pmmh, log_marg_like_pen, log_marg_like, stats_pmmh] = biips_pmmh_samples(obj_pmmh, n_iter, n_part,...
    'thin', 1); % Samples
biips_clear(model)