import QtQuick 2.15

Item {
    id: root

    property real radius: 4
    property real progress: .5

    signal requestUpdateProgress(real newProgress)

    Rectangle {
        id: sliderBg

        anchors.verticalCenter: parent.verticalCenter
        height: root.height / 5
        width: parent.width

        radius: root.radius
        color: "#C0C0C0"

        Rectangle {
            id: progressRect

            anchors.top: parent.top
            anchors.bottom: parent.bottom

            width: parent.width * root.progress
            radius: root.radius
            color: "white"
        }

        Rectangle {
            id: handle

            anchors.verticalCenter: parent.verticalCenter
            width: root.height / 2
            height: width
            radius: width
            color: "orange"

            onXChanged: {
                if (mouse.drag.active)
                    root.requestUpdateProgress((x / sliderBg.width))

            }
        }


        MouseArea {
            id: mouse

            anchors.fill: parent

            drag.target: handle
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: sliderBg.width

            acceptedButtons: Qt.LeftButton
            onClicked: function (mouse) {
                root.requestUpdateProgress(mouse.x / sliderBg.width)
            }

        }
    }

    Binding {
        target: handle
        property: "x"
        value: (sliderBg.width * root.progress - handle.width / 2)
        when: !mouse.drag.active
    }
}
