QT += quick

CONFIG += c++11

SOURCES += \
        Source/CompassBackend.cpp \
        Source/Oscillator.cpp \
        Source/Main.cpp

RESOURCES += AppleCompass.qrc

HEADERS += \
    Source/CompassBackend.h \
    Source/Macros.h \
    Source/Oscillator.h
