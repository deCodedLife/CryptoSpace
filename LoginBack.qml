// Element writed by コード化されたライブ
import QtQuick 2.0

Item {
    id: root
    property string version: root.version
    property string form: root.form

    Rectangle {
        id: background
        anchors.fill: parent
        color: "white"

        Rectangle {
            id: upPanel
            width: parent.width / 2.5
            height: parent.height / 4
            x: parent.width
            y: 0
            color: "black"
            Text {
                id: txt
                text: "> CryptoSpace version " + qsTr(root.version)
                wrapMode: Text.Wrap
                font.pointSize: 10
                color: "white"
                z: 10
                anchors.leftMargin: 3
            }
            NumberAnimation on x {
                id: show
                to: parent.width - upPanel.width
                easing.type: Easing.OutCubic
                duration: 500
                running: false
            }

            NumberAnimation on x {
                id: hide
                to: parent.width
                easing.type: Easing.OutCubic
                duration: 500
                running: false
                onStopped: root.visible = false
            }
        }
    }

    Timer {
        interval: 1000
        repeat: false
        onTriggered: { root.start(); }
        running: true
    }

    function start(check) {
        show.running = true;
        let newText = txt.text + "\nroot@local>init " + root.form + " page";
        timer.setTimeout(function(){init( newText.length, newText );}, 1000 );
    }

    function init( size, text ) {
        let textSize = txt.text.length;
        if ( textSize != size ) {
            txt.text = txt.text + text.charAt(textSize);
            timer.interval = 50;
            timer.setTimeout(function(){init( size, text );}, 50 );
            timer.running = true;
        } else {
            txt.text = txt.text + "\nInitializing..."
            timer.setTimeout(function(){last();}, 1500 );
        }
    }

    function last ()
    {
        txt.text = txt.text + " Ok";
        let newText = txt.text + "\nroot@local>hide panel";
        timer.setTimeout(function(){ hidePanel( newText.length, newText ); }, 1200);
    }

    function hidePanel ( size, text ) {
        let textSize = txt.text.length;
        if ( textSize != size ) {
            txt.text = txt.text + text.charAt(textSize);
            timer.interval = 50;
            timer.setTimeout(function(){hidePanel( size, text );}, 50 );
            timer.running = true;
        } else hide.running = true;
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
}
