#!/bin/bash
# Patch the kernel for the Intel Realsense library librealsense on a Jetson TX Development Kit
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License

# Error out if something goes wrong
set -e

CLEANUP=true

function usage
{
    echo "usage: ./buildPatchedKernel.sh [[-n nocleanup ] | [-h]]"
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



INSTALL_DIR=$PWD
# Is this the correct kernel version?
source scripts/jetson_variables.sh
#Print Jetson version
echo "$JETSON_DESCRIPTION"
#Print Jetpack version
echo "Jetpack $JETSON_JETPACK [L4T $JETSON_L4T]"

# Check to make sure we're installing the correct kernel sources
L4TTarget="28.2"
if [ $JETSON_L4T != $L4TTarget ] ; then
#   echo "Getting kernel sources"
   # sudo ./scripts/getKernelSources.sh
# else
   echo ""
   tput setaf 1
   echo "==== L4T Kernel Version Mismatch! ============="
   tput sgr0
   echo ""
   echo "This repository is for modifying the kernel for L4T "$L4TTarget "system." 
   echo "You are attempting to modify a L4T "$JETSON_L4T "system."
   echo "The L4T releases must match!"
   echo ""
   echo "There may be versions in the tag/release sections that meet your needs"
   echo ""
   exit 1
fi

# Is librealsense on the device?
LIBREALSENSE_DIRECTORY=${HOME}/librealsense
LIBREALSENSE_VERSION=v2.10.4

if [ ! -d "$LIBREALSENSE_DIRECTORY" ] ; then
   echo "The librealsense repository directory is not available"
   read -p "Would you like to git clone librealsense? (y/n) " answer
   case ${answer:0:1} in
     y|Y )
         # clone librealsense
         cd ${HOME}
         echo "${green}Cloning librealsense${reset}"
         git clone https://github.com/IntelRealSense/librealsense.git
         cd librealsense
         # Checkout version the last tested version of librealsense
         git checkout $LIBREALSENSE_VERSION
     ;;
     * )
         echo "Kernel patch and build not started"   
         exit 1
     ;;
   esac
fi

# Is the version of librealsense current enough?
cd $LIBREALSENSE_DIRECTORY
VERSION_TAG=$(git tag -l $LIBREALSENSE_VERSION)
if [ ! $VERSION_TAG  ] ; then
   echo ""
  tput setaf 1
  echo "==== librealsense Version Mismatch! ============="
  tput sgr0
  echo ""
  echo "The installed version of librealsense is not current enough for these scripts."
  echo "This script needs librealsense tag version: "$LIBREALSENSE_VERSION "but it is not available."
  echo "This script uses patches from librealsense on the kernel source."
  echo "Please upgrade librealsense before attempting to patch and build the kernel again."
  echo ""
  exit 1
fi

KERNEL_BUILD_DIR=""
cd $INSTALL_DIR
echo "Ready to patch and build kernel "$JETSON_BOARD
if [ $JETSON_BOARD == "TX2" ] ; then 
  git clone https://github.com/jetsonhacks/buildJetsonTX2Kernel.git
  KERNEL_BUILD_DIR=buildJetsonTX2Kernel
  cd $KERNEL_BUILD_DIR
  git checkout vL4T28.2r3
elif [ $JETSON_BOARD == "TX1" ] ; then
    git clone https://github.com/jetsonhacks/buildJetsonTX1Kernel.git
    KERNEL_BUILD_DIR=buildJetsonTX1Kernel
    cd $KERNEL_BUILD_DIR
    git checkout v1.0-L4T28.2
  else 
    tput setaf 1
    echo "==== Build Issue! ============="
    tput sgr0
    echo "There are no build scripts for this Jetson board"
    exit 1
fi

# Get the kernel sources; does not open up editor on .config file
echo "${green}Getting Kernel sources${reset}"
./getKernelSourcesNoGUI.sh
cd ..
echo "${green}Patching and configuring kernel${reset}"
sudo ./scripts/configureKernel.sh
sudo ./scripts/patchKernel.sh

cd $KERNEL_BUILD_DIR
# Make the new Image and build the modules
echo "${green}Building Kernel and Modules${reset}"
./makeKernel.sh
# Now copy over the built image
./copyImage.sh
# Remove buildJetson Kernel scripts
if [ $CLEANUP == true ]
then
 echo "Removing Kernel build sources"
 ./removeAllKernelSources.sh
 cd ..
 sudo rm -r $KERNEL_BUILD_DIR
else
 echo "Kernel sources are in /usr/src"
fi


echo "Please reboot for changes to take effect"

