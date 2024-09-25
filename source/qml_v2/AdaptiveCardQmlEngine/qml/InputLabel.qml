import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Label {
    id: inputLabel

    property bool required
    property string label

    wrapMode: Text.Wrap
    width: parent.width
    color: CardConstants.toggleButtonConstants.textColor
    font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
    Accessible.ignored: true
    text: required ? AdaptiveCardUtils.escapeHtml(label) + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : AdaptiveCardUtils.escapeHtml(label)
}