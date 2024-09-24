import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Rectangle {
    id: multiLineTextElementRect

    property bool errorMessageVisible
    property string textValue: inputtextTextField.text

    width: parent.width
    height: cardConst.inputTextConstants.multiLineTextHeight
    color: 'transparent'

    ScrollView {
        id: multiLineTextScrollView

        anchors.fill: parent
        ScrollBar.vertical.interactive: true
        ScrollBar.horizontal.interactive: false
        ScrollBar.horizontal.visible: false

        TextArea {
            id: inputtextTextField

            property bool outerShowErrorMessage: errorMessageVisible

            function assignMaxLength() {
                if (textInputModel.maxLength != 0)
                    maximumLength = textInputModel.maxLength;
            }

            function colorChange(colorItem, focusItem, isPressed) {
                if (isPressed && !focusItem.outerShowErrorMessage)
                    colorItem.color = cardConst.inputFieldConstants.backgroundColorOnPressed;
                else
                    colorItem.color = focusItem.activeFocus ? cardConst.inputFieldConstants.backgroundColorOnPressed : focusItem.hovered ? cardConst.inputFieldConstants.backgroundColorOnHovered : cardConst.inputFieldConstants.backgroundColorNormal;
            }

            wrapMode: Text.Wrap
            selectByMouse: true
            selectedTextColor: 'white'
            color: cardConst.inputFieldConstants.textColor
            placeholderTextColor: cardConst.inputFieldConstants.placeHolderColor
            leftPadding: cardConst.inputFieldConstants.textHorizontalPadding
            rightPadding: cardConst.inputFieldConstants.textHorizontalPadding
            height: inputtextTextFieldWrapper.height // need to check for strech height
            width: inputtextTextFieldWrapper.width
            Accessible.role: Accessible.EditableText
            onTextChanged: {
                if (textInputModel.maxLength != 0)
                    remove(textInputModel.maxLength, length);
            }

            Component.onCompleted: {
                assignMaxLength();
            }

            onOuterShowErrorMessageChanged: {
                if (textInputModel.isRequired || textInputModel.regex != "")
                    colorChange(multilinetextidTextFieldBackground, inputtextTextField, false);
            }

            onPressed: {
                colorChange(multilinetextidTextFieldBackground, inputtextTextField, true);
                event.accepted = true;
            }

            onReleased: {
                colorChange(multilinetextidTextFieldBackground, inputtextTextField, false);
                forceActiveFocus();
                event.accepted = true;
            }

            onHoveredChanged: colorChange(multilinetextidTextFieldBackground, inputtextTextField, false)
            onActiveFocusChanged: {
                colorChange(multilinetextidTextFieldBackground, inputtextTextField, false);
                if (activeFocus)
                    Accessible.name = getAccessibleName();
            }

            Accessible.name: ""
            Keys.onTabPressed: {
                nextItemInFocusChain().forceActiveFocus();
                event.accepted = true;
            }
            Keys.onBacktabPressed: {
                nextItemInFocusChain(false).forceActiveFocus();
                event.accepted = true;
            }
            font.pixelSize: cardConst.inputFieldConstants.pixelSize
            text: textInputModel.value
            placeholderText: activeFocus ? '' : textInputModel.placeholder

            background: Rectangle {
                id: multilinetextidTextFieldBackground

                radius: cardConst.inputFieldConstants.borderRadius
                color: cardConst.inputFieldConstants.backgroundColorNormal
                border.color: inputtextTextField.outerShowErrorMessage ? cardConst.inputFieldConstants.borderColorOnError : cardConst.inputFieldConstants.borderColorNormal
                border.width: cardConst.inputFieldConstants.borderWidth
            }
        }
    }

    WCustomFocusItem {
        isRectangle: true
        visible: inputtextTextField.activeFocus
        designatedParent: parent
    }
}