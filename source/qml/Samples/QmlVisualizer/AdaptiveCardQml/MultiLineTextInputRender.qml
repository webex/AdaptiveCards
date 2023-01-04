import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {

    property bool _showErrorMessage
    property alias inputtextTextField: _inputtextTextField

    width: parent.width
    height: CardConstants.inputTextConstants.multiLineTextHeight
    color:'transparent'

    ScrollView {
        anchors.fill:parent
        ScrollBar.vertical.interactive:true
        ScrollBar.horizontal.interactive:false
        ScrollBar.horizontal.visible:false

        TextArea {
            property bool outerShowErrorMessage: _showErrorMessage
            id: _inputtextTextField
            wrapMode:Text.Wrap
            selectByMouse:true
            selectedTextColor:'white'
            color: CardConstants.inputFieldConstants.textColor
            placeholderTextColor: CardConstants.inputFieldConstants.placeHolderColor
            leftPadding: CardConstants.inputFieldConstants.textHorizontalPadding
            rightPadding: CardConstants.inputFieldConstants.textHorizontalPadding
            height:_inputtextTextFieldWrapper.height// need to check for strech height
            width:_inputtextTextFieldWrapper.width
            Accessible.role:Accessible.EditableText
            function assignMaxLength() {
                if(_maxLength != 0) { maximumLength = _maxLength;}
            }
            onTextChanged: { if(_maxLength != 0) {remove(_maxLength, length) }
            if(_isRequired || _regex != "" ) {
                    validate()
                }
                _submitValue = text
            }
            Component.onCompleted: {
                assignMaxLength();
            }

            background:Rectangle{
                radius: CardConstants.inputFieldConstants.borderRadius
                id: _multilinetextidTextFieldBackground
                color: CardConstants.inputFieldConstants.backgroundColorNormal
                border.color:_inputtextTextField.outerShowErrorMessage? CardConstants.inputFieldConstants.borderColorOnError:_inputtextTextField.activeFocus? CardConstants.inputFieldConstants.borderColorOnFocus : CardConstants.inputFieldConstants.borderColorNormal
                border.width: CardConstants.inputFieldConstants.borderWidth
            }

            function colorChange(colorItem,focusItem,isPressed) {
                if (isPressed && !focusItem.outerShowErrorMessage) {
                    colorItem.color = CardConstants.inputFieldConstants.backgroundColorOnPressed
                }
                else {
                    colorItem.color = focusItem.outerShowErrorMessage ? CardConstants.inputFieldConstants.backgroundColorOnError : focusItem.activeFocus ? CardConstants.inputFieldConstants.backgroundColorOnPressed : focusItem.hovered ? CardConstants.inputFieldConstants.backgroundColorOnHovered : CardConstants.inputFieldConstants.backgroundColorNormal
                }
            }

            onOuterShowErrorMessageChanged: { if(_isRequired || _regex != "" ) {
                    colorChange(_multilinetextidTextFieldBackground,_inputtextTextField, false) 
                }
            }

            onPressed:{colorChange(_multilinetextidTextFieldBackground,_inputtextTextField,true);event.accepted = true;}
            onReleased:{colorChange(_multilinetextidTextFieldBackground,_inputtextTextField,false);forceActiveFocus();event.accepted = true;}
            onHoveredChanged:colorChange(_multilinetextidTextFieldBackground,_inputtextTextField,false)
            onActiveFocusChanged:{
                colorChange(_multilinetextidTextFieldBackground,_inputtextTextField,false)
                if(activeFocus){
                    Accessible.name = getAccessibleName()
                }
            }

            Accessible.name:""
            Keys.onTabPressed:{nextItemInFocusChain().forceActiveFocus(); event.accepted = true;}
            Keys.onBacktabPressed:{nextItemInFocusChain(false).forceActiveFocus(); event.accepted = true;}
            font.pixelSize: CardConstants.inputFieldConstants.pixelSize
            text: _mEscapedValueString
            placeholderText: activeFocus? '' : _mEscapedPlaceHolderString
        }

    }


}