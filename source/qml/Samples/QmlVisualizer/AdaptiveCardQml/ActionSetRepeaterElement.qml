import QtQuick 2.3

Repeater {
    id: defaultRepeaterId

    property var _rectangleElements
    property var _actionElements
    property var _actionButtonModel
    property var _setActiveShowCard
    property var _adaptivecard
    property var _width
    property var parentElement

    Rectangle {
        property var actionModel: _actionButtonModel[index]
        height: adaptiveActionRenderId.height
        width: adaptiveActionRenderId.width
        color: 'transparent'
        Component.onCompleted: {
            _rectangleElements.push(this);
        }

        AdaptiveActionRender {
            id: adaptiveActionRenderId

            objectName: actionModel._objectName
            _buttonConfigType: actionModel.buttonConfigType
            _isIconLeftOfTitle: actionModel.isIconLeftOfTitle
            _escapedTitle: actionModel.escapedTitle
            _isShowCardButton: actionModel.isShowCardButton
            _isActionSubmit: actionModel.isActionSubmit
            _isActionOpenUrl: actionModel.isActionOpenUrl
            _isActionToggleVisibility: actionModel.isActionToggleVisibility
            _hasIconUrl: actionModel.hasIconUrl
            _imgSource: actionModel.imgSource
             _toggleVisibilityTarget: actionModel.isActionToggleVisibility ? actionModel.toggleVisibilityTarget : null
            _paramStr: actionModel.isActionSubmit ? actionModel.paramStr : ""
            _is1_3Enabled: actionModel.is1_3Enabled
            _adaptiveCard: defaultRepeaterId._adaptivecard
            _selectActionId: actionModel.selectActionId
            width: parentElement.width > implicitWidth ? implicitWidth : parentElement.width
            _loaderId: actionModel.loaderId
            Component.onCompleted: {
                adaptiveActionRenderId.handleShowCardToggleVisibility.connect(_setActiveShowCard);
                _actionElements.push(this);
            }
        }

    }

}
