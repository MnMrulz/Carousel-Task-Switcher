import QtQuick
import org.kde.kwin as KWin
import org.kde.kirigami as Kirigami

Item {
    id: root

    // ─────────────────────────────────────────────
    // Public properties
    // ─────────────────────────────────────────────

    property var windowId
    property string iconName: ""
    property string caption: ""
    property bool selected: false

    signal clicked()

    // ─────────────────────────────────────────────
    // Window card
    // ─────────────────────────────────────────────

    Rectangle {
        id: card

        anchors.fill: parent

        radius: selected ? 20 : 16

        color: selected
               ? Qt.rgba(0.94, 0.95, 0.97, 0.88)
               : Qt.rgba(0.91, 0.92, 0.94, 0.64)

        border.width: selected ? 2 : 1

        border.color: selected
                      ? Qt.rgba(1, 1, 1, 0.75)
                      : Qt.rgba(1, 1, 1, 0.32)

        clip: true

        Behavior on radius {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.width {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        // ─────────────────────────────────────────
        // Live window thumbnail
        // ─────────────────────────────────────────

        KWin.WindowThumbnail {
            id: thumbnail

            anchors.fill: parent
            anchors.margins: selected ? 3 : 2

            wId: root.windowId

            opacity: selected ? 0.96 : 0.84
        }

        // ─────────────────────────────────────────
        // Subtle glass overlay
        // ─────────────────────────────────────────

        Rectangle {
            anchors.fill: parent

            color: Qt.rgba(1, 1, 1, selected ? 0.08 : 0.035)

            radius: card.radius

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(1, 1, 1, selected ? 0.16 : 0.08)
                }

                GradientStop {
                    position: 0.45
                    color: Qt.rgba(1, 1, 1, 0.0)
                }

                GradientStop {
                    position: 1.0
                    color: Qt.rgba(0, 0, 0, selected ? 0.08 : 0.04)
                }
            }
        }

        // ─────────────────────────────────────────
        // App icon
        // ─────────────────────────────────────────

        Rectangle {
            id: iconBackground

            width: selected ? 48 : 38
            height: width

            radius: width / 2

            anchors.left: parent.left
            anchors.top: parent.top

            anchors.leftMargin: selected ? 10 : 7
            anchors.topMargin: selected ? 10 : 7

            color: Qt.rgba(0.08, 0.09, 0.11, 0.52)

            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.24)

            Kirigami.Icon {
                anchors.centerIn: parent

                width: parent.width * 0.66
                height: width

                source: root.iconName

                isMask: false
            }

            Behavior on width {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on height {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }
        }

        // ─────────────────────────────────────────
        // Window title
        // ─────────────────────────────────────────

        Rectangle {
            id: titleBackground

            visible: selected && root.caption.length > 0

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            height: 34

            color: Qt.rgba(0.04, 0.05, 0.06, 0.58)

            Text {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                verticalAlignment: Text.AlignVCenter

                text: root.caption

                color: "white"

                font.pixelSize: 12
                font.weight: Font.Medium

                elide: Text.ElideRight
            }
        }

        // ─────────────────────────────────────────
        // Selected highlight
        // ─────────────────────────────────────────

        Rectangle {
            visible: root.selected

            anchors.fill: parent

            radius: card.radius

            color: "transparent"

            border.width: 1

            border.color: Qt.rgba(1, 1, 1, 0.34)
        }
    }

    // ─────────────────────────────────────────────
    // Mouse interaction
    // ─────────────────────────────────────────────

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        cursorShape: Qt.PointingHandCursor

        onClicked: {
            root.clicked()
        }
    }
}
