import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

ApplicationWindow {

    id: root
    visible: true

    width: 900
    minimumWidth: 800
    //maximumWidth: assetsColumnLayout.implicitWidth

    //height: 300
    minimumHeight: 430
    maximumHeight: 800

    title: qsTr('FBF Publish')

    property int marginSize: 16
    signal droppedFiles(var files)

    onDroppedFiles: {
        console.log('on dropped files called')
        for (var i = 0; i < files.length; i++){
            console.log(files[i]);
        }
    }

    DropArea {
        width: root.width
        height: root.height

        onDropped: {
            console.log('user has dropped something!')
            if (drop.hasUrls){
                // Emit the custom signal
                root.droppedFiles(drop.urls)
                assetsListView.visible = true
            }
        }
    }

    Rectangle {

        id: mainLayout
        visible: true
        // Makes the layout fill its parent
        anchors.fill: parent

        Rectangle {

            id: header
            width: mainLayout.width
            height: 80

            Text {
                id: textFbfPublishText
                anchors.left: header.left
                anchors.top: header.top
                anchors.leftMargin: 16
                anchors.topMargin: 16
                text: '<b>' + 'FBF Publish' + '</b>'
                font.pointSize: 18
            }

            Text {
                id: versionText
                anchors.left: header.left
                anchors.top: textFbfPublishText.bottom
                anchors.leftMargin: 16
                text: 'v1.0.0'
                font.pointSize: 14
            }

            ComboBox {
                anchors.top: header.top
                anchors.right: header.right
                anchors.rightMargin: 16
                anchors.topMargin: 16
                model: ['Lighting', 'Compositing']
            }
        }

        ListView {

            id: assetsListView
            visible: false
            focus: true
            anchors.top: header.bottom
            anchors.bottom: finalRowLayout.top
            clip: true
            width: parent.width
            height: 300


            model: AssetModel {}
            delegate: ColumnLayout {

                width: root.width

                RowLayout {

                    ButtonGroup {
                        id: passesButtonGroup
                        exclusive: false
                        checkState: assetCheckBox.checkState
                    }

                    CheckBox {
                        id: assetCheckBox
                        checked: true
                        checkState: passesButtonGroup.checkState
                    }

                    Label {
                        text: name
                        font.pointSize: 14
                        font.bold: true
                    }
                }

                Repeater {
                    model: assetComponents
                    delegate: RowLayout {

                        Item {
                            width: marginSize
                        }

                        FBFCheckBox {
                            checked: true
                            ButtonGroup.group: passesButtonGroup
                        }

                        Label {
                            text: passName
                            font.italic: true
                        }

                        TextEdit {
                            Layout.fillWidth: true
                            text: path
                            readOnly: true
                            selectByMouse: true
                            selectionColor: 'green'

                        }

                        Label {
                            text: startFrame
                        }

                        Label {
                            text: endFrame
                        }

                        Item {
                            width: marginSize
                        }
                    }
                }

                Item {
                    height: marginSize
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        RowLayout {

            id: finalRowLayout
            anchors.bottom: mainLayout.bottom
            anchors.bottomMargin: marginSize / 2
            anchors.right: mainLayout.right
            anchors.rightMargin: 16

            FBFButton {
                text: 'Publish'
            }
        }
    }
}
