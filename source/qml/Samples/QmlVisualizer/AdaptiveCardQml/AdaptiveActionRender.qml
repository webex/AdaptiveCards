import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import "AdaptiveCardUtils.js" as AdaptiveCardUtils


Button {
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
    property var _buttonColors : getButtonConfig()
    onReleased: handleMouseAreaClick() 
    signal handleShowCardToggleVisibility(var showcardLoaderElement, var currButtonElemID)


    function handleMouseAreaClick() {
        if (_isActionToggleVisibility && _selectActionId === 'Action.ToggleVisibility') {
           console.log("_toggleVisibilityTarget" + _toggleVisibilityTarget)
            AdaptiveCardUtils.handleToggleVisibilityAction(/*JSON.parse*/(_toggleVisibilityTarget));
            return ;
        } else if (_isActionSubmit && _selectActionId === 'Action.Submit') {
            console.log("_paramStr" + _paramStr)
            console.log("_adaptiveCard" + _adaptiveCard)
            AdaptiveCardUtils.handleSubmitAction(_paramStr, _adaptiveCard, _is1_3Enabled);
            return ;
        } else if(_isActionOpenUrl){
            _adaptiveCard.buttonClicked('', 'Action.OpenUrl', _selectActionId);
            return ;
        }
        else if(_isShowCardButton){
             handleShowCardToggleVisibility(_loaderId, this)
        }
    }

    function getButtonConfig() {

        if(_buttonConfigType === 'positiveColorConfig')
            return CardConstants.positiveButtonColors
        else if(_buttonConfigType ===  'destructiveColorConfig')
            return CardConstants.destructiveButtonColors
        else {
            return CardConstants.primaryButtonColors
        }
    }

    function getTextSpacing() {
        if(_hasIconUrl) {
            return CardConstants.actionButtonConstants.imageSize + CardConstants.actionButtonConstants.iconTextSpacing;
        }
        if(_isShowCardButton) {
            return CardConstants.actionButtonConstants.iconWidth + CardConstants.actionButtonConstants.iconTextSpacing;
        }
        return 2 * CardConstants.actionButtonConstants.horizotalPadding - 2;
    }

    Connections{
    
        id:buttonAuto1Connection
        target:_aModel
        function onEnableAdaptiveCardSubmitButton()
        {
            if (_isActionSubmit && actionButton.isButtonDisabled) {
                actionButton.isButtonDisabled = false;
            }
        }
    }

    id: actionButton
    width: (parent.width > implicitWidth) ? implicitWidth : parent.width
    horizontalPadding: CardConstants.actionButtonConstants.horizotalPadding
    verticalPadding: CardConstants.actionButtonConstants.verticalPadding
    height: CardConstants.actionButtonConstants.buttonHeight
    Keys.onPressed:{if(event.key === Qt.Key_Return){down=true;event.accepted=true;}}
    Keys.onReleased:{if(event.key === Qt.Key_Return){down=false;actionButton.onReleased();event.accepted=true;}}
    property bool isButtonDisabled:false
    enabled:!isButtonDisabled

    background: Rectangle {
        id: actionButtonBg
        anchors.fill: parent
        radius: CardConstants.actionButtonConstants.buttonRadius

        border.color: setBorderColorForBackground()
        color: setColorForBackground()


        function setBorderColorForBackground() {
            if(_isActionSubmit == true) {
                return (isButtonDisabled ? _buttonColors.buttonColorDisabled :  _buttonColors.borderColorNormal)
            }
            else {
                return _buttonColors.borderColorNormal
            }
        }

        function setColorForBackground() {
            if(_isShowCardButton == true) {
            console.log("actionButton.down : " + actionButton.down + " actionButton.showCard: " + actionButton.showCard)
                if(actionButton.showCard || actionButton.down) {
                    return _buttonColors.buttonColorPressed
                }
                else {
                    if(actionButton.hovered) {
                        return _buttonColors.buttonColorHovered
                    }
                    else {
                        return _buttonColors.buttonColorNormal
                    } 
                }
                
            }
            else if(_isActionSubmit == true) {
                if(actionButton.isButtonDisabled) {
                    _buttonColors.buttonColorDisabled
                }
                else {
                    if(actionButton.down) {
                        return _buttonColors.buttonColorPressed
                    }
                    else {
                        if(actionButton.hovered) {
                            return _buttonColors.buttonColorHovered
                        }
                        else {
                            return _buttonColors.buttonColorNormal
                        }    
                    }
                }
                
            }
            else {
                if(actionButton.down) {
                    return _buttonColors.buttonColorPressed
                }
                else {
                    if(actionButton.hovered) {
                        return _buttonColors.buttonColorHovered
                    }
                    else {
                        return _buttonColors.buttonColorNormal
                    }
                }
            }
        }

    } // background rectangle ends here

    contentItem: Item {
        height: parent.height
        implicitWidth: _isIconLeftOfTitle == true ? contentItemRow.implicitWidth : contentItemCol.implicitWidth
        Accessible.name: _isIconLeftOfTitle == true ? contentRowLayout.contentItemContentText : contentColLayout.contentItemContentText

        Row {
            id: contentItemRow
            spacing: CardConstants.actionButtonConstants.iconTextSpacing
            padding:0
            height:parent.height
            visible: _isIconLeftOfTitle == true

            Loader {
                    active: _hasIconUrl
                    sourceComponent:    Image {
                        id: contentItemColImg
                        visible: _hasIconUrl
                        cache: false
                        height: CardConstants.actionButtonConstants.imageSize
                        width: CardConstants.actionButtonConstants.imageSize
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        source: actionButton._imgSource
                    }
              }  

            ActionsContentLayout {
                id: contentRowLayout
            }

            Loader {
                active: _isShowCardButton
                anchors.verticalCenter: contentRowLayout.verticalCenter
                sourceComponent:    Button {
                    visible: _isShowCardButton
                    background:Rectangle{
                        anchors.fill:parent
                        color:'transparent'
                    }
                    id: contentItemRowContentShowCard
                    width: contentRowLayout.fontPixelSizeAlias
                    height: contentRowLayout.fontPixelSizeAlias
                    anchors.margins: 2
                    horizontalPadding: 0
                    verticalPadding: 0
                    icon.width:12
                    icon.height:12
                    focusPolicy:Qt.NoFocus
                    icon.color: contentRowLayout.colorAlias
                    icon.source: !showCard ? _iconSource : _iconSourceUp
                    onReleased: actionButton.onReleased()                 
                } 
            }
        }


        Column {
            id: contentItemCol
            spacing: CardConstants.actionButtonConstants.iconTextSpacing
            padding:0
            height:parent.height
            visible: _isIconLeftOfTitle == false

            Loader {
                    active: _hasIconUrl
                    sourceComponent:    Image {
                        id: contentItemColImg
                        visible: _hasIconUrl
                        cache: false
                        height: CardConstants.actionButtonConstants.imageSize
                        width: CardConstants.actionButtonConstants.imageSize
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: actionButton._imgSource
                    }
              }  

            ActionsContentLayout {
                id: contentColLayout
            }

            Loader {
                active: _isShowCardButton
                //anchors.verticalCenter: contentColLayout.verticalCenter
                sourceComponent:    Button {
                    visible: _isShowCardButton
                    background:Rectangle{
                        anchors.fill:parent
                        color:'transparent'
                    }
                    id: contentItemColContentShowCard
                    width: contentColLayout.fontPixelSizeAlias
                    height: contentColLayout.fontPixelSizeAlias
                    anchors.margins: 2
                    horizontalPadding: 0
                    verticalPadding: 0
                    icon.width:12
                    icon.height:12
                    focusPolicy:Qt.NoFocus
                    icon.color: contentColLayout.colorAlias
                    icon.source: !showCard ? _iconSource : _iconSourceUp
                    onReleased: actionButton.onReleased()                 
                } 
            }
        }

        Rectangle {
            width:actionButton.width
            height:actionButton.height
            x: -CardConstants.actionButtonConstants.horizotalPadding
            y: -CardConstants.actionButtonConstants.verticalPadding
            color:"transparent"
            border.color: _buttonColors.focusRectangleColor
            border.width: actionButton.activeFocus ? 1 : 0
        }

    } // Content Item Ends Here

    Accessible.name: _isIconLeftOfTitle == true ? contentRowLayout.contentItemContentText : contentColLayout.contentItemContentText

} // Button Ends Here

