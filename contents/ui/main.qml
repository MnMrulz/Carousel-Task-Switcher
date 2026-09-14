import QtQuick

import org.kde.kwin as KWin

KWin.TabBoxSwitcher {
    id: tabBox

    Window {
        id: switcherWindow

        visible: tabBox.visible

        flags: Qt.BypassWindowManagerHint |
               Qt.FramelessWindowHint

        color: "transparent"

        width: carousel.width
        height: carousel.height

        Carousel {
            id: carousel

            model: tabBox.model

            currentIndex: tabBox.currentIndex

            anchors.centerIn: parent
        }

        /*
         * Keep the switcher centered on the active screen.
         */
        onVisibleChanged: {
            if (!visible)
                return

            var screen =
                KWin.Workspace.clientArea(
                    KWin.Workspace.ScreenArea,
                    KWin.Workspace.activeScreen,
                    KWin.Workspace.currentDesktop
                )

            switcherWindow.x =
                screen.x +
                (screen.width - switcherWindow.width) / 2

            switcherWindow.y =
                screen.y +
                (screen.height - switcherWindow.height) / 2

            carousel.refresh()
        }
    }

    /*
     * KWin changes this whenever Alt+Tab changes
     * the selected window.
     */
    onCurrentIndexChanged: {
        carousel.currentIndex = currentIndex
    }
}
