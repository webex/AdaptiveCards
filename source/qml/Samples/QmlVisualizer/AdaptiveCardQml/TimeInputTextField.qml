import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

TextField {
    id: timeInputTextField

    property var timeInputElement
    property var timeInputPopout
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants

    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage)
            accessibleName += 'Error. ' + _mEscapedErrorString;

        accessibleName += _mEscapedLabelString;
        if (text.match(timeInputElement._regex))
            accessibleName += text;
        else
            accessibleName += placeholderText;
        return accessibleName;
    }

    font.family: "Segoe UI"
    font.pixelSize: inputFieldConstants.pixelSize
    selectByMouse: true
    selectedTextColor: 'white'
    width: parent.width
    placeholderTextColor: inputFieldConstants.placeHolderColor
    placeholderText: timeInputElement._mEscapedPlaceholderString ? timeInputElement._mEscapedPlaceholderString : 'Select Time'
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
        text = AdaptiveCardUtils.getTimeFieldString(timeInputElement._currHour, timeInputElement._currMinute, timeInputElement._is12Hour);
    }
    Keys.onReleased: {
        if (event.key === Qt.Key_Escape)
            event.accepted = true;

    }
    onFocusChanged: {
        if (focus) {
            inputMask = timeInputElement._inputMask;
        } else {
            if (text === timeInputElement._emptyField)
                inputMask = "";

        }
    }
    onTextChanged: {
        [timeInputElement._currHour, timeInputElement._currMinute] = AdaptiveCardUtils.getTimeFromString(text, timeInputElement._is12Hour, timeInputElement._regex);
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
        regExp: timeInputElement._regex
    }

    background: Rectangle {
        color: 'transparent'
    }

}
