import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: carousel

    property var model
    property int currentIndex: 0

    readonly property real diameter: 410
    readonly property real radius: 145

    readonly property int itemCount:
        model ? model.count : 0

    readonly property real angleStep:
        itemCount > 1 ? 360 / itemCount : 360

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
        border.color: Qt.rgba(1, 1, 1, 0.40)

        // Inner glass highlight
        Rectangle {
            anchors.fill: parent
            anchors.margins: 1

            radius: width / 2

            color: "transparent"

            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.13)
        }

        // Very subtle top highlight
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top

            width: parent.width * 0.56
            height: 2

            radius: 1

            color: Qt.rgba(1, 1, 1, 0.18)
        }
    }

    // ─────────────────────────────────────────────
    // Center focus
    // ─────────────────────────────────────────────

    Rectangle {
        id: centerFocus

        width: 116
        height: 116

        radius: width / 2

        anchors.centerIn: parent

        color: Qt.rgba(0.08, 0.09, 0.11, 0.20)

        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.22)

        // Selected application icon
        Kirigami.Icon {
            id: centerIcon

            anchors.centerIn: parent

            width: 62
            height: 62

            source: {
                var item = windowRepeater.itemAt(
                    carousel.currentIndex
                )

                return item ? item.appIcon : ""
            }

            isMask: false
        }

        // Soft icon backing
        Rectangle {
            anchors.centerIn: centerIcon

            width: centerIcon.width + 22
            height: centerIcon.height + 22

            radius: width / 2

            color: Qt.rgba(1, 1, 1, 0.045)

            z: -1
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
            property string appIcon: model.icon

            property bool selected:
                itemIndex === carousel.currentIndex

            /*
             * Shortest circular distance from selection.
             *
             * Example:
             *
             * selected = 0
             * item = last
             *
             * becomes -1 rather than +N.
             */
            property int relativeIndex: {
                var count = carousel.itemCount

                if (count <= 1)
                    return 0

                var delta = itemIndex - carousel.currentIndex

                while (delta > count / 2)
                    delta -= count

                while (delta < -count / 2)
                    delta += count

                return delta
            }

            /*
             * -90 degrees = 12 o'clock.
             *
             * The selected item therefore always occupies
             * the fixed focal position.
             */
            property real angle:
                -90 + relativeIndex * carousel.angleStep

            property real radians:
                angle * Math.PI / 180

            property real distance:
                Math.abs(relativeIndex)

            // Selected window becomes substantially larger.
            property real targetScale:
                selected
                    ? 1.0
                    : Math.max(
                        0.56,
                        0.88 - distance * 0.075
                    )

            property real targetOpacity:
                selected
                    ? 1.0
                    : Math.max(
                        0.30,
                        0.88 - distance * 0.12
                    )

            width: selected ? 180 : 124
            height: selected ? 124 : 88

            x:
                carousel.width / 2 +
                Math.cos(radians) * carousel.radius -
                width / 2

            y:
                carousel.height / 2 +
                Math.sin(radians) * carousel.radius -
                height / 2

            scale: targetScale
            opacity: targetOpacity

            z:
                selected
                    ? 100
                    : 50 - distance

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
                    duration: 230
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
                    carousel.currentIndex =
                        delegateRoot.itemIndex
                }
            }
        }
    }

    // ─────────────────────────────────────────────
    // Model refresh
    // ─────────────────────────────────────────────

    function refresh() {
        windowRepeater.model = null
        windowRepeater.model = carousel.model
    }
}import QtQuick
import org.kde.kirigami as Kirigami

Item {
    id: carousel

    property var model
    property int currentIndex: 0

    readonly property real diameter: 410
    readonly property real radius: 145

    readonly property int itemCount:
        model ? model.count : 0

    readonly property real angleStep:
        itemCount > 1 ? 360 / itemCount : 360

    width: diameter
    height: diameter

    // ─────────────────────────────────────────────
    // Glass body
    // ─────────────────────────────────────────────

    Rectangle {
        id: glass

        anchors.fill: parent

        radius: width / 2

        color: Qt.rgba(0.82, 0.84, 0.87, 0.73)

        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.38)

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
    // Center
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

        Kirigami.Icon {
            id: centerIcon

            anchors.centerIn: parent

            width: 64
            height: 64

            source: {
                var item = windowRepeater.itemAt(carousel.currentIndex)

                if (!item)
                    return ""

                return item.appIcon
            }

            isMask: false

            Behavior on source {
                // Gives the icon swap a little breathing room.
                // The icon itself is still immediately updated.
            }
        }

        Rectangle {
            anchors.centerIn: centerIcon

            width: centerIcon.width + 18
            height: centerIcon.height + 18

            radius: width / 2

            color: Qt.rgba(1, 1, 1, 0.055)

            z: -1
        }
    }

    // ─────────────────────────────────────────────
    // Carousel items
    // ─────────────────────────────────────────────

    Repeater {
        id: windowRepeater

        model: carousel.model

        delegate: Item {
            id: delegateRoot

            property int itemIndex: index
            property var appIcon: model.icon

            property bool selected:
                itemIndex === carousel.currentIndex

            /*
             * Calculate the shortest circular distance
             * between this item and the selected item.
             */
            property int relativeIndex: {
                var count = carousel.itemCount

                if (count <= 1)
                    return 0

                var delta = itemIndex - carousel.currentIndex

                while (delta > count / 2)
                    delta -= count

                while (delta < -count / 2)
                    delta += count

                return delta
            }

            /*
             * The selected item is exactly at 12 o'clock.
             *
             * Every other item is positioned around it.
             */
            property real angle:
                -90 + relativeIndex * carousel.angleStep

            property real radians:
                angle * Math.PI / 180

            property real distance:
                Math.abs(relativeIndex)

            property real targetScale:
                selected
                    ? 1.0
                    : Math.max(
                        0.58,
                        0.90 - distance * 0.08
                    )

            property real targetOpacity:
                selected
                    ? 1.0
                    : Math.max(
                        0.35,
                        0.90 - distance * 0.12
                    )

            width: selected ? 180 : 125
            height: selected ? 125 : 88

            x:
                carousel.width / 2 +
                Math.cos(radians) * carousel.radius -
                width / 2

            y:
                carousel.height / 2 +
                Math.sin(radians) * carousel.radius -
                height / 2

            scale: targetScale
            opacity: targetOpacity

            z:
                selected
                    ? 100
                    : 50 - distance

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
                    duration: 240
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
    // Refresh
    // ─────────────────────────────────────────────

    function refresh() {
        windowRepeater.model = null
        windowRepeater.model = carousel.model
    }
}
