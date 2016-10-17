#!/bin/bash

export BUILD_JOB_NUMBER=`grep processor /proc/cpuinfo|wc -l`

make exynos7420-noblelte_mea_jv_defconfig
make -j$BUILD_JOB_NUMBER
