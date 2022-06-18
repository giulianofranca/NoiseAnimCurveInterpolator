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
configure_file("main.cpp.in"
    "${CMAKE_CURRENT_BINARY_DIR}/main.cpp" @ONLY)

set(INTERPOLATORS_FILES
    "interpolators/waveInterpolator.cpp"
)

set(PLUGIN_SOURCES
    "${CMAKE_CURRENT_BINARY_DIR}/main.cpp"
    ${INTERPOLATORS_FILES}
)

find_package(Maya REQUIRED)

add_library(
    ${PROJECT_NAME}
    SHARED ${PLUGIN_SOURCES}
)
target_link_libraries(
    ${PROJECT_NAME}
    PRIVATE Maya::Maya
)
target_include_directories(
    ${PROJECT_NAME}
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} Maya::Maya
)
target_compile_options(
    ${PROJECT_NAME}
    PRIVATE ${COMPILE_FLAGS}
)
set_target_properties(
    ${PROJECT_NAME}
    PROPERTIES 
        OUTPUT_NAME ${PROJECT_NAME}
)

MAYA_PLUGIN(${PROJECT_NAME})

install(TARGETS ${PROJECT_NAME}
    ${MAYA_TARGET_TYPE} DESTINATION "plug-ins/${MAYA_VERSION}"
)
