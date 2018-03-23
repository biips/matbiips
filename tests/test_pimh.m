% [CRASHES ON WINDOWS]

clear variables
close all

addpath ..
biips_clear

% Test pimh with vectors
data.t_max = 10;
data.mean_x_init = 0;
data.prec_x_init = 1;
data.prec_x = 1;
data.prec_y = 10;
%%% Compile BUGS model and sample data
model_filename = 'hmm_1d_lin.bug'; % BUGS model filename
sample_data = true; % Boolean
model = biips_model(model_filename, data, 'sample_data', sample_data);
data = model.data;

variables = {'x', 'x[1:2]'};
n_part = 100;
n_iter = 20;
obj_pimh = biips_pimh_init(model, variables);
obj_pimh = biips_pimh_update(obj_pimh, n_iter, n_part);
[obj_pimh, samples_pimh, log_marg_like_pimh] = biips_pimh_samples(obj_pimh, n_iter, n_part);
biips_clear(model)

% Test pimh with matrices
data.t_max = 10;
data.mean_x_init = 0;
data.prec_x_init = 1;
data.prec_x = 1;
data.prec_y = 10;
%%% Compile BUGS model and sample data
model_filename = 'hmm_1d_lin2.bug'; % BUGS model filename
sample_data = true; % Boolean
model = biips_model(model_filename, data, 'sample_data', sample_data);
data = model.data;

variables = {'x', 'x[1:2,1]'};
n_part = 100;
n_iter = 20;
obj_pimh = biips_pimh_init(model, variables);
obj_pimh = biips_pimh_update(obj_pimh, n_iter, n_part);
[obj_pimh, samples_pimh, log_marg_like_pimh] = biips_pimh_samples(obj_pimh, n_iter, n_part);
biips_clear(model)
