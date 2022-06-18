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

#include <maya/MPxAnimCurveInterpolator.h>
#include <maya/MFnAnimCurve.h>
#include <maya/MTime.h>
#include <maya/MObject.h>


class WaveInterpolator : public MPxAnimCurveInterpolator{
public:
    // Public constructors and destructors.
    WaveInterpolator();
    ~WaveInterpolator() override;

    // Public overridden methods.
    void            initialize(const MObject &animCurve, unsigned int interval) override;
    double          evaluate(const MTime &time) override;

    // Public static methods.
    static void*            creator();

    // Public static attributes.
    const static MString                                                kInterpolatorName;
    const static MFnAnimCurve::TangentType                              kInterpolatorID;
    const static MPxAnimCurveInterpolator::InterpolatorFlags            kInterpolatorFlags;

private:
    // Private members.
    MObject             mAnimCurveMob;
    unsigned int            mInterval;
};