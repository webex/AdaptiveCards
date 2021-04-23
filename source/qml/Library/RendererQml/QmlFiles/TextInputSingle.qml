import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

TextField{
	property string bgrcolor

    id:textfieldID
    width:100
	selectByMouse:true
    selectedTextColor:'white'
    background:Rectangle
    {
        radius:5
        color: textfieldID.bgrcolor
        border.color: textfieldID.activeFocus? 'black' : 'grey'
        border.width:1
        layer.enabled: textfieldID.activeFocus ? true : false
        layer.effect:Glow
        {
            samples:25
            color:'skyblue'
        }
    }
}
