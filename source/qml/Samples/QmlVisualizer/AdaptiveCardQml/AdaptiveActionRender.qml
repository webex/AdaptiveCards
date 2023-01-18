// Button Ends Here

import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Button {
    // background rectangle ends here
    // Content Item Ends Here

    id: actionButton

    property string _buttonConfigType
    property bool _isIconLeftOfTitle
    property string _escapedTitle
    property bool _isShowCardButton
    property var _adaptiveCard
    property bool _is1_3Enabled
    property var _paramStr
    property var _toggleVisibilityTarget: null
    property bool _isActionSubmit: false
    property bool _isActionOpenUrl
    property bool _isActionToggleVisibility
    property string _selectActionId: ""
    property var _loaderId
    property bool showCard: false
    property bool _hasIconUrl
    property var _imgSource
    property string _iconSource: CardConstants.showCardArrowDownImage
    property string _iconSourceUp: CardConstants.showCardArrowUpImage
    property var _getActionToggleVisibilityClickFunc: ""
    property int _textSpacing: getTextSpacing()
    property var _onReleased: ""
    property var _buttonColors: getButtonConfig()
    property bool isButtonDisabled: false

    signal handleShowCardToggleVisibility(var showcardLoaderElement, var currButtonElemID)

    function handleMouseAreaClick() {
        if (_isActionToggleVisibility && _selectActionId === 'Action.ToggleVisibility') {
            AdaptiveCardUtils.handleToggleVisibilityAction((_toggleVisibilityTarget));
            return ;
        } else if (_isActionSubmit && _selectActionId === 'Action.Submit') {
            AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, _is1_3Enabled);
            return ;
        } else if (_isActionOpenUrl) {
            _adaptiveCard.buttonClicked('', 'Action.OpenUrl', _selectActionId);
            return ;
        } else if (_isShowCardButton) {
            handleShowCardToggleVisibility(_loaderId, this);
        }
    }

    function getButtonConfig() {
        if (_buttonConfigType === 'positiveColorConfig')
            return CardConstants.positiveButtonColors;
        else if (_buttonConfigType === 'destructiveColorConfig')
            return CardConstants.destructiveButtonColors;
        else
            return CardConstants.primaryButtonColors;
    }

    function getTextSpacing() {
        if (_hasIconUrl)
            return CardConstants.actionButtonConstants.imageSize + CardConstants.actionButtonConstants.iconTextSpacing;

        if (_isShowCardButton)
            return CardConstants.actionButtonConstants.iconWidth + CardConstants.actionButtonConstants.iconTextSpacing;

        return 2 * CardConstants.actionButtonConstants.horizotalPadding - 2;
    }

    onReleased: handleMouseAreaClick()
    horizontalPadding: CardConstants.actionButtonConstants.horizotalPadding
    verticalPadding: CardConstants.actionButtonConstants.verticalPadding
    height: CardConstants.actionButtonConstants.buttonHeight
    Keys.onPressed: {
        if (event.key === Qt.Key_Return) {
            down = true;
            event.accepted = true;
        }
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Return) {
            down = false;
            actionButton.onReleased();
            event.accepted = true;
        }
    }
    enabled: !isButtonDisabled
    Accessible.name: _isIconLeftOfTitle == true ? contentRowLayout.contentItemContentText : contentColLayout.contentItemContentText

    Connections {
        id: buttonConnection

        function onEnableAdaptiveCardSubmitButton(cardIndex) {
            if (_isActionSubmit && actionButton.isButtonDisabled)
                actionButton.isButtonDisabled = false;

        }

        target: _aModel
    }

    Component {
        id: imageComponent

        Image {
            id: contentItemColImg

            visible: _hasIconUrl
            cache: false
            height: CardConstants.actionButtonConstants.imageSize
            width: CardConstants.actionButtonConstants.imageSize
            fillMode: Image.PreserveAspectFit
            source: actionButton._imgSource
        }

    }

    Component {
        id: showcardComponent

        Button {
            id: contentItemRowContentShowCard

            visible: _isShowCardButton
            width: contentRowLayout.fontPixelSizeAlias
            height: contentRowLayout.fontPixelSizeAlias
            anchors.margins: 2
            horizontalPadding: 0
            verticalPadding: 0
            icon.width: 12
            icon.height: 12
            focusPolicy: Qt.NoFocus
            icon.color: contentRowLayout.colorAlias
            icon.source: !showCard ? _iconSource : _iconSourceUp
            onReleased: actionButton.onReleased()

            background: Rectangle {
                anchors.fill: parent
                color: 'transparent'
            }

        }

    }

    background: Rectangle {
        id: actionButtonBg

        function setBorderColorForBackground() {
            if (_isActionSubmit == true)
                return (isButtonDisabled ? _buttonColors.buttonColorDisabled : _buttonColors.borderColorNormal);
            else
                return _buttonColors.borderColorNormal;
        }

        function setColorForBackground() {
            if (_isShowCardButton == true) {
                if (actionButton.showCard || actionButton.down) {
                    return _buttonColors.buttonColorPressed;
                } else {
                    if (actionButton.hovered)
                        return _buttonColors.buttonColorHovered;
                    else
                        return _buttonColors.buttonColorNormal;
                }
            } else if (_isActionSubmit == true) {
                if (actionButton.isButtonDisabled) {
                    _buttonColors.buttonColorDisabled;
                } else {
                    if (actionButton.down) {
                        return _buttonColors.buttonColorPressed;
                    } else {
                        if (actionButton.hovered)
                            return _buttonColors.buttonColorHovered;
                        else
                            return _buttonColors.buttonColorNormal;
                    }
                }
            } else {
                if (actionButton.down) {
                    return _buttonColors.buttonColorPressed;
                } else {
                    if (actionButton.hovered)
                        return _buttonColors.buttonColorHovered;
                    else
                        return _buttonColors.buttonColorNormal;
                }
            }
        }

        anchors.fill: parent
        radius: CardConstants.actionButtonConstants.buttonRadius
        border.color: setBorderColorForBackground()
        color: setColorForBackground()
    }

    contentItem: Item {
        height: parent.height
        implicitWidth: _isIconLeftOfTitle == true ? contentItemRow.implicitWidth : contentItemCol.implicitWidth
        Accessible.name: _isIconLeftOfTitle == true ? contentRowLayout.contentItemContentText : contentColLayout.contentItemContentText

        Row {
            id: contentItemRow

            spacing: CardConstants.actionButtonConstants.iconTextSpacing
            padding: 0
            height: parent.height
            visible: _isIconLeftOfTitle == true

            Loader {
                active: _hasIconUrl
                sourceComponent: imageComponent
                anchors.verticalCenter: parent.verticalCenter
            }

            ActionsContentLayout {
                id: contentRowLayout
            }

            Loader {
                active: _isShowCardButton
                anchors.verticalCenter: contentRowLayout.verticalCenter
                sourceComponent: showcardComponent
            }

        }

        Column {
            id: contentItemCol

            spacing: CardConstants.actionButtonConstants.iconTextSpacing
            padding: 0
            height: parent.height
            visible: _isIconLeftOfTitle == false

            Loader {
                active: _hasIconUrl
                sourceComponent: imageComponent
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ActionsContentLayout {
                id: contentColLayout
            }

            Loader {
                active: _isShowCardButton
                //anchors.verticalCenter: contentColLayout.verticalCenter
                sourceComponent: showcardComponent
            }

        }

        Rectangle {
            width: actionButton.width
            height: actionButton.height
            x: -CardConstants.actionButtonConstants.horizotalPadding
            y: -CardConstants.actionButtonConstants.verticalPadding
            color: "transparent"
            border.color: _buttonColors.focusRectangleColor
            border.width: actionButton.activeFocus ? 1 : 0
        }

    }

}
