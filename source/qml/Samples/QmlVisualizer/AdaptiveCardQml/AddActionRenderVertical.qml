import QtQuick 2.3
import "AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: colActionId
    property int _spacing
    property var actionButtonModel
    property var adaptiveCard
    
    width: parent.width
    spacing: _spacing

     Repeater {
        id: defaultRepeaterId
        model: actionButtonModel
        Rectangle {
            
            height : adaptiveActionRenderId.height
            width : adaptiveActionRenderId.width
            color: 'transparent'
     
            AdaptiveActionRender {
                    id: adaptiveActionRenderId
                    _buttonConfigType: buttonConfigType
                    _isIconLeftOfTitle: isIconLeftOfTitle
                    _escapedTitle: escapedTitle
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
                    _adaptiveCard: colActionId.adaptiveCard
                    _selectActionId: selectActionId
                    width: implicitWidth
                    _loaderId: loaderId
                }
            }

     }
}
