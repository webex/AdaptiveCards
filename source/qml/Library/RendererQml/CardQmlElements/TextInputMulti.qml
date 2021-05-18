/*
Example Usage

TextInputMulti{
    id:multilineinputid
    height:multilineinputid.visible ? 100 : 0
    multifont.pixelSize:14
    maxLength:50
    font.pixelSize:14
    color:'#171B1F'
    bgrcolor:'#FFFFFF'
    placeholderText:"enter comment"
}
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ScrollView{
    id: scrollViewID

    property alias bgrcolor: backgroundRectangle.color
    property alias textfont: textAreaID.font
    property alias text: textAreaID.text
    property alias placeholderText: textAreaID.placeholderText
    property alias color: textAreaID.color
    //Custom Property required to obtain the max length set by user
    //QML int limit based on documentation
    property int maxLength: 2000000000
    
    width: 100
    height: textAreaID.visible ? 100 : 0
    ScrollBar.vertical.interactive: true
    
    TextArea{
        id: textAreaID
        
        wrapMode: Text.Wrap
        selectByMouse: true
        selectedTextColor: 'white'
        padding: 10
        font.pixelSize: 14
        
        onTextChanged: {
            remove(scrollViewID.maxLength,length)
        }
        
        background: Rectangle{
            id: backgroundRectangle
            
            radius: 5
            color: '#FFFFFF'
            border.color: textAreaID.activeFocus? 'black' : 'grey'
            border.width: 1
            layer.enabled: textAreaID.activeFocus ? true : false
            
            layer.effect: Glow{
                samples: 25
                color: 'skyblue'
            }
        }
    }
}
