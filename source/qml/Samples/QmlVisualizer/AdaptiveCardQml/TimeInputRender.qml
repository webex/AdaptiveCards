import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: timeInput

    property var _adaptiveCard
    property bool _isRequired
    property bool _validationRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property string _inputMask
    property var _regex
    property int _minHour: 0
    property int _minMinute: 0
    property int _maxHour: 23
    property int _maxMinute: 59
    property int _currHour: -1
    property int _currMinute: -1
    property bool _is12Hour
    property string _submitValue: getSubmitValue()
    property bool showErrorMessage: false
    property int minWidth: CardConstants.inputTimeConstants.timeInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputTimeConstants: CardConstants.inputTimeConstants
    property string _emptyField: _is12Hour ? ': ' : ':'

    function colorChange(isPressed) {
        if (isPressed && !showErrorMessage)
            timeWrapper.color = inputFieldConstants.backgroundColorOnPressed;
        else
            timeWrapper.color = timeInputTextField.activeFocus ? inputFieldConstants.backgroundColorOnPressed : timeInputTextField.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
    }

    function validate() {
        let isValid = true;
        if (isValid) {
            if (_currHour < _minHour || (_currHour === _minHour && _currMinute < _minMinute))
                isValid = false;

            if (_currHour > _maxHour || (_currHour === _maxHour && _currMinute > _maxMinute))
                isValid = false;

        }
        if (_validationRequired && !timeInputTextField.text.match(_regex))
            isValid = true;

        if (showErrorMessage && isValid)
            showErrorMessage = false;

        return !isValid;
    }

    function getSubmitValue() {
        if (!timeInputTextField.text.match(_regex))
            return '';

        return _currHour.toString().padStart(2, '0') + ':' + _currMinute.toString().padStart(2, '0');
    }

    onActiveFocusChanged: {
        if (activeFocus)
            timeInputTextField.forceActiveFocus();

    }
    on_CurrHourChanged: {
        if (_isRequired || _validationRequired)
            validate();

    }
    on_CurrMinuteChanged: {
        if (_isRequired || _validationRequired)
            validate();

    }
    onShowErrorMessageChanged: colorChange(false)
    width: parent.width

    InputLabel {
        id: inputTimeLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label.length
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
            visible: (!timeInputTextField.focus && timeInputTextField.text !== "") || (timeInputTextField.focus && timeInputTextField.text !== _emptyField)
            onClicked: {
                nextItemInFocusChain().forceActiveFocus();
                timeInputTextField.clear();
                _currHour = -1;
                _currMinute = -1;
            }
        }

        WCustomFocusItem {
            isRectangle: true
            visible: timeInputTextField.activeFocus
        }

    }

    InputErrorMessage {
        id: inputTimeErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage
    }

}
