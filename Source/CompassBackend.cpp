#include "CompassBackend.h"

#include <cmath>

CompassBackend::CompassBackend(QObject *parent)
    : QObject{parent}
{
    constexpr int TICK_INTERVAL_MS = 10;

    connect(&mTimer, &QTimer::timeout, this, [=]() {
        mAnimationTime += TICK_INTERVAL_MS / 1000.0;

        SetLevelTheta(2 * M_PI * std::sin(mAnimationTime));
        SetLevelOffset(20 * std::abs(std::sin(mAnimationTime / 10)));
    });

    mTimer.start(TICK_INTERVAL_MS);
}

DEFINE_SET_METHOD(CompassBackend, double, Heading);
DEFINE_SET_METHOD(CompassBackend, double, LevelOffset);
DEFINE_SET_METHOD(CompassBackend, double, LevelTheta);
