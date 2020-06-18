// Writed by コード化されたライブ

import QtQuick 2.8
import QtQuick.Controls 2.5
import QtQuick.Shapes 1.12
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.2
import CryptoSpace 1.0
import QtGraphicalEffects 1.0
import QtMultimedia 5.9

Window {
    id: application
    visible: true
    width: 640
    height: 480
    x: Screen.desktopAvailableWidth - application.width
    y: Screen.desktopAvailableHeight - application.height
    flags: Qt.AA_NativeWindows
    maximumHeight: 480
    maximumWidth: 640
    minimumHeight: 480
    minimumWidth: 640

    property var colors: []
    property bool auth: false
    property bool activeForm: false
    property bool signUp: false
    property string version: "3.0.4 (XDL)"
    property string workpath: "Storage"
    property string nextPath: ""
    property var audioFormats: ["WAV","wav","MP3","mp3","FLAC","flac","OGG","ogg","3GP","3gp","VOC","voc"]
    property var imageFormats: ["JPEG","jpeg","Exif","Exif","TIFF","tiff","GIF","gif","BMP","bmp","PNG","png"]
    property var videoFormats: ["MP4","mp4","m4a","m4v","f4v","f4a","f4b","mov","3GP","3gp","OGG","ogg","WMV","wmv","wma","WEBM","webm","FLV","flv","AVI"]
    property var docsFormats:  ["DOC","doc","DOCX","docx","ODT","odt","PDF","pdf","RTF","rtf","TEX","tex","WKS","wks","WPS","wps","WPD","wpd"]

    title: "CryptoSpace " + version

    CryptoSpace {id: core}

    StackView {
        id: mainWindow
        anchors.fill: parent
    }

    Component {
        id: preloader

        Item {
            id: main
            anchors.fill: parent

            Rectangle {
                id: background
                anchors.fill: parent

                Rectangle {
                    id: black
                    anchors.fill: parent
                    color: {
                        let r = (Math.random() * (1 - 0.2) + 0.2);
                        let g = (Math.random() * (1 - 0.2) + 0.2);
                        let b = (Math.random() * (1 - 0.2) + 0.2);
                        application.colors = [r, g, b];
                        Qt.rgba(r,g,b);
                    }
                    z: 10
                    opacity: 1

                    NumberAnimation on opacity {
                        to: 0.6
                        running: true
                        duration: 1000
                    }
                }

                AnimatedImage {
                    id: img
                    width: 420
                    height: 420
                    x: parent.width / 2 - img.width / 2
                    y: parent.height / 3 - img.height / 2
                    source: "qrc:/images/preloader.gif"
                    z: 10
                }

                Text {
                    id: txt
                    text: "CryptoSpace"
                    font.pointSize: 32
                    font.family: "Calibri"
                    x: parent.width / 2 - txt.width / 2
                    y: parent.height - parent.height / 5 - txt.contentHeight
                    z: 10
                }

                Background { anchors.fill: parent }
            }
        }
    }

    Component {
        id: main

        Item {
            id: mainWindows
            anchors.fill: parent

            LoginBack {
                z: 10
                id: start
                anchors.fill: parent
                version: application.version
                form: { if (!application.auth) start.form = "login"; else start.form = "register"; }
                onVisibleChanged: { formAnimation.running = true; }
                Component.onCompleted: { form.visible = true; }
            }

            Rectangle {
                id: form
                visible: false
                anchors.fill: parent
                color: "#282828"
                z: 5

                Rectangle {
                    id: data
                    color: "#3c3c3c"
                    width: parent.width / 1.5
                    height: parent.height / 2
                    x: parent.width
                    y: parent.height / 4
                    radius: 3

                    Rectangle {
                        id: background
                        width: parent.width - 20
                        height: 32
                        radius: 4
                        color: "#282828"
                        x: parent.width
                        y: parent.height / 2 - 32

                        TextInput {
                            id: textInput
                            x:8
                            y:8
                            font.pixelSize: 16
                            font.family: "UD Digi Kyokasho NP-B"
                            color: "#ff6e6e"
                            z: 5
                            width: parent.width - 10
                            height: parent.height - 10
                            layer.enabled: true
                            enabled: false

                            Text {
                                id: txt
                                font.pixelSize: 16
                                font.family: "UD Digi Kyokasho NP-B"
                                visible: !textInput.text
                                color: "#ff6e6e"
                                z: 3
                            }

                            Component.onCompleted: { if ( application.auth == false ) textInput.echoMode = TextInput.Password; }
                        }

                        NumberAnimation on x {
                            id: backShow
                            duration: 500
                            to: 10
                            easing.type: Easing.InOutQuad
                            running: false
                            onStopped: {
                                let nText;
                                if ( application.auth == false ) nText = "Enter your password";
                                else nText = "Enter new password";
                                typing( nText.length, nText );
                            }

                            function typing ( size, text ) {
                                let textSize = txt.text.length;
                                if ( textSize != size ) {
                                    txt.text = txt.text + text.charAt(textSize);
                                    timer.interval = 50;
                                    timer.setTimeout(function(){typing( size, text );}, 30 );
                                    timer.running = true;
                                } else textInput.enabled = true;
                            }
                        }
                    }

                    Rectangle {
                        id: buttonBackground
                        width: 100
                        height: 32
                        color: "#3c3c3c"
                        x: data.width
                        y: data.height / 2 + 8
                        radius: 4
                        z: 6
                        border.color: "lightgrey"

                        Text {
                            id: buttonTxt
                            text: "Enter"
                            color: "#ff6e6e"
                            x: 8
                            y: 8
                            font.family: "UD Digi Kyokasho NP-B"
                            font.pixelSize: 16
                        }

                        MouseArea {
                            id: mouse
                            anchors.fill: parent
                            onHoveredChanged: {
                                if ( mouse.containsMouse ) {
                                    buttonBackground.color = "#ff6e6e";
                                    buttonTxt.color = "white";
                                } else {
                                    buttonBackground.color = "#3c3c3c";
                                    buttonTxt.color = "#ff6e6e";
                                }
                            }
                            onClicked: {
                                let password = textInput.text;
                                let ok = true;
                                if ( application.auth == true ) core.db_register( password );
                                else ok = core.db_getKey( password );
                                if ( !ok ) { dlg.txt = "Password fail"; dlg.visible = true; }
                                else {
                                    hideAnimation.running = true;
                                    mouse.enabled = false;
                                    textInput.enabled = false;
                                }
                            }
                            enabled: false
                            hoverEnabled: true
                        }

                        NumberAnimation on x {
                            id: showBack
                            duration: 500
                            to: data.width - (buttonBackground.width + 10)
                            easing.type: Easing.OutQuad
                            running: false
                            onStopped: mouse.enabled = true;
                        }
                    }

                    NumberAnimation on x {
                        id: formAnimation
                        to: application.width - data.width
                        duration: 400
                        easing.type: Easing.InCubic
                        running: false
                        onStopped: { backShow.running = true; showBack.running = true; }
                    }

                    NumberAnimation on y {
                        id: hideAnimation
                        easing.type: Easing.InBack
                        to: application.height
                        duration: 1000
                        running: false
                        onStopped: { application.push(); }
                    }
                }
            }
        }
    }

    function push() { mainWindow.clear(); mainWindow.push(cryptoItem); }

    Component {
        id: cryptoItem

        Item {

            id: cryptoSpace
            anchors.fill: parent

            FolderEncrypt {
                id: folderEnc;
                width: parent.width
                height: parent.height
                onVisibleChanged: { if ( folderEnc.ready == false ) { cryptoSpace.load( true ); folderEnc.folderName = ""; }  }
                z: 100
            }

            Rectangle {
                id: background
                color: "#282828"
                anchors.fill: parent
                opacity: 0.1

                Rectangle {
                    id: toolBar
                    width: parent.width
                    height: 24
                    color: "#3c3c3c"
                    y: -24

                    Image {
                        id: decrypt
                        property string fileName: ""
                        width: 24
                        height: 24
                        source: "qrc:/images/decrypt24.png"
                        sourceSize: Qt.size(22, 22)
                        fillMode: Image.PreserveAspectFit
                        x: parent.width - 26
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if ( decrypt.fileName != "" && decryptHide.visible == false )
                                {
                                    let debug = core.encrypt(decrypt.fileName);
                                    if ( debug === 0 ) cryptoSpace.load( true );
                                }
                            }
                        }
                        Colorize {id: decryptHide; anchors.fill: decrypt; source: decrypt; hue: 0.0; saturation: 0; lightness: 0; visible: false }
                    }


                    Image {
                        id: encrypt
                        antialiasing: true
                        property string fileName: ""
                        width: 24
                        height: 24
                        source: "qrc:/images/encrypt24.png"
                        sourceSize: Qt.size(22,22)
                        fillMode: Image.PreserveAspectFit
                        x: parent.width - 50
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                let extension = encrypt.fileName.split(".");
                                if ( encrypt.fileName != "" && encryptHide.visible == false )
                                {
                                    if ( extension.length > 1 ) {
                                        let debug = core.encrypt(encrypt.fileName);
                                        if ( debug == 0 ) cryptoSpace.load( true );
                                    } else {
                                        folderEnc.folderName = encrypt.fileName;
                                        folderEnc.ready = true;
                                        folderEnc.core = core;
                                        folderEnc.visible = true;
                                    }
                                }
                            }
                        }
                        Colorize {id: encryptHide; anchors.fill: encrypt; source: encrypt; hue: 0.0; saturation: 0; lightness: 0; visible: false }
                    }

                    Image {
                        id: imgBack
                        width: 24
                        height: 24
                        x: 60
                        y: 2
                        sourceSize: Qt.size(22,22)
                        source: "qrc:/images/next24.png"
                        fillMode: Image.PreserveAspectFit
                        transformOrigin: Item.Center
                        rotation: 180
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if ( backHide.visible == false) {
                                    let temp = application.workpath.split("/");
                                    let newPath = "";
                                    for ( let i = 0; i < temp.length; i++ ) {
                                        if ( i != temp.length - 1 ) {
                                            if ( i == temp.length - 2 ) newPath = newPath + temp[i];
                                            else newPath = newPath + temp[i] + "/";
                                        }
                                    }
                                    let next = application.nextPath.split(newPath + "/");
                                    if ( next.length > 1 ) nextHide.visible = false;
                                    else {
                                        application.nextPath = application.workpath;
                                        nextHide.visible = false;
                                    }
                                    application.workpath = newPath;
                                    if ( application.workpath == application.nextPath ) nextHide.visible = true;
                                    cryptoSpace.load( true );
                                    if ( application.workpath == "Storage" ) backHide.visible = true;
                                }
                            }
                        }
                    }
                    Colorize {id: backHide; rotation: 180; transformOrigin: Item.Center; anchors.fill: imgBack; source: imgBack; hue: 0.0; saturation: 0; lightness: 0; visible: true }

                    Image {
                        id: imgNext
                        width: 24
                        height: 24
                        x: 84
                        y: 2
                        sourceSize: Qt.size(22,22)
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/images/next24.png"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if ( nextHide.visible == false) {
                                    let arr = application.nextPath.split(application.workpath + "/");
                                    let path = "";
                                    if ( arr.length > 1 ) path = arr[1].split("/");
                                    let newPath = application.workpath + "/" + path[0];
                                    application.workpath = newPath;
                                    if ( application.workpath == application.nextPath ) nextHide.visible = true;
                                    cryptoSpace.load( true );
                                }
                            }
                        }
                    }
                    Colorize {id: nextHide; anchors.fill: imgNext; source: imgNext; hue: 0.0; saturation: 0; lightness: 0; visible: true }

                    Rectangle {
                        id: temp1
                        antialiasing: true
                        color: "#ff6e6e"
                        width: parent.width + 24
                        height: 24
                        x: -parent.width - 24

                        Item {

                            id: showMore
                            width: 24
                            height: 24
                            anchors.right: parent.right

                            Rectangle {
                                z: 2
                                color: "#3c3c3c"
                                width: 20
                                height: 24
                                anchors.right: parent.right
                            }

                            Rectangle {
                                id: r3; x: 5; y:8; width: 12; height: 2; antialiasing: true; z:4
                                states: State { name: "rotated"; PropertyChanges {target: r3; rotation: 30} }
                                transitions: Transition { RotationAnimation { duration: 600; to: 30 } }
                            }
                            Rectangle {
                                id: r4; x: 5; y:14;width: 12; height: 2; antialiasing: true; z:4
                                states: State { name: "rotated"; PropertyChanges {target: r4; rotation: -30} }
                                transitions: Transition { RotationAnimation { duration: 600; to: -30 } }
                            }

                            Shape {
                                antialiasing: true;
                                anchors.fill: parent
                                z:3
                                ShapePath {
                                    strokeColor: "#ff6e6e"
                                    strokeWidth: 2
                                    fillColor: "#ff6e6e"
                                    capStyle: ShapePath.FlatCap
                                    startX: 4
                                    startY: 1
                                    PathLine { x: 22; y:12 }
                                    PathLine { x: 4; y:23 }
                                }
                            }

                            MouseArea {
                                id: showMenu
                                width: 48
                                height: 24
                                x: -48
                                hoverEnabled: true
                                onHoveredChanged: {
                                    if ( showMenu.containsMouse ) shPanel.running = true;
                                    else anim3.running = true;
                                }
                                onClicked: {
                                    showAnim.running = true;
                                    hideMenu.enabled = true;
                                    showMenu.enabled = false;
                                }
                                enabled: false
                                z: 9
                            }

                            z: 1
                        }

                        NumberAnimation on x {
                            id: shPanel
                            to: -parent.width + 34
                            duration: 200
                            easing.type: Easing.Linear
                            running: false
                        }

                        Item {
                            id: hideMore
                            width: 24
                            height: 24
                            x: 0

                            Rectangle {
                                z: 1
                                color: "#3c3c3c"
                                anchors.fill: parent
                            }

                            Rectangle {
                                id: r1; x: 5; y:8; width: 12; height: 2; antialiasing: true; z:9
                                states: State { name: "rotated"; PropertyChanges {target: r1; rotation: -30 } }
                                transitions: Transition { RotationAnimation { duration: 800; to: -30  } }
                            }
                            Rectangle {
                                id: r2; x: 5; y:14; width: 12; height: 2; antialiasing: true; z:9
                                states: State { name: "rotated"; PropertyChanges {target: r2; rotation: 30} }
                                transitions: Transition { RotationAnimation { duration: 800; to: 30 } }
                            }

                            Shape {
                                antialiasing: true;
                                anchors.fill: parent
                                z:8
                                ShapePath {
                                    strokeColor: "#ff6e6e"
                                    strokeWidth: 2
                                    fillColor: "#ff6e6e"
                                    capStyle: ShapePath.FlatCap
                                    startX: 24
                                    startY: 0
                                    PathLine { x: 1; y:12 }
                                    PathLine { x: 24; y:23 }
                                }
                            }

                            MouseArea {
                                id: hideMenu
                                width: 42
                                height: 24
                                anchors.left: parent.left
                                hoverEnabled: true
                                onHoveredChanged: {
                                    if ( hideMenu.containsMouse ) hidePanel1.running = true;
                                    else { showAnim.duration = 200; showAnim.running = true; }
                                }
                                onClicked: {anim3.running = true; showMenu.enabled = true; hideMenu.enabled = false }
                                z: 9
                                enabled: false
                            }

                            z: 5
                        }

                        NumberAnimation on x {
                            id: hidePanel1
                            to: 10
                            duration: 200
                            easing.type: Easing.Linear
                            running: false
                        }

                        NumberAnimation on x {
                            id: showAnim
                            to: 24
                            duration: 800
                            running: false
                            easing.type: Easing.Linear
                            onStopped: {
                                r1.state = "rotated";
                                r2.state = "rotated";
                                showAnim.duration = 800;
                            }
                        }

                        NumberAnimation on x {
                            id: anim3
                            to: -parent.width + 24
                            duration: 300
                            easing.type: Easing.Liner
                            running: false
                            onStopped: {
                                r3.state = "rotated";
                                r4.state = "rotated";
                            }
                        }
                    }

                    NumberAnimation on y {
                        id: anim1
                        to: 0
                        duration: 1000
                        easing.type: Easing.Linear
                        running: false
                        onStopped: anim3.running = true;
                    }
                }

                ListView {
                    id: pathView
                    width: parent.width / 3
                    height: parent.height - 24
                    y: 24
                    clip: true
                    //ScrollBar.horizontal.interactive: true
                    //ScrollBar.vertical.interactive: true

                    property var modelLoad: []

                    Rectangle {
                        width: 1
                        height: parent.height
                        color: "grey"
                        x: parent.width - 1
                        y: parent.height

                        NumberAnimation on y {
                            id: anim0
                            to: 0
                            duration: 700
                            easing.type: Easing.InOutCubic
                            running: false
                            onStopped: {
                                fileView.model = fileView.modelLoad;
                                pathView.model = pathView.modelLoad;
                                showPath.running = true;
                                showFiles.running = true;
                            }
                        }
                    }

                    delegate: Item {
                        width: parent.width
                        height: 24

                        Rectangle {
                            id: rect
                            anchors.fill: parent
                            color: "lightblue"
                            opacity: 0
                        }

                        Image  {
                            id: img
                            source: "qrc:/images/folder24.png"
                            sourceSize: Qt.size(22, 22)
                            anchors.left: parent.left
                        }

                        Text {
                            id: txt
                            text: modelData.text
                            font.pixelSize: 15
                            font.family: "Segoe UI Black"
                            color: "#ff6e6e"
                            x: 24
                        }

                        Rectangle {
                            color: "grey"
                            width: parent.width
                            height: 1
                            anchors.bottom: parent.bottom
                        }

                        MouseArea {
                            id: m2
                            anchors.fill: parent
                            onClicked: { pathView.currentIndex = index; pathView.select( modelData.fullName ); }
                            onDoubleClicked: { application.workpath = modelData.fullName; cryptoSpace.load( true ); }
                            x: 2
                            hoverEnabled: true
                            onHoveredChanged: {
                                if ( rect.opacity != 0.5 )
                                {
                                    if ( m2.containsMouse ) rect.opacity = 0.2;
                                    else rect.opacity = 0;
                                }
                            }
                        }

                        function select_ () { rect.opacity = 0.5; txt.color = Qt.rgba(1,1,1,0.7); }
                        function deselect_(){ rect.opacity = 0; txt.color = "#ff6e6e";  }
                    }

                    function select( path ) {
                        let curr = pathView.currentIndex;
                        for ( let i = 0; i < pathView.model.length; i++ ) {
                            pathView.currentIndex = i;
                            if ( i === curr ) pathView.currentItem.select_();
                            else pathView.currentItem.deselect_();
                        }
                        encryptHide.visible = false;
                        decryptHide.visible = true;
                        encrypt.fileName = path;
                    }

                    onModelChanged: {
                        let temp = application.workpath.split("/");
                        let newPath = "";
                        for ( let i = 0; i < temp.length; i++ ) {
                            if ( i != temp.length - 1 ) {
                                if ( i == temp.length - 2 ) newPath = newPath + temp[i];
                                else newPath = newPath + temp[i] + "/";
                            }
                        }
                        let next = application.nextPath.split(newPath + "/");
                        if ( next.length > 1 ) nextHide.visible = false;
                        else {
                            application.nextPath = application.workpath;
                            nextHide.visible = false;
                        }
                        let array = application.nextPath.split(application.workpath);
                        if ( array.length == 1 ) application.nextPath = application.workpath;
                        if ( application.workpath != "Storage" ) backHide.visible = false;
                        if ( application.workpath == application.nextPath ) nextHide.visible = true;
                    }

                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                        NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                    }

                    displaced: Transition {
                        NumberAnimation { properties: "x,y"; duration: 700; easing.type: Easing.OutBounce }
                        NumberAnimation { property: "opacity"; to: 1.0; }
                        NumberAnimation { property: "scale"; to: 1 }
                    }
                }

                Rectangle {
                    color: "#282828"
                    width: parent.width / 3 - 1
                    height: parent.height - 24
                    y: 24

                    NumberAnimation on opacity {
                        id: showPath
                        to: 0
                        duration: 400
                        running: false
                        easing.type: Easing.Linear
                    }
                    z: 5
                }

                Rectangle {
                    width: parent.width - parent.width / 3
                    height: parent.height - 24
                    y: 24
                    x: parent.width / 3
                    color: "#282828"

                    NumberAnimation on opacity {
                        id: showFiles
                        to: 0
                        duration: 400
                        running: false
                        easing.type: Easing.Linear
                    }
                    z: 5
                }

                MouseArea {
                    id: previewPanelMouse
                    width: 24
                    height: 24
                    x: parent.width / 3
                    y: 24
                    enabled: false
                    propagateComposedEvents: true
                    onClicked: {
                        previewHide.running = true;
                        r5.state = "";
                        r6.state = "";
                        preview.enabled = false;
                        fileView.visible = true;
                        previewPanelMouse.enabled = false;
                    }
                    z: 100
                }

                ListView {
                    id: fileView
                    property var modelLoad: []
                    width: parent.width - parent.width / 3
                    height: parent.height - 24
                    y: 24
                    x: parent.width / 3
                    z: 2

                    delegate: Item {

                        width: parent.width
                        height: 24

                        Rectangle {
                            id: rect1
                            anchors.fill: parent
                            opacity: 0
                            color: "lightblue"
                        }

                        Image {
                            id: ico
                            source: {
                                let extention = modelData.text.split(".");
                                let ext = "";
                                for ( let i = 0; i < application.imageFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.imageFormats[i] ) ext = "img"; }
                                for ( let i = 0; i < application.videoFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.videoFormats[i] ) ext = "vid"; }
                                for ( let i = 0; i < application.audioFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.audioFormats[i] ) ext = "mp3"; }
                                for ( let i = 0; i < application.docsFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.docsFormats[i] ) ext = "doc"; }
                                if  ( extention[ extention.length - 1 ] == "crp" ) ext = "crp";
                                if ( ext == "img" ) ico.source = "qrc:/images/image24.png";
                                else if ( ext == "vid" ) ico.source = "qrc:/images/video24.png";
                                else if ( ext == "doc" ) ico.source = "qrc:/images/doc24.png";
                                else if ( ext == "mp3" ) ico.source = "qrc:/images/audio24.png";
                                else if ( ext == "crp" ) ico.source = "qrc:/images/crp24.png";
                                else if ( ext == "" ) ico.source = "qrc:/images/file24.png";
                            }
                            sourceSize: Qt.size(22, 22)
                            anchors.left: parent.left
                        }

                        Text {
                            id: tzt
                            text: modelData.text
                            font.pixelSize: 15
                            font.family: "Segoe UI Black"
                            color: "#ff6e6e"
                            x: 24
                        }

                        Rectangle {
                            color: "grey"
                            width: parent.width
                            height: 1
                            anchors.bottom: parent.bottom
                        }

                        MouseArea {
                            id: m1
                            width: parent.width - 24
                            height: parent.height
                            x: 24
                            hoverEnabled: true
                            onHoveredChanged: {
                                if ( rect1.opacity != 0.5 )
                                {
                                    if ( m1.containsMouse ) rect1.opacity = 0.2;
                                    else rect1.opacity = 0;
                                }
                            }
                            onClicked: { fileView.currentIndex = index; fileView.select( modelData.fullName );  }
                            onDoubleClicked: {
                                preview.fileName = modelData.fullName;
                                previewShow.running = true;
                                fileView.enabled = false;
                            }
                            z: 2
                        }

                        function select_ () { rect1.opacity = 0.5; tzt.color = Qt.rgba(1,1,1,0.7); }
                        function deselect_(){ rect1.opacity = 0; tzt.color = "#ff6e6e"  }
                    }

                    add: Transition {
                        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                        NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                    }

                    displaced: Transition {
                        NumberAnimation { properties: "x,y"; duration: 700; easing.type: Easing.OutBounce }
                        NumberAnimation { property: "opacity"; to: 1.0; }
                        NumberAnimation { property: "scale"; to: 1 }
                    }

                    function select( file ) {
                        let curr = fileView.currentIndex;
                        for ( let i = 0; i < fileView.model.length; i++ ) {
                            fileView.currentIndex = i;
                            if ( i === curr )
                            {
                                let fileName = fileView.model[i].text.split(".");
                                if ( fileName[1] == "crp" ) { encryptHide.visible = true; decryptHide.visible = false; decrypt.fileName = file; }
                                else { encryptHide.visible = false; decryptHide.visible = true; encrypt.fileName = file; }
                                fileView.currentItem.select_();
                            }
                            else fileView.currentItem.deselect_();
                        }
                    }

                    enabled: true
                    visible: true

                    Rectangle {
                        id: preview
                        property string fileName: ""
                        property string currentName: ""
                        property bool local: false
                        width: parent.width
                        height: parent.height
                        x: parent.width
                        enabled: false
                        color: "#3c3c3c"
                        z: 1000

                        Text {
                            id: previewText
                            text: ""
                            font.pixelSize: 16
                            font.family: "Segoe UI Black"
                            color: "#ff6e6e"
                            y: parent.height - previewText.height - 3
                            x: 0
                            z: 100
                        }

                        Image {
                            id: previewImage
                            width: parent.width
                            height: parent.height - 48
                            y: 24
                            source: ""
                            sourceSize: Qt.size(previewImage.width, previewImage.height)
                            visible: false
                        }

                        Rectangle {
                            id: previewSource
                            width: parent.width
                            height: parent.height - 48
                            y: 24
                            color: "#3c3c3c"
                            visible: false

                            Flickable {
                                id: flickable
                                width: parent.width
                                height: parent.height
                                flickableDirection: Flickable.VerticalFlick
                                contentHeight: flickable.height

                                TextArea.flickable: TextArea {
                                    id: sourceText
                                    font.pixelSize: 10
                                    font.family: "Segoe UI Black"
                                    color: "#ff6e6e"
                                    wrapMode: Text.Wrap
                                }

                                ScrollBar.vertical: ScrollBar{
                                    parent: flickable.parent
                                    policy: ScrollBar.AsNeeded
                                }
                            }
                        }

                        Rectangle {
                            id: previewPanel
                            width: parent.width
                            height: 24
                            anchors.top: parent.top
                            color: "#3c3c3c"

                            Rectangle {
                                width: parent.width
                                height: 1
                                anchors.top: parent.top
                                color: "grey"
                            }

                            Item {

                                id: hidePreview
                                width: 24
                                height: 24
                                anchors.left: parent.left
                                default property alias children: previewPanelMouse.data

                                Rectangle {
                                    id: r5; x: 5; y:8; width: 12; height: 2; antialiasing: true;
                                    states: State { name: "rotated"; PropertyChanges {target: r5; rotation: 30} }
                                    transitions: Transition { RotationAnimation { duration: 600; to: 30 } }
                                }
                                Rectangle {
                                    id: r6; x: 5; y:14;width: 12; height: 2; antialiasing: true;
                                    states: State { name: "rotated"; PropertyChanges {target: r6; rotation: -30} }
                                    transitions: Transition { RotationAnimation { duration: 600; to: -30 } }
                                }
                            }
                        }

                        Rectangle {
                            id: mediaArea
                            width: parent.width
                            height: parent.height - 48
                            y: 24
                            color: "#3c3c3c"
                            visible: false

                            MediaPlayer {
                                id: mediaPlayer
                                autoPlay: true
                                autoLoad: true
                                source: ""
                            }

                            VideoOutput {
                                id: videoOutput
                                source: mediaPlayer
                                anchors.fill: parent
                                fillMode: VideoOutput.PreserveAspectFit
                            }
                        }

                        Rectangle {
                            id: audioArea
                            width: parent.width
                            height: parent.height - 48
                            y: 24
                            color: "#3c3c3c"
                            visible: false

                            ProgressBar {
                                id: progress
                                width: parent.width - 20
                                height: 5
                                x: 10
                                y: parent.height / 2
                                to: audioPlayer.duration
                            }

                            Audio {
                                id: audioPlayer
                                autoPlay: true
                                autoLoad: true
                                source: ""

                                onPositionChanged: { progress.value = audioPlayer.position; }

                                onStatusChanged: {
                                    if ( audioPlayer.status == mediaPlayer.Loaded ) console.log(audioPlayer.metaData);
                                }
                            }
                        }

                        ProgressBar {
                            id: preloader
                            width: parent.width
                            height: 5
                            value: 0.5
                            anchors.centerIn: parent
                            visible: true
                            indeterminate: true
                        }

                        NumberAnimation on x {
                            id: previewShow
                            to: 0
                            from: parent.width
                            duration: 500
                            easing.type: Easing.InOutCubic
                            running: false
                            onStopped: {
                                preview.enabled = true;
                                let  repeated = preview.fileName.split(".");
                                let filePath;
                                if ( repeated[1] == "crp" ) {filePath = core.getFileContent(preview.fileName); }
                                else { filePath = core.getGlobalPath() + preview.fileName; preview.local = true; }
                                let array = filePath.split("/");
                                let extention = array[ array.length - 1 ].split(".");
                                previewText.text = "File name: " + array[ array.length - 1 ];
                                let ext = "";
                                for ( let i = 0; i < application.imageFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.imageFormats[i] ) ext = "img"; }
                                for ( let i = 0; i < application.videoFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.videoFormats[i] ) ext = "vid"; }
                                for ( let i = 0; i < application.audioFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.audioFormats[i] ) ext = "mp3"; }
                                for ( let i = 0; i < application.docsFormats.length; i++ ) { if ( extention[ extention.length - 1 ] == application.docsFormats[i] ) ext = "doc"; }
                                if ( ext == "img" ) {
                                    previewImage.source = "file:///" + filePath;
                                    previewImage.visible = true;
                                }
                                else if ( ext == "vid" ) {
                                    mediaArea.visible = true;
                                    mediaPlayer.source = "file:///" + filePath;
                                    mediaPlayer.play();
                                }
                                else if ( ext == "mp3" ) {
                                    audioArea.visible = true;
                                    audioPlayer.source = "file:///" + filePath;
                                }
                                else if ( ext == "" ) {
                                    previewSource.visible = true;
                                    sourceText.text = core.getTextInfo( filePath );
                                }
                                preloader.visible = false;
                                preview.currentName = filePath;
                                r5.state = "rotated";
                                r6.state = "rotated";
                                previewPanelMouse.enabled = true;
                            }
                        }

                        NumberAnimation on x {
                            id: previewHide
                            from: 0
                            to: parent.width
                            duration: 500
                            easing.type: Easing.InOutCubic
                            running: false
                            onStopped: {
                                previewText.text = "";
                                preview.enabled = false;
                                fileView.visible = true;
                                fileView.enabled = true;
                                mediaPlayer.stop();
                                preloader.visible = true;
                                mediaPlayer.source = "";
                                mediaArea.visible = false;
                                audioArea.visible = false;
                                audioPlayer.stop();
                                audioPlayer.source = "";
                                previewImage.visible = false;
                                previewSource.visible = false;
                                if ( preview.local == false ) { core.deleteFile( preview.currentName ); }
                                preview.local = false;
                            }
                        }
                    }
                }

                NumberAnimation on opacity {
                    id: formAnimation
                    to: 1
                    duration: 500
                    easing.type: Easing.InOutCubic
                    running: false
                    onStopped: { anim0.running = true; anim1.running = true; showMenu.enabled = true; }
                }
            }

            Keys.onPressed: {
                if ( event.key == Qt.Key_F12 && event.modifiers == Qt.ShiftModifier ) {
                    dlg.text = "Programm writed by コード化されたライブ\n" +
                            "Programm version: " + application.version
                    dlg.visible = true;
                }
            }

            Component.onCompleted: {
                formAnimation.running = true;
                load( false );
            }

            function load ( reload ) {
                let files = core.get_files( application.workpath );
                let filesArray = [];
                let dirsArray = [];
                for ( let i = 0; i < files.length; i++ ) {
                    let file = files[i];
                    let fname = file.split("/");
                    let arr = fname[fname.length - 1].split(".");
                    if ( arr.length > 1 ) {
                        let meta = {
                            "id" : i,
                            "text" : fname[fname.length - 1],
                            "fullName" : file
                        };
                        filesArray.push( meta );
                    } else {
                        let meta = {
                            "id" : i,
                            "text" : fname[fname.length - 1],
                            "fullName" : file
                        };
                        dirsArray.push(meta);
                    }
                }
                if ( reload == true ) {
                    pathView.model = dirsArray;
                    fileView.model = filesArray;
                } else {
                    pathView.modelLoad = dirsArray;
                    fileView.modelLoad = filesArray;
                }
            }
        }
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

    MessageDialog {
        id: dlg
        property string txt: dlg.txt
        text: txt
        visible: false
        title: "Warning"
    }

    Component.onCompleted: {
        mainWindow.clear();
        mainWindow.push(preloader);
        let data = core.db_getUserData();
        if ( data[0] === "" || data[1] === "" ) application.auth = true;
        timer.setTimeout(function(){ mainWindow.push(main); }, 1200);
    }
}
