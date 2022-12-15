import QtQuick 2.3
import "AdaptiveCardUtils.js" as AdaptiveCardUtils

Flow {
    id: flowActionId
    property int _spacing
    property string _layoutDirection
    property var actionButtonModel
    property var adaptiveCard
    
    width: parent.width
    spacing: _spacing
    layoutDirection: _layoutDirection === 'Qt.RightToLeft' ? Qt.RightToLeft : Qt.LeftToRight


     Repeater {
        model: actionButtonModel
        Rectangle {
            id: _buttonId
            height : _id.height
            width : _id.width
     
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
                    _adaptiveCard: flowActionId.adaptiveCard
                    _selectActionId: selectActionId
                    width: implicitWidth
                }
            }

     }
}
