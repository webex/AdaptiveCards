import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextEdit {
    id: "richTextBlock"    
    
    property var richTextBlockModel:  model.richTextBlockRole

    width: implicitWidth
    height: implicitHeight

    padding: 0
    clip: true
    
    visible: richTextBlockModel.isVisible
    text:  richTextBlockModel.text
    textFormat: Text.RichText

    wrapMode: richTextBlockModel.textWrap ? Text.Wrap : Text.NoWrap

    horizontalAlignment : richTextBlockModel.horizontalAlignment === 0 ? Text.AlignLeft :
                          richTextBlockModel.horizontalAlignment === 1 ? Text.AlignHCenter : Text.AlignRight  

    color: richTextBlockModel.color

    font.pixelSize: richTextBlockModel.fontPixelSize
    font.weight: richTextBlockModel.fontWeight === "extraLight" ? Font.ExtraLight :
				 richTextBlockModel.fontWeight === "bold" ? Font.Bold : Font.Normal
    font.family: richTextBlockModel.fontFamily
    font.italic: richTextBlockModel.fontStyle == "italic" ? true : false
    font.underline: richTextBlockModel.textUnderlineDecoration
    font.strikeout: richTextBlockModel.textStrikethroughDecoration
}
