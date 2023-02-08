import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.0

import "Widgets"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        VideoPlayer {
            id: player

            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Rectangle {
            color: "blue"

            Layout.fillWidth: true
            height: 40

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    margins: 4
                }

                Button {
                    text: {
                        if (player.isPaused)
                            return "Play"
                        else if (player.isPlaying)
                            return "Pause"
                        return "Stopped"
                    }

                    onClicked: {
                        if (player.isPlaying)
                            player.pause()
                        else
                            player.play()
                    }
                }
            }
        }
    }

}
