import Qt 4.7

Image {
    id: button

    signal clicked()

    property alias pressedColor: pressed.color
    property alias pressedColorOpacity: pressed.opacity

    width: 100; height: 40
    Behavior on scale { NumberAnimation { duration: 50 } }

    Rectangle {
        id: pressed

        anchors { fill: parent; margins: 2 }
        color: "transparent"
        radius: 8
        opacity: 1
        Behavior on opacity { NumberAnimation { } }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: button.scale = 0.9
        onReleased: button.scale = 1.0
        onClicked: button.clicked()
    }
}