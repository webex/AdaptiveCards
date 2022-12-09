import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15


Button {

    property int _textSpacing
    property bool _isIconLeftOfTitle
    property bool _isActionSubmit
    property bool _isActionOpenUrl
    property bool _isActionToggleVisibility
    property bool showCard
    property var _buttonColors : CardConstants.primaryButtonColors
    property bool _hasIconUrl: false
    property var _imgSource: ""
    property string _escapedTitle
    property var _iconSource: ""
    property var _getActionToggleVisibilityClickFunc: ""
    onReleased: onReleasedFunction()
    property string _actionTitle: ""


    function onReleasedFunction() {
        if(_isActionOpenUrl) {
            return adaptiveCard.buttonClicked(_actionTitle, "Action.OpenUrl", "https://adaptivecards.io");
        }
        else if(_isActionToggleVisibility) {
            return _getActionToggleVisibilityClickFunc
        }
        else {
            return ""
        }

    }
    /* TODO Check This */
    Connections{
        //enable : _isActionSubmit
        id:buttonAuto1Connection
        target:_aModel
        function onEnableAdaptiveCardSubmitButton()
        {
            if (actionButton.isButtonDisabled) {
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
            if(showCard == true) {
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
        implicitWidth: contentItemRow.implicitWidth
        Accessible.name: contentItemRowContentText.text

        Row {
            id: contentItemRow
            spacing: CardConstants.actionButtonConstants.iconTextSpacing
            padding:0
            height:parent.height

            Image {
                id: contentItemRowImg
                visible: _hasIconUrl
                cache: false
                height: CardConstants.actionButtonConstants.imageSize
                width: CardConstants.actionButtonConstants.imageSize
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: _isIconLeftOfTitle ? parent.verticalCenter : undefined
                anchors.horizontalCenter: !_isIconLeftOfTitle ? parent.horizontalCenter : undefined
                source: actionButton._imgSource
            }

            Row {
                spacing: CardConstants.actionButtonConstants.iconTextSpacing
                padding: 0
                height: parent.height

                Text {
                    id: contentItemRowContentText
                    anchors.verticalCenter: parent.verticalCenter
                    width: getTextWidth()
                    text: _escapedTitle
                    font.pixelSize: CardConstants.actionButtonConstants.pixelSize
                    font.weight: CardConstants.actionButtonConstants.fontWeight
                    elide: Text.ElideRight
                    color: getTextColor()
                    function getTextWidth() {if (text.length == 0) return 0;if (implicitWidth < _textSpacing) return implicitWidth;return implicitWidth < actionButton.width - _textSpacing ? implicitWidth : (actionButton.width - _textSpacing > 1 ? actionButton.width - _textSpacing : 1);}

                    function getTextColor() {
                        if(showCard == true) {
                            if(actionButton.showCard || actionButton.showCard || actionButton.down ) {
                                return _buttonColors.textColorHovered
                            }
                            else {
                                return _buttonColors.textColorNormal
                            }
                        }

                        else if(_isActionSubmit == true) {
                            if(actionButton.isButtonDisabled) {
                                return _buttonColors.textColorDisabled
                            }
                            else {
                                if(actionButton.hovered || actionButton.down) {
                                    return _buttonColors.textColorHovered
                                }
                                else {
                                    return _buttonColors.textColorNormal
                                }
                            }

                        }
                        else {
                            if(actionButton.hovered || actionButton.down) {
                                    return _buttonColors.textColorHovered
                            }
                            else {
                                return _buttonColors.textColorNormal
                            }
                        }

                    }//  getTextColor ends here



                }// Text Ends Here

                Button {
                    visible: showCard
                    background:Rectangle{
                        anchors.fill:parent
                        color:'transparent'
                    }
                    id: contentItemRowContentShowCard
                    width: contentItemRowContentText.font.pixelSize
                    height: contentItemRowContentText.font.pixelSize
                    anchors.margins: 2
                    horizontalPadding: 0
                    verticalPadding: 0
                    icon.width:12
                    icon.height:12
                    focusPolicy:Qt.NoFocus
                    anchors.verticalCenter: contentItemRowContentText.verticalCenter
                    icon.color: contentItemRowContentText.color
                    icon.source: _iconSource
                    onReleased: actionButton.onReleased()                 
                }

            } // Row Ends Here
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

    Accessible.name: contentItemRowContentText.text

} // Button Ends Here





/*Rectangle {
    width: 200
    height: 100
    color: "red"

    Text {
        anchors.centerIn: parent
        text: "Hello, World!"
    }
}*/
