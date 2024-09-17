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
    CardConstants{
        id:cardConst
        
    }

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
    spacing: cardConst.inputFieldConstants.columnSpacing
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
     visible:numberinputModel.escapedLabelString
    }
    
    Row {
        id: numberInputRow
        
        width: parent.width
        height: cardConst.inputFieldConstants.height
        
        Rectangle {
            id: numberInputRectangle
            
            function colorChange(isPressed) {
                if (isPressed && !showErrorMessage)
                    color = inputFieldConstants.backgroundColorOnPressed;
                else
                    color = numberInputTextField.activeFocus ? cardConst.inputFieldConstants.backgroundColorOnPressed : numberInputTextField.hovered ? cardConst.inputFieldConstants.backgroundColorOnHovered : cardConst.inputFieldConstants.backgroundColorNormal;
            }
            
            border.width: cardConst.inputFieldConstants.borderWidth
            border.color: showErrorMessage ? cardConst.inputFieldConstants.borderColorOnError : cardConst.inputFieldConstants.borderColorNormal
            radius: cardConst.inputFieldConstants.borderRadius
            height: parent.height
            color: numberInputSpinBox.Opressed ? cardConst.inputFieldConstants.backgroundColorOnPressed : numberInputSpinBox.hovered ? cardConst.inputFieldConstants.backgroundColorOnHovered : cardConst.inputFieldConstants.backgroundColorNormal
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
                
                width: parent.width - numberInputClearIcon.width - cardConst.inputFieldConstants.clearIconHorizontalPadding
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
                    
                    font.pixelSize: cardConst.inputFieldConstants.pixelSize
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
                    
                    leftPadding: cardConst.inputFieldConstants.textHorizontalPadding
                    rightPadding: cardConst.inputFieldConstants.textHorizontalPadding
                    topPadding: cardConst.inputFieldConstants.textVerticalPadding
                    bottomPadding: cardConst.inputFieldConstants.textVerticalPadding
                    placeholderText: numberinputModel.placeHolder
                    Accessible.role: Accessible.EditableText
                    color: cardConst.inputFieldConstants.textColor
                    placeholderTextColor: cardConst.inputFieldConstants.placeHolderColor
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
                anchors.margins: cardConst.inputFieldConstants.clearIconHorizontalPadding
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
            
            width: cardConst.inputNumberConstants.upDownButtonWidth
            radius: cardConst.inputFieldConstants.borderRadius
            height: parent.height
            border.color: cardConst.inputFieldConstants.borderColorNormal
            activeFocusOnTab: true
            color:(numberInputArrowIcon.pressed || activeFocus) ? cardConst.inputFieldConstants.backgroundColorOnPressed : numberInputArrowIcon.hovered ? cardConst.inputFieldConstants.backgroundColorOnHovered : cardConst.inputFieldConstants.backgroundColorNormal
            
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
                horizontalPadding: cardConst.inputFieldConstants.iconPadding
                verticalPadding: cardConst.inputFieldConstants.iconPadding
                icon.width: cardConst.numberInputConstants.upDownIconSize
                icon.height: cardConst.numberInputConstants.upDownIconSize
                focusPolicy: Qt.NoFocus
                icon.color: cardConst.inputNumberConstants.upDownIconColor
                height: parent.height
                icon.source: cardConst.numberInputUpDownArrowImage
                
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