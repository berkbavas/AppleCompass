import QtQuick 2.0
import QtQuick.Extras 1.4

CircularGauge {
    id: root

    style: AppleCompassStyle {
        minimumValueAngle: 0
        maximumValueAngle: 360
        tickmarkStepSize: 30
        minorTickmarkCount: 14
    }

    onValueChanged: canvas.requestPaint();

    Canvas {
        id: canvas
        anchors.fill: parent

        readonly property real radius : 0.5 * width;
        readonly property real labelFontSize : (34 / 324) * radius;
        readonly property real labelInset : (40 / 324) * radius;
        readonly property real arrowInset : (54 / 324) * radius;
        readonly property real arrowHeight : (16 / 324) * radius;
        readonly property real arrowWidth : (16 / 324) * radius;
        readonly property real directionInset : (200 / 324) * radius;
        readonly property real directionFontSize : (68 / 324) * radius;

        onPaint: {

            var ctx = getContext("2d");
            ctx.reset();

            // Red arrow
            ctx.beginPath();
            ctx.moveTo(radius, arrowInset);
            ctx.lineTo(radius - 0.5 * arrowWidth, arrowInset + arrowHeight);
            ctx.lineTo(radius + 0.5 * arrowWidth, arrowInset + arrowHeight);
            ctx.closePath();
            ctx.fillStyle = "#e73325";
            ctx.fill();

            var labels = ["0", "30", "60", "90", "120", "150", "180", "210", "240", "270", "300", "330"];

            for(var i = 0; i < labels.length; i++)
            {
                ctx.resetTransform();
                ctx.translate(radius, radius);
                ctx.rotate(30 * i * Math.PI / 180);
                ctx.translate(-radius, -radius);

                ctx.translate(radius, labelInset - 0.5 * labelFontSize);
                ctx.rotate((-30 * i - root.value) * Math.PI / 180);
                ctx.translate(-radius, -labelInset + 0.5 * labelFontSize);

                ctx.fillStyle = "#ffffff";
                ctx.font = labelFontSize + 'px Teko';
                ctx.textAlign = "center";
                ctx.fillText(labels[i], radius, labelInset);

            }

            var directions = ["N", "E", "S", "W"];

            for(var j = 0; j < directions.length; j++)
            {
                ctx.resetTransform();
                ctx.translate(radius, radius);
                ctx.rotate(j * Math.PI / 2);
                ctx.translate(-radius, -radius);

                ctx.translate(radius, directionInset - 0.5 * directionFontSize);
                ctx.rotate((-90 * j - root.value) * Math.PI / 180);
                ctx.translate(-radius, -directionInset + 0.5 * directionFontSize);


                ctx.fillStyle = "#ffffff";
                ctx.font = directionFontSize + 'px Teko';
                ctx.textAlign = "center";
                ctx.fillText(directions[j], radius, directionInset);
            }
        }
    }
}
