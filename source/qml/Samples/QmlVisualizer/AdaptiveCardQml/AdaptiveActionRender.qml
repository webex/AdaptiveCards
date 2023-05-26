import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Button {
    id: actionButton

    property string _buttonConfigType
    property bool _isIconLeftOfTitle
    property string _escapedTitle
    property bool _isShowCardButton
    property var _adaptiveCard
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
    property bool _hasAssociatedInputs: false
    property var submitData: ""
    property var buttonConstants: CardConstants.actionButtonConstants
    property double minWidth: _textSpacing + textMetrics.width + buttonConstants.iconTextSpacing

    signal handleShowCardToggleVisibility(var showcardLoaderElement, var currButtonElemID)

    function handleMouseAreaClick() {
        if (_isActionToggleVisibility && _selectActionId === 'Action.ToggleVisibility') {
            AdaptiveCardUtils.handleToggleVisibilityAction((_toggleVisibilityTarget));
            return ;
        } else if (_isActionSubmit && _selectActionId === 'Action.Submit') {
            actionButton.submitData = AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, _hasAssociatedInputs);
            if(actionButton.submitData)
                isButtonDisabled = true;
            return ;
        } else if (_isActionOpenUrl) {
            _adaptiveCard.buttonClicked('', 'Action.OpenUrl', _selectActionId);
            return ;
        } else if (_isShowCardButton) {
            handleShowCardToggleVisibility(_loaderId, this);
        }
    }

    function getButtonConfig() {
        return _buttonConfigType === 'positiveColorConfig' ? CardConstants.positiveButtonColors : _buttonConfigType === 'destructiveColorConfig' ? CardConstants.destructiveButtonColors : CardConstants.primaryButtonColors;
    }

    function getTextSpacing() {
        let tempSpacing = 0;
        if (_hasIconUrl)
            tempSpacing += buttonConstants.imageSize + buttonConstants.iconTextSpacing;

        if (_isShowCardButton)
            tempSpacing += buttonConstants.iconWidth + buttonConstants.iconTextSpacing;

        tempSpacing += (2 * buttonConstants.horizotalPadding);
        return tempSpacing;
    }

    function getTextColor() {
        return actionButton.isButtonDisabled ? _buttonColors.textColorDisabled : (actionButton.showCard || actionButton.hovered || actionButton.down) ? _buttonColors.textColorHovered : _buttonColors.textColorNormal;
    }

    onReleased: handleMouseAreaClick()
    horizontalPadding: buttonConstants.horizotalPadding
    verticalPadding: buttonConstants.verticalPadding
    height: buttonConstants.buttonHeight
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
    Accessible.name: _escapedTitle

    WCustomFocusItem {
    }

    TextMetrics {
        id: textMetrics

        text: _escapedTitle
        font.pixelSize: buttonConstants.pixelSize
        font.weight: Font.DemiBold
        elide: Text.ElideRight
    }


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
            height: buttonConstants.imageSize
            width: buttonConstants.imageSize
            fillMode: Image.PreserveAspectFit
            source: actionButton._imgSource
        }

    }

    Component {
        id: showcardComponent

        Button {
            id: contentItemRowContentShowCard

            visible: _isShowCardButton
            width: buttonConstants.pixelSize
            height: buttonConstants.pixelSize
            anchors.margins: 2
            horizontalPadding: 0
            verticalPadding: 0
            icon.width: 12
            icon.height: 12
            focusPolicy: Qt.NoFocus
            icon.color: getTextColor()
            icon.source: !showCard ? _iconSource : _iconSourceUp
            onReleased: actionButton.onReleased()

            background: Rectangle {
                anchors.fill: parent
                color: 'transparent'
            }

        }

    }

    Component {
        id: buttonTextComponent

        Text {
            id: buttonContentText

            function getTextWidth() {
                if (text.length == 0)
                    return 0;

                if (implicitWidth < _textSpacing)
                    return implicitWidth;

                return implicitWidth < actionButton.parent.width - _textSpacing ? implicitWidth : (actionButton.parent.width - _textSpacing > 1 ? actionButton.parent.width - _textSpacing : 1);
            }

            verticalAlignment: Text.AlignVCenter
            width: getTextWidth()
            height: parent.height
            text: _escapedTitle
            font.pixelSize: buttonConstants.pixelSize
            font.weight: buttonConstants.fontWeight
            elide: Text.ElideRight
            color: getTextColor()
        }

    }

    background: Rectangle {
        id: actionButtonBg

        function setColorForBackground() {
            return actionButton.isButtonDisabled ? _buttonColors.buttonColorDisabled : (actionButton.showCard || actionButton.down) ? _buttonColors.buttonColorPressed : actionButton.hovered ? _buttonColors.buttonColorHovered : _buttonColors.buttonColorNormal;
        }

        anchors.fill: parent
        radius: buttonConstants.buttonRadius
        border.color: isButtonDisabled ? _buttonColors.buttonColorDisabled : _buttonColors.borderColorNormal
        color: setColorForBackground()
    }

    contentItem: Item {
        height: parent.height
        implicitWidth: _isIconLeftOfTitle == true ? contentItemRow.implicitWidth : contentItemCol.implicitWidth

        Row {
            id: contentItemRow

            spacing: buttonConstants.iconTextSpacing
            padding: 0
            height: parent.height
            visible: _isIconLeftOfTitle == true

            Loader {
                active: _hasIconUrl
                height: parent.height
                width: item ? item.width : 0
                sourceComponent: imageComponent
                anchors.verticalCenter: parent.verticalCenter
            }

            Loader {
                sourceComponent: buttonTextComponent
                height: parent.height
                width: item ? item.width : 0
                anchors.verticalCenter: parent.verticalCenter
            }

            Loader {
                active: _isShowCardButton
                height: parent.height
                width: item ? item.width : 0
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: showcardComponent
            }

        }

        Column {
            id: contentItemCol

            spacing: buttonConstants.iconTextSpacing
            padding: 0
            height: parent.height
            visible: _isIconLeftOfTitle == false

            Loader {
                active: _hasIconUrl
                sourceComponent: imageComponent
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Loader {
                sourceComponent: buttonTextComponent
            }

            Loader {
                active: _isShowCardButton
                sourceComponent: showcardComponent
            }

        }

    }

}
