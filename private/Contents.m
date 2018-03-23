% PRIVATE
%
% Files
%   cell2struct_weaknames - builds a structure with "illegal" names
%   check_struct          - Checks if the structure is a valid object of class class
%   clear_monitors        - clears some monitors  
%   clone_model           - Creates a clone of the model
%   deparse_varname       - returns a string of the variable name including bounds
%   get_seed              - return a random seed for RNG
%   has_fsb_fields        - check if structure S has f, s or b fields
%   is_monitored          - check if a variable is monitored
%   kde                   - kernel density estimation with gaussian kernels
%   monitor               - setup monitoring of a variable
%   parse_varname         - parses a string of the form x[1:5]
%   parsevar              - parses the set of optional parameters and returns their values
%   pimh_algo             - performs iterations for the PIMH algorithm
%   pmmh_algo             - performs iterations for the PMMH algorithm
%   pmmh_one_update       - performs one step of the PMMH algorithm
%   pmmh_rw_learn_cov     - updates the empirical covariance of the samples
%   pmmh_rw_proposal      - samples from the proposal distribution
%   pmmh_rw_rescale       - rescale the randow walk variance
%   pmmh_set_param        - Either set or sample initial parmeter value for PMMH
%   smc_forward_algo      - SMC_FORWARD_algo runs a SMC algorithm
%   to_biips_vname        - format string to a valid Biips variable name
%   bw_select             - Computes bandwidth for kernel density estimates
%   data_preprocess       - preprocess the data for Biips
%   is_legal_vname        - check if vname is a legal BUGS variable name
%   is_smc_array          - check if S is a structure with fields 'values', 'weights',
%   pmmh_rw_transform     - Applies transformation functions to samples
%   wtd_stat              - computes univariate statistics on weighted samples
%   check_mex             - check matbiips mexfile is working

