function [obj_pmmh, varargout] = biips_pmmh_update(obj_pmmh, n_iter, n_part, varargin)
% BIIPS_PMMH_UPDATE Perform adaptation and burn-in iterations for the PMMH algorithm.
% [obj_pmmh, log_marg_like_pen, log_marg_like, info_pmmh] = biips_pmmh_update(obj_pmmh, n_iter, n_part,...
%                           'PropertyName', PropertyValue, ...)
%
%   INPUT: 
%   - obj_pmmh:     PMMH structure as returned by BIIPS_PMMH_INIT
%   - n_iter:       integer. Number of adaptation and burn-in iterations
%   - n_part:       integer. Number of particles used in SMC algorithms
%   Optional Inputs:
%   - thin:         integer. Thinning interval. Returns output every 'thin' iterations
%                   (default = 1)
%   - max_fail:     integer. maximum number of failed SMC algorithms allowed.
%                   (default=0).
%   - rw_adapt:     logical. Activate adaptation of the proposal (default=true)
%   - rs_thres, rs_type, ... : Additional arguments to be passed to the SMC
%      algorithm. See BIIPS_SMC_SAMPLES for for details.
%   - max_fail:    integer. maximum number of failed SMC algorithms allowed.
%                  (default=0)
%   - proposal:     proposal string. The type of proposal used by the SMC algorithm.
%                   Possible values are 'auto' and 'prior'. 'auto' selects the
%                   best sampler among available ones automatically. 'prior' forces
%                   assignment of the prior sampler to every node. 'prior' switches off
%                   lots of instructions and can speed up the startup of the SMC for large
%                   models. (default = 'prior').
%
%   OUTPUT:
%   - obj_pmmh:          structure. updated PMMH object
%   Optional output:
%   - log_marg_like_pen:  vector of penalized log marginal likelihood estimates over iterations
%   - log_marg_like:      vector of log marginal likelihood estimates over iterations
%   - info_pmmh:          structure. Additional information on the MCMC run
%                         with the fields:
%                         * accept_rate: vector of acceptance rates over
%                         iterations
%                         * n_fail: number of failed SMC algorithms
%                         * rw_step: standard deviations of the random walk
%                         over iterations.
%
%   See also BIIPS_MODEL, BIIPS_PMMH_INIT, BIIPS_PMMH_SAMPLES

%--------------------------------------------------------------------------
% EXAMPLE:
% modelfile = 'hmm.bug';
% type(modelfile);
% 
% data = struct('tmax', 10, 'p', [.5; .5], 'logtau_true', log(1));
% model = biips_model(modelfile, data);
% 
% n_part = 50;
% obj_pmmh = biips_pmmh_init(model, {'logtau'}, 'latent_names', {'x', 'c[2:10]'}, 'inits', {-2}); % Initialize
% [obj_pmmh, plml_pmmh_burn] = biips_pmmh_update(obj_pmmh, 100, n_part); % Burn-in
% [obj_pmmh, out_pmmh, plml_pmmh] = biips_pmmh_samples(obj_pmmh, 100, n_part, 'thin', 1); % Samples
%--------------------------------------------------------------------------

% Biips Project - Bayesian Inference with interacting Particle Systems
% Matbiips interface
% Authors: Adrien Todeschini, Marc Fuentes, François Caron
% Copyright (C) Inria
% License: GPL-3
% Jan 2014; Last revision: 21-10-2014
%--------------------------------------------------------------------------


%% Call pmmh_algo internal routine
return_samples = false;

varargout = cell(nargout-1,1);
[obj_pmmh, varargout{:}] = pmmh_algo(obj_pmmh, n_iter, n_part,...
    return_samples, varargin{:});
