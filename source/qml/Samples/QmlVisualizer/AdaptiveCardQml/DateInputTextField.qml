import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

TextField {
    id: dateInputTextField

    property var dateInputElement
    property var dateInputPopout
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants

    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage === true)
            accessibleName += 'Error. ' + _mEscapedErrorString;

        accessibleName += _mEscapedLabelString;
        if (dateInputElement._currentDate)
            accessibleName += (dateInputElement._currentDate.toLocaleDateString() + '. ');
        else
            accessibleName += placeholderText;
        return accessibleName;
    }

    function setValidDate(dateString) {
        let tempDate = AdaptiveCardUtils.getDateFromString(text, dateInputElement._dateInputFormat, dateInputElement._regex);
        if (tempDate && Number(tempDate) && tempDate !== dateInputElement._currentDate)
            dateInputElement._currentDate = tempDate;
        else
            dateInputElement._currentDate = null

        Accessible.name = getAccessibleName();
    }

    function setTextFromDate(date) {
        if (date)
            text = date.toLocaleString(Qt.locale('en_US'), dateInputElement._dateInputFormat);

    }

    function getPlaceholderText() {
        let placeholder = '';
        if (dateInputElement._mEscapedPlaceholderString)
            placeholder += dateInputElement._mEscapedPlaceholderString;
        else
            placeholder += 'Select Date';
        placeholder += (' in ' + dateInputElement._dateInputFormat.toLowerCase());
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
            inputMask = dateInputElement._inputMask;

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
    Component.onCompleted: setTextFromDate(dateInputElement._currentDate)

    background: Rectangle {
        color: 'transparent'
    }

    validator: RegExpValidator {
        regExp: dateInputElement._regex
    }

}
