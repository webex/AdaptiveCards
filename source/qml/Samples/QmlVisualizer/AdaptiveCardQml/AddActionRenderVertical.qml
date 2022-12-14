import QtQuick 2.3
import "AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    property int _spacing
    property var actionButtonModel
    
    width: parent.width
    spacing: _spacing

    Repeater {
        model: actionButtonModel

    Loader {
        height: item ? item.height : 0
        width: (parent.width > implicitWidth) ? implicitWidth : parent.width
        active: !_isactionAlignmentCenter

            sourceComponent: 
                AdaptiveActionRender {
                    _buttonConfigType: buttonConfigType
                    _isIconLeftOfTitle: isIconLeftOfTitle
                    _escapedTitle: escapedTitle
                    id: _id
                    _isShowCardButton: isShowCardButton
                    _iconSource: iconSource
                    _isActionSubmit: isActionSubmit
                    _isActionOpenUrl: isActionOpenUrl
                    _isActionToggleVisibility: isActionToggleVisibility
                    _hasIconUrl: hasIconUrl
                    _imgSource: imgSource
                    _toggleVisibilityTarget: toggleVisibilityTarget
                    _paramStr: paramStr
                    _is1_3Enabled: is1_3Enabled
                    _adaptiveCard: adaptiveCard
                    _selectActionId: selectActionId
                }
        }
    }
}
