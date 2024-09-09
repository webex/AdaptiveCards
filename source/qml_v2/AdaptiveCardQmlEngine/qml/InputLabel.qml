import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Label {
    id: inputLabel

    property bool _required
    property string _label

    wrapMode: Text.Wrap
    width: parent.width
    color:  "black"//CardConstants.toggleButtonConstants.textColor
    font.pixelSize: 14 //CardConstants.inputFieldConstants.labelPixelSize
    Accessible.ignored: true
    text:""// _isRequired ? AdaptiveCardUtils.escapeHtml(_label) + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : AdaptiveCardUtils.escapeHtml(_label)
}
