# Borrowed from the libfreenect2 project and slightly tweaked:
# https://github.com/OpenKinect/libfreenect2/blob/master/cmake_modules/FindLibUSB.cmake
#
# - Find libusb for portable USB support
# 
# If the LIBUSB_ROOT environment variable
# is defined, it will be used as base path.
# The following standard variables get defined:
#  LIBUSB_FOUND:    true if LIBUSB was found
#  LIBUSB_INCLUDE_DIR: the directory that contains the include file
#  LIBUSB_LIBRARIES:  the libraries

IF(PKG_CONFIG_FOUND)
  IF(DEPENDS_DIR) #Otherwise use System pkg-config path
    SET(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${DEPENDS_DIR}/libusb/lib/pkgconfig")
  ENDIF()
  SET(MODULE "libusb-1.0")
  IF(CMAKE_SYSTEM_NAME MATCHES "Linux")
    SET(MODULE "libusb-1.0>=1.0.20")
  ENDIF()
  IF(LIBUSB_FIND_REQUIRED)
    SET(LIBUSB_REQUIRED "REQUIRED")
  ENDIF()
  PKG_CHECK_MODULES(LIBUSB ${LIBUSB_REQUIRED} ${MODULE})

  FIND_LIBRARY(LIBUSB_LIBRARY
    NAMES ${LIBUSB_LIBRARIES}
    HINTS ${LIBUSB_LIBRARY_DIRS}
  )
  SET(LIBUSB_LIBRARIES ${LIBUSB_LIBRARY})

  RETURN()
ENDIF()

FIND_PATH(LIBUSB_INCLUDE_DIRS
  NAMES libusb.h
  PATHS
    "${DEPENDS_DIR}/libusb"
    "${DEPENDS_DIR}/libusbx"
    ENV LIBUSB_ROOT
  PATH_SUFFIXES
    include
    libusb
    include/libusb-1.0
)

SET(LIBUSB_NAME libusb)

FIND_LIBRARY(LIBUSB_LIBRARIES
  NAMES ${LIBUSB_NAME}-1.0
  PATHS
    "${DEPENDS_DIR}/libusb"
    "${DEPENDS_DIR}/libusbx"
    ENV LIBUSB_ROOT
  PATH_SUFFIXES
    x64/Release/dll
    x64/Debug/dll
    Win32/Release/dll
    Win32/Debug/dll
    MS64
    MS64/dll
)

IF(WIN32)
FIND_FILE(LIBUSB_DLL
  ${LIBUSB_NAME}-1.0.dll
  PATHS
    "${DEPENDS_DIR}/libusb"
    "${DEPENDS_DIR}/libusbx"
    ENV LIBUSB_ROOT
  PATH_SUFFIXES
    x64/Release/dll
    x64/Debug/dll
    Win32/Release/dll
    Win32/Debug/dll
    MS64
    MS64/dll
)
ENDIF()

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBUSB FOUND_VAR LIBUSB_FOUND
  REQUIRED_VARS LIBUSB_LIBRARIES LIBUSB_INCLUDE_DIRS)
