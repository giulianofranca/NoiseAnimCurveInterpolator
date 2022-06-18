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
#include "waveInterpolator.hpp"

// Constructors and destructors.
WaveInterpolator::WaveInterpolator() {}
WaveInterpolator::~WaveInterpolator() {}

// Init static members.
const MPxAnimCurveInterpolator::InterpolatorFlags WaveInterpolator::kInterpolatorFlags = 
static_cast<MPxAnimCurveInterpolator::InterpolatorFlags>(0);


void* WaveInterpolator::creator(){
    return new WaveInterpolator();
}

void WaveInterpolator::initialize(const MObject &animCurve, unsigned int interval){
    mAnimCurveMob = animCurve;
    mInterval = interval;
}

double WaveInterpolator::evaluate(const MTime &time){
    // Evaluate the animation curve at the given time.
    MFnAnimCurve animCurveFn(mAnimCurveMob);
    return animCurveFn.value(mInterval);
}