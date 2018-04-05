# buildLibrealsense2TX2
Build librealsense 2.0 library on the NVIDIA Jetson TX Development kit. Jetson TX1 and Jetson TX2. Intel RealSense D400 series cameras.

Work in Progress 4/4/2018

This is for version L4T 28.2 (JetPack 3.2)
librealsense v2.10.2

To install the librealsense library:

$ ./installLibrealsense.sh


Which will install needed dependencies, and then build the librealsense repository. The install script will also set udev rules so that the camera may be used in user space.

In order for librealsense to work properly, the kernel image must be rebuilt and patches applied to the uvc module and some other support modules. The installLibrealsense.sh will appear to mostly work but will be missing features such as frame metadata support.

To Do:

Kernel patch script
Kernel building instructions   


