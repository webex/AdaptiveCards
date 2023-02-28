import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import AdaptiveCards 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Button {
    id: inuputFieldClearIcon

    width: CardConstants.inputFieldConstants.clearIconSize
    anchors.right: parent.right
    anchors.margins: CardConstants.inputFieldConstants.clearIconHorizontalPadding
    horizontalPadding: 0
    verticalPadding: 0
    icon.width: CardConstants.inputFieldConstants.clearIconSize
    icon.height: CardConstants.inputFieldConstants.clearIconSize
    icon.color: CardConstants.inputFieldConstants.clearIconColorNormal
    anchors.verticalCenter: parent.verticalCenter
    icon.source: CardConstants.clearIconImage

    background: Rectangle {
        color: 'transparent'
        radius: CardConstants.inputFieldConstants.borderRadius

        WCustomFocusItem {
            isRectangle: true
            visible: _inputtextTextFieldClearIcon.activeFocus
            designatedParent: parent
        }

    }

}
