import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Label {
    id: inputLabel

    property bool _required
    property string _label

    wrapMode: Text.Wrap
    width: parent.width
    color: CardConstants.toggleButtonConstants.textColor
    font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
    Accessible.ignored: true
    text: _isRequired ? AdaptiveCardUtils.escapeHtml(_label) + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : AdaptiveCardUtils.escapeHtml(_label)
}
