#!/bin/bash

# This script installs OpenFOAM 6 on the Delft Blue supercomputer

# Set install location
export inst_loc=$HOME/OpenFOAM
mkdir -p $inst_loc
cd $inst_loc

# Get OpenFOAM-6
if [ ! -d "OpenFOAM-6" ]; then
    echo Cloning OpenFOAM-6 git repository
    git clone https://github.com/OpenFOAM/OpenFOAM-6.git
else
    echo OpenFOAM-6 directory already exists
fi

# Some hacks for using system libraries
#
# Set scotch version and path
sed -i -e 's/SCOTCH_VERSION=scotch_6.0.6/SCOTCH_VERSION=scotch_6.1.1/g' OpenFOAM-6/etc/config.sh/scotch
sed -i -e 's/SCOTCH_ARCH_PATH=$WM_THIRD_PARTY_DIR\/platforms\/$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION\/$SCOTCH_VERSION/SCOTCH_ARCH_PATH=$SCOTCH_ROOT/g' OpenFOAM-6/etc/config.sh/scotch
# Set CGAL path
sed -i -e 's/unset\ CGAL_ARCH_PATH/export CGAL_ARCH_PATH=$CGAL_ROOT/g' OpenFOAM-6/etc/config.sh/CGAL
# Set GMP and MPFR path
sed -i "288i \    export GMP_ARCH_PATH=\$GMP_ROOT" OpenFOAM-6/etc/config.sh/settings
sed -i "288i \    export MPFR_ARCH_PATH=\$MPFR_ROOT" OpenFOAM-6/etc/config.sh/settings
# Set library path to mpfr and gmp needed for CGAL
sed -i -e 's/-L$(MPFR_ARCH_PATH)\/lib$(WM_COMPILER_LIB_ARCH)/-L$(MPFR_ARCH_PATH)\/lib/g' OpenFOAM-6/wmake/rules/General/CGAL
sed -i -e 's/-L$(GMP_ARCH_PATH)\/lib$(WM_COMPILER_LIB_ARCH)/-L$(GMP_ARCH_PATH)\/lib/g' OpenFOAM-6/wmake/rules/General/CGAL

# Download OpenFOAM environment script
wget https://raw.githubusercontent.com/DriesAllaerts/OpenFOAM-installation-scripts/main/OpenFOAM-6/DelftBlue/OF-6-env-DelftBlue
mkdir etc
mv OF-6-env-DelftBlue etc/OF-6-env-DelftBlue
# Launch OpenFOAM environment
source etc/OF-6-env-DelftBlue
OpenFOAM-6-env

# Compile OpenFOAM-6
echo Compiling OpenFOAM
echo ------------------
echo Running compilation in the background, this make up to a few hours
echo Check with $ jobs and abort with $ kill
echo See progress with tail -f build.log
cd OpenFOAM-6/
./Allwmake > build.log 2>&1 &
