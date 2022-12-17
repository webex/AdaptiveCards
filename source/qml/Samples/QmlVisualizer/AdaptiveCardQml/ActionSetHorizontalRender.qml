import QtQuick 2.3
import "AdaptiveCardUtils.js" as AdaptiveCardUtils

Flow {
    id: flowActionId
    property int _spacing
    property string _layoutDirection
    property var actionButtonModel
    property var adaptiveCard
    property var _toggleVisibilityTarget: null
    property var activeShowCard: null
    property var prevLoaderId: null
    property bool isCentreAlign: false
    onWidthChanged: handleCentreAligmentFunction()
    onImplicitWidthChanged: handleCentreAligmentFunction()
    onImplicitHeightChanged: handleCentreAligmentFunction()
    Component.onCompleted: { handleCentreAligmentFunction() }

    function handleCentreAligmentFunction() {
        if(isCentreAlign) {
            AdaptiveCardUtils.horizontalAlignActionSet(this, actionElements, rectangleElements)
        }
    }


    function setActiveShowCard( showcardLoaderElement, buttonElement ) {
        if(prevLoaderId !== null) {
            prevLoaderId.visible = false
        
        }
        if(activeShowCard !== null) {
            activeShowCard.showCard = !activeShowCard.showCard
        }
        if(buttonElement == activeShowCard) {
            activeShowCard = null
            prevLoaderId = null 
            return
        }
        buttonElement.showCard = !buttonElement.showCard
        showcardLoaderElement.visible= !showcardLoaderElement.visible
        activeShowCard = buttonElement

        prevLoaderId = showcardLoaderElement
    }

    width: parent.width
    spacing: _spacing
    layoutDirection: _layoutDirection === 'Qt.RightToLeft' ? Qt.RightToLeft : Qt.LeftToRight
    property var rectangleElements: []
    property var actionElements: []

     Repeater {
        id: defaultRepeaterId
        model: actionButtonModel

        Rectangle {
            
            height : adaptiveActionRenderId.height
            width : adaptiveActionRenderId.width
            color: 'transparent'
            Component.onCompleted: { rectangleElements.push(this) }
            AdaptiveActionRender {
                    
                    id: adaptiveActionRenderId
                    _buttonConfigType: buttonConfigType
                    _isIconLeftOfTitle: isIconLeftOfTitle
                    _escapedTitle: escapedTitle
                    _isShowCardButton: isShowCardButton
                    _isActionSubmit: isActionSubmit
                    _isActionOpenUrl: isActionOpenUrl
                    _isActionToggleVisibility: isActionToggleVisibility
                    _hasIconUrl: hasIconUrl
                    _imgSource: imgSource
                    _toggleVisibilityTarget: isActionToggleVisibility ? flowActionId._toggleVisibilityTarget[index] : null
                    _paramStr: paramStr
                    _is1_3Enabled: is1_3Enabled
                    _adaptiveCard: flowActionId.adaptiveCard
                    _selectActionId: selectActionId
                    width: flowActionId.width > implicitWidth ? implicitWidth : flowActionId.width
                    _loaderId: loaderId

                    Component.onCompleted: { adaptiveActionRenderId.handleShowCardToggleVisibility.connect(setActiveShowCard)
                        actionElements.push(this)
                    }
                }
            }

     }
}
