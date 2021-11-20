import QtQuick 2.15
import QtQuick.Window 2.15
import com.github.berkbavas.oscillator 1.0

Window {
    width: 650
    height: 650
    visible: true
    title: "Apple Compass"
    color: "#000000"

    FontLoader {
        name: "Teko"
        source: "Resources/Fonts/Teko/Teko-Regular.ttf"
    }

    Oscillator {
        id: oscillator
        minimum: 0
        maximum: 360
        initialValue: 0
        period: 60
    }

    Item {
        anchors.fill: parent
        anchors.margins: 0.1 * Math.min(parent.width, parent.height)

        Canvas {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width

            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.strokeStyle = "#ffffff"; /// !!!!!!!!!!!
                ctx.lineWidth = (6 / 324) * 0.5 * width
                ctx.moveTo(0.5 * width, 0);
                ctx.lineTo(0.5 * width, (76 / 324) * 0.5 * width);
                ctx.stroke();
            }
        }

        AppleCompass {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            minimumValue: 0
            maximumValue: 360
            value: oscillator.value
            rotation: oscillator.value

            Component.onCompleted: {
                oscillator.start();
            }
        }
    }
}
