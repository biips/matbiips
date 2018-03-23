clear variables
close all

addpath ..
biips_clear

% RUNS A SET OF TESTS

%% Test console
N=10;
ids=zeros(N,1);
for i=1:N
    ids(i)=matbiips('make_console');
end
p=randperm(N);
for i=1:N
    matbiips('clear_console',ids(p(i)));
end

%% Test model
t_max = 10; mean_x_init = 0;prec_x_init = 1;prec_x = 1;prec_y = 10;
data = struct('t_max', t_max, 'prec_x_init', prec_x_init,...
    'prec_x', prec_x,  'prec_y', prec_y, 'mean_x_init', mean_x_init);

%%% Compile BUGS model and sample data
model_filename = 'hmm_1d_lin.bug'; % BUGS model filename
sample_data = true; % Boolean
model = biips_model(model_filename, data, 'sample_data', sample_data);
data = model.data;
biips_clear(model)

%% Test biips_build_sampler
model = biips_model(model_filename, data, 'sample_data', sample_data);
biips_build_sampler(model)
biips_build_sampler(model,'proposal', 'prior')
biips_build_sampler(model,'proposal', 'auto')
biips_clear(model)


%% test model with wrong type for argument
sample_data = 'tartealacreme';
try
    model = biips_model(model_filename, data, 'sample_data', sample_data);
    data = model.data;
catch err
    if ~isoctave()
        fprintf('[\bExpected error: %s]\b\n', err.message)
    else
        fprintf('\033[31mExpected error: %s\033[0m\n', err.message)
    end
end


%% Test biips_model with argument data names
assignin('base', 't_max', t_max)
assignin('base', 'mean_x_init', mean_x_init)
assignin('base', 'prec_x_init', prec_x_init)
assignin('base', 'prec_x', prec_x)
assignin('base', 'prec_y', prec_y)

model_filename = 'hmm_1d_lin.bug'; % BUGS model filename
sample_data = true; % Boolean
datanames = {'t_max'
    'prec_x'
    'prec_y'
    'mean_x_init'
    'prec_x_init'};
model = biips_model(model_filename, datanames, 'sample_data', sample_data);
biips_clear(model)

%% Missing variable in data names. [SOLVED] CRASH on Windows
bad_datanames = {'t_max'
    'prec_x'
    'prec_y'
    'mean_x_init'};
try
    biips_model(model_filename, bad_datanames, 'sample_data', sample_data)
catch err
    if ~isoctave()
        fprintf('[\bExpected error: %s]\b\n', err.message)
    else
        fprintf('\033[31mExpected error: %s\033[0m\n', err.message)
    end
end


%% Test model with unknown file
data = struct('t_max', t_max, 'prec_x_init', prec_x_init,...
    'prec_x', prec_x,  'prec_y', prec_y, 'mean_x_init', mean_x_init);

badmodel = 'an_unknown_bug_file.bug'; % BUGS model filename
try
    biips_model(badmodel, data, 'sample_data', sample_data)
catch err
    if ~isoctave()
        fprintf('[\bExpected error: %s]\b\n', err.message)
    else
        fprintf('\033[31mExpected error: %s\033[0m\n', err.message)
    end
end

%% Test model with bad filename
badmodel2 = 2; % BUGS model filename
try
    biips_model(badmodel2, data, 'sample_data', sample_data)
catch err
    if ~isoctave()
        fprintf('[\bExpected error: %s]\b\n', err.message)
    else
        fprintf('\033[31mExpected error: %s\033[0m\n', err.message)
    end
end

%% TESTS BIIPS_SMC_SAMPLES with vectors
model_filename = 'hmm_1d_lin.bug'; % BUGS model filename
model = biips_model(model_filename, data, 'sample_data', sample_data);
n_part = 20; % Number of particles
variables = {'x', 'x[1:2]'}; % Variables to be monitored
type = 'fs'; rs_type = 'stratified'; rs_thres = 0.5; % Optional parameters
% Run SMC
out_smc = biips_smc_samples(model, variables, n_part,...
    'type', type, 'rs_type', rs_type, 'rs_thres', rs_thres);
nodes = biips_nodes(model)
biips_clear(model)

% %% TESTS BIIPS_SMC_SAMPLES with matrices [FIXME] ***CRASH on Windows***
% model_filename = 'hmm_1d_lin2.bug'; % BUGS model filename
% model = biips_model(model_filename, data, 'sample_data', sample_data);
% n_part = 20; % Number of particles
% variables = {'x', 'x[1:2,1]'}; % Variables to be monitored
% type = 'fs'; rs_type = 'stratified'; rs_thres = 0.5; % Optional parameters
% % Run SMC
% out_smc = biips_smc_samples(model, variables, n_part,...
%     'type', type, 'rs_type', rs_type, 'rs_thres', rs_thres);
% nodes = biips_nodes(model)
% biips_clear(model)
