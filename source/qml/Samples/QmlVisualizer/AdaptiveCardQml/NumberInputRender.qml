import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: numberInput

    property var _adaptiveCard
    property bool _isRequired
    property bool _validationRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property bool showErrorMessage: false
    property int _minValue
    property int _maxValue
    property int _value
    property bool _hasDefaultValue: false
    property var numberInputConstants: CardConstants.inputNumberConstants
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property int minWidth: numberInputConstants.numberInputMinWidth
    property string _submitValue: _numberInputTextField.text ? Number(_numberInputTextField.text).toString() : ''

    function validate() {
        if (_numberInputTextField.text.length !== 0 && Number(_numberInputTextField.text) >= _numberInputSpinBox.from && Number(_numberInputTextField.text) <= _numberInputSpinBox.to) {
            showErrorMessage = false;
            return false;
        } else {
            return true;
        }
    }

    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage)
            accessibleName += 'Error. ' + _mEscapedErrorString + '. ';

        if (_mEscapedLabelString)
            accessibleName += _mEscapedLabelString + '. ';

        if (_numberInputTextField.text !== '')
            accessibleName += (_numberInputTextField.text);
        else
            accessibleName += _mEscapedPlaceholderString;
        accessibleName += qsTr(", Type the number");
        return accessibleName;
    }

    width: parent.width
    spacing: inputFieldConstants.columnSpacing
    onShowErrorMessageChanged: {
        _numberInputRectangle.colorChange(false);
    }
    onActiveFocusChanged: {
        if (activeFocus)
            _numberInputTextField.forceActiveFocus();

    }

    InputLabel {
        id: _numberInputLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label
    }

    Row {
        id: _numberInputRow

        width: parent.width
        height: inputFieldConstants.height

        Rectangle {
            id: _numberInputRectangle

            function colorChange(isPressed) {
                if (isPressed && !showErrorMessage)
                    color = inputFieldConstants.backgroundColorOnPressed;
                else
                    color = showErrorMessage ? inputFieldConstants.backgroundColorOnError : _numberInputTextField.activeFocus ? inputFieldConstants.backgroundColorOnPressed : _numberInputTextField.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal;
            }

            border.width: inputFieldConstants.borderWidth
            border.color: showErrorMessage ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
            radius: inputFieldConstants.borderRadius
            height: parent.height
            color: _numberInputSpinBox.pressed ? inputFieldConstants.backgroundColorOnPressed : _numberInputSpinBox.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
            width: parent.width - _numberInputArrowRectangle.width

             WCustomFocusItem {
                isRectangle: true
                visible: _numberInputTextField.activeFocus
            }

            SpinBox {
                id: _numberInputSpinBox

                function changeValue(keyPressed) {
                    if ((keyPressed === Qt.Key_Up || keyPressed === Qt.Key_Down) && _numberInputTextField.text.length === 0) {
                        value = (from > 0) ? from : 0;
                    } else if (keyPressed === Qt.Key_Up) {
                        _numberInputSpinBox.value = Number(_numberInputTextField.text);
                        _numberInputSpinBox.increase();
                    } else if (keyPressed === Qt.Key_Down) {
                        _numberInputSpinBox.value = Number(_numberInputTextField.text);
                        _numberInputSpinBox.decrease();
                    }
                    _numberInputTextField.text = _numberInputSpinBox.value;
                }

                width: parent.width - _numberInputClearIcon.width - CardConstants.inputFieldConstants.clearIconHorizontalPadding
                padding: 0
                editable: true
                stepSize: 1
                to: _maxValue
                from: _minValue
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                        _numberInputSpinBox.changeValue(event.key);
                        event.accepted = true;
                    }
                }
                Accessible.ignored: true
                Component.onCompleted: {
                    if (_hasDefaultValue)
                        _numberInputSpinBox.value = _value;

                }

                contentItem: TextField {
                    id: _numberInputTextField

                    font.pixelSize: inputFieldConstants.pixelSize
                    anchors.left: parent.left
                    anchors.right: parent.right
                    selectByMouse: true
                    selectedTextColor: 'white'
                    readOnly: !_numberInputSpinBox.editable
                    validator: _numberInputSpinBox.validator
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onPressed: {
                        _numberInputRectangle.colorChange(true);
                        event.accepted = true;
                    }
                    onReleased: {
                        _numberInputRectangle.colorChange(false);
                        forceActiveFocus();
                        event.accepted = true;
                    }
                    onHoveredChanged: _numberInputRectangle.colorChange(false)
                    onActiveFocusChanged: {
                        _numberInputRectangle.colorChange(false);
                        Accessible.name = getAccessibleName();
                    }
                    leftPadding: inputFieldConstants.textHorizontalPadding
                    rightPadding: inputFieldConstants.textHorizontalPadding
                    topPadding: inputFieldConstants.textVerticalPadding
                    bottomPadding: inputFieldConstants.textVerticalPadding
                    placeholderText: _mEscapedPlaceholderString
                    Accessible.role: Accessible.EditableText
                    color: inputFieldConstants.textColor
                    placeholderTextColor: inputFieldConstants.placeHolderColor
                    onTextChanged: {
                        validate();
                    }
                    Component.onCompleted: {
                        if (_hasDefaultValue)
                            _numberInputTextField.text = _numberInputSpinBox.value;

                    }

                    background: Rectangle {
                        id: _numberInputTextFieldBg

                        color: 'transparent'
                    }

                }

                background: Rectangle {
                    id: _numberSpinBoxBg

                    color: 'transparent'
                }

                up.indicator: Rectangle {
                    color: 'transparent'
                    z: -1
                }

                down.indicator: Rectangle {
                    color: 'transparent'
                    z: -1
                }

                validator: DoubleValidator {
                }

            }

            InputFieldClearIcon {
                id: _numberInputClearIcon

                Keys.onReturnPressed: onClicked()
                visible: _numberInputTextField.length !== 0
                onClicked: {
                    nextItemInFocusChain().forceActiveFocus();
                    _numberInputSpinBox.value = _numberInputSpinBox.from;
                    _numberInputTextField.clear();
                }
            }

        }

        Rectangle {
            id: _numberInputArrowRectangle

            property string accessibilityPrefix: ''

            width: numberInputConstants.upDownButtonWidth
            radius: inputFieldConstants.borderRadius
            height: parent.height
            border.color: activeFocus ? inputFieldConstants.borderColorOnFocus : inputFieldConstants.borderColorNormal
            activeFocusOnTab: true
            color: (_numberInputArrowIcon.pressed || activeFocus) ? inputFieldConstants.backgroundColorOnPressed : _numberInputArrowIcon.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
            Keys.onPressed: {
                if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                    _numberInputSpinBox.changeValue(event.key);
                    accessibilityPrefix = '';
                    event.accepted = true;
                }
            }
            onActiveFocusChanged: {
                if (activeFocus)
                    accessibilityPrefix = qsTr("Use up arrow to increase the value and down arrow to decrease the value") + (_numberInputTextField.text ? ", Current number is " : "");

            }
            Accessible.name: accessibilityPrefix + _numberInputTextField.displayText
            Accessible.role: Accessible.NoRole

            Button {
                id: _numberInputArrowIcon

                width: parent.width
                anchors.right: parent.right
                horizontalPadding: inputFieldConstants.iconPadding
                verticalPadding: inputFieldConstants.iconPadding
                icon.width: numberInputConstants.upDownIconSize
                icon.height: numberInputConstants.upDownIconSize
                focusPolicy: Qt.NoFocus
                icon.color: numberInputConstants.upDownIconColor
                height: parent.height
                icon.source: CardConstants.numberInputUpDownArrowImage

                background: Rectangle {
                    color: 'transparent'
                }

            }

            MouseArea {
                id: _numberInputSpinBoxUpIndicatorArea

                width: parent.width
                height: parent.height / 2
                anchors.top: parent.top
                onReleased: {
                    _numberInputSpinBox.changeValue(Qt.Key_Up);
                    _numberInputArrowRectangle.forceActiveFocus();
                }
            }

            MouseArea {
                id: _numberInputSpinBoxDownIndicatorArea

                width: parent.width
                height: parent.height / 2
                anchors.top: _numberInputSpinBoxUpIndicatorArea.bottom
                onReleased: {
                    _numberInputSpinBox.changeValue(Qt.Key_Down);
                    _numberInputArrowRectangle.forceActiveFocus();
                }
            }

            WCustomFocusItem {
                isRectangle: true
            }

        }

    }

    InputErrorMessage {
        id: _numberInputErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString
    }

}
