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
cmake_minimum_required(VERSION 3.9)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH
    "${CMAKE_SOURCE_DIR}/cmake/modules"
    "${CMAKE_SOURCE_DIR}/cmake/defaults")

include(Version)

project(${PLUGIN_NAME}
    VERSION ${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}
    DESCRIPTION ${PLUGIN_DESCRIPTION}
    LANGUAGES CXX)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(INSTALL_NAME "${PROJECT_NAME}_${STR_VERSION}_${CMAKE_SYSTEM_NAME}")
    set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${INSTALL_NAME}" CACHE PATH "..." FORCE)
endif()
message(STATUS "Install location: ${CMAKE_INSTALL_PREFIX}")

add_subdirectory(plug-ins)

# Install underworld files
# configure_file("install.py.in"
#     "${CMAKE_CURRENT_BINARY_DIR}/install.py" @ONLY)
install(
    FILES 
        "install.py" "install_instructions.txt" "LICENSE"
    DESTINATION 
        "${CMAKE_INSTALL_PREFIX}"
)
