#!/bin/bash
# Patch the kernel for the Intel Realsense library librealsense on a Jetson TX2 Development Kit
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License

# To Do: Check if kernel source is already on device

# Error out if something goes wrong
set -e

CLEANUP=true

function usage
{
    echo "usage: ./buildLibrealsense2TX.sh [[-n nocleanup ] | [-h]]"
    echo "-n | --nocleanup   Do not remove kernel and module sources after build"
    echo "-h | --help  This message"
}

# Iterate through command line inputs
while [ "$1" != "" ]; do
    case $1 in
        -n | --nocleanup )      CLEANUP=false
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done


git clone https://github.com/jetsonhacks/buildJetsonTX2Kernel.git
cd buildJetsonTX2Kernel
git checkout vL4T28.2r2
# Get the kernel sources; does not open up editor on .config file
echo "${green}Getting Kernel sources${reset}"
./getKernelSourcesNoGUI.sh
# This is for a completely stock kernel with the librealsense modules enabled; uname -r = 4.4.38-tegra
echo "${green}Copying librealsense2 Kernel configuration to .config${reset}"
sudo cp ../config/TX2/librealsense2Config /usr/src/kernel/kernel-4.4/.config
echo "${green}Applying librealsense2 kernel and module patches${reset}"
cd ..
./applyKernelPatches.sh
cd buildJetsonTX2Kernel
# Make the new Image and build the modules
echo "${green}Building Kernel and Modules${reset}"
./makeKernel.sh
# Now copy over the built image
./copyImage.sh
# Remove buildJetsonTX2Kernel scripts
cd ..
if [ $CLEANUP == true ]
then
 echo "Removing Kernel build sources"
 sudo rm -r buildJetsonTX2Kernel
 # Remove kernel sources
 sudo rm -r /usr/src/kernel
 sudo rm -r /usr/src/hardware 
 sudo rm  /usr/src/source_release.tbz2
else
 echo "Kernel sources are in /usr/src"
fi


echo "Please reboot for changes to take effect"
