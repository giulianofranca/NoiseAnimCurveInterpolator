/*
Copyright (c) 2022 Giuliano Franca

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
#pragma once

#include <maya/MFnPlugin.h>


#define REGISTER_ANIM_CURVE_INTERPOLATOR(plugin, interpolatorClass)         \
    status = plugin.registerAnimCurveInterpolator(                          \
        interpolatorClass::kInterpolatorName,                               \
        interpolatorClass::kInterpolatorID,                                 \
        interpolatorClass::creator,                                         \
        interpolatorClass::kInterpolatorFlags                               \
    );                                                                      \
    CHECK_MSTATUS_AND_RETURN_IT(status);

#define DEREGISTER_ANIM_CURVE_INTERPOLATOR(plugin, interpolatorClass)       \
    status = plugin.deregisterAnimCurveInterpolator(                        \
        interpolatorClass::kInterpolatorName                                \
    );                                                                      \
    CHECK_MSTATUS_AND_RETURN_IT(status);

#define REGISTER_COMMAND(plugin, commandClass)                              \
    status = plugin.registerCommand(                                        \
        commandClass::kCommandName,                                         \
        commandClass::creator,                                              \
        commandClass::syntaxCreator                                         \
    );                                                                      \
    CHECK_MSTATUS_AND_RETURN_IT(status);

#define DEREGISTER_COMMAND(plugin, commandClass)                            \
    status = plugin.deregisterCommand(                                      \
        commandClass::kCommandName                                          \
    );                                                                      \
    CHECK_MSTATUS_AND_RETURN_IT(status);
