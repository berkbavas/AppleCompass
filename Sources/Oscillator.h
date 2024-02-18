#ifndef OSCILLATOR_H
#define OSCILLATOR_H

#include <QObject>
#include <QTimer>

class Oscillator : public QObject
{
    Q_OBJECT
public:
    explicit Oscillator(QObject *parent = nullptr);

    Q_PROPERTY(float value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(float minimum READ minimum WRITE setMinimum NOTIFY minimumChanged)
    Q_PROPERTY(float maximum READ maximum WRITE setMaximum NOTIFY maximumChanged)
    Q_PROPERTY(float period READ period WRITE setPeriod NOTIFY periodChanged)
    Q_PROPERTY(float initialValue READ initialValue WRITE setInitialValue NOTIFY initialValueChanged)

    float value() const;
    void setValue(float newValue);

    float minimum() const;
    void setMinimum(float newMinimum);

    float maximum() const;
    void setMaximum(float newMaximum);

    float period() const;
    void setPeriod(float newPeriod);

    float initialValue() const;
    void setInitialValue(float newInitialValue);

public slots:
    void start();
    void stop();
    void tick();

signals:
    void valueChanged();
    void minimumChanged();
    void maximumChanged();
    void periodChanged();
    void initialValueChanged();

private:
    float mValue;
    float mMinimum;
    float mMaximum;
    float mPeriod;
    float mInitialValue;

    float mDelta;
    int mTimeout;
    int mSign;
    QTimer mTimer;
};

#endif // OSCILLATOR_H
