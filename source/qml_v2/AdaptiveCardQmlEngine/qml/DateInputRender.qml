import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Column {
    id: dateInput
    
    property int minWidth: CardConstants.inputDateConstants.dateInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants
    
    width: parent.width
    spacing:CardConstants.inputFieldConstants.columnSpacing
    InputLabel {
        id: inputDateLabel
        
        label: "this is a label"
        required: true
        visible: label.length
    }
    
    Rectangle {
        id: dateWrapper
        
        width: parent.width
        height: inputFieldConstants.height
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: true ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
        
        ComboBox {
            id: dateInputCombobox
            
            anchors.left: dateInputIcon.right
            anchors.right: dateInputClearIcon.left
            focusPolicy: Qt.NoFocus
            Accessible.ignored: true
            Keys.onReturnPressed: {
                setFocusBackOnClose(dateInputCombobox);
                this.popup.open();
            }
            
            indicator: Rectangle {
            }
            
            popup: DateInputPopout {
                id: dateInputPopout
                
                dateInputElement: dateInput
                dateInputField: dateInputTextField
            }
            
            background: DateInputTextField {
                id: dateInputTextField
                
            }
            
        }
        
        Button {
            id: dateInputIcon
            
            width: inputDateConstants.dateIconButtonSize
            height:inputDateConstants.dateIconButtonSize
            horizontalPadding: 0
            verticalPadding: 0
            icon.width: inputDateConstants.dateIconSize
            icon.height: inputDateConstants.dateIconSize
            icon.color: inputDateConstants.dateIconColorNormal
            icon.source: CardConstants.calendarIcon
            Keys.onReturnPressed: onClicked()
            anchors.left: parent.left
            anchors.leftMargin: inputDateConstants.dateIconHorizontalPadding
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                dateInputPopout.open();
            }
            Accessible.name: qsTr("Date picker")
            Accessible.role: Accessible.Button
            
            background: Rectangle {
                color: 'transparent'
                radius: CardConstants.inputFieldConstants.borderRadius
                
                WCustomFocusItem {
                    isRectangle: true
                    visible: dateInputIcon.activeFocus
                    designatedParent: parent
                }
                
            }
        }
        
        InputFieldClearIcon {
            id: dateInputClearIcon
            
            anchors.right: parent.right
            anchors.rightMargin: inputFieldConstants.clearIconHorizontalPadding
            anchors.verticalCenter: parent.verticalCenter
            Keys.onReturnPressed: onClicked()
            visible: (!dateInputTextField.focus && dateInputTextField.text !== '') || (dateInputTextField.focus && dateInputTextField.text !== '\/\/')
            onClicked: {
                nextItemInFocusChain().forceActiveFocus();
                dateInputTextField.clear();
                _currentDate = null;
            }
        }
        
        WCustomFocusItem {
            isRectangle: true
            visible: dateInputTextField.activeFocus
        }
    }
    
    InputErrorMessage {
        id: inputDateErrorMessage
        
        isErrorMessage: "error"
        visible: true
    }
}
