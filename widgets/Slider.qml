import QtQuick 2.15

Item {
    id: root

    property real radius: 4
    property real progress: .5

    // when is slider is dragged, this is called to request
    // to change the progress
    signal requestUpdateProgress(real newProgress)

    Rectangle {
        id: sliderBg

        anchors.verticalCenter: parent.verticalCenter
        height: root.height / 5
        width: parent.width

        radius: root.radius
        color: Qt.darker(progressRect.color, 2)

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

            // handles drag for "handle"
            drag.target: handle
            drag.axis: Drag.XAxis

            // limit drag area to sliderBg
            drag.minimumX: 0
            drag.maximumX: sliderBg.width

            // this keeps handle always under mouse
            drag.threshold: 0

            acceptedButtons: Qt.LeftButton
            onClicked: function (mouse) {
                root.requestUpdateProgress(mouse.x / sliderBg.width)
            }

        }
    }

    Binding {
        // bind handle x to progress, but allow it to move when dragging
        target: handle
        property: "x"
        value: (sliderBg.width * root.progress - handle.width / 2)
        when: !mouse.drag.active
    }
}
