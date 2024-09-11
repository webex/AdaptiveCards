import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Label {
    id: inputLabel

    property bool required
 
    wrapMode: Text.Wrap
    width: parent.width
    color: cardConst.toggleButtonConstants.textColor
    font.pixelSize: cardConst.inputFieldConstants.labelPixelSize
    Accessible.ignored: true
    text:  textInputModel.isRequired ? AdaptiveCardUtils.escapeHtml(textInputModel.label) + " " + "<font color='" + cardConst.inputFieldConstants.errorMessageColor + "'>*</font>" : AdaptiveCardUtils.escapeHtml(textInputModel.label)
}
