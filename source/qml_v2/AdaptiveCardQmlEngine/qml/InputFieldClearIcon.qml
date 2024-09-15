import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Button {
    id: inputFieldClearIcon

    width: cardConst.inputFieldConstants.clearIconSize
    horizontalPadding: 0
    verticalPadding: 0
    icon.width: cardConst.inputFieldConstants.clearIconSize
    icon.height: cardConst.inputFieldConstants.clearIconSize
    icon.color: cardConst.inputFieldConstants.clearIconColorNormal
    icon.source: cardConst.clearIconImage
    Accessible.name: qsTr("Clear Input")
    Accessible.role: Accessible.Button

    background: Rectangle {
        color: 'transparent'
        radius: cardConst.inputFieldConstants.borderRadius

        WCustomFocusItem {
            isRectangle: true
            visible: inputFieldClearIcon.activeFocus
            designatedParent: parent
        }
    }
}
