import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: dateInput

    property var _adaptiveCard
    property bool _isRequired
    property bool _validationRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property string _dateInputFormat
    property string _inputMask
    property var _regex
    property var _minDate: new Date(0, 0, 1)
    property var _maxDate: new Date(3000, 0, 1)
    property var _currentDate
    property string _submitValue: getSubmitValue()
    property bool showErrorMessage: false
    property int minWidth: CardConstants.inputDateConstants.dateInputMinWidth
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants

    function colorChange(isPressed) {
        if (isPressed && !showErrorMessage)
            dateWrapper.color = inputFieldConstants.backgroundColorOnPressed;
        else
            dateWrapper.color = showErrorMessage ? inputFieldConstants.backgroundColorOnError : dateInputTextField.activeFocus ? inputFieldConstants.backgroundColorOnPressed : dateInputTextField.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
    }

    function validate() {
        var isValid = true;
        if (_currentDate)
            isValid = ((_currentDate >= _minDate) && (_currentDate <= _maxDate));
        else if (_isRequired)
            isValid = false;
        if (showErrorMessage) {
            if (isValid)
                showErrorMessage = false;

        }
        return !isValid;
    }

    function getSubmitValue() {
        if (!dateInputTextField.text.match(_regex))
            return '';

        if (_currentDate && Number(_currentDate))
            return _currentDate.toLocaleString(Qt.locale('en_US'), 'yyyy-MM-dd');

        return '';
    }

    onActiveFocusChanged: {
        if (activeFocus)
            dateInputTextField.forceActiveFocus();

    }
    on_CurrentDateChanged: {
        if (_isRequired || _validationRequired)
            validate();

    }
    onShowErrorMessageChanged: colorChange(false)
    width: parent.width

    InputLabel {
        id: inputDateLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label.length
    }

    Rectangle {
        id: dateWrapper

        width: parent.width
        height: inputFieldConstants.height
        radius: inputFieldConstants.borderRadius
        color: inputFieldConstants.backgroundColorNormal
        border.color: showErrorMessage ? inputFieldConstants.borderColorOnError : dateInputTextField.activeFocus ? inputFieldConstants.borderColorOnFocus : inputFieldConstants.borderColorNormal
        border.width: inputFieldConstants.borderWidth

        RowLayout {
            id: dateInputRow

            width: parent.width
            height: parent.height
            spacing: 0

            Button {
                id: dateInputIcon

                width: inputDateConstants.dateIconButtonSize
                height: inputDateConstants.dateIconButtonSize
                horizontalPadding: 0
                verticalPadding: 0
                icon.width: inputDateConstants.dateIconSize
                icon.height: inputDateConstants.dateIconSize
                icon.color: showErrorMessage ? inputDateConstants.dateIconColorOnError : dateInputTextField.activeFocus ? inputDateConstants.dateIconColorOnFocus : inputDateConstants.dateIconColorNormal
                icon.source: CardConstants.calendarIcon
                Keys.onReturnPressed: onClicked()
                Layout.leftMargin: inputDateConstants.dateIconHorizontalPadding
                Layout.alignment: Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                onClicked: {
                    dateInputPopout.open();
                }

                background: Rectangle {
                    color: 'transparent'
                }

            }

            ComboBox {
                id: dateInputCombobox

                Layout.fillWidth: true
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
                id: dateInputClearIcon

                width: inputFieldConstants.clearIconSize
                horizontalPadding: 0
                verticalPadding: 0
                icon.width: inputFieldConstants.clearIconSize
                icon.height: inputFieldConstants.clearIconSize
                icon.color: activeFocus ? inputFieldConstants.clearIconColorOnFocus : inputFieldConstants.clearIconColorNormal
                icon.source: CardConstants.clearIconImage
                Keys.onReturnPressed: onClicked()
                Layout.rightMargin: inputFieldConstants.clearIconHorizontalPadding
                visible: (!dateInputTextField.focus && dateInputTextField.text !== '') || (dateInputTextField.focus && dateInputTextField.text !== '\/\/')
                onClicked: {
                    nextItemInFocusChain().forceActiveFocus();
                    dateInputTextField.clear();
                }
                Accessible.name: 'Date Picker clear'
                Accessible.role: Accessible.Button

                background: Rectangle {
                    color: 'transparent'
                }

            }

        }

    }

    InputErrorMessage {
        id: inputDateErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
