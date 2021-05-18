/*
Example Usage

TextBlock{
    id:sample
    width:200
    text:"What time do you want to meet?"
    horizontalAlignment:Qt.AlignLeft
    color:'#171B1F'
    font.pixelSize:14
    font.weight:Font.Normal
    font.family:"Segoe UI"
}
*/
import QtQuick 2.15

Text{
    //LIMITATION: Elide and maximumLineCount property do not work for textFormat: Text.MarkdownText
    clip: true
    textFormat: Text.MarkdownText
    elide: Text.ElideRight
    horizontalAlignment: Qt.AlignLeft
}
