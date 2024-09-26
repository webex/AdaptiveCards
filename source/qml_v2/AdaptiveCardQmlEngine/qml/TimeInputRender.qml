import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: timeInput
    
    property int minWidth: CardConstants.inputTimeConstants.timeInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    
    width: parent.width
    spacing: CardConstants.inputFieldConstants.columnSpacing
    
    InputLabel {
        id: inputTimeLabel
        
        label: "Time label"
        required: true
        visible: label.length
    }
    
    Rectangle {
        id: timeWrapper
        
        width: parent.width
        height: inputFieldConstants.height
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: true ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
        
        ComboBox {
            id: timeInputCombobox
            
            anchors.left: timeInputIcon.right
            anchors.right: timeInputClearIcon.left
            focusPolicy: Qt.NoFocus
            onActiveFocusChanged: colorChange(false)
            Accessible.ignored: true
            Keys.onReturnPressed: {
                setFocusBackOnClose(timeInputCombobox);
                this.popup.open();
            }
            
            indicator: Rectangle {
            }
            
            popup: TimeInputPopout {
                id: timeInputPopout
                
                timeInputElement: timeInput
                timeInputField: timeInputTextField
            }
            
            background: TimeInputTextField {
                id: timeInputTextField                
            }
        }
        
        Button {
            id: timeInputIcon
            
            width: inputTimeConstants.timeIconButtonSize
            height: inputTimeConstants.timeIconButtonSize
            horizontalPadding: 0
            verticalPadding: 0
            icon.width: inputTimeConstants.timeIconSize
            icon.height: inputTimeConstants.timeIconSize
            icon.color: inputTimeConstants.timeIconColorNormal
            icon.source: CardConstants.clockIcon
            Keys.onReturnPressed: onClicked()
            anchors.left: parent.left
            anchors.leftMargin: inputTimeConstants.timeIconHorizontalPadding
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                timeInputPopout.open();
            }
            Accessible.name: qsTr("Time picker")
            Accessible.role: Accessible.Button
            
            background: Rectangle {
                color: 'transparent'
                radius: CardConstants.inputFieldConstants.borderRadius
                
                WCustomFocusItem {
                    isRectangle: true
                    visible: timeInputIcon.activeFocus
                    designatedParent: parent
                }
            }
        }
        
        InputFieldClearIcon {
            id: timeInputClearIcon
            
            anchors.right: parent.right
            anchors.rightMargin: inputFieldConstants.clearIconHorizontalPadding
            anchors.verticalCenter: parent.verticalCenter
            Keys.onReturnPressed: onClicked()
            
            onClicked: {
                timeInputTextField.forceActiveFocus();
                timeInputTextField.clear();
            }
        }
        
        WCustomFocusItem {
            isRectangle: true
            visible: timeInputTextField.activeFocus
        }
    }
    
    InputErrorMessage {
        id: inputTimeErrorMessage
        
        isErrorMessage: "Error"
        visible: true
    }
}
