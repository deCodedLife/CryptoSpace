// Element writed by コード化されたライブ
import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: root

    property var core: root.core
    property string folderName: ""
    property bool ready: false

    anchors.fill: parent
    visible: false

    Rectangle {
        id: background
        color: "black"
        opacity: 0.7
        anchors.fill: parent

        Rectangle {
            id: viewPanel
            width: parent.width - 20
            height: parent.height - parent.height / 3
            x: 10
            y: parent.height / 3 / 2
            color: "#282828"

            Text {
                id: txt
                text: "Encrypt: " + root.folderName
                color: "#ff6e6e"
                font.pixelSize: 18
                font.family: "Segoe UI Black"
                x: parent.width / 2 - txt.width / 2
                y: txt.height / 2
            }

            ProgressBar {
                id: progress;
                width: parent.width - 20
                height: 32
                anchors.centerIn: parent
                indeterminate: true
                value: 0.5
            }

            Rectangle {
                id: cancelButton
                width: 100
                height: 32
                color: "#3c3c3c"
                radius: 4
                border.color: "lightgrey"
                x: 5
                y: parent.height - 37

                Text {
                    id: buttonText
                    text: "Cancel"
                    color: "#ff6e6e"
                    font.family: "UD Digi Kyokasho NP-B"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    onHoveredChanged: {
                        if ( mouse.containsMouse ) {
                            cancelButton.color = "#ff6e6e";
                            buttonText.color = "white";
                        } else {
                            cancelButton.color = "#3c3c3c";
                            buttonText.color = "#ff6e6e";
                        }
                    }
                    enabled: false
                    hoverEnabled: true
                    onClicked: root.ready = false;
                }
            }
        }
    }

    function start() { root.visible = true; timer.setTimeout( function() { next(); }, 1000 ); }

    function next () {
        let filesArray = root.core.getAllFiles(root.folderName)
        for ( let i = 0; i < filesArray.length; i++ ) {
            let arr = filesArray[i].split(".");
            if ( root.ready == true && arr.length > 1 ) {
                console.log( filesArray[i] + " : " + i );
                root.core.encrypt( filesArray[i] );
                console.log("Ok");
            }
        }
        root.ready = false;
        root.visible = false;
    }

    Timer {
        id: timer
        function setTimeout(cb, delayTime, a, b) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.triggered.connect(function release () {
                timer.triggered.disconnect(cb); // This is important
                timer.triggered.disconnect(release); // This is important as well
            });
            timer.start();
        }
    }

    onVisibleChanged: { if ( root.ready == true ) root.start(); }

}
