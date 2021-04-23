import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

ScrollView{
    property string bgrcolor
	property font multifont
	property alias text: textAreaID.text
	property alias placeholderText: textAreaID.placeholderText
	property alias color: textAreaID.color
	property alias length: textAreaID.length
	//Gaining access to function TextArea's remove() method
	property var remove: textAreaID.remove
	
	id:scrollViewID
    width:100
	height:textAreaID.visible ? 100 : 0
    ScrollBar.vertical.interactive:true
    TextArea{
        id:textAreaID
        wrapMode:Text.Wrap
        selectByMouse:true
        selectedTextColor:'white'
        padding:10
        font.pixelSize:scrollViewID.multifont.pixelSize
		background:Rectangle{
			id: backgroundRectangle
            radius:5
            color: scrollViewID.bgrcolor
			border.color:textAreaID.activeFocus? 'black' : 'grey'
            border.width:1
            layer.enabled:textAreaID.activeFocus ? true : false
            layer.effect:Glow{
                samples:25
                color:'skyblue'
            }
        }
    }
}
