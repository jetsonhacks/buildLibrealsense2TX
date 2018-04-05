# buildLibrealsense2TX2
Build librealsense 2.0 library on the NVIDIA Jetson TX Development kit. Jetson TX1 and Jetson TX2. Intel RealSense D400 series cameras.

Work in Progress 4/4/2018

This is for version L4T 28.2 (JetPack 3.2)
librealsense v2.10.2

To install the librealsense library:

$ ./installLibrealsense.sh

The install script does the following:

<ul>
<li>Install dependencies</li>
<li>Applies Jetson specific patches</li>
<li>Sets up udev rules so the camera may be used in user space</li>
<li>Builds librealsense, tools and demos</li>
<li>Installs libraries and executables</li>
</ul>


In order for librealsense to work properly, the kernel image must be rebuilt and patches applied to the uvc module and some other support modules. Running installLibrealsense.sh alone will appear to mostly work but will be missing features such as frame metadata support ( https://github.com/IntelRealSense/librealsense/blob/master/doc/frame_metadata.md ).

<h2>To Do:</h2>

<ul>
<li>Kernel patch script</li>
<li>Kernel building instructions</li>
</ul>


<b>Notes:</b>
<ul>
<li>Tested on Intel RealSense D435</li>
</ul>

