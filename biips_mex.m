function biips_mex(varargin)
% BIIPS_MEX Build matbiips mex library
%   biips_mex('PropertyName', PropertyValue, ...)
%
%   Optional inputs:
%   - build_type: string. 'release' (default), 'debug' or 'relwithdebinfo'.
%   - rebuild: logical. rebuild existing files (default = true).
%   - clean: logical. clean object files after build (default = true).
%   - verbose: logical. build in verbose mode (default = false).
%
%   Requires boost header library:
%   - Ubuntu/Debian: sudo apt-get install libboost-dev
%   - Windows/OS X: Download from URL
%                   https://sourceforge.net/projects/boost/
%                   Extract on disk and set environment variable 
%                   'BOOST_ROOT' to the extraction path.
%--------------------------------------------------------------------------
% EXAMPLE:
% setenv('BOOST_ROOT', 'C:\boost_1_58_0')
% biips_mex()
% biips_mex('rebuild', true)
%--------------------------------------------------------------------------

% Biips Project - Bayesian Inference with interacting Particle Systems
% Matbiips interface
% Authors: Adrien Todeschini, Marc Fuentes, François Caron
% Copyright (C) 2012-2017 Inria
% License: GPL-3
% Last revision: 18-02-2017
%--------------------------------------------------------------------------

%% parse arguments
optarg_names = {'build_type' 'rebuild' 'clean' 'verbose'};
optarg_default = {'release' false true false};
optarg_valid = {{'release' 'debug' 'relwithdebinfo'} {} {} {}};
optarg_type = {'char' 'logical' 'logical' 'logical'};
[build_type, rebuild, clean, verbose] = parsevar(varargin, optarg_names, ...
    optarg_type, optarg_valid, optarg_default);

%% configure build
if isoctave
    objext = '.o';
    flags = {'--std=c++11' '-DOCTAVE'};
    switch build_type
        case 'release'
            flags = [flags {'--strip'}];
        otherwise
            flags = [flags {'-g'}];
    end
    if verbose
        flags = [flags {'-v'}];
    end
else
    if ispc
        objext = '.obj';
    else
        objext = '.o';
    end
    flags = {'-largeArrayDims' 'CXXFLAGS=$CXXFLAGS -Wno-deprecated-declarations'};
    switch build_type
        case 'release'
            flags = [flags {'-O'}];
        case 'debug'
            flags = [flags {'-g'}];
        case 'relwithdebinfo'
            flags = [flags {'-g' '-O'}];
    end
    if verbose
        flags = [flags {'-v'}];
    else
        flags = [flags {'-silent'}];
    end
end


%% set includes
includes = fullfile('-Isrc/biips/include', {'core' 'base' 'compiler'});

boost_root = getenv('BOOST_ROOT');
if ~isempty(boost_root)
    if ~isdir(boost_root)
        error(['invalid BOOST_ROOT environment variable: ' boost_root])
    end
    includes = [includes {['-I' boost_root]}];
elseif ispc
    warning('Missing environment variable BOOST_ROOT')
    disp('Press enter to continue...')
    pause
end

%% set source files

% matbiips c++ sources (except matbiips.cpp)
cpp = dir(fullfile('src', '*.cpp'));
src_files = setdiff({cpp.name}, 'matbiips.cpp');
sources = fullfile('src', src_files);

% biips c++ sources
src_dirs = fullfile('src/biips/src', {'core', 'base', 'compiler'});
for i = 1:numel(src_dirs)
    sd = src_dirs{i};
    cpp = dir(fullfile(sd, '*.cpp'));
    cc = dir(fullfile(sd, '*.cc'));
    sources = [sources fullfile(sd, {cpp.name cc.name})];
    src_files = [src_files {cpp.name cc.name}];
    
    d = dir(sd);
    subdirs = {d([d.isdir]).name};
    for j = 3:numel(subdirs)
        sd2 = fullfile(src_dirs{i}, subdirs{j});
        cpp = dir(fullfile(sd2, '*.cpp'));
        cc = dir(fullfile(sd2, '*.cc'));
        sources = [sources fullfile(sd2, {cpp.name cc.name})];
        src_files = [src_files {cpp.name cc.name}];
    end
end

obj_files = cellfun(@(x)[regexp(x, '\w*', 'match', 'once') objext], src_files, 'UniformOutput', false);

%% build
if rebuild || ~check_mex()
    % build object files
    for i = 1:numel(sources)
        if rebuild || ~exist(obj_files{i}, 'file')
            fprintf('[%d%%] Building %s\n', round(100*(i-1)/numel(sources)), obj_files{i})
            mex('-c', flags{:}, includes{:}, sources{i})
        else
            fprintf('[%d%%] Skipped already built %s\n', round(100*(i-1)/numel(sources)), obj_files{i})
        end
    end
    
    % build mex library
    fprintf('[100%%] Building matbiips.%s\n', mexext)
    mex(flags{:}, includes{:}, 'src/matbiips.cpp', obj_files{:})
else
    fprintf('[100%%] Skipped already built matbiips.%s\n', mexext)
end

%% clean
ok = cellfun(@(x)exist(x, 'file')==2, obj_files);
if clean && any(ok)
    fprintf('Cleaning %s\n', sprintf('%s ', obj_files{ok}))
    delete(obj_files{ok})
end

end
