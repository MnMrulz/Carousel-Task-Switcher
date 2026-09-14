import QtQuick
import org.kde.kwin as KWin

KWin.Switcher {
    id: switcher

    Window {
        id: switcherWindow

        visible: switcher.visible

        flags: Qt.BypassWindowManagerHint |
               Qt.FramelessWindowHint

        color: "transparent"

        width: carousel.width
        height: carousel.height

        Carousel {
            id: carousel

            anchors.centerIn: parent

            model: switcher.model
            currentIndex: switcher.currentIndex

            onCurrentIndexChanged: {
                if (switcher.currentIndex !== currentIndex)
                    switcher.currentIndex = currentIndex
            }
        }

        onVisibleChanged: {
            if (!visible)
                return

            x = switcher.screenGeometry.x +
                (switcher.screenGeometry.width - width) / 2

            y = switcher.screenGeometry.y +
                (switcher.screenGeometry.height - height) / 2

            carousel.refresh()
        }
    }

    onCurrentIndexChanged: {
        if (carousel.currentIndex !== currentIndex)
            carousel.currentIndex = currentIndex
    }
}
