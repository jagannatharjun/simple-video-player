import QtQuick
import QtMultimedia

Item {

    property alias playbackState: video.playbackState

    readonly property bool isPlaying: playbackState === MediaPlayer.PlayingState
    readonly property bool isPaused: playbackState === MediaPlayer.PausedState
    readonly property bool isStopped: playbackState === MediaPlayer.StoppedState

    function play() { video.play() }
    function pause() { video.pause() }
    function stop() { video.stop() }

    Video {
        id: video
        source: "file:///D:/Youtube-Videos/1 - Why Alien Life Would be our Doom - The Great Filter.mp4"

        anchors.fill: parent

        transform: [
            Scale {
                id: zoomScale
            },
            Translate {
                id: zoomTranslate
            }
        ]
        Component.onCompleted: video.play()

        function zoom(x, y, zoomin) {
            zoomScale.origin.x = x
            zoomScale.origin.y = y

            var factor = zoomin ? .1 : -.1
            zoomScale.xScale += factor
            zoomScale.yScale += factor
        }

        function move(x, y) {
            zoomTranslate.x += x
            zoomTranslate.y += y
        }
    }

    MouseArea {
        id: mouse

        property var _lastPressed: null

        anchors.fill: parent

        onWheel: function (wheel) {
            if (wheel.modifiers != Qt.ControlModifier)
                return

            wheel.accepted = true
            video.zoom(wheel.x, wheel.y, wheel.angleDelta.y > 0)
        }

        onPositionChanged: function (mouse) {
            if (mouse.buttons != Qt.LeftButton)
                return

            if (_lastPressed != null) {
                video.move(mouse.x - _lastPressed.x, mouse.y - _lastPressed.y)
            }

            _lastPressed = Qt.point(mouse.x, mouse.y)
            mouse.accepted = true
        }

        onReleased: {
            _lastPressed = null
        }
    }
}
