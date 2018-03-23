% [FIXME] TESTS BIIPS_PMMH 
clear variables
close all

addpath ..
biips_clear

% set data
data = struct;
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

param_names = {'log_prec_y2[1:2]'};
inits = {[0;0]};

% *Init PMMH*
obj_pmmh = biips_pmmh_init(model, param_names, 'inits', inits); % creates a pmmh object


% Warning: RUNTIME ERROR: Can not change data: variable log_prec_y2[1:2] does not match one node exactly.
%  
% > In pmmh_set_param (line 13)
%   In biips_pmmh_init (line 176) 
% Error using pmmh_set_param (line 16)
% Data change failed: invalid initial value: log_prec_y2[1:2] = [0 0 ]
% 
% Error in biips_pmmh_init (line 176)
% sample_param = pmmh_set_param(console, param_names, pn_param, inits);
