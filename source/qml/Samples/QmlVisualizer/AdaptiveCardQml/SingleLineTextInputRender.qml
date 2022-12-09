import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {

    property bool _showErrorMessage
    property alias inputtextTextField: _inputtextTextField

    border.color:_inputtextTextField.outerShowErrorMessage? CardConstants.inputFieldConstants.borderColorOnError:_inputtextTextField.activeFocus? CardConstants.inputFieldConstants.borderColorOnFocus : CardConstants.inputFieldConstants.borderColorNormal
    border.width: CardConstants.inputFieldConstants.borderWidth
    radius: CardConstants.inputFieldConstants.borderRadius
    width: (_supportsInterActivity== true && _supportsInlineAction == true) ? parent.width - button_auto_1.width - _inputtext_textField_row.spacing : parent.width
    color: CardConstants.inputFieldConstants.backgroundColorNormal
    height: CardConstants.inputFieldConstants.height

    TextField {
        property bool outerShowErrorMessage: _showErrorMessage
        id: _inputtextTextField
        selectByMouse: true
        selectedTextColor: 'white'
        color: CardConstants.inputFieldConstants.textColor
        placeholderTextColor: CardConstants.inputFieldConstants.placeHolderColor
        Accessible.role:Accessible.EditableText

        background:Rectangle{
            color:'transparent'
        }

        function colorChange(colorItem,focusItem,isPressed) {
            if (isPressed && !focusItem.outerShowErrorMessage) {
                colorItem.color = CardConstants.inputFieldConstants.backgroundColorOnPressed
            }
            else {
                colorItem.color = focusItem.outerShowErrorMessage ? CardConstants.inputFieldConstants.backgroundColorOnError : focusItem.activeFocus ? CardConstants.inputFieldConstants.backgroundColorOnPressed : focusItem.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal
            }
        }

        onPressed:{colorChange(_inputtextTextFieldWrapper,_inputtextTextField,true);event.accepted = true;}
        onReleased:{colorChange(_inputtextTextFieldWrapper,_inputtextTextField,false);forceActiveFocus();event.accepted = true;}
        onHoveredChanged:colorChange(_inputtextTextFieldWrapper,_inputtextTextField,false)
        onActiveFocusChanged:{
            colorChange(_inputtextTextFieldWrapper,_inputtextTextField,false)
            if(activeFocus){
                Accessible.name = getAccessibleName()
            }
        }
                
        onOuterShowErrorMessageChanged: { if(_isRequired || _regex != "" ) {
                colorChange(_inputtextTextFieldWrapper,_inputtextTextField, false) 
            }
        }

        Accessible.name: ""
        leftPadding: CardConstants.inputFieldConstants.textHorizontalPadding
        rightPadding: CardConstants.inputFieldConstants.textHorizontalPadding
        topPadding: CardConstants.inputFieldConstants.textVerticalPadding
        bottomPadding: CardConstants.inputFieldConstants.textVerticalPadding
        padding: 0
                

        function assignMaxLength() {
            if(_maxLength != 0) { maximumLength = _maxLength;}
        }
        font.pixelSize: CardConstants.inputFieldConstants.pixelSize
        text: _mEscapedValueString
        placeholderText:activeFocus? '' : _mEscapedPlaceHolderString
        width:parent.width

        onTextChanged: { if(_isRequired || _regex != "" ) {
                validate()
            }
            _submitValue = text
        }

        Component.onCompleted: {
            assignMaxLength();
        }
    }


    Button{
        background:Rectangle{
            color:'transparent'
        }
                         
        width: CardConstants.inputFieldConstants.clearIconSize
        anchors.right:parent.right
        anchors.margins: CardConstants.inputFieldConstants.clearIconHorizontalPadding
        horizontalPadding:0
        verticalPadding:0
        icon.width: CardConstants.inputFieldConstants.clearIconSize
        icon.height: CardConstants.inputFieldConstants.clearIconSize
        icon.color:activeFocus ? CardConstants.inputFieldConstants.clearIconColorOnFocus : CardConstants.inputFieldConstants.clearIconColorNormal
        anchors.verticalCenter:parent.verticalCenter
        icon.source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHZpZXdCb3g9IjAgMCAxMCAxMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+Y29tbW9uLWFjdGlvbnMvY2FuY2VsXzEwPC90aXRsZT48cGF0aCBkPSJNNS43MDcyNSA1LjAwMDI1bDIuNjQ2LTIuNjQ2Yy4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDgtLjE5NS0uMTk1LS41MTEtLjE5NS0uNzA3IDBsLTIuNjQ2IDIuNjQ3LTIuNjQ3LTIuNjQ3Yy0uMTk1LS4xOTUtLjUxMS0uMTk1LS43MDcgMC0uMTk1LjE5Ni0uMTk1LjUxMiAwIC43MDhsMi42NDcgMi42NDYtMi42NDcgMi42NDZjLS4xOTUuMTk2LS4xOTUuNTEyIDAgLjcwOC4wOTguMDk3LjIyNi4xNDYuMzU0LjE0Ni4xMjggMCAuMjU2LS4wNDkuMzUzLS4xNDZsMi42NDctMi42NDcgMi42NDYgMi42NDdjLjA5OC4wOTcuMjI2LjE0Ni4zNTQuMTQ2LjEyOCAwIC4yNTYtLjA0OS4zNTMtLjE0Ni4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDhsLTIuNjQ2LTIuNjQ2eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
        Keys.onReturnPressed:onClicked()
        id:_inputtextTextFieldClearIcon
        visible:_inputtextTextField.text.length != 0
        onClicked:{nextItemInFocusChain().forceActiveFocus();_inputtextTextField.clear()}
        Accessible.name: "String.raw`" + (_mEscapedPlaceHolderString == "" ? "Text": _mEscapedPlaceHolderString) + " clear`"
        Accessible.role:Accessible.Button
    }         
}

