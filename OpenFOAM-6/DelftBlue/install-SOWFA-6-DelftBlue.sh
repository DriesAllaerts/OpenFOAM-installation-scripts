#!/bin/bash

# This script installs SOWFA-6 on the Delft Blue supercomputer

# Set install location
export inst_loc=$HOME/OpenFOAM
cd $inst_loc

# Get SOWFA-6
if [ ! -d "SOWFA-6" ]; then
    echo Cloning SOWFA-6 git repository
    git clone https://github.com/NREL/SOWFA-6.git
else
    echo SOWFA-6 directory already exists
fi

# Launch SOWFA environment
if [ ! -f "etc/OF-6-env-DelftBlue" ]; then
    # Download OpenFOAM environment script
    wget https://raw.githubusercontent.com/DriesAllaerts/OpenFOAM-installation-scripts/main/OpenFOAM-6/DelftBlue/OF-6-env-DelftBlue
    mkdir -p etc
    mv OF-6-env-DelftBlue etc/OF-6-env-DelftBlue
fi
source etc/OF-6-env-DelftBlue
OpenFOAM-6-env

# SOWFA-6 is still in development stage, so check out the dev branch of the git repository
cd $SOWFA_DIR
git checkout dev

# Compile SOWFA-6
echo Compiling SOWFA-6
./Allwmake > build.log 2>&1
cd ..
