import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Column {
    id: numberInput

    property var _adaptiveCard
    property bool _isRequired
    property bool _validationRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property bool showErrorMessage: false
    property double _minValue
    property double _maxValue
    property double _value
    property int _spinBoxMinVal : Math.max(-2147483648, _minValue)
    property int _spinBoxMaxVal : Math.min(2147483647, _maxValue)
    property bool _hasDefaultValue: false
 
    property int minWidth: cardConst.inputNumberConstants.numberInputMinWidth
    property string _submitValue: _numberInputTextField.text ? Number(_numberInputTextField.text).toString() : ''

 CardConstants{

            id:cardConst

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
    spacing:cardConst.inputFieldConstants.columnSpacing
     Component.onCompleted: {
      console.log("inputFieldConstants.columnSpacing",+cardConst.inputFieldConstants.columnSpacing);
     }
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
        height: cardConst.inputFieldConstants.height

        Rectangle {
            id: _numberInputRectangle



            border.width: cardConst.inputFieldConstants.borderWidth
            border.color: "black"//showErrorMessage ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
            radius: cardConst.inputFieldConstants.borderRadius
            height: parent.height
            color:"white"// _numberInputSpinBox.pressed ? inputFieldConstants.backgroundColorOnPressed : _numberInputSpinBox.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
            width: parent.width - 31//_numberInputArrowRectangle.width


             /*WCustomFocusItem {
                isRectangle: true
                visible: _numberInputTextField.activeFocus
            }*/

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

                width: parent.width - _numberInputClearIcon.width - cardConst.inputFieldConstants.clearIconHorizontalPadding
                padding: 0
                editable: true
                stepSize: 1
               // to: _spinBoxMaxVal
               // from: _spinBoxMinVal
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

                    font.pixelSize: cardConst.inputFieldConstants.pixelSize
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
                    leftPadding: cardConst.inputFieldConstants.textHorizontalPadding
                    rightPadding: cardConst.inputFieldConstants.textHorizontalPadding
                    topPadding: cardConst.inputFieldConstants.textVerticalPadding
                    bottomPadding: cardConst.inputFieldConstants.textVerticalPadding
                    placeholderText: _mEscapedPlaceholderString
                    Accessible.role: Accessible.EditableText
                    color: cardConst.inputFieldConstants.textColor
                    placeholderTextColor: cardConst.inputFieldConstants.placeHolderColor
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
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: cardConst.inputFieldConstants.clearIconHorizontalPadding
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

            width: 31//numberInputConstants.upDownButtonWidth
            radius:8// inputFieldConstants.borderRadius
            height: parent.height
            border.color: "black"//inputFieldConstants.borderColorNormal
            activeFocusOnTab: true
            color:"gray" //(_numberInputArrowIcon.pressed || activeFocus) ? inputFieldConstants.backgroundColorOnPressed : _numberInputArrowIcon.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
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
                horizontalPadding: 4//inputFieldConstants.iconPadding
                verticalPadding: 4//inputFieldConstants.iconPadding
                icon.width: 31//numberInputConstants.upDownIconSize
                icon.height:31// numberInputConstants.upDownIconSize
                focusPolicy: Qt.NoFocus
                icon.color: "black"//numberInputConstants.upDownIconColor
                height: parent.height
                icon.source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxNCAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEzLjQ0NzQgOS43NzYzOEMxMy40MTggOS43MTc2MyAxMy4zNzc0IDkuNjY1MjUgMTMuMzI3OCA5LjYyMjIyQzEzLjI3ODIgOS41NzkxOCAxMy4yMjA2IDkuNTQ2MzUgMTMuMTU4MyA5LjUyNTU4QzEzLjA5NiA5LjUwNDgxIDEzLjAzMDIgOS40OTY1MiAxMi45NjQ3IDkuNTAxMThDMTIuODk5MiA5LjUwNTgzIDEyLjgzNTIgOS41MjMzNSAxMi43NzY1IDkuNTUyNzNMNy4wMDAwNCAxMi40NDA5TDEuMjIzNzkgOS41NTI3M0MxLjEwNTE2IDkuNDkzNDEgMC45Njc4MzIgOS40ODM2NSAwLjg0MjAwOSA5LjUyNTU5QzAuNzE2MTg2IDkuNTY3NTIgMC42MTIxNzYgOS42NTc3MyAwLjU1Mjg2MSA5Ljc3NjM1QzAuNDkzNTQ1IDkuODk0OTggMC40ODM3ODIgMTAuMDMyMyAwLjUyNTcyIDEwLjE1ODFDMC41Njc2NTggMTAuMjg0IDAuNjU3ODYxIDEwLjM4OCAwLjc3NjQ4NiAxMC40NDczTDYuNzc2NDkgMTMuNDQ3M0M2Ljg0NTk0IDEzLjQ4MiA2LjkyMjUgMTMuNSA3LjAwMDE0IDEzLjVDNy4wNzc3NyAxMy41IDcuMTU0MzQgMTMuNDgyIDcuMjIzNzkgMTMuNDQ3M0wxMy4yMjM4IDEwLjQ0NzNDMTMuMjgyNSAxMC40MTc5IDEzLjMzNDkgMTAuMzc3MyAxMy4zNzc5IDEwLjMyNzdDMTMuNDIxIDEwLjI3OCAxMy40NTM4IDEwLjIyMDQgMTMuNDc0NiAxMC4xNTgxQzEzLjQ5NTMgMTAuMDk1OCAxMy41MDM2IDEwLjAzMDEgMTMuNDk4OSA5Ljk2NDU2QzEzLjQ5NDMgOS44OTkwNSAxMy40NzY4IDkuODM1MTEgMTMuNDQ3NCA5Ljc3NjM4WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMTMuMjIzOSAzLjU1MjcyTDcuMjIzNjkgMC41NTI3MjRDNy4xNTQyNCAwLjUxODA1IDcuMDc3NjggMC41IDcuMDAwMDYgMC41QzYuOTIyNDQgMC41IDYuODQ1ODggMC41MTgwNSA2Ljc3NjQ0IDAuNTUyNzI0TDAuNzc2NDM4IDMuNTUyNzJDMC42NTc4MTMgMy42MTIwMyAwLjU2NzYwOCAzLjcxNjA0IDAuNTI1NjY1IDMuODQxODZDMC41MDQ4OTcgMy45MDQxNSAwLjQ5NjYwNCAzLjk2OTkzIDAuNTAxMjU3IDQuMDM1NDRDMC41MDU5MTEgNC4xMDA5NCAwLjUyMzQyMSA0LjE2NDg5IDAuNTUyNzg4IDQuMjIzNjJDMC41ODIxNTUgNC4yODIzNiAwLjYyMjgwMyA0LjMzNDc0IDAuNjcyNDEzIDQuMzc3NzdDMC43MjIwMjIgNC40MjA3OSAwLjc3OTYyIDQuNDUzNjMgMC44NDE5MTkgNC40NzQ0QzAuOTY3NzM3IDQuNTE2MzQgMS4xMDUwNiA0LjUwNjU4IDEuMjIzNjkgNC40NDcyN0w3LjAwMDA5IDEuNTU5MDdMMTIuNzc2NyA0LjQ0NzI3QzEyLjg5NTMgNC41MDY1OCAxMy4wMzI2IDQuNTE2MzQgMTMuMTU4NSA0LjQ3NDRDMTMuMjIwOCA0LjQ1MzYzIDEzLjI3ODQgNC40MjA3OSAxMy4zMjggNC4zNzc3N0MxMy4zNzc2IDQuMzM0NzQgMTMuNDE4MiA0LjI4MjM2IDEzLjQ0NzYgNC4yMjM2MkMxMy40NzcgNC4xNjQ4OSAxMy40OTQ1IDQuMTAwOTQgMTMuNDk5MSA0LjAzNTQ0QzEzLjUwMzggMy45Njk5MyAxMy40OTU1IDMuOTA0MTUgMTMuNDc0NyAzLjg0MTg2QzEzLjQ1MzkgMy43Nzk1NiAxMy40MjExIDMuNzIxOTYgMTMuMzc4MSAzLjY3MjM1QzEzLjMzNTEgMy42MjI3NCAxMy4yODI3IDMuNTgyMDkgMTMuMjIzOSAzLjU1MjcyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8L3N2Zz4K"//CardConstants.numberInputUpDownArrowImage

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

            /*WCustomFocusItem {
                isRectangle: true
            }*/

        }

    }

    /*InputErrorMessage {
        id: _numberInputErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage
    }*/

}
/*Column {
    id: numberInput

    property var _adaptiveCard
    property bool _isRequired
    property bool _validationRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property bool showErrorMessage: false
    property double _minValue
    property double _maxValue
    property double _value
    property int _spinBoxMinVal : Math.max(-2147483648, _minValue)
    property int _spinBoxMaxVal : Math.min(2147483647, _maxValue)
    property bool _hasDefaultValue: false
    //property var numberInputConstants: CardConstants.inputNumberConstants
    //property var inputFieldConstants: CardConstants.inputFieldConstants
    property int minWidth:200// numberInputConstants.numberInputMinWidth
    property string _submitValue: _numberInputTextField.text ? Number(_numberInputTextField.text).toString() : ''

    function validate() {
        if (_numberInputTextField.text.length !== 0 && Number(_numberInputTextField.text) >= _minValue && Number(_numberInputTextField.text) <= _maxValue) {
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

    width:50//parent.width
    spacing: 3//inputFieldConstants.columnSpacing
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
        height: 32//inputFieldConstants.height

        Rectangle {
            id: _numberInputRectangle



            border.width: 1//inputFieldConstants.borderWidth
            border.color: "black"//showErrorMessage ? inputFieldConstants.borderColorOnError : inputFieldConstants.borderColorNormal
            radius: 8//inputFieldConstants.borderRadius
            height: parent.height
            color:"white"// _numberInputSpinBox.pressed ? inputFieldConstants.backgroundColorOnPressed : _numberInputSpinBox.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
            width: 400//parent.width - _numberInputArrowRectangle.width


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

                width:50// parent.width - _numberInputClearIcon.width - CardConstants.inputFieldConstants.clearIconHorizontalPadding
                padding: 0
                editable: true
                stepSize: 1
               // to: _spinBoxMaxVal
               // from: _spinBoxMinVal
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

                    font.pixelSize: 16//inputFieldConstants.pixelSize
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
                    leftPadding: 12//inputFieldConstants.textHorizontalPadding
                    rightPadding: 12//inputFieldConstants.textHorizontalPadding
                    topPadding: 4//inputFieldConstants.textVerticalPadding
                    bottomPadding: 4//inputFieldConstants.textVerticalPadding
                    placeholderText: _mEscapedPlaceholderString
                    Accessible.role: Accessible.EditableText
                    color: "black"//inputFieldConstants.textColor
                    placeholderTextColor: "white"//inputFieldConstants.placeHolderColor
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
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 12//CardConstants.inputFieldConstants.clearIconHorizontalPadding
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

            width: 31//numberInputConstants.upDownButtonWidth
            radius:8// inputFieldConstants.borderRadius
            height: parent.height
            border.color: "black"//inputFieldConstants.borderColorNormal
            activeFocusOnTab: true
            color:"gray" //(_numberInputArrowIcon.pressed || activeFocus) ? inputFieldConstants.backgroundColorOnPressed : _numberInputArrowIcon.hovered ? inputFieldConstants.backgroundColorOnHovered : inputFieldConstants.backgroundColorNormal
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
                horizontalPadding: 4//inputFieldConstants.iconPadding
                verticalPadding: 4//inputFieldConstants.iconPadding
                icon.width: 31//numberInputConstants.upDownIconSize
                icon.height:31// numberInputConstants.upDownIconSize
                focusPolicy: Qt.NoFocus
                icon.color: "black"//numberInputConstants.upDownIconColor
                height: parent.height
                icon.source: "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTQiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxNCAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEzLjQ0NzQgOS43NzYzOEMxMy40MTggOS43MTc2MyAxMy4zNzc0IDkuNjY1MjUgMTMuMzI3OCA5LjYyMjIyQzEzLjI3ODIgOS41NzkxOCAxMy4yMjA2IDkuNTQ2MzUgMTMuMTU4MyA5LjUyNTU4QzEzLjA5NiA5LjUwNDgxIDEzLjAzMDIgOS40OTY1MiAxMi45NjQ3IDkuNTAxMThDMTIuODk5MiA5LjUwNTgzIDEyLjgzNTIgOS41MjMzNSAxMi43NzY1IDkuNTUyNzNMNy4wMDAwNCAxMi40NDA5TDEuMjIzNzkgOS41NTI3M0MxLjEwNTE2IDkuNDkzNDEgMC45Njc4MzIgOS40ODM2NSAwLjg0MjAwOSA5LjUyNTU5QzAuNzE2MTg2IDkuNTY3NTIgMC42MTIxNzYgOS42NTc3MyAwLjU1Mjg2MSA5Ljc3NjM1QzAuNDkzNTQ1IDkuODk0OTggMC40ODM3ODIgMTAuMDMyMyAwLjUyNTcyIDEwLjE1ODFDMC41Njc2NTggMTAuMjg0IDAuNjU3ODYxIDEwLjM4OCAwLjc3NjQ4NiAxMC40NDczTDYuNzc2NDkgMTMuNDQ3M0M2Ljg0NTk0IDEzLjQ4MiA2LjkyMjUgMTMuNSA3LjAwMDE0IDEzLjVDNy4wNzc3NyAxMy41IDcuMTU0MzQgMTMuNDgyIDcuMjIzNzkgMTMuNDQ3M0wxMy4yMjM4IDEwLjQ0NzNDMTMuMjgyNSAxMC40MTc5IDEzLjMzNDkgMTAuMzc3MyAxMy4zNzc5IDEwLjMyNzdDMTMuNDIxIDEwLjI3OCAxMy40NTM4IDEwLjIyMDQgMTMuNDc0NiAxMC4xNTgxQzEzLjQ5NTMgMTAuMDk1OCAxMy41MDM2IDEwLjAzMDEgMTMuNDk4OSA5Ljk2NDU2QzEzLjQ5NDMgOS44OTkwNSAxMy40NzY4IDkuODM1MTEgMTMuNDQ3NCA5Ljc3NjM4WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMTMuMjIzOSAzLjU1MjcyTDcuMjIzNjkgMC41NTI3MjRDNy4xNTQyNCAwLjUxODA1IDcuMDc3NjggMC41IDcuMDAwMDYgMC41QzYuOTIyNDQgMC41IDYuODQ1ODggMC41MTgwNSA2Ljc3NjQ0IDAuNTUyNzI0TDAuNzc2NDM4IDMuNTUyNzJDMC42NTc4MTMgMy42MTIwMyAwLjU2NzYwOCAzLjcxNjA0IDAuNTI1NjY1IDMuODQxODZDMC41MDQ4OTcgMy45MDQxNSAwLjQ5NjYwNCAzLjk2OTkzIDAuNTAxMjU3IDQuMDM1NDRDMC41MDU5MTEgNC4xMDA5NCAwLjUyMzQyMSA0LjE2NDg5IDAuNTUyNzg4IDQuMjIzNjJDMC41ODIxNTUgNC4yODIzNiAwLjYyMjgwMyA0LjMzNDc0IDAuNjcyNDEzIDQuMzc3NzdDMC43MjIwMjIgNC40MjA3OSAwLjc3OTYyIDQuNDUzNjMgMC44NDE5MTkgNC40NzQ0QzAuOTY3NzM3IDQuNTE2MzQgMS4xMDUwNiA0LjUwNjU4IDEuMjIzNjkgNC40NDcyN0w3LjAwMDA5IDEuNTU5MDdMMTIuNzc2NyA0LjQ0NzI3QzEyLjg5NTMgNC41MDY1OCAxMy4wMzI2IDQuNTE2MzQgMTMuMTU4NSA0LjQ3NDRDMTMuMjIwOCA0LjQ1MzYzIDEzLjI3ODQgNC40MjA3OSAxMy4zMjggNC4zNzc3N0MxMy4zNzc2IDQuMzM0NzQgMTMuNDE4MiA0LjI4MjM2IDEzLjQ0NzYgNC4yMjM2MkMxMy40NzcgNC4xNjQ4OSAxMy40OTQ1IDQuMTAwOTQgMTMuNDk5MSA0LjAzNTQ0QzEzLjUwMzggMy45Njk5MyAxMy40OTU1IDMuOTA0MTUgMTMuNDc0NyAzLjg0MTg2QzEzLjQ1MzkgMy43Nzk1NiAxMy40MjExIDMuNzIxOTYgMTMuMzc4MSAzLjY3MjM1QzEzLjMzNTEgMy42MjI3NCAxMy4yODI3IDMuNTgyMDkgMTMuMjIzOSAzLjU1MjcyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8L3N2Zz4K"//CardConstants.numberInputUpDownArrowImage

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

            /*WCustomFocusItem {
                isRectangle: true
            }

        }

    }

    /*InputErrorMessage {
        id: _numberInputErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage
    }

}*/

