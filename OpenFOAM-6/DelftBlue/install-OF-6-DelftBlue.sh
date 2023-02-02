#!/bin/bash

# This script installs OpenFOAM 6 on the Delft Blue supercomputer

# Set install location
export inst_loc=$HOME/OpenFOAM
mkdir -p $inst_loc
cd $inst_loc

# Get OpenFOAM-6
echo Cloning OpenFOAM-6
git clone https://github.com/OpenFOAM/OpenFOAM-6.git

# Load relevant modules
module load 2022r2
module load openmpi
module load cgal
module load boost
module load mpfr
module load readline
module load scotch
module load flex
module load gmp

# Launch OpenFOAM environment
cd OpenFOAM-6/
source etc/bashrc 

# Use custom scotch config file to point to Delft Blue version and location
wget https://raw.githubusercontent.com/DriesAllaerts/OpenFOAM-installation-scripts/main/OpenFOAM-6/DelftBlue/scotch-config-DelftBlue
mv scotch-config-DelftBlue etc/config.sh/scotch

# Compile OpenFOAM-6
./Allwmake > build.log 2>&1 &
