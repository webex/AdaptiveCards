import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: dateInput
    
    property var dateInputModel:model.dateInputRole    
    
    property var currentDate:dateInputModel.currentDate
    property bool showErrorMessage: false
    property int minWidth: CardConstants.inputDateConstants.dateInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants
    
    function colorChange(isPressed) {
        if (isPressed && !showErrorMessage)
            dateWrapper.color = inputFieldConstants.backgroundColorOnPressed;
        else
            dateWrapper.color = dateInputTextField.activeFocus ? inputFieldConstants.backgroundColorOnPressed : dateInputTextField.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
    }
    
    
    function getSubmitValue() {
        if (!dateInputTextField.text.match(dateInputModel.regex))
            return '';
        
        if (dateInputModel.currentDate && Number(dateInputModel.currentDate))
            return dateInputModel.currentDate.toLocaleString(Qt.locale('en_US'), 'yyyy-MM-dd');
        
        return '';
    }
    
    onActiveFocusChanged: {
        if (activeFocus)
            dateInputTextField.forceActiveFocus();
    }
    
    width: parent.width
    spacing: CardConstants.inputFieldConstants.columnSpacing
    
    InputLabel {
        id: inputDateLabel
        
        label: dateInputModel.escapedLabelString
        required: dateInputModel.isRequired
        visible: label.length
    }
    visible: dateInputModel.visible
    Rectangle {
        id: dateWrapper
        
        width: parent.width
        height: inputFieldConstants.height
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: showErrorMessage ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth
        
        ComboBox {
            id: dateInputCombobox
            
            anchors.left: dateInputIcon.right
            anchors.right: dateInputClearIcon.left
            focusPolicy: Qt.NoFocus
            onActiveFocusChanged: colorChange(false)
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
                
                dateInputElement: dateInput
                dateInputPopout: dateInputPopout
            }
            
        }
        
        Button {
            id: dateInputIcon
            
            width: inputDateConstants.dateIconButtonSize
            height: inputDateConstants.dateIconButtonSize
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
                dateInputModel.currentDate;
            }
        }
        
        WCustomFocusItem {
            isRectangle: true
            visible: dateInputTextField.activeFocus
        }
        
    }
    
    InputErrorMessage {
        id: inputDateErrorMessage
        
        visible: showErrorMessage
    }




 
}
