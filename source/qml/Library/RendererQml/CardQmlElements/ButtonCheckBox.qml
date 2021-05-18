/*
Momentum Icon Used: 
Name-Check , Color-White, Size-12

Example Usage

In Input.ChoiceSet:
ButtonCheckBox{
    value:checked ? "1" : ""
    id:sample1_id
    text:"Red"
    font.pixelSize:14
    checked:true
    textcolor:'#171B1F'
}

In Input.Toggle:
ButtonCheckBox{
    valueOn:"true"
    valueOff:"false"
    value:checked ? valueOn : valueOff
    id:sample2_id
    text:"I accept the terms and agreements"
    font.pixelSize:14
    checked:true
    textcolor:'#171B1F'
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15

CheckBox{
    id: checkbox_ID

    property alias textcolor: text_contentItem.color
    property alias wrapMode: text_contentItem.wrapMode
    property string value: checked ? valueOn : valueOff

    //Cannot be set as read only as Input Toggle can change these properties
    property string valueOn: "true"
    property string valueOff: "false"
    
    width: 100
    text: ""
    font.pixelSize: 14
    
    indicator: Rectangle{
        width: parent.font.pixelSize
        height: parent.font.pixelSize
        y: parent.topPadding + (parent.availableHeight - height) / 2
        radius: 3
        border.color: checkbox_ID.checked ? '#0075FF' : '767676'
        color: checkbox_ID.checked ? '#0075FF' : '#ffffff'
        
        Image{
            anchors.centerIn: parent
            width: parent.width - 3
            height: parent.height - 3
            visible: checkbox_ID.checked
            source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+YWxlcnRzLWFuZC1ub3RpZmljYXRpb25zL2NoZWNrXzEyX3c8L3RpdGxlPjxwYXRoIGQ9Ik00LjUwMjQgOS41Yy0uMTMzIDAtLjI2LS4wNTMtLjM1NC0uMTQ3bC0zLjAwMi0zLjAwN2MtLjE5NS0uMTk2LS4xOTUtLjUxMi4wMDEtLjcwNy4xOTQtLjE5NS41MTEtLjE5Ni43MDcuMDAxbDIuNjQ4IDIuNjUyIDUuNjQyLTUuNjQ2Yy4xOTUtLjE5NS41MTEtLjE5NS43MDcgMCAuMTk1LjE5NS4xOTUuNTEyIDAgLjcwOGwtNS45OTUgNmMtLjA5NC4wOTMtLjIyMS4xNDYtLjM1NC4xNDYiIGZpbGw9IiNGRkYiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg=="
        }
    }

    contentItem: Text{
        id: text_contentItem
        
        text: parent.text
        font: parent.font
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: parent.indicator.width + parent.spacing
        color: '#171B1F'
        elide: Text.ElideRight
    }
}
