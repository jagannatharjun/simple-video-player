import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.0

import "Widgets"
import SystemLockManager

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Video Player")

    // Main Layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        VideoPlayer {
            id: player

            Layout.fillHeight: true
            Layout.fillWidth: true

            onPlaybackStateChanged: {
                SystemLockManager.preventSystemLock(player.isPlaying)
            }

            Text {
                // caption
                anchors.fill: parent
                font.pixelSize: 32
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: !player.isPlaying

                text: {
                    var s = ""
                    if (player.error != 0)
                        s += "Failed to play '" + player.source + "', Error - " + player.errorString + "\n\n"

                    return s + "Drop Files to play or click 'Open File'"
                }
            }
        }


        // bottom controls rectangle
        Rectangle {
            color: "black"

            Layout.fillWidth: true
            height: 44

            RowLayout {
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    margins: 4
                }

                spacing: 10

                Button {
                    // open file button

                    text: "Open File"

                    onClicked: fileDialog.open()
                }

                Button {
                    // play button

                    text: "Play"

                    enabled: !player.isPlaying && player.source.length > 0 // handles isStopped case as well

                    onClicked: player.play()
                }

                Button {
                    // pause button

                    text: "Pause"

                    enabled: player.isPlaying

                    onClicked: player.pause()
                }

                Slider {
                    // playback slider
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    progress: player.position / player.duration

                    onRequestUpdateProgress: function (newProgress) {
                        player.position = newProgress * player.duration
                    }
                }
            }
        }
    }


    // utility classes

    VideoFileDialog {
        id: fileDialog

        onOpenFileName: {
            player.playSource(selectedFile)
        }
    }

    DropArea {
        // handles files drop from explorer
        anchors.fill: parent
        onDropped: function (event) {
            if (!event.hasUrls || event.urls.lenght < 1)
                return

            // We don't support playlist, so only add first url and ignore rest
            player.playSource(event.urls[0])

            event.accepted = true
        }
    }
}
