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
    property var _minDate: new Date(0, 0, 2)
    property var _maxDate: new Date(3000, 0, 0)
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
            isValid = ((_currentDate > _minDate) && (_currentDate < _maxDate));
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

    Component.onCompleted: {
        _minDate.setDate(_minDate.getDate() - 1);
        _maxDate.setDate(_maxDate.getDate() + 1);
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
            icon.color: showErrorMessage ? inputDateConstants.dateIconColorOnError : inputDateConstants.dateIconColorNormal
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

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
