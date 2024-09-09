import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Rectangle {
    id: singleLineTextElementRect

    property bool _showErrorMessage
    property string textValue: inputtextTextField.text

    border.color: inputtextTextField.outerShowErrorMessage ? cardConst.inputFieldConstants.borderColorOnError : cardConst.inputFieldConstants.borderColorNormal
    border.width: cardConst.inputFieldConstants.borderWidth
    radius: cardConst.inputFieldConstants.borderRadius
    color: cardConst.inputFieldConstants.backgroundColorNormal
    height: cardConst.inputFieldConstants.height

    TextField {
        id: inputtextTextField

        property bool outerShowErrorMessage: _showErrorMessage

        function colorChange(colorItem, focusItem, isPressed) {
            if (isPressed && !focusItem.outerShowErrorMessage)
                colorItem.color = cardConst.inputFieldConstants.backgroundColorOnPressed;
            else
                colorItem.color = focusItem.activeFocus ? cardConst.inputFieldConstants.backgroundColorOnPressed : focusItem.hovered ? cardConst.inputFieldConstants.backgroundColorOnHovered : cardConst.inputFieldConstants.backgroundColorNormal ;
        } 

        function assignMaxLength() {
            if (textInputModel.maxLength != 0)
                maximumLength = textInputModel.maxLength;

        }

        selectByMouse: true
        selectedTextColor: 'white'
        color: cardConst.inputFieldConstants.textColor
        placeholderTextColor: cardConst.inputFieldConstants.placeHolderColor
        Accessible.role: Accessible.EditableText
        onPressed: {
            colorChange(inputtextTextFieldWrapper, inputtextTextField, true);
            event.accepted = true;
        }
        onReleased: {
            colorChange(inputtextTextFieldWrapper, inputtextTextField, false);
            forceActiveFocus();
            event.accepted = true;
        }
        onHoveredChanged: colorChange(inputtextTextFieldWrapper, inputtextTextField, false)
        onActiveFocusChanged: {
            colorChange(inputtextTextFieldWrapper, inputtextTextField, false);
            if (activeFocus)
                Accessible.name = getAccessibleName();

        }
        onOuterShowErrorMessageChanged: {
            if (textInputModel.isRequired || textInputModel.regex != "")
                colorChange(inputtextTextFieldWrapper, inputtextTextField, false);

        }
        Accessible.name: ""
        leftPadding: cardConst.inputFieldConstants.textHorizontalPadding
        rightPadding: cardConst.inputFieldConstants.textHorizontalPadding
        topPadding: cardConst.inputFieldConstants.textVerticalPadding
        bottomPadding: cardConst.inputFieldConstants.textVerticalPadding
        padding: 0
        font.pixelSize: cardConst.inputFieldConstants.pixelSize
        text: textInputModel.value
        placeholderText: activeFocus ? '' : textInputModel.placeholder
        width: parent.width
        onTextChanged: {
            if (textInputModel.maxLength != 0)
                remove(textInputModel.maxLength, length);

        }
        Component.onCompleted: {
            assignMaxLength();
        }

        background: Rectangle {
            color: 'transparent'
        }

    }

    InputFieldClearIcon {
        id: inputtextTextFieldClearIcon

        Keys.onReturnPressed: onClicked()
        visible: inputtextTextField.text.length != 0
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: cardConst.inputFieldConstants.clearIconHorizontalPadding
        onClicked: {
            nextItemInFocusChain().forceActiveFocus();
            inputtextTextField.clear();
        }
    }

/*   WCustomFocusItem {
        isRectangle: true
        visible: inputtextTextField.activeFocus
        designatedParent: parent
    } */
    
}
