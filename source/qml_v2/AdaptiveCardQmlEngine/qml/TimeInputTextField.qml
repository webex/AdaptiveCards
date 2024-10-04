import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextField {
    id: timeInputTextField
    
    property var timeInputElement
    property var timeInputPopout
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    
    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage)
            accessibleName += 'Error. ' + timeInputModel.errorMessage;
        
        accessibleName += timeInputModel.label;
        if (text.match(timeInputElement.timeInputModel.regex))
            accessibleName += text;
        else
            accessibleName += placeholderText;
        
        accessibleName += qsTr(". Type a time");
        return accessibleName;
    }
    
    font.family: "Segoe UI"
    font.pixelSize: inputFieldConstants.pixelSize
    selectByMouse: true
    selectedTextColor: 'white'
    width: parent.width
    placeholderTextColor: inputFieldConstants.placeHolderColor
    placeholderText: timeInputElement.timeInputModel.placeholder ? timeInputElement.timeInputModel.placeholder : 'Select Time'
    color: inputFieldConstants.textColor
    leftPadding: inputFieldConstants.textHorizontalPadding
    rightPadding: inputFieldConstants.textHorizontalPadding
    topPadding: inputFieldConstants.textVerticalPadding
    bottomPadding: inputFieldConstants.textVerticalPadding
    Accessible.name: ""
    Accessible.role: Accessible.EditableText
    onHoveredChanged: timeInputElement.colorChange(false)
    onPressed: {
        timeInputElement.colorChange(true);
        event.accepted = true;
    }
    onReleased: {
        timeInputElement.colorChange(false);
        forceActiveFocus();
        event.accepted = true;
    }
    Component.onCompleted: {
        text = AdaptiveCardUtils.getTimeFieldString(timeInputElement.currHour, timeInputElement.currMinute, timeInputElement.timeInputModel.is12Hour);
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Escape)
            event.accepted = true;
        
    }
    onFocusChanged: {
        if (focus) {
            inputMask = timeInputElement.timeInputModel.inputMask;
        } else {
            if (text === timeInputElement.emptyField)
                inputMask = "";            
        }
    }
    onTextChanged: {
        [timeInputElement.currHour, timeInputElement.currMinute] = AdaptiveCardUtils.getTimeFromString(text, timeInputElement.timeInputModel.is12Hour, timeInputElement.timeInputModel.regex);
        timeInputElement.validate();
    }
    onActiveFocusChanged: {
        if (activeFocus) {
            onTextChanged();
            Accessible.name = getAccessibleName();
            cursorPosition = 0;
        }
    }
    activeFocusOnTab: true
    
    validator: RegExpValidator {
        regExp: timeInputElement.timeInputModel.regex
    }
    
    background: Rectangle {
        color: 'transparent'
    }
}