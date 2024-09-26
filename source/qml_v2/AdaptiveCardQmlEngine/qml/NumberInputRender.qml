import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Column {
    id: numberInput
    property var numberinputModel:model.numberInputRole
    property bool showErrorMessage: false
    property int spinBoxMinVal : Math.max(-2147483648, numberinputModel.minValue)
    property int spinBoxMaxVal : Math.min(2147483647, numberinputModel.maxValue)
    
    function validate() {
        if (numberInputTextField.text.length !== 0 && Number(numberInputTextField.text) >= numberinputModel.minValue && Number(numberInputTextField.text) <= numberinputModel.maxValue) {
            showErrorMessage = false;
            return false;
        } else {
            return true;
        }
    }
    
    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage)
            accessibleName += 'Error. ' + numberinputModel.escapedErrorString + '. ';
        
        if (numberinputModel.escapedLabelString)
            accessibleName += numberinputModel.escapedLabelString + '. ';
        
        if (numberInputTextField.text !== '')
            accessibleName += (numberInputTextField.text);
        else
            accessibleName += numberinputModel.placeHolder;
        accessibleName += qsTr(", Type the number");
        return accessibleName;
    }
    width: parent.width
    spacing: CardConstants.inputFieldConstants.columnSpacing
    onShowErrorMessageChanged: {
        numberInputRectangle.colorChange(false);
    }
    onActiveFocusChanged: {
        if (activeFocus)
            numberInputTextField.forceActiveFocus();
        
    }
    visible: numberinputModel.visible
    InputLabel {
        id: numberInputLabel
        required: numberinputModel.isRequired
        label:  numberinputModel.escapedLabelString
        visible:numberinputModel.escapedLabelString
    }
    
    Row {
        id: numberInputRow
        
        width: parent.width
        height: CardConstants.inputFieldConstants.height
        
        Rectangle {
            id: numberInputRectangle
            
            function colorChange(isPressed) {
                if (isPressed && !showErrorMessage)
                    color = inputFieldConstants.backgroundColorOnPressed;
                else
                    color = numberInputTextField.activeFocus ? CardConstants.inputFieldConstants.backgroundColorOnPressed : numberInputTextField.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal;
            }
            
            border.width: CardConstants.inputFieldConstants.borderWidth
            border.color: showErrorMessage ? CardConstants.inputFieldConstants.borderColorOnError : CardConstants.inputFieldConstants.borderColorNormal
            radius: CardConstants.inputFieldConstants.borderRadius
            height: parent.height
            color: numberInputSpinBox.Opressed ? CardConstants.inputFieldConstants.backgroundColorOnPressed : numberInputSpinBox.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal
            width: parent.width - numberInputArrowRectangle.width
            WCustomFocusItem {
                isRectangle: true
                visible: numberInputTextField.activeFocus
            }
            
            SpinBox {
                id: numberInputSpinBox
                
                
                function changeValue(keyPressed) {
                    if ((keyPressed === Qt.Key_Up || keyPressed === Qt.Key_Down) && numberInputTextField.text.length === 0) {
                        value = (from > 0) ? from : 0;
                    } else if (keyPressed === Qt.Key_Up) {
                        numberInputSpinBox.value = Number(numberInputTextField.text);
                        numberInputSpinBox.increase();
                    } else if (keyPressed === Qt.Key_Down) {
                        numberInputSpinBox.value = Number(numberInputTextField.text);
                        numberInputSpinBox.decrease();
                    }
                    numberInputTextField.text = numberInputSpinBox.value;
                }
                
                width: parent.width - numberInputClearIcon.width - CardConstants.inputFieldConstants.clearIconHorizontalPadding
                padding: 0
                editable: true
                stepSize: 1
                to: spinBoxMaxVal
                from: spinBoxMinVal
                Keys.onPressed: {
                    if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                        numberInputSpinBox.changeValue(event.key);
                        event.accepted = true;
                    }
                }
                Accessible.ignored: true
                Component.onCompleted: {
                    if (numberinputModel.defaultValue)
                        numberInputSpinBox.value = numberinputModel.value;
                    
                }
                
                contentItem: TextField {
                    id: numberInputTextField
                    
                    font.pixelSize: CardConstants.inputFieldConstants.pixelSize
                    anchors.left: parent.left
                    anchors.right: parent.right
                    selectByMouse: true
                    selectedTextColor: 'white'
                    readOnly: !numberInputSpinBox.editable
                    validator: numberInputSpinBox.validator
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    onPressed: {
                        numberInputRectangle.colorChange(true);
                        event.accepted = true;
                    }
                    onReleased: {
                        numberInputRectangle.colorChange(false);
                        forceActiveFocus();
                        event.accepted = true;
                    }
                    onHoveredChanged: numberInputRectangle.colorChange(false)
                    onActiveFocusChanged: {
                        numberInputRectangle.colorChange(false);
                        Accessible.name = getAccessibleName();
                    }
                    
                    leftPadding: CardConstants.inputFieldConstants.textHorizontalPadding
                    rightPadding: CardConstants.inputFieldConstants.textHorizontalPadding
                    topPadding: CardConstants.inputFieldConstants.textVerticalPadding
                    bottomPadding: CardConstants.inputFieldConstants.textVerticalPadding
                    placeholderText: numberinputModel.placeHolder
                    Accessible.role: Accessible.EditableText
                    color: CardConstants.inputFieldConstants.textColor
                    placeholderTextColor: CardConstants.inputFieldConstants.placeHolderColor
                    onTextChanged: {
                        validate();
                    }
                    Component.onCompleted: {
                        if (numberinputModel.defaultValue)
                            numberInputTextField.text = numberInputSpinBox.value;  
                    }
                    
                    background: Rectangle {
                        id: numberInputTextFieldBg
                        
                        color: 'transparent'
                    }
                    
                }
                
                background: Rectangle {
                    id: numberSpinBoxBg
                    
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
                id: numberInputClearIcon
                
                Keys.onReturnPressed: onClicked()
                visible: numberInputTextField.length !== 0
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: CardConstants.inputFieldConstants.clearIconHorizontalPadding
                onClicked: {
                    nextItemInFocusChain().forceActiveFocus();
                    numberInputSpinBox.value = numberInputSpinBox.from;
                    numberInputTextField.clear();
                }
            }
        }
        
        Rectangle {
            id: numberInputArrowRectangle
            
            property string accessibilityPrefix: ''
            
            width: CardConstants.inputNumberConstants.upDownButtonWidth
            radius: CardConstants.inputFieldConstants.borderRadius
            height: parent.height
            border.color: CardConstants.inputFieldConstants.borderColorNormal
            activeFocusOnTab: true
            color:(numberInputArrowIcon.pressed || activeFocus) ? CardConstants.inputFieldConstants.backgroundColorOnPressed : numberInputArrowIcon.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal
            
            Keys.onPressed: {
                if (event.key === Qt.Key_Up || event.key === Qt.Key_Down) {
                    numberInputSpinBox.changeValue(event.key);
                    accessibilityPrefix = '';
                    event.accepted = true;
                }
            }
            onActiveFocusChanged: {
                if (activeFocus)
                    accessibilityPrefix = qsTr("Use up arrow to increase the value and down arrow to decrease the value") + (numberInputTextField.text ? ", Current number is " : "");
                
            }
            Accessible.name: accessibilityPrefix + numberInputTextField.displayText
            Accessible.role: Accessible.NoRole
            
            Button {
                id: numberInputArrowIcon
                
                width: parent.width
                anchors.right: parent.right
                horizontalPadding: CardConstants.inputFieldConstants.iconPadding
                verticalPadding: CardConstants.inputFieldConstants.iconPadding
                icon.width: CardConstants.numberInputConstants.upDownIconSize
                icon.height: CardConstants.numberInputConstants.upDownIconSize
                focusPolicy: Qt.NoFocus
                icon.color: CardConstants.inputNumberConstants.upDownIconColor
                height: parent.height
                icon.source: CardConstants.numberInputUpDownArrowImage
                
                background: Rectangle {
                    color: 'transparent'
                }
            }
            
            MouseArea {
                id: numberInputSpinBoxUpIndicatorArea
                
                width: parent.width
                height: parent.height / 2
                anchors.top: parent.top
                onReleased: {
                    numberInputSpinBox.changeValue(Qt.Key_Up);
                    numberInputArrowRectangle.forceActiveFocus();
                }
            }
            
            MouseArea {
                id: numberInputSpinBoxDownIndicatorArea
                
                width: parent.width
                height: parent.height / 2
                anchors.top: numberInputSpinBoxUpIndicatorArea.bottom
                onReleased: {
                    numberInputSpinBox.changeValue(Qt.Key_Down);
                    numberInputArrowRectangle.forceActiveFocus();
                }
            }
            
            WCustomFocusItem {
                isRectangle: true
            }
        }
    }
    
    InputErrorMessage {
        id: numberInputErrorMessage
        visible: showErrorMessage
    }
}