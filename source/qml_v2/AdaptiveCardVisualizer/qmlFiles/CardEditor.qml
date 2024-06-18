import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root

    width: 400
    height: 600

    color: "black"

    signal renderButtonClicked(var cardJSON)
    property alias text: textArea.text

ScrollView {
        id: scrollView
            
        width: parent.width
        height: parent.height * 0.9

        ScrollBar.vertical.interactive:true;
        ScrollBar.vertical.visible: true
            
        TextArea {
            id: textArea
            
            implicitHeight: parent.height
                
            font.pixelSize: 12;
            color: "light gray"
            selectByMouse: true
                
            text: "cardModel.cardJson"
            placeholderText:"Enter card json";
        }

        clip: true
    }


    Button {
        id: renderButton
        height: parent.height * 0.1
        width: parent.width

        enabled: textArea.text.length > 0
            
        text: "Render"

        anchors.top: scrollView.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
            
        onClicked: {
            renderButtonClicked(root.text);
        }
    }
}
