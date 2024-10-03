import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: timeInput
    
    property var timeInputModel: model.timeInputRole
    
    property int minHour: timeInputModel.minHour()
    property int minMinute: timeInputModel.minMinute()
    property int maxHour: timeInputModel.maxHour()
    property int maxMinute: timeInputModel.maxMinute()
    property int currHour: timeInputModel.currHour()
    property int currMinute: timeInputModel.currMinute()
    
    property string submitValue: getSubmitValue()
    property bool showErrorMessage: false
    property int minWidth: CardConstants.inputTimeConstants.timeInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    property string emptyField: timeInputModel.is12hour ? ': ' : ':'
    
    function colorChange(isPressed) {
        if (isPressed && !showErrorMessage)
            timeWrapper.color = inputFieldConstants.backgroundColorOnPressed;
        else
            timeWrapper.color = timeInputTextField.activeFocus ? inputFieldConstants.backgroundColorOnPressed : timeInputTextField.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
    }
    
    function validate() {
        let isValid = true;
        if (isValid) {
            if (currHour < minHour || (currHour === minHour && currMinute < minMinute))
                isValid = false;
            
            if (currHour > maxHour || (currHour === maxHour && currMinute > maxMinute))
                isValid = false;           
        }
        if (timeInputModel.validationRequired && !timeInputTextField.text.match(timeInputModel.regex))
            isValid = true;
        
        if (showErrorMessage && isValid)
            showErrorMessage = false;
        
        return !isValid;
    }
    
    function getSubmitValue() {
        if (!timeInputTextField.text.match(timeInputModel.regex))
            return '';
        
        return currHour.toString().padStart(2, '0') + ':' + currMinute.toString().padStart(2, '0');
    }
    
    onActiveFocusChanged: {
        if (activeFocus)
            timeInputTextField.forceActiveFocus();       
    }
    onCurrHourChanged: {
        if (timeInputModel.isRequired || timeInputModel.validationRequired)
            validate();       
    }
    onCurrMinuteChanged: {
        if (timeInputModel.isRequired || timeInputModel.validationRequired)
            validate();        
    }
    onShowErrorMessageChanged: colorChange(false)
    width: parent.width
    spacing: CardConstants.inputFieldConstants.columnSpacing
    visible: timeInputModel.isVisible
    
    InputLabel {
        id: inputTimeLabel
        
        label: timeInputModel.label
        required: timeInputModel.isRequired
        visible: label.length
    }
    
    Rectangle {
        id: timeWrapper
        
        width: parent.width
        height: inputFieldConstants.height
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: showErrorMessage ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
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
                
                timeInputElement: timeInput
                timeInputPopout: timeInputPopout
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
            visible: (!timeInputTextField.focus && timeInputTextField.text !== "") || (timeInputTextField.focus && timeInputTextField.text !== emptyField)
            onClicked: {
                timeInputTextField.forceActiveFocus();
                timeInputTextField.clear();
                currHour = -1;
                currMinute = -1;
            }
        }
        
        WCustomFocusItem {
            isRectangle: true
            visible: timeInputTextField.activeFocus
        }
    }
    
    InputErrorMessage {
        id: inputTimeErrorMessage
        
        isErrorMessage: timeInputModel.errorMessage
        visible: showErrorMessage
    }
}