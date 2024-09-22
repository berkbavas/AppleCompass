#pragma once

#include <QObject>
#include <QTimer>

#include "Macros.h"

class CompassBackend : public QObject
{
    Q_OBJECT
public:
    explicit CompassBackend(QObject *parent = nullptr);

signals:
    void HeadingChanged();
    void LevelOffsetChanged();
    void LevelThetaChanged();

private:
    QTimer mTimer;
    double mAnimationTime{0.0};

    DECLARE_MEMBER(double, Heading);
    DECLARE_MEMBER(double, LevelOffset);
    DECLARE_MEMBER(double, LevelTheta);

    Q_PROPERTY(double heading READ GetHeading WRITE SetHeading NOTIFY HeadingChanged);
    Q_PROPERTY(double levelOffset READ GetLevelOffset WRITE SetLevelOffset NOTIFY LevelOffsetChanged);
    Q_PROPERTY(double levelTheta READ GetLevelTheta WRITE SetLevelTheta NOTIFY LevelThetaChanged);
};
