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
git checkout vL4T28.2r3
# Get the kernel sources; does not open up editor on .config file
echo "${green}Getting Kernel sources${reset}"
./getKernelSourcesNoGUI.sh
cd ..
echo "${green}Patching and configuring kernel${reset}"
sudo ./scripts/configureKernel.sh
sudo ./scripts/patchKernel.sh

cd buildJetsonTX2Kernel
# Make the new Image and build the modules
echo "${green}Building Kernel and Modules${reset}"
./makeKernel.sh
# Now copy over the built image
./copyImage.sh
# Remove buildJetsonTX2Kernel scripts
if [ $CLEANUP == true ]
then
 echo "Removing Kernel build sources"
 ./removeAllKernelSources.sh
 cd ..
 sudo rm -r buildJetsonTX2Kernel
else
 echo "Kernel sources are in /usr/src"
fi


echo "Please reboot for changes to take effect"
