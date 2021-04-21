import QtQuick 2.15

Text{

    /*
    QtObject{
        id:internal
        elide:Text.ElideRight
    }*/
    clip:true
    textFormat:Text.MarkdownText
    text:"This is some text"
    horizontalAlignment:Qt.AlignLeft
    color:'#171B1F'
    font.pixelSize:21
    font.weight:Font.Normal
    font.family:"Segoe UI"
}
