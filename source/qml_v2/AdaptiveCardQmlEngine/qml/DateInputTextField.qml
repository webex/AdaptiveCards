import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextField {
    id: dateInputTextField
    
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants
    
    width: parent.width
    height: parent.height
    font.family: 'Segoe UI'
    font.pixelSize: inputFieldConstants.pixelSize
    selectByMouse: true
    selectedTextColor: 'white'
    color: inputFieldConstants.textColor
    leftPadding: inputFieldConstants.textHorizontalPadding
    rightPadding: inputFieldConstants.textHorizontalPadding
    topPadding: inputFieldConstants.textVerticalPadding
    bottomPadding: inputFieldConstants.textVerticalPadding
    Accessible.name: ''
    Accessible.role: Accessible.EditableText
    
    background: Rectangle {
        color: 'transparent'
    }
}
