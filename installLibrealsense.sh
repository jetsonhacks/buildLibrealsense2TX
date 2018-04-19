#!/bin/bash
# Builds the Intel Realsense library librealsense on a Jetson TX Development Kit
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# e.g. echo "${red}The red tail hawk ${green}loves the green grass${reset}"

echo ""
echo "Please make sure that no RealSense cameras are currently attached"
echo ""
read -n 1 -s -r -p "Press any key to continue"
echo ""
sudo ./scripts/installDependencies.sh

INSTALL_DIR=$PWD
cd ${HOME}
echo "${green}Cloning librealsense${reset}"
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
# Checkout version v2.10.4 of librealsense, last tested version
git checkout v2.10.4

echo "${green}Applying Device Bus Patch${reset}"
# Some assumptions are made about how devices attach in the library.
# The Jetson has some devices onboard (the ina3221x power monitor, camera module) 
# that do not report on the USB bus as the library expects.
# This patch is a work around to avoid spamming the console
patch -p1 -i $INSTALL_DIR/patches/internalbus.patch

echo "${green}Applying Model-Views Patch${reset}"
# The render loop of the post processing does not yield; add a sleep
patch -p1 -i $INSTALL_DIR/patches/model-views.patch

echo "${green}Applying AVC Switch Patch${reset}"
# The CMakeLists.txt references the -mavx2 switch, which is not available
# on the Jetson. This patch simply comments it out
patch -p1 -i $INSTALL_DIR/patches/avxSwitch.patch

echo "${green}Applying CUDA Enhancement Patch${reset}"
# Add CUDA code to translate uyvy to RGB/BGR/RGBA/BGRA
patch -p1 -i $INSTALL_DIR/patches/cudaImage.patch

echo "${green}Applying udev rules${reset}"
# Copy over the udev rules so that camera can be run from user space
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger

# Now compile librealsense and install
mkdir build && cd build
# Build examples, including graphical ones
echo "${green}Building make system${reset}"
# Build with CUDA (default), the CUDA flag is USE_CUDA, ie -DUSE_CUDA=true
cmake ../ -DBUILD_EXAMPLES=true
# The library will be installed in /usr/local/lib, header files in /usr/local/include
# The demos, tutorials and tests will located in /usr/local/bin.
echo "${green}Building librealsense, headers, toolsnvidia and demos${reset}"
make -j4
echo "${green}Installing librealsense, headers, tools and demos${reset}"
sudo make install
echo "${green}Library Installed${reset}"
echo " "
echo " -----------------------------------------"
echo "The library is installed in /usr/local/lib"
echo "The header files are in /usr/local/include"
echo "The demos and tools are located in /usr/local/bin"
echo " "
echo " -----------------------------------------"
echo " "



