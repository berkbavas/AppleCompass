QT += quick

CONFIG += c++11

SOURCES += \
        src/CompassBackend.cpp \
        src/Oscillator.cpp \
        src/Main.cpp

RESOURCES += AppleCompass.qrc

HEADERS += \
    src/CompassBackend.h \
    src/Macros.h \
    src/Oscillator.h
