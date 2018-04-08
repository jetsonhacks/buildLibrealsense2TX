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

<h2>Rebuilding the kernel</h2>
The Jetsons have the v4l2 module built into the kernel image. The module should not be built as an external module, due to needed support for the carrier board camera. Because of this, a separate kernel Image should be generated, as well as any needed modules (such as the patched UVC module).

In order to support Intel RealSense cameras with built in accelerometers and gyroscopes, modules need to be enabled. These modules are in the Industrail I/O device tree. The Jetson already has IIO support enabled in the kernel image to support the INA3321x power monitors. To support these other HID IIO devices, IIO_BUFFER must be enabled; it must be built into the kernel Image as well.

A configuration file of a stock image with the added librealsense2 modules enabled is located in the 'config' folder. The local version is "-tegra"

Most developers will want to apply the needed patches, configure the .config to match their desired environment, and build their kernel image and modules. The script applyKernelPatches.sh will patch the kernel modules and Image to support the librealsense2 cameras. Typically you will need to do a diff with the previously mentioned config file to create a patch to correctly configure the your .config file. You can apply the kernel patches:

$ ./applyKernelPatches.sh

The script assumes that the source is in the usual place for the Jetson, i.e. /usr/src/kernel/kernel-4.4, though you may want to change it to match your needs. Make sure to also update the .config file to include the librealsense2 module configuration information.

<h3>A nasty little alternative</h3>

If you live a little more dangerously, and you are not concerned with building/maintaining your own kernel, there is a script which downloads the kernel source, patches it, builds a new kernel and installs it. To be clear, this is not good development methodology, but it gets the job done. You will need to install the librealsense2 library beforehand as described above.

<em><strong>Note: </strong>If you have a modified kernel Image or module configuration, you do *NOT* want to run this script! The script will overwrite the current kernel image.</em>

On the Jetson TX2:

$ ./buildPatchedKernelTX2.sh

By default, the kernel sources will be erased from the disk after the kernel has been compiled and installed. You will need ~3GB of disk space to build the kernel in this manner. Please note that you should do this on a freshly flashed system. In the case when something goes wrong, it may make the system fail and become unresponsive; the only way to recover may be to use JetPack to reflash.

The script has an option to keep the kernel sources and build information:

$ ./buildPatchedKernelTX2.sh --nocleanup

which may prove useful for debugging purposes.

The script is more provided as a guide on how to build a system that supports librealsense2 than as a practical method to generate a new system.


<h2>To Do:</h2>

<ul>
<li>Kernel patch script for Jetson TX1</li>
</ul>


<b>Notes:</b>
<ul>
<li>Tested on Intel RealSense D435</li>
<li>L4T 28.2 (JetPack 3.2)
<li>NVIDIA Jetson TX2</li>
</ul>

