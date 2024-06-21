#!/bin/bash
# © Copyright 2024 INPE
# This software is licensed under the terms of the Apache Licence Version 2.0 which can be obtained at
# http://www.apache.org/licenses/LICENSE-2.0.
#
# How to build JEDI MPAS-BUNDLE at EGEON
#

# This indicate where libraries from mpas-jedi are installed
export JEDI_OPT=/mnt/beegfs/jose.aravequia/opt-gnu

# Set Compiler and MPI
export JEDI_COMPILER=gnu9/9.4.0
export JEDI_MPI=openmpi4/4.1.1

## to make available the core modules :

module use $JEDI_OPT/modulefiles/core

# Load GNU compiler so this version is the first to be found (without is the system found 8.5.1 first)
#                                           To be sure use "gcc --version". It returns :
#                                           gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-4)
module purge
module load gnu9/9.4.0

## Load MPAS-JEDI compiler and MPI modules

module load jedi-gnu9/9.4.0
module load jedi-openmpi4/4.1.1

##   LOAD THE LIBRARIES MODULES

module load ecbuild/ecmwf-3.8.4 ## ecbuild/ecmwf-3.6.1
module load cmake/3.20.0
module load szip/2.1.1
module load udunits/2.2.28
module load zlib/1.2.11
module load lapack/3.8.0
module load boost-headers/1.68.0
module load eigen/3.3.7
module load hdf5/1.12.0
module load netcdf/4.7.4
module load nccmp/1.8.7.0

## make MKL avail
source /opt/intel/oneapi/mkl/2022.1.0/env/vars.sh

###           develop     rel 2.0.0  >>  rel. 1.0.0     ##  develop
export ver_ec=1.24.4    #   1.23.0     ##  1.16.0       ##   1.24.4
export ver_fc=0.11.0    #   0.9.5      ##  0.9.2        ##   0.11.0
export ver_atlas=0.35.0 #   0.31.1     ##  0.24.1       ##   0.35.0

module load eckit/ecmwf-$ver_ec ## 1.24.4 ## eckit/ecmwf-1.16.0
module load fckit/ecmwf-$ver_fc ## 0.12.1 ## fckit/ecmwf-0.9.2
module load atlas/ecmwf-$ver_atlas ## 0.35.0 ## atlas/ecmwf-0.24.1
module load cgal/5.0.4
module load fftw/3.3.8
export FFTW_INCLUDES=${FFTW_DIR}/include
export FFTW_LIBRARIES=${FFTW_DIR}/lib
module load bufr/noaa-emc-12.0.0
module load pybind11/2.11.0
module load gsl_lite/0.37.0
module load pio/2.5.1-debug
module load json/3.9.1 json-schema-validator/2.1.0
module load odc/ecmwf-2021.03.0
### Not sure that 3 lines below are needed for release 1.0.0
module load gmp/6.2.1
module load mpfr/4.2.1
module load lapack/3.8.0
module load git-lfs/2.11.0
module load ecflow/5.5.3

conda deactivate

### Python is used in ctest
module load python-3.9.15-gcc-9.4.0-f466wuv

###
### User can adjust the 3 lines below to its case
export JEDI_ROOT=${HOME}/jedi
export JEDI_SRC=${JEDI_ROOT}/mpas-bundle-dev   ## path to mpas-bundle release 2.0.0 was download from git
export JEDI_BUILD=${JEDI_ROOT}/build-mpas-dev   ## path to build the JEDI mpas-bundle package

mkdir -p $JEDI_BUILD
cd $JEDI_BUILD

ulimit -s unlimited
ulimit -v unlimited

export PIO_TYPENAME_VALID_VALUES=netcdf,netcdf4p,netcdf4c,pnetcdf;
export PIO_VERSION_MAJOR=2;

export CGAL_DIR=$CGAL_ROOT                 # Path to directory containing CGALConfig.cmake
export Eigen3_DIR=$EIGEN3_PATH             # Path to directory containing Eigen3Config.cmake
export FFTW_PATH=$FFTW_DIR
export Qhull_DIR=${JEDI_OPT}/gnu9-9.4.0/openmpi4-4.1.1/qhull
## export nlohmann_json_DIR=/mnt/beegfs/jose.aravequia/opt/core/json/3.9.1/include/nlohmann
export nlohmann_json_DIR=${JEDI_OPT}/core/json/3.9.1/lib/cmake/nlohmann_json/
export CODE=$JEDI_SRC
export BUILD=$JEDI_BUILD

GMP_DIR=${JEDI_OPT}/gnu9-9.4.0/gmp-6.2.1
export GMP_INC=$GMP_DIR/include
export GMP_LIB=$GMP_DIR/lib
export GMP_LIBRARIES=$GMP_LIB
export GMP_INCLUDE_DIR=$GMP_INC

## ecbuild will redirect URL downloads for coefficients and test-data to the local mirror (copy):
export ECBUILD_DOWNLOAD_BASE_URL=file:///mnt/beegfs/jose.aravequia/mirror-mpas-bundle

ecbuild $JEDI_SRC
make -j4

## Run the tests that are built with mpas
ctest
