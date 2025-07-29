# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/apcave/nordic/blinky"
  "/home/apcave/nordic/blinky/build/blinky"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/tmp"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/src/blinky-stamp"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/src"
  "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/src/blinky-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/src/blinky-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/apcave/nordic/blinky/build/_sysbuild/sysbuild/images/blinky-prefix/src/blinky-stamp${cfgdir}") # cfgdir has leading slash
endif()
