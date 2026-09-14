import QtQuick

Item {
    id: carousel

    // ─────────────────────────────────────────────
    // Public API
    // ─────────────────────────────────────────────

    property var model
    property int currentIndex: 0

    // Overall size — intentionally ~7% smaller than the
    // original reference design.
    readonly property real diameter: 410

    // Radius on which the windows travel.
    readonly property real radius: 145

    // How many degrees separate each window.
    readonly property real angleStep:
        model && model.count > 0
        ? 360 / model.count
        : 360

    width: diameter
    height: diameter

    // ─────────────────────────────────────────────
    // Main glass surface
    // ─────────────────────────────────────────────

    Rectangle {
        id: glass

        anchors.fill: parent

        radius: width / 2

        color: Qt.rgba(0.82, 0.84, 0.87, 0.73)

        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.38)

        // Very subtle inner highlight
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1

            radius: width / 2

            color: "transparent"

            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.12)
        }
    }

    // ─────────────────────────────────────────────
    // Center focus area
    // ─────────────────────────────────────────────

    Rectangle {
        id: centerFocus

        width: 118
        height: 118

        radius: width / 2

        anchors.centerIn: parent

        color: Qt.rgba(0.12, 0.13, 0.15, 0.18)

        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.20)

        Behavior on width {
            NumberAnimation {
                duration: 280
                easing.type: Easing.OutCubic
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 280
                easing.type: Easing.OutCubic
            }
        }
    }

    // ─────────────────────────────────────────────
    // Window carousel
    // ─────────────────────────────────────────────

    Repeater {
        id: windowRepeater

        model: carousel.model

        delegate: Item {
            id: delegateRoot

            property int itemIndex: index

            // Circular distance from selected item.
            //
            // Example:
            // current = 0
            // item = last item
            // relativeIndex = -1
            //
            // This makes the carousel wrap naturally.
            property int relativeIndex: {
                if (!carousel.model || carousel.model.count <= 0)
                    return 0

                var count = carousel.model.count
                var delta = itemIndex - carousel.currentIndex

                while (delta > count / 2)
                    delta -= count

                while (delta < -count / 2)
                    delta += count

                return delta
            }

            property real angle:
                -90 + relativeIndex * carousel.angleStep

            property real radians:
                angle * Math.PI / 180

            property real distanceFromFocus:
                Math.abs(relativeIndex)

            property bool selected:
                itemIndex === carousel.currentIndex

            // Selected item becomes substantially larger.
            property real itemScale:
                selected
                ? 1.38
                : Math.max(
                    0.62,
                    1.0 - distanceFromFocus * 0.09
                  )

            width: selected ? 180 : 125
            height: selected ? 125 : 88

            x: carousel.width / 2
               + Math.cos(radians) * carousel.radius
               - width / 2

            y: carousel.height / 2
               + Math.sin(radians) * carousel.radius
               - height / 2

            z: selected
               ? 100
               : 50 - distanceFromFocus

            scale: itemScale

            opacity: selected
                      ? 1.0
                      : Math.max(
                          0.42,
                          0.92 - distanceFromFocus * 0.10
                        )

            Behavior on x {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: 280
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            WindowItem {
                anchors.fill: parent

                windowId: model.windowId
                iconName: model.icon
                caption: model.caption
                selected: delegateRoot.selected

                onClicked: {
                    carousel.currentIndex = delegateRoot.itemIndex
                }
            }
        }
    }

    // ─────────────────────────────────────────────
    // Keep carousel visually centered
    // ─────────────────────────────────────────────

    function refresh() {
        // Force bindings to re-evaluate after the KWin
        // model is recreated.
        windowRepeater.model = null
        windowRepeater.model = carousel.model
    }
}
