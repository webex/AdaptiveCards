import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15


Frame{
    width: 250
    height: 800
    padding: 5
    background: Rectangle{
        color: 'lightblue'
        border.color: 'black'
        border.width: 2
        radius: 8
    }

    Component{
        id: cardDelegate
        Rectangle{
            color: cardListView.currentIndex === index ? 'yellow' : 'white'
            width: cardListView.width
            implicitHeight: txt.implicitHeight
            radius: 5
            border.width: 1
            border.color: 'black'

            Text {
                id: txt
                width: parent.width
                padding: 5
                text: qsTr("text")
                font.pixelSize: 15

                MouseArea{
                    anchors.fill: parent
                    onClicked: cardListView.currentIndex = index
                }
            }
        }
    }

    ListView{
        id: cardListView
        width: parent.width
        height: parent.height
        clip: true
        model: 100
        delegate: cardDelegate
    }
}

