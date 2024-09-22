import QtQuick 2.15
import QtQuick.Window 2.15
import com.github.berkbavas.oscillator 1.0

Window {
    id: root
    width: 900
    height: 900
    visible: true
    title: "Apple Compass"
    color: "#000000"

    property double diameter: Math.min(root.width, root.height)

    FontLoader {
        source: "qrc:/Resources/Fonts/Teko/Teko-Regular.ttf"
    }

    FontLoader {
        source: "qrc:/Resources/Fonts/Teko/Teko-Bold.ttf"
    }

    Oscillator {
        id: oscillator
        minimum: 0
        maximum: 360
        initialValue: 0
        period: 60
    }

    Item {
        id: container
        anchors.fill: parent

        AppleCompass {
            id: compass
            heading: oscillator.value * Math.PI / 180
            anchors.centerIn: parent
            diameter: 0.9 * root.diameter

            MouseArea {
                anchors.fill: compass
                onClicked: {
                    compass.holding = !compass.holding
                    compass.holdingStartAngle = compass.heading
                    compass.requestPaint()
                }

                WheelHandler {
                    onWheel: {
                        compass.heading = rotation / 200
                    }
                }
            }
        }

        Level {
            id: level
            anchors.centerIn: parent
            diameter: 0.325 * root.diameter

            levelOffset: backend.levelOffset
            levelTheta: backend.levelTheta

            MouseArea {
                anchors.fill: level

                onPositionChanged: {
                    let x = mouseX - 0.5 * level.width
                    let y = mouseY - 0.5 * level.height
                    backend.levelOffset = Math.pow(x * x + y * y, 0.5)
                    backend.levelTheta = Math.atan2(y, x)
                }

                onReleased: {
                    backend.levelOffset = 0
                    backend.levelTheta = 0
                }
            }
        }
    }

    Item {
        Component.onCompleted: {
            oscillator.start()
        }
    }
}
