import QtQuick 2.0

Canvas {
    id: root
    width: diameter
    height: diameter

    property double diameter
    readonly property double radius: 0.5 * diameter

    readonly property string lineColor: "#ffffff"

    property double levelTheta: 0
    property double levelOffset: 0 // Relative to center in pixels
    readonly property double levelMaxOffset: 0.5 * innerDiskRadius // Relative to canvas center

    readonly property double innerDiskRadius: 0.25 * diameter
    readonly property string innerDiskColor: "#1E1E1E"

    readonly property double indicatorLength: 0.25 * innerDiskRadius

    onLevelThetaChanged: requestPaint()
    onLevelOffsetChanged: requestPaint()

    function clamp(min, val, max) {
        return Math.min(Math.max(val, min), max)
    }

    onPaint: {
        let ctx = getContext("2d")
        ctx.reset()

        // Disk
        let offset = clamp(0, levelOffset, levelMaxOffset)

        let x = radius + offset * Math.cos(levelTheta)
        let y = radius + offset * Math.sin(levelTheta)

        ctx.beginPath()
        ctx.arc(x, y, innerDiskRadius, 0, 2 * Math.PI)
        ctx.closePath()

        ctx.fillStyle = innerDiskColor
        ctx.fill()

        // Indicator +
        ctx.beginPath()
        ctx.moveTo(x, y - indicatorLength)
        ctx.lineTo(x, y + indicatorLength)
        ctx.moveTo(x - indicatorLength, y)
        ctx.lineTo(x + indicatorLength, y)
        ctx.closePath()

        ctx.lineWidth = 1
        ctx.strokeStyle = lineColor
        ctx.stroke()

        // Guideline +
        ctx.beginPath()
        ctx.moveTo(radius, 0)
        ctx.lineTo(radius, diameter)
        ctx.moveTo(0, radius)
        ctx.lineTo(diameter, radius)
        ctx.closePath()

        ctx.lineWidth = 1
        ctx.strokeStyle = lineColor
        ctx.stroke()
    }
}
