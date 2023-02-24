import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: multiLineTextElementRect

    property bool _showErrorMessage
    property alias inputtextTextField: _inputtextTextField

    width: parent.width
    height: CardConstants.inputTextConstants.multiLineTextHeight
    color: 'transparent'

    ScrollView {
        id: multiLineTextScrollView

        anchors.fill: parent
        ScrollBar.vertical.interactive: true
        ScrollBar.horizontal.interactive: false
        ScrollBar.horizontal.visible: false

        TextArea {
            id: _inputtextTextField

            property bool outerShowErrorMessage: _showErrorMessage

            function assignMaxLength() {
                if (_maxLength != 0)
                    maximumLength:
                    _maxLength;

            }

            function colorChange(colorItem, focusItem, isPressed) {
                if (isPressed && !focusItem.outerShowErrorMessage)
                    colorItem.color = CardConstants.inputFieldConstants.backgroundColorOnPressed;
                else
                    colorItem.color = focusItem.outerShowErrorMessage ? CardConstants.inputFieldConstants.backgroundColorOnError : focusItem.activeFocus ? CardConstants.inputFieldConstants.backgroundColorOnPressed : focusItem.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal;
            }

            wrapMode: Text.Wrap
            selectByMouse: true
            selectedTextColor: 'white'
            color: CardConstants.inputFieldConstants.textColor
            placeholderTextColor: CardConstants.inputFieldConstants.placeHolderColor
            leftPadding: CardConstants.inputFieldConstants.textHorizontalPadding
            rightPadding: CardConstants.inputFieldConstants.textHorizontalPadding
            height: _inputtextTextFieldWrapper.height // need to check for strech height
            width: _inputtextTextFieldWrapper.width
            Accessible.role: Accessible.EditableText
            onTextChanged: {
                if (_maxLength != 0)
                    remove(_maxLength, length);

                if (_isRequired || _regex != "")
                    validate();

                _submitValue = text;
            }
            Component.onCompleted: {
                assignMaxLength();
            }
            onOuterShowErrorMessageChanged: {
                if (_isRequired || _regex != "")
                    colorChange(_multilinetextidTextFieldBackground, _inputtextTextField, false);

            }
            onPressed: {
                colorChange(_multilinetextidTextFieldBackground, _inputtextTextField, true);
                event.accepted = true;
            }
            onReleased: {
                colorChange(_multilinetextidTextFieldBackground, _inputtextTextField, false);
                forceActiveFocus();
                event.accepted = true;
            }
            onHoveredChanged: colorChange(_multilinetextidTextFieldBackground, _inputtextTextField, false)
            onActiveFocusChanged: {
                colorChange(_multilinetextidTextFieldBackground, _inputtextTextField, false);
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
            font.pixelSize: CardConstants.inputFieldConstants.pixelSize
            text: _mEscapedValueString
            placeholderText: activeFocus ? '' : _mEscapedPlaceHolderString

            background: Rectangle {
                id: _multilinetextidTextFieldBackground

                radius: CardConstants.inputFieldConstants.borderRadius
                color: CardConstants.inputFieldConstants.backgroundColorNormal
                border.color: _inputtextTextField.outerShowErrorMessage ? CardConstants.inputFieldConstants.borderColorOnError : CardConstants.inputFieldConstants.borderColorNormal
                border.width: CardConstants.inputFieldConstants.borderWidth
            }

        }

    }

    WCustomFocusItem {
        isRectangle: true
        visible: _inputtextTextField.activeFocus
        designatedParent: parent
    }

}
