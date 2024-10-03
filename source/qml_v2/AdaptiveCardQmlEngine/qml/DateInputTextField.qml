import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

TextField {
    id: dateInputTextField
    
    property var dateInputElement
    property var dateInputPopout
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants
    
    function getAccessibleName() {
        let accessibleName = '';
        
        accessibleName += dateInputModel.escapedLabelString;
        if (dateInputModel.currentDate)
            accessibleName += (dateInputElement.currentDate + '. ');
        else
            accessibleName += placeholderText;
        accessibleName += qsTr(". Type a date");
        return accessibleName;
    }
    
    function setValidDate(dateString) {
        let tempDate = AdaptiveCardUtils.getDateFromString(text, dateInputModel.dateInputFormat, dateInputModel.regex);
        if (tempDate && Number(tempDate) && tempDate !== dateInputElement.currentDate)
            dateInputElement.currentDate = tempDate;
        else
            dateInputElement.currentDate;
        Accessible.name = getAccessibleName();
    }
    
    function setTextFromDate(date) {
        if (date)
            text = date.toLocaleString(Qt.locale('en_US'), dateInputModel.dateInputFormat);
        
    }
    
    function getPlaceholderText() {
        let placeholder = '';
        if (dateInputModel.PlaceHolder)
            placeholder += dateInputModel.PlaceHolder;
        else
            placeholder += 'Select Date';
        placeholder += (' in ' + dateInputModel.dateInputFormat.toLowerCase());
        return placeholder;
    }
    
    width: parent.width
    height: parent.height
    font.family: 'Segoe UI'
    font.pixelSize: inputFieldConstants.pixelSize
    selectByMouse: true
    selectedTextColor: 'white'
    color: inputFieldConstants.textColor
    leftPadding: inputFieldConstants.textHorizontalPadding
    rightPadding: inputFieldConstants.textHorizontalPadding
    topPadding: inputFieldConstants.textVerticalPadding
    bottomPadding: inputFieldConstants.textVerticalPadding
    Accessible.name: ''
    Accessible.role: Accessible.EditableText
    placeholderTextColor: inputFieldConstants.placeHolderColor
    placeholderText: getPlaceholderText()
    Keys.onReleased: {
        if (event.key === Qt.Key_Escape)
            event.accepted = true;
        
    }
    onTextChanged: {
        setValidDate(text);
    }
    onActiveFocusChanged: {
        if (activeFocus) {
            dateInputPopout.close();
            Accessible.name = getAccessibleName();
            cursorPosition = 0;
        }
    }
    onFocusChanged: {
        if (focus === true)
            inputMask = dateInputModel.InputMask;
        
        if (focus === false) {
            if (text === '\/\/')
                inputMask = '';
            
        }
    }
    onPressed: {
        dateInputElement.colorChange(true);
        event.accepted = true;
    }
    onReleased: {
        dateInputElement.colorChange(false);
        forceActiveFocus();
        event.accepted = true;
    }
    onHoveredChanged: dateInputElement.colorChange(false)
    Component.onCompleted: setTextFromDate(dateInputElement.currentDate)
    
    background: Rectangle {
        color: 'transparent'
    }
    
}
