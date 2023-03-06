import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: errorMessage

    property string _errorMessage

    width: parent.width
    height: errorMessageLabel.implicitHeight
    color: 'transparent'

    Button {
        id: errorIcon

        width: CardConstants.inputFieldConstants.errorIconWidth
        anchors.left: parent.left
        anchors.leftMargin: CardConstants.inputFieldConstants.errorIconLeftMargin
        anchors.topMargin: CardConstants.inputFieldConstants.errorIconTopMargin
        horizontalPadding: 0
        verticalPadding: 0
        icon.width: CardConstants.inputFieldConstants.errorIconWidth
        icon.height: CardConstants.inputFieldConstants.errorIconHeight
        icon.color: CardConstants.toggleButtonConstants.errorMessageColor
        anchors.top: parent.top
        icon.source: CardConstants.errorIcon
        enabled: false

        background: Rectangle {
            color: 'transparent'
        }

    }

    Label {
        id: errorMessageLabel

        wrapMode: Text.Wrap
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        color: CardConstants.toggleButtonConstants.errorMessageColor
        anchors.left: errorIcon.right
        anchors.leftMargin: CardConstants.inputFieldConstants.errorIconLeftMargin
        anchors.right: parent.right
        text: _errorMessage
    }

}
