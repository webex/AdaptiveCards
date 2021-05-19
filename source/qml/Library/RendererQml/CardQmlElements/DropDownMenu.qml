/*
Momentum Icon Used: 
Name- arrow-up, Color-Black, Size-12

Example Usage:

DropDownMenu{
    id:mycolor
    width:200
    textcolor:'#171B1F'
    //model refers to the model of the ComboBox 
    model:[{ value: '1', text: 'Red'},
        { value: '2', text: 'Green'},
        { value: '3', text: 'Blue'},
    ]
    bgrcolor:'#FFFFFF'
    currentIndex:1
    displayText:currentText
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ComboBox{
    id: comboBox_id
    
    property alias textcolor: contentItem_text.color
    property alias bgrcolor: bgrRectangle.color

    textRole: 'text'
    valueRole: 'value'
    width: 100
    
    indicator: Item{
        id: icon_area
        width: dropdown_icon.implicitWidth
        height: dropdown_icon.implicitHeight
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 5
                
        Image{
        id: dropdown_icon
        anchors.fill:parent
        source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTIiIHZpZXdCb3g9IjAgMCAxMiAxMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+bmF2aWdhdGlvbi9hcnJvdy1kb3duXzEyPC90aXRsZT48cGF0aCBkPSJNMS4wMDA0MSAzLjQ5OTc0ODc2NGMwLS4xMzcuMDU2LS4yNzMuMTY1LS4zNzIuMjA2LS4xODUwMDAwMDAxLjUyMi0uMTY4MDAwMDAwMS43MDcuMDM3bDQuMTI4IDQuNTg2OTk5OTk2IDQuMTI4LTQuNTg2OTk5OTk2Yy4xODUtLjIwNTAwMDAwMDEuNTAxLS4yMjIwMDAwMDAxLjcwNy0uMDM3LjIwNC4xODUuMjIxLjUwMS4wMzcuNzA2bC00LjUgNC45OTk5OTk5OTZjLS4wOTYuMTA2LS4yMy4xNjYtLjM3Mi4xNjYtLjE0MiAwLS4yNzYtLjA2LS4zNzItLjE2NmwtNC41LTQuOTk5OTk5OTk2Yy0uMDg2LS4wOTUtLjEyOC0uMjE1LS4xMjgtLjMzNCIgZmlsbD0iIzAwMCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
        fillMode: Image.PreserveAspectFit
        mipmap: true
        }
        
        ColorOverlay{
            anchors.fill: dropdown_icon
            source: dropdown_icon
            color: comboBox_id.textcolor
        }
    }

    background: Rectangle{
        id: bgrRectangle
        
        radius: 5
        color: '#FFFFFF'
        border.color: 'grey'
        border.width: 1
    }

    displayText: currentText
    
    delegate: ItemDelegate{
        width: parent.width
        
        background: Rectangle{
            color: hovered? 'lightgrey' : comboBox_id.bgrcolor
            border.color: 'grey'
            border.width: 1
        }

        contentItem: Text{
            id: delegateItem_text
            
            text: modelData.text
            font: comboBox_id.font
            verticalAlignment: Text.AlignVCenter
            color: comboBox_id.textcolor
            elide: Text.ElideRight
        }
    }

    contentItem: Text{
        id: contentItem_text
        
        text: parent.displayText
        font: parent.font
        verticalAlignment: Text.AlignVCenter
        padding: 12
        elide: Text.ElideRight
        color: '#171B1F'
    }
}