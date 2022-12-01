import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Label {
    id: errorMessage

    property string _errorMessage

    wrapMode: Text.Wrap
    width: parent.width
    font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
    Accessible.ignored: true
    color: CardConstants.toggleButtonConstants.errorMessageColor
    text: _errorMessage
}
