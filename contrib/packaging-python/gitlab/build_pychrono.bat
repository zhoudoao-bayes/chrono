@echo on
echo Process begins
call "%CONDA_INSTALL_LOCN%"\Scripts\activate.bat
Rem Create a fresh env for the build
call conda create --name buildenv python=3.8 --yes
call conda activate buildenv
call conda install --yes anaconda-client
Rem call conda uninstall --yes conda-build
call conda install --yes conda-build=3.18.11
Rem call conda update --all --yes
call conda install --yes -c intel mkl-devel
Rem needed for libiomp5md.lib
Rem conda install -c intel openmp
call conda install -c conda-forge swig=4.0.2 --yes
call conda install -c dlr-sc opencascade --yes
call conda install mkl --yes
call conda install cmake --yes
call conda install jinja2 --yes
call conda config --add channels https://conda.anaconda.org/conda-forge
call conda config --add channels https://conda.anaconda.org/intel
Rem call conda install ninja --yes
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
Rem CMAKE config output is redirected to a file otherwise it gets truncated due to depth
Rem call conda build purge-all timeout /t 240
call conda build .\contrib\packaging-python\conda --python=3.8 --no-remove-work-dir
Rem call anaconda --token "%ANACONDA_TOKEN%" upload "%CONDA_INSTALL_LOCN%"\conda-bld\win-64\pychrono*.bz2 --force --label develop  >> "%LOG_DIR%"\condauploadlog.txt 2>&1
Rem call conda build purge-all  timeout /t 240
call conda build .\contrib\packaging-python\conda --python=3.7 --no-remove-work-dir
Rem call anaconda --token "%ANACONDA_TOKEN%" upload "%CONDA_INSTALL_LOCN%"\envs\buildenv\conda-bld\win-64\pychrono*.bz2 --force --label develop  >> "%LOG_DIR%"\condauploadlog.txt 2>&1
Rem call conda build purge  timeout /t 240
call conda build .\contrib\packaging-python\conda --python=3.9 --no-remove-work-dir
call anaconda --token "%ANACONDA_TOKEN%" upload "%CONDA_INSTALL_LOCN%"\envs\buildenv\conda-bld\win-64\pychrono*.bz2 --force --label develop  >> "%LOG_DIR%"\condauploadlog.txt 2>&1
Rem Delete the build env, so that we have a fresh one every time
call conda activate base
call conda remove --name buildenv --all --yes
echo End Reached