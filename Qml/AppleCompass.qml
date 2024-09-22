import QtQuick 2.0

Canvas {
    id: canvas
    width: diameter
    height: diameter

    // In radians
    property double heading

    property double diameter
    property real radius: 0.5 * diameter

    property bool holding: false
    property double holdingStartAngle: 0 // In radians

    readonly property string textAlign: "center"
    readonly property string textBaseline: "middle"

    readonly property real arrowInset: (74 / 324) * radius
    readonly property real arrowWidth: (16 / 324) * radius
    readonly property real arrowHeight: (16 / 324) * radius
    readonly property string arrowColor: "#ff0000"

    readonly property real numbersInset: (54 / 324) * radius
    readonly property real numbersFontSize: (34 / 324) * radius
    readonly property string numbersFont: numbersFontSize + "px Teko"

    readonly property real lettersInset: (172 / 324) * radius
    readonly property real lettersFontSize: (68 / 324) * radius
    readonly property string lettersFont: lettersFontSize + "px Teko"

    readonly property int tickmarkCount: 12
    readonly property real tickmarkInset: (96 / 324) * radius
    readonly property real tickmarkWidth: (6 / 324) * radius
    readonly property real tickmarkHeight: (34 / 324) * radius

    readonly property int minorTickmarkCount: 14
    readonly property real minorTickmarkInset: (96 / 324) * radius
    readonly property real minorTickmarkWidth: (2 / 324) * radius
    readonly property real minorTickmarkHeight: (34 / 324) * radius

    readonly property real indicatorHeight: tickmarkInset + tickmarkHeight
    readonly property real indicatorWidth: (6 / 324) * radius

    readonly property real arcInnerRadius: (116 / 324) * radius
    readonly property real arcOuterRadius: (190 / 324) * radius
    readonly property real holdingAngleNumberInset: (40 / 324) * radius
    readonly property real holdingAngleNumberTextFontSize: numbersFontSize
    readonly property string holdingAngleNumberFont: "bold " + holdingAngleNumberTextFontSize + "px Teko"

    readonly property real holdingIndicatorInset: (64 / 324) * radius
    readonly property real holdingIndicatorHeight: tickmarkInset - holdingIndicatorInset + tickmarkHeight
    readonly property real holdingIndicatorWidth: (4 / 324) * radius

    onHeadingChanged: canvas.requestPaint()

    onPaint: {
        let ctx = getContext("2d")
        ctx.reset()

        if (holding)
            drawFilledRedArcIfApplicable(ctx, heading, holdingStartAngle)

        let angle = -heading

        rotateAroundCenter(ctx, angle)

        drawRedTriangleIndicator(ctx)
        drawTickmarks(ctx)
        drawNumbers(ctx, angle)
        drawLetters(ctx, angle)

        if (holding) {
            drawHoldingStartAngleText(ctx, angle, holdingStartAngle)
            drawHoldingIndicator(ctx, angle, holdingStartAngle)
        }

        rotateAroundCenter(ctx, -angle)

        drawWhiteRectangleIndicator(ctx)
    }

    function rotateAroundCenter(ctx, angle) {
        ctx.translate(radius, radius)
        ctx.rotate(angle)
        ctx.translate(-radius, -radius)
    }

    function drawHoldingIndicator(ctx, angle, holdingStartAngle) {
        ctx.save()

        ctx.translate(radius, radius)
        ctx.rotate(holdingStartAngle)
        ctx.translate(-radius, -radius)

        ctx.fillStyle = "#ffffff"
        ctx.fillRect(radius - 0.5 * indicatorWidth, holdingIndicatorInset, holdingIndicatorWidth, holdingIndicatorHeight)

        ctx.restore()
    }

    function drawFilledRedArcIfApplicable(ctx, heading, holdingStartAngle) {

        heading = clampAngle(heading)
        holdingStartAngle = clampAngle(holdingStartAngle)

        let endAngle = holdingStartAngle - heading

        if (Math.abs(holdingStartAngle - heading) < Math.PI) {
            let ccw = holdingStartAngle < heading
            fillArc(ctx, 0, endAngle, ccw)
        } else if (Math.abs(holdingStartAngle - heading) > Math.PI) {
            let ccw = holdingStartAngle > heading
            fillArc(ctx, 0, endAngle, ccw)
        }
    }

    function drawHoldingStartAngleText(ctx, heading, holdingStartAngle) {
        ctx.save()

        holdingStartAngle = clampAngle(holdingStartAngle)

        let holdingAngleRounded = Math.round(180 * holdingStartAngle / Math.PI)

        let x = radius
        let y = holdingAngleNumberInset
        let fix = 0.25 * holdingAngleNumberTextFontSize

        ctx.translate(radius, radius)
        ctx.rotate(holdingStartAngle)
        ctx.translate(-radius, -radius)

        ctx.translate(x, y)
        ctx.rotate(-heading - holdingStartAngle)
        ctx.translate(-x, -y)

        ctx.textBaseline = textBaseline
        ctx.font = holdingAngleNumberFont
        ctx.textAlign = textAlign
        ctx.fillStyle = "#ffffff"
        ctx.fillText(holdingAngleRounded, x, y + fix)

        ctx.restore()
    }

    function drawWhiteRectangleIndicator(ctx) {
        ctx.save()
        ctx.fillStyle = "#ffffff"
        ctx.globalCompositeOperation = "xor"
        ctx.fillRect(radius - 0.5 * indicatorWidth, 0, indicatorWidth, indicatorHeight)
        ctx.restore()
    }

    function drawRedTriangleIndicator(ctx) {
        ctx.beginPath()
        ctx.moveTo(radius, arrowInset)
        ctx.lineTo(radius - 0.5 * arrowWidth, arrowInset + arrowHeight)
        ctx.lineTo(radius + 0.5 * arrowWidth, arrowInset + arrowHeight)
        ctx.closePath()
        ctx.fillStyle = arrowColor
        ctx.fill()
    }

    function drawTickmarks(ctx) {
        for (var t = 0; t < tickmarkCount; t++) {
            ctx.save()

            let tickmarkPlacementAngle = t / tickmarkCount * 2 * Math.PI
            ctx.translate(radius, radius)
            ctx.rotate(tickmarkPlacementAngle)
            ctx.translate(-radius, -radius)

            ctx.fillStyle = "#ffffff"
            ctx.fillRect(radius - 0.5 * tickmarkWidth, tickmarkInset, tickmarkWidth, tickmarkHeight)

            // Minor Tickmarks
            for (var mt = 1; mt <= minorTickmarkCount; mt++) {
                ctx.translate(radius, radius)
                ctx.rotate((2 * Math.PI / tickmarkCount) / (minorTickmarkCount + 1))
                ctx.translate(-radius, -radius)

                ctx.fillStyle = "#ffffff"
                ctx.fillRect(radius - 0.5 * minorTickmarkWidth, minorTickmarkInset, minorTickmarkWidth, minorTickmarkHeight)
            }

            ctx.restore()
        }
    }

    function drawNumbers(ctx, heading) {
        let numbers = [0, 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330]

        for (var i = 0; i < numbers.length; i++) {

            if (holding) {
                if (Math.abs(numbers[i] - clampAngle(holdingStartAngle) * 180 / Math.PI) < 10)
                    continue
            }

            ctx.save()

            let numberPlacementAngle = 30 * i * Math.PI / 180
            let x = radius
            let y = numbersInset
            let fix = 0.25 * numbersFontSize

            ctx.translate(radius, radius)
            ctx.rotate(numberPlacementAngle)
            ctx.translate(-radius, -radius)

            ctx.translate(x, y)
            ctx.rotate(-heading - numberPlacementAngle)
            ctx.translate(-x, -y)

            ctx.textBaseline = textBaseline
            ctx.font = numbersFont
            ctx.textAlign = textAlign
            if (holding)
                ctx.fillStyle = "#c0c0c0"
            else
                ctx.fillStyle = "#ffffff"
            ctx.fillText(numbers[i], x, y + fix)

            ctx.restore()
        }
    }

    function drawLetters(ctx, heading) {
        let letters = ["N", "E", "S", "W"]

        for (var j = 0; j < letters.length; j++) {
            ctx.save()

            let letterPlacementAngle = j * Math.PI / 2
            let x = radius
            let y = lettersInset
            let fix = 0.25 * lettersFontSize

            ctx.translate(radius, radius)
            ctx.rotate(letterPlacementAngle)
            ctx.translate(-radius, -radius)

            // Rotate letter so that baseline is parallel to x-axis
            ctx.translate(x, y)
            ctx.rotate(-heading - letterPlacementAngle)
            ctx.translate(-x, -y)

            ctx.textBaseline = textBaseline
            ctx.font = lettersFont
            ctx.textAlign = textAlign
            ctx.fillStyle = "#ffffff"
            ctx.fillText(letters[j], x, y + fix)

            ctx.restore()
        }
    }

    function clampAngle(angle) {
        while (angle < 0)
            angle += 2 * Math.PI

        while (angle > 2 * Math.PI)
            angle -= 2 * Math.PI

        return angle
    }

    function fillArc(ctx, startAngle, endAngle, ccw) {
        ctx.save()
        ctx.beginPath()

        // Note that arc() assumes angles are measured from the positive x-axis
        // so we add 90 degrees to the args.
        ctx.arc(radius, radius, arcInnerRadius, startAngle - 0.5 * Math.PI, endAngle - 0.5 * Math.PI, ccw)
        ctx.arc(radius, radius, arcOuterRadius, endAngle - 0.5 * Math.PI, startAngle - 0.5 * Math.PI, !ccw)

        ctx.closePath()
        ctx.fillStyle = arrowColor
        ctx.fill()
        ctx.restore()
    }
}
