import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Row {
    property string  contentItemContentText: contentItemRowContentText.text
    property var fontPixelSizeAlias: contentItemRowContentText.font.pixelSize
    property color colorAlias: contentItemRowContentText.color
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
            if(_isShowCardButton == true) {
                if(actionButton.showCard || actionButton.hovered || actionButton.down ) {
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
                
} // Row Ends Here

