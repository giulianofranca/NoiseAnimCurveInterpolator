# Copyright (c) 2022 Giuliano Franca
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# This is a small modification of FindMaya.cmake created by Chad Vernon.
# Source: https://github.com/chadmv/cgcmake/blob/master/modules/FindMaya.cmake
#
#
#.rst:
# FindMaya
# --------
#
# Find Maya headers and libraries.
#
# Imported targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following :prop_tgt:`IMPORTED` target:
#
# ``Maya::Maya``
#   The Maya libraries, if found.
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project:
#
# ``Maya_FOUND``
#   Defined if a Maya installation has been detected
# ``MAYA_INCLUDE_DIR``
#   Where to find the headers (maya/MFn.h)
# ``MAYA_LIBRARIES``
#   All the Maya libraries.
# ``MAYA_TARGET_TYPE``
#   The target type to be installed.
# ``MAYA_PYTHON_INTERPRETER``
#   The python interpreter of maya.
#

set(MAYA_VERSION "2019" CACHE STRING "Specify the Maya version")

if(${MAYA_VERSION} STRLESS "2018")
    message(FATAL_ERROR "Error: Don't work with Maya versions less than 2018.")
endif()

# OS Specific environment setup
set(MAYA_COMPILE_DEFINITIONS "REQUIRE_IOSTREAM;_BOOL")
set(MAYA_TARGET_TYPE LIBRARY)
if(WIN32)
    # Windows
    set(MAYA_INSTALL_BASE_DEFAULT "C:/Program Files/Autodesk")
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};NT_PLUGIN")
    set(MAYA_PLUGIN_EXTENSION ".mll")
    set(MAYA_TARGET_TYPE RUNTIME)
elseif(APPLE)
    # Apple
    set(MAYA_INSTALL_BASE_DEFAULT "/Applications/Autodesk")
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};OSMac_")
    set(MAYA_PLUGIN_EXTENSION ".bundle")
else()
    # Linux
    set(MAYA_INSTALL_BASE_DEFAULT "/usr/autodesk")
    set(MAYA_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS};LINUX")
    set(MAYA_PLUGIN_EXTENSION ".so")
endif()

set(MAYA_INSTALL_BASE_PATH ${MAYA_INSTALL_BASE_DEFAULT} CACHE STRING
    "Root path containing your maya installations, e.g. /usr/autodesk or /Applications/Autodesk/")

set(MAYA_LOCATION ${MAYA_INSTALL_BASE_PATH}/maya${MAYA_VERSION})

# Maya include directory
find_path(MAYA_INCLUDE_DIR maya/MFn.h
    PATHS
        ${MAYA_LOCATION}
    PATH_SUFFIXES
        "devkitBase/include/"
        "include/"
)

# Maya lib directory
find_library(MAYA_LIBRARY
    NAMES 
        OpenMaya
    PATHS
        ${MAYA_LOCATION}
    PATH_SUFFIXES
        "devkitBase/lib/"
        "lib/"
        "Maya.app/Contents/MacOS/"
    NO_DEFAULT_PATH
)

# Maya Python Interpreter
if(USE_MAYAPY)
    find_program(MAYA_PYTHON_INTERPRETER
        NAMES
            mayapy
        PATHS
            ${MAYA_LOCATION}
        PATH_SUFFIXES
            "bin/"
        NO_DEFAULT_PATH
    )
    if(NOT MAYA_PYTHON_INTERPRETER)
        message(FATAL_ERROR "Could not find mayapy version ${MAYA_VERSION}")
    endif()
endif()

set(MAYA_LIBRARIES "${MAYA_LIBRARY}")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Maya
    REQUIRED_VARS 
        MAYA_INCLUDE_DIR
        MAYA_LIBRARY
    VERSION_VAR
        MAYA_VERSION
)
mark_as_advanced(MAYA_INCLUDE_DIR MAYA_LIBRARY)

if (NOT TARGET Maya::Maya)
    add_library(Maya::Maya UNKNOWN IMPORTED)
    set_target_properties(Maya::Maya PROPERTIES
        INTERFACE_COMPILE_DEFINITIONS "${MAYA_COMPILE_DEFINITIONS}"
        INTERFACE_INCLUDE_DIRECTORIES "${MAYA_INCLUDE_DIR}"
        IMPORTED_LOCATION "${MAYA_LIBRARY}")
    
    if (APPLE AND ${CMAKE_CXX_COMPILER_ID} MATCHES "Clang" AND MAYA_VERSION LESS 2017)
        # Clang and Maya 2016 and older needs to use libstdc++
        set_target_properties(Maya::Maya PROPERTIES
            INTERFACE_COMPILE_OPTIONS "-std=c++0x;-stdlib=libstdc++")
    endif ()
endif()

# Add the other Maya libraries into the main Maya::Maya library
# Libraries to add if needed: OpenMayaFX, OpenMayaAnim, clew
set(_MAYA_LIBRARIES OpenMayaFX OpenMayaAnim OpenMayaRender OpenMayaUI Foundation)
foreach(MAYA_LIB ${_MAYA_LIBRARIES})
    find_library(MAYA_${MAYA_LIB}_LIBRARY
        NAMES 
            ${MAYA_LIB}
        PATHS
            ${MAYA_LOCATION}
        PATH_SUFFIXES
            "devkitBase/lib/"
            "lib/"
            "Maya.app/Contents/MacOS/"
        NO_DEFAULT_PATH)
    mark_as_advanced(MAYA_${MAYA_LIB}_LIBRARY)
    if (MAYA_${MAYA_LIB}_LIBRARY)
        set_property(TARGET Maya::Maya APPEND PROPERTY
            INTERFACE_LINK_LIBRARIES "${MAYA_${MAYA_LIB}_LIBRARY}")
        set(MAYA_LIBRARIES ${MAYA_LIBRARIES} "${MAYA_${MAYA_LIB}_LIBRARY}")
    endif()
endforeach()

function(MAYA_PLUGIN _target)
    if (WIN32)
        set_target_properties(${_target} PROPERTIES
            LINK_FLAGS "/export:initializePlugin /export:uninitializePlugin")
    endif()
    set_target_properties(${_target} PROPERTIES
        PREFIX ""
        SUFFIX ${MAYA_PLUGIN_EXTENSION})
endfunction()
