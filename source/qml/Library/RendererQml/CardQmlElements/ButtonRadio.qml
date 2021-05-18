/*
Example Usage

ButtonRadio{
    value:checked ? "1" : ""
    id:sample_id
    text:"Blue"
    font.pixelSize:14
    textcolor:'#171B1F'
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

RadioButton{
    id: radio_id
    
    property alias textcolor: contentItem_text.color
    property alias wrapMode: contentItem_text.wrapMode
    property alias elide: contentItem_text.elide
    property string value

    font.pixelSize: 14

    indicator: Rectangle{
        width: parent.font.pixelSize
        height: parent.font.pixelSize
        y: parent.topPadding + (parent.availableHeight - height) / 2
        radius: height/2
        border.color: radio_id.checked ? '#0075FF' : '767676'
        color: radio_id.checked ? '#0075FF' : '#ffffff'
        
        Rectangle{
            width: parent.width/2
            height: parent.height/2
            x: width/2
            y: height/2
            radius: height/2
            color: radio_id.checked ? '#ffffff' : 'defaultPalette.backgroundColor'
            visible: radio_id.checked
        }
    }

    contentItem:Text{
        id: contentItem_text
        
        text: parent.text
        font: parent.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: parent.indicator.width + parent.spacing
        color:'#171B1F'
        elide: Text.ElideRight
    }
}
