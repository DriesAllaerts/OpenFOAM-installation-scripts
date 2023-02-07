#!/bin/bash

# This script installs OpenFOAM 6 on the Delft Blue supercomputer

# Set install location
export inst_loc=$HOME/OpenFOAM
mkdir -p $inst_loc
cd $inst_loc

# Get OpenFOAM-6
if [ ! -d "OpenFOAM-6"]; then
    echo Cloning OpenFOAM-6 git repository
    git clone https://github.com/OpenFOAM/OpenFOAM-6.git
else
    echo OpenFOAM-6 directory already exists
fi

# Download OpenFOAM environment script
wget https://raw.githubusercontent.com/DriesAllaerts/OpenFOAM-installation-scripts/main/OpenFOAM-6/DelftBlue/OF-6-env-DelftBlue
mkdir etc
mv OF-6-env-DelftBlue etc/OF-6-env-DelftBlue
# Launch OpenFOAM environment
source etc/OF-6-env-DelftBlue
OpenFOAM-6-env

# Use custom scotch config file to point to Delft Blue version and location
wget https://raw.githubusercontent.com/DriesAllaerts/OpenFOAM-installation-scripts/main/OpenFOAM-6/DelftBlue/scotch-config-DelftBlue
mv scotch-config-DelftBlue OpenFOAM-6/etc/config.sh/scotch

# Compile OpenFOAM-6
echo Compiling OpenFOAM
echo ------------------
echo Running compilation in the background, this make up to a few hours
echo Check with $ jobs and abort with $ kill
echo See progress with tail -f build.log
cd OpenFOAM-6/
./Allwmake > build.log 2>&1 &
