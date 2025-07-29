# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/apcave/nordic/bootloader/mcuboot/boot/zephyr"
  "/home/apcave/nordic/blinky/build/mcuboot"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/tmp"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/src/mcuboot-stamp"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/src"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/src/mcuboot-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/src/mcuboot-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/bootloader/mcuboot-prefix/src/mcuboot-stamp${cfgdir}") # cfgdir has leading slash
endif()
