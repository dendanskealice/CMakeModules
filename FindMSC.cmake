# Locate ShaderConductor.
# Based on: https://gitlab.inria.fr/Puffertools/pufferscaletest/pufferscale-exp/blob/master/cmake/Modules/FindYamlCpp.cmake
#
# This module defines:
#  MSC_FOUND, if false, do not try to link to ShaderConductor.
#  MSC_STATIC, if true, link against ShaderConductor statically.
#  MSC_LIBRARY_RELEASE, where to find Release or RelWithDebInfo of ShaderConductor.
#  MSC_LIBRARY_DEBUG, where to find Debug of ShaderConductor.
#  MSC_INCLUDE_DIR, where to find header files of ShaderConductor.
#  MSC_LIBRARY_DIR, the directories to find ShaderConductor library files.
#
# By default, the dynamic libraries of ShaderConductor will be found. To find the static ones instead,
# you must set the MSC_USE_STATIC_LIBS variable to TRUE before calling find_package(ShaderConductor ...).

if(MSC_USE_STATIC_LIBS)
    set(MSC_STATIC ShaderConductor.a)
    set(MSC_STATIC_DEBUG ShaderConductor.a)
endif()

if(${MSVC})
    set(MSC_LIBNAME "ShaderConductor" CACHE STRING "Name of ShaderConductor library")
    set(MSC_LIBNAME optimized ${MSC_LIBNAME} debug ShaderConductor)
else() ### Set ShaderConductor libary name for Unix, Linux, OS X, etc
    set(MSC_LIBNAME "ShaderConductor" CACHE STRING "Name of ShaderConductor library")
endif()

# Find the HLSL include directory.
find_path(MSC_INCLUDE_DIR
        NAMES ShaderConductor.hpp
        PATH_SUFFIXES include
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/include
        ~/Library/Frameworks/ShaderConductor/include/
        /Library/Frameworks/ShaderConductor/include/
        /usr/local/include/
        /usr/include/
        /sw/ShaderConductor/         # Fink
        /opt/local/ShaderConductor/  # DarwinPorts
        /opt/csw/ShaderConductor/    # Blastwave
        /opt/ShaderConductor/)

# Find the release ShaderConductor library.
find_library(MSC_LIBRARY_RELEASE
        NAMES ${MSC_STATIC} ShaderConductor ShaderConductor.lib ShaderConductor.lib
        PATH_SUFFIXES lib64 lib Release RelWithDebInfo
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/build
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/sln
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local
        /usr
        /sw
        /opt/local
        /opt/csw
        /opt)

# Find the debug ShaderConductor library.
find_library(MSC_LIBRARY_DEBUG
        NAMES ${MSC_STATIC_DEBUG} ShaderConductor ShaderConductor.lib ShaderConductor.lib
        PATH_SUFFIXES lib64 lib Debug
        PATHS
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/build
        ${PROJECT_SOURCE_DIR}/dependencies/ShaderConductor/sln
        ~/Library/Frameworks
        /Library/Frameworks
        /usr/local
        /usr
        /sw
        /opt/local
        /opt/csw
        /opt)

# Set library vars.
set(MSC_LIBRARY ${MSC_LIBRARY_RELEASE})
if(CMAKE_BUILD_TYPE MATCHES Debug AND EXISTS ${MSC_LIBRARY_DEBUG})
    set(MSC_LIBRARY ${MSC_LIBRARY_DEBUG})
endif()

get_filename_component(MSC_LIBRARY_RELEASE_DIR ${MSC_LIBRARY_RELEASE} PATH)
get_filename_component(MSC_LIBRARY_DEBUG_DIR ${MSC_LIBRARY_DEBUG} PATH)
set(MSC_LIBRARY_DIR ${MSC_LIBRARY_RELEASE_DIR} ${MSC_LIBRARY_DEBUG_DIR})

# Handle the QUIETLY and REQUIRED arguments and set MSC_FOUND to TRUE if all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(ShaderConductor DEFAULT_MSG
        MSC_INCLUDE_DIR
        MSC_LIBRARY
        MSC_LIBRARY_DIR)
		mark_as_advanced(
			MSC_INCLUDE_DIR
			MSC_LIBRARY_DIR
			MSC_LIBRARY
			MSC_LIBRARY_RELEASE
			MSC_LIBRARY_RELEASE_DIR
			MSC_LIBRARY_DEBUG
			MSC_LIBRARY_DEBUG_DIR)
