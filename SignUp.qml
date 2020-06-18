import QtQuick 2.0

Item {
    id: root

    Rectangle {
        id: base
        anchors.fill: parent

        Rectangle {
            id: background
            width: parent.width - 10
            height: 48

            anchors.centerIn: parent
        }
    }
}
