/*
Example Usage

TextInputSingle{
    maximumLength:500
    id:defaultinputid
    width:200
    font.pixelSize:14
    color:'#171B1F'
    bgrcolor:'#FFFFFF'
    placeholderText:"enter comment"
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField{
    id: textfieldID

    property alias bgrcolor: backgroundRectangle.color

    width: 100
    selectByMouse: true
    selectedTextColor: 'white'
    
    background: Rectangle
    {
        id: backgroundRectangle
        
        radius: 5
        color: '#FFFFFF' 
        border.color: textfieldID.activeFocus? 'black' : 'grey'
        border.width: 1
        layer.enabled: textfieldID.activeFocus ? true : false
        
        layer.effect: Glow
        {
            samples: 25
            color: 'skyblue'
        }
    }
}
