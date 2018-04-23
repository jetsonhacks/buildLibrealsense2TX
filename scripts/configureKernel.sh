#!/bin/bash
# Configure the kernel for the Intel Realsense library on a NVIDIA Jetson TX Development Kit
# Jetson TX1, Jetson TX2
# Copyright (c) 2016-18 Jetsonhacks 
# MIT License

# For L4T 28.2 the kernel is 4.4.38 hence kernel-4.4
echo "Configuring Kernel for librealsense"

cd /usr/src/kernel/kernel-4.4
echo "Current working directory: "$PWD
KERNEL_VERSION=$(uname -r)
# For L4T 28.2 the kernel is 4.4.38 ; everything after that is the local version
# This removes the suffix
LOCAL_VERSION=${KERNEL_VERSION#$"4.4.38"}

# == Industrial I/O support
# IIO_BUFFER - Enable buffer support within IIO
# IIO_TRIGGERED_BUFFER -
# HID_SENSOR_IIO_COMMON - Common modules for all HID Sensor IIO drivers
# HID_SENSOR_IIO_TRIGGER - Common module (trigger) for all HID Sensor IIO drivers)
# HID_SENSOR_HUB - HID Sensors framework support
# == Devices
# HID_SENSOR_ACCEL_3D - HID Accelerometers 3D (NEW)
# HID_SENSOR_GYRO_3D - HID Gyroscope 3D (NEW)


bash scripts/config --file .config \
	--set-str LOCALVERSION $LOCAL_VERSION \
	--enable IIO_BUFFER \
        --module IIO_KFIFO_BUF \
        --module IIO_TRIGGERED_BUFFER \
        --enable IIO_TRIGGER \
        --set-val IIO_CONSUMERS_PER_TRIGGER 2 \
        --module HID_SENSOR_IIO_COMMON \
        --module HID_SENSOR_IIO_TRIGGER \
        --module HID_SENSOR_HUB \
        --module HID_SENSOR_ACCEL_3D \
	--module HID_SENSOR_GYRO_3D

