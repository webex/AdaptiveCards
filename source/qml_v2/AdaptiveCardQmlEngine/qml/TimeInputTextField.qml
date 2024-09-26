import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextField {
    id: timeInputTextField

    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants

    font.family: "Segoe UI"
    font.pixelSize: inputFieldConstants.pixelSize
    selectByMouse: true
    selectedTextColor: 'white'
    width: parent.width
    placeholderTextColor: inputFieldConstants.placeHolderColor
    placeholderText: ''
    color: inputFieldConstants.textColor
    leftPadding: inputFieldConstants.textHorizontalPadding
    rightPadding: inputFieldConstants.textHorizontalPadding
    topPadding: inputFieldConstants.textVerticalPadding
    bottomPadding: inputFieldConstants.textVerticalPadding
    Accessible.name: ""
    Accessible.role: Accessible.EditableText
    onHoveredChanged: timeInputElement.colorChange(false)
    activeFocusOnTab: true

    background: Rectangle {
        color: 'transparent'
    }
}
