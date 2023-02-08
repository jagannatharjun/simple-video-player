import QtQuick 2.15


Rectangle {
    id: root

    property alias text: label.text
    property alias font: label.font
    property alias textColor: label.color

    property alias hovered: mouse.containsMouse

    property alias leftPadding: label.leftPadding
    property alias rightPadding: label.rightPadding
    property alias topPadding: label.topPadding
    property alias bottomPadding: label.bottomPadding

    signal clicked()

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    color: "transparent"

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton

        onClicked: root.clicked()
    }

    Text {
        id: label

        anchors.centerIn: parent
        font.pixelSize: 24

        color: {
            if (hovered)
                return "orange"
            return "white"
        }

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }
}
