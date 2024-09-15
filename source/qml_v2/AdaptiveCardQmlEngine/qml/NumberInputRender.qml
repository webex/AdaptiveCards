import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils
Column {
    id: numberInput

    CardConstants{

        id:cardConst
    }

    width: parent.width
    spacing: cardConst.inputFieldConstants.columnSpacing

    InputLabel {
        id: numberInputLabel

        label: "This is the label "
        required: true
        visible: label
    }

    Row {
        id: numberInputRow

        width: parent.width
        height: cardConst.inputFieldConstants.height

        Rectangle {
            id: numberInputRectangle

            border.width: cardConst.inputFieldConstants.borderWidth
            border.color: true ? cardConst.inputFieldConstants.borderColorOnError : cardConst.inputFieldConstants.borderColorNormal
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

                width: parent.width - numberInputClearIcon.width - cardConst.inputFieldConstants.clearIconHorizontalPadding
                padding: 0
                editable: true
                stepSize: 1
                Accessible.ignored: true

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
                    placeholderText: "Enter a number"
                    Accessible.role: Accessible.EditableText
                    color: cardConst.inputFieldConstants.textColor
                    placeholderTextColor: cardConst.inputFieldConstants.placeHolderColor
                  
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
            }

            MouseArea {
                id: numberInputSpinBoxDownIndicatorArea

                width: parent.width
                height: parent.height / 2
                anchors.top: numberInputSpinBoxUpIndicatorArea.bottom
            }

            WCustomFocusItem {
                isRectangle: true
            }
        }
    }

     InputErrorMessage {
        id: numberInputErrorMessage

        isErrorMessage:"errorMessage"
        visible: true
    }
}