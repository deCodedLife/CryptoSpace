// Element writed by コード化されたライブ
import QtQuick 2.0
import QtQuick.Layouts 1.3

Item {
    id: root
    property bool showAnimation: true

    Canvas {
        id: canvas
        anchors.fill: parent
        z: 0
        onPaint: {
            var ctx = getContext('2d');
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            ctx.lineWidth = 2;
            ctx.strokeStyle = "black";

            var height = parent.height;
            var width  = parent.width;
            var colors = [''];
            var array = [];
            var point = [0,0];
            for ( let i = 0; i < 11; i++ ) {
                let add = 0;
                if ( i % 2 != 0 ) add = ((width + 255) / 20) / 2;
                for ( let j = 0; j < 20; j++ ){
                    let obj = {'width' : j * (width / 20) + add, 'height' : i * (height / 10), 'arr' : []};
                    array.push(obj);
                }
            }

            for ( let i = 0; i < 200; i++ )
            {
                ctx.moveTo(array[i]['width'], array[i]['height'])
                ctx.lineTo(array[i + 20]['width'], array[i + 20]['height']);
                if ( i % 2 == 0) {
                    ctx.moveTo(array[i]['width'], array[i]['height'])
                    ctx.lineTo(array[i + 21]['width'], array[i + 21]['height']);
                }
            }
            ctx.stroke()
        }
        opacity: 0

        NumberAnimation on opacity {
            id: anim
            to: 1
            running: false
            duration: 1000
        }

        Component.onCompleted: { if ( root.showAnimation == true ) anim.running = true; canvas.opacity = 1; }
    }
}
