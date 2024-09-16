import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Rectangle {
    id: errorMessage

    property string errorMessage

    width: parent.width
    height: errorMessageLabel.implicitHeight
    color: 'transparent'

    Button {
        id: errorIcon

        width: cardConst.inputFieldConstants.errorIconWidth
        anchors.left: parent.left
        anchors.leftMargin: cardConst.inputFieldConstants.errorIconLeftMargin
        anchors.topMargin: cardConst.inputFieldConstants.errorIconTopMargin
        horizontalPadding: 0
        verticalPadding: 0
        icon.width: cardConst.inputFieldConstants.errorIconWidth
        icon.height: cardConst.inputFieldConstants.errorIconHeight
        icon.color: cardConst.toggleButtonConstants.errorMessageColor
        anchors.top: parent.top
        icon.source: cardConst.errorIcon
        enabled: false

        background: Rectangle {
            color: 'transparent'
        }

    }

    Label {
        id: errorMessageLabel

        wrapMode: Text.Wrap
        font.pixelSize: cardConst.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        color: cardConst.toggleButtonConstants.errorMessageColor
        anchors.left: errorIcon.right
        anchors.leftMargin: cardConst.inputFieldConstants.errorIconLeftMargin
        anchors.right: parent.right
        text: textInputModel.errorMessage//_errorMessage
    }

}
