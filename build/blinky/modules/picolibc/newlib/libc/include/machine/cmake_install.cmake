# Install script for directory: /home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "MinSizeRel")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/home/apcave/stm32-tools/bin/arm-none-eabi-objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/machine" TYPE FILE FILES
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/ansi.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/_arc4random.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/_default_types.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/endian.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/fastmath.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/fenv-softfloat.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/ieeefp.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/malloc.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/setjmp.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/stdlib.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/termios.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/_time.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/time.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/_types.h"
    "/home/apcave/nordic/modules/lib/picolibc/newlib/libc/include/machine/types.h"
    )
endif()

