# Locate HLSLcc.
# Based on: https://gitlab.inria.fr/Puffertools/pufferscaletest/pufferscale-exp/blob/master/cmake/Modules/FindYamlCpp.cmake
#
# This module defines:
#  HLSLCC_FOUND, if false, do not try to link to HLSLcc.
#  HLSLCC_STATIC, if true, link against HLSLcc statically.
#  HLSLCC_LIBRARY_RELEASE, where to find Release or RelWithDebInfo of HLSLcc.
#  HLSLCC_LIBRARY_DEBUG, where to find Debug of HLSLcc.
#  HLSLCC_INCLUDE_DIR, where to find header files of HLSLcc.
#  HLSLCC_LIBRARY_DIR, the directories to find HLSLcc library files.
#
# By default, the dynamic libraries of HLSLcc will be found. To find the static ones instead,
# you must set the HLSLCC_USE_STATIC_LIBS variable to TRUE before calling find_package(HLSLcc ...).

if(HLSLCC_USE_STATIC_LIBS)
    set(HLSLCC_STATIC hlslcc.a)
    set(HLSLCC_STATIC_DEBUG hlslcc.a)
endif()

if(${MSVC})
    set(HLSLCC_LIBNAME "hlslcc" CACHE STRING "Name of HLSLcc library")
    set(HLSLCC_LIBNAME optimized ${HLSLCC_LIBNAME} debug hlslcc)
else() ### Set HLSLcc libary name for Unix, Linux, OS X, etc
    set(HLSLCC_LIBNAME "hlslcc" CACHE STRING "Name of HLSLcc library")
endif()

# Find the HLSL include directory.
find_path(HLSLCC_INCLUDE_DIR
        NAMES hlslcc.h
        PATH_SUFFIXES include
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/HLSLcc/include
        ~/Library/Frameworks/HLSLcc/include/
        /Library/Frameworks/HLSLcc/include/
        /usr/local/include/
        /usr/include/
        /sw/HLSLcc/         # Fink
        /opt/local/HLSLcc/  # DarwinPorts
        /opt/csw/HLSLcc/    # Blastwave
        /opt/HLSLcc/)

# Find the release HLSLcc library.
find_library(HLSLCC_LIBRARY_RELEASE
        NAMES ${HLSLCC_STATIC} hlslcc hlslcc.lib hlslcc.lib
        PATH_SUFFIXES lib64 lib Release RelWithDebInfo
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/build
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/sln
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local
        /usr
        /sw
        /opt/local
        /opt/csw
        /opt)

# Find the debug HLSLcc library.
find_library(HLSLCC_LIBRARY_DEBUG
        NAMES ${HLSL_STATIC_DEBUG} hlslcc hlslcc.lib hlslcc.lib
        PATH_SUFFIXES lib64 lib Debug
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/build
        ${PROJECT_SOURCE_DIR}/dependencies/hlslcc/sln
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local
        /usr
        /sw
        /opt/local
        /opt/csw
        /opt)

# Set library vars.
set(HLSLCC_LIBRARY ${HLSLCC_LIBRARY_RELEASE})
if(CMAKE_BUILD_TYPE MATCHES Debug AND EXISTS ${HLSLCC_LIBRARY_DEBUG})
    set(HLSLCC_LIBRARY ${HLSLCC_LIBRARY_DEBUG})
endif()

get_filename_component(HLSLCC_LIBRARY_RELEASE_DIR ${HLSLCC_LIBRARY_RELEASE} PATH)
get_filename_component(HLSLCC_LIBRARY_DEBUG_DIR ${HLSLCC_LIBRARY_DEBUG} PATH)
set(HLSLCC_LIBRARY_DIR ${HLSLCC_LIBRARY_RELEASE_DIR} ${HLSLCC_LIBRARY_DEBUG_DIR})

# Handle the QUIETLY and REQUIRED arguments and set HLSLCC_FOUND to TRUE if all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(HLSLcc DEFAULT_MSG
        HLSLCC_INCLUDE_DIR
        HLSLCC_LIBRARY
        HLSLCC_LIBRARY_DIR)
mark_as_advanced(
        HLSLCC_INCLUDE_DIR
        HLSLCC_LIBRARY_DIR
        HLSLCC_LIBRARY
        HLSLCC_LIBRARY_RELEASE
        HLSLCC_LIBRARY_RELEASE_DIR
        HLSLCC_LIBRARY_DEBUG
        HLSLCC_LIBRARY_DEBUG_DIR)
