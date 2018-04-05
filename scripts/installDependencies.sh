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
apt-get install cmake-curses-gui -y
# Graphics libraries are for the examples; not required for librealsense core library
apt-get install libglfw3-dev libgtk-3-dev -y
apt-get install build-essential -y
# QtCreator for development; not required for librealsense core library
apt-get install qtcreator -y



