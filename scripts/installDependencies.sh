#!/bin/bash
# installDependencies.sh
# Install dependencies for  the Intel Realsense library librealsense on a Jetson TX Development Kit
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
# e.g. echo "${red}red text ${green}green text${reset}"
echo "${green}Adding Universe repository and updating${reset}"
apt-add-repository universe
apt-get update
echo "${green}Adding dependencies, graphics libraries and tools${reset}"
apt-get install libusb-1.0-0-dev pkg-config -y
# This is for ccmake
apt-get install build-essential -y
# librealsense requires CMake 3.8; This cmake-curses-gui is for 3.5.1
# apt-get install cmake-curses-gui -y


# Graphics libraries are for the examples; not required for librealsense core library
apt-get install libglfw3-dev libgtk-3-dev -y

# QtCreator for development; not required for librealsense core library
apt-get install qtcreator -y

# From /etc/init/nv.conf

	# Ensure libglx.so is not overwritten by a distribution update of Xorg
	ARCH=`/usr/bin/dpkg --print-architecture`
	if [ "x${ARCH}" = "xarm64" ]; then
		LIB_DIR="/usr/lib/aarch64-linux-gnu"
	elif [ "x${ARCH}" = "xarmhf" ]; then
		LIB_DIR="/usr/lib/arm-linux-gnueabihf"
	else
		LIB_DIR="/usr/lib/arm-linux-gnueabi"
	fi

	if [ -e "${LIB_DIR}/tegra/libglx.so" ]; then
		ln -sf ${LIB_DIR}/tegra/libglx.so /usr/lib/xorg/modules/extensions/libglx.so
	fi

	if [ -e "${LIB_DIR}/tegra/libGL.so.1" ]; then
		ln -sf ${LIB_DIR}/tegra/libGL.so.1 ${LIB_DIR}/libGL.so
	fi

	if [ -e "${LIB_DIR}/tegra-egl/libEGL.so.1" ]; then
		ln -sf ${LIB_DIR}/tegra-egl/libEGL.so.1 ${LIB_DIR}/libEGL.so
	fi

	if [ -e "/var/lib/lightdm" ]; then
		sudo chown lightdm:lightdm /var/lib/lightdm -R
	fi

