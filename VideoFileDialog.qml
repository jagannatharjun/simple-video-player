import QtQuick
import QtQuick.Dialogs

FileDialog {
    signal openFileName(string filename);

    fileMode: FileDialog.OpenFile
    nameFilters: ["Video files (*.mkv *.avi *.mp4)"]

    onAccepted: openFileName(selectedFile)
}
