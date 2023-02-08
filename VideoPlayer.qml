import QtQuick
import QtMultimedia

Item {

    // forward video properties
    property alias playbackState: video.playbackState
    property alias duration: video.duration
    property alias position: video.position
    property alias source: video.source
    property alias error: video.error
    property alias errorString: video.errorString

    readonly property bool isPlaying: playbackState === MediaPlayer.PlayingState
    readonly property bool isPaused: playbackState === MediaPlayer.PausedState
    readonly property bool isStopped: playbackState === MediaPlayer.StoppedState

    function play() { video.play() }
    function pause() { video.pause() }
    function stop() { video.stop() }

    function playSource(filename) {
        video.source = filename
        video.play()
    }


    // since this component has transformations we don't make it
    // root component since that will cause interference with
    // all children and our own MouseArea won't work then
    Video {
        id: video

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

        // mouse position on last onPositionChanged handling, used to
        // calculate move cords in between of mouse position change
        property var _lastPressed: null

        anchors.fill: parent

        onWheel: function (wheel) {
            if (wheel.modifiers !== Qt.ControlModifier)
                return

            video.zoom(wheel.x, wheel.y, wheel.angleDelta.y > 0)
            wheel.accepted = true
        }

        onPositionChanged: function (mouse) {
            if (mouse.buttons !== Qt.LeftButton)
                return

            if (_lastPressed !== null) {
                video.move(mouse.x - _lastPressed.x, mouse.y - _lastPressed.y)
            }

            _lastPressed = Qt.point(mouse.x, mouse.y)
            mouse.accepted = true
        }

        onReleased: {
            // reset _lastPressed
            _lastPressed = null
        }
    }

    PinchHandler {
        // previous active scale during press
        property var _previousScale: null

        target: null

        onRotationChanged: video.rotation = rotation
        onTranslationChanged: video.move(translation.x, translation.y)
        onActiveScaleChanged: {
            if (_previousScale != null)
                video.zoom(centroid.position.x, centroid.position.y, activeScale - _previousScale)

            _previousScale = activeScale
        }

        onActiveChanged: {
            if (active)
                _previousScale = 1
            else
                _previousScale = null
        }
    }
}
