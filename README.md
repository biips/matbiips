matbiips
=========
MATLAB/Octave interface for Biips - Bayesian inference with interacting particle systems.

Biips is a general software for Bayesian inference with interacting
particle systems, a.k.a. sequential Monte Carlo (SMC) methods. It aims at
popularizing the use of these methods to non-statistician researchers and
students, thanks to its automated "black box" inference engine. It borrows from
the BUGS/JAGS software, widely used in Bayesian statistics, the statistical
modeling with graphical models and the language associated with their
descriptions. See <https://biips.github.io> for more information on Biips.

- Version: 0.11.9000
- URL: https://github.com/biips/matbiips
- Bug Reports: https://github.com/biips/matbiips/issues
- Authors: 

	- [Adrien Todeschini](http://adrien.tspace.fr) <adrien.todeschini@gmail.com>
	- [François Caron](http://www.stats.ox.ac.uk/~caron/) <francois.caron@stat.ox.ac.uk>
	- Marc Fuentes <marc.fuentes@inria.fr>
	
- Copyright: Copyright (C) Inria, 2012-2018
- License: GPL-3

Tip for Octave
---------------
Turn output pagination off with

```octave
more off
```

Build mexfile
==============

Linux
-------

Requirements:
- g++
- boost >= 1.58
    - Debian/Ubuntu: `libboost-dev`
    - Fedora/RedHat/OpenSUSE/CentOS: `boost-devel`

```matlab
biips_mex()
```

Mac OS X
---------

Requirements:
- Xcode: from the Mac App Store.
- boost >= 1.58: download from <https://sourceforge.net/projects/boost/files/boost/>
  and extract to e.g. `~/boost_1_58_0`.

```matlab
setenv('BOOST_ROOT', '~/boost_1_58_0')
biips_mex()
```

Windows
--------

Requirements:
- boost 1.58.0: download from 
  <https://sourceforge.net/projects/boost/files/boost/>
  and extract to e.g. `C:\boost_1_58_0`.
- MATLAB requires a C/C++ compiler, see <https://fr.mathworks.com/support/compilers.html>.
  For a free compiler, use MinGW-w64 TDM-GCC, see 
  <https://fr.mathworks.com/help/matlab/matlab_external/compiling-c-mex-files-with-mingw.html>.
    - Download from <http://tdm-gcc.tdragon.net/download>
      and install to e.g. `C:\TDM-GCC-64` (the installation path cannot contain space).
    - Either set the environment variable `MW_MINGW64_LOC` to `C:\TDM-GCC-64` 
      in your system properties or set it manually in the MATLAB console.

        ```matlab
        setenv('MW_MINGW64_LOC', 'C:\TDM-GCC-64')
        ```

    - If you have multiple C or C++ compilers, use `mex -setup` to choose MinGW 
      for both C and C++ MEX files.

        ```matlab
        mex -setup
        mex -setup cpp
        ```

```matlab
setenv('BOOST_ROOT', 'C:\boost_1_58_0')
biips_mex()
```

Run demo
=========

```matlab
cd demo
matbiips_demo
```

Issues
=======

Under Windows, MATLAB/Octave might crash due to unresolved heap corruption problems.

Run tests
==========

```matlab
cd tests
run_tests
```

Curently failing
------------------

Linux: `test_pmmh2`

Windows: `test_pmmh2`, `test_pimh`, `test_crash3`, `test_crash5`, `test_crash6`, `test_crash7`



