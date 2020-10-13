import QtQuick 2.15
import QtQuick.Window 2.15
import "./Widgets" as Widgets

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    VideoPlayer {
        anchors.fill:  parent
    }
}
