import QtQuick 2.3

    Repeater {
        id: defaultRepeaterId

        property var _rectangleElements
        property var _actionElements
        property var toggleVisibilityTarget
        property var _setActiveShowCard
        property var _adaptivecard
        property var _width
        property var parentElement

        Rectangle {
            height: adaptiveActionRenderId.height
            width: adaptiveActionRenderId.width
            color: 'transparent'
            Component.onCompleted: {
                _rectangleElements.push(this);
            }

            AdaptiveActionRender {
                id: adaptiveActionRenderId

                objectName: _objectName
                _buttonConfigType: buttonConfigType
                _isIconLeftOfTitle: isIconLeftOfTitle
                _escapedTitle: escapedTitle
                _isShowCardButton: isShowCardButton
                _isActionSubmit: isActionSubmit
                _isActionOpenUrl: isActionOpenUrl
                _isActionToggleVisibility: isActionToggleVisibility
                _hasIconUrl: hasIconUrl
                _imgSource: imgSource
                _toggleVisibilityTarget: isActionToggleVisibility ? toggleVisibilityTarget[index] : null
                _paramStr: paramStr
                _is1_3Enabled: is1_3Enabled
                _adaptiveCard: _adaptivecard
                _selectActionId: selectActionId
                width: parentElement.width > implicitWidth ? implicitWidth : parentElement.width
                _loaderId: loaderId
                Component.onCompleted: {
                    adaptiveActionRenderId.handleShowCardToggleVisibility.connect(_setActiveShowCard);
                    _actionElements.push(this);
                }
            }
        }
    }