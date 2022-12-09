import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import AdaptiveCards 1.0


Column{
    id:_inputText   
    
    property int _spacing
    property color _labelColor
    property bool _isRequired: false
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceHolderString
    property string _mEscapedValueString
    property bool _supportsInterActivity
    property bool _supportsInlineAction
    property int _heightType
    property string _regex: ""
    property int _maxLength
    property string _submitValue
    property bool _isMultiLineText

    property int minWidth: 200
    spacing: _spacing
    width: parent.width


    /* Action Button To be discussed */
    property bool _isShowCardButton
    property var _inputtextTextField: !_isMultiLineText ? singlineLoaderElement.item.inputtextTextField : multilineLoaderElement.item.inputtextTextField 

    /* Ends here */

    property bool showErrorMessage: false
    function validate(){
       //Issue Here  const regex = new RegExp(String.raw`%s%s`);
        var isValid = (text !== '' && regex.test(text))
        if (showErrorMessage) {
            if (isValid) {
                showErrorMessage = false
            }
        }return !isValid
    }


    function getAccessibleName(){
        let accessibleName = '';if(showErrorMessage === true){
            accessibleName += String.raw`Error` + _mEscapedErrorString;
        }
        accessibleName += _mEscapedLabelString;
        if(_inputtextTextField.text !== ''){
            accessibleName += (_inputtextTextField.text + '. ');
        }
        else{
            accessibleName += _mEscapedPlaceHolderString;
        }
        console.log("Text is : " + _inputtextTextField.text)
        return accessibleName;
    }
    
    Label {
        id: _inputTextLabel
        wrapMode: Text.Wrap
        width: parent.width
        color: _labelColor
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        text: _isRequired ? _mEscapedLabelString + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : _mEscapedLabelString
        visible: text.length
    }

    Row {
        id: _inputtextTextFieldRow
        spacing: 5
        width: parent.width
        //height: _heightType == 1 ? parent.height > 0 ? parent.height :CardConstants.inputFieldConstants.multiLineTextHeight: CardConstants.inputFieldConstants.height


       Loader {
            id: singlineLoaderElement
            //property alias inputtextTextField: _inputtextTextFieldWrapper.__inputtextTextField
            height: item ? item.height : 0
            width: parent.width
            active: !_isMultiLineText
            sourceComponent: SingleLineTextInputRender {
                id: _inputtextTextFieldWrapper
                _showErrorMessage: showErrorMessage
            }
        }

        Loader {
            id: multilineLoaderElement
            //property alias inputtextTextField: _inputtextTextFieldWrapper.__inputtextTextField
            height: item ? item.height : 0
            width: parent.width
            active: _isMultiLineText
            sourceComponent: MultiLineTextInputRender {
                id: _inputtextTextFieldWrapper
                _showErrorMessage: showErrorMessage
            }
        }       
    }

    Label{
        id:_inputtextErrorMessage
        wrapMode:Text.Wrap
        width:parent.width
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored:true
        color: CardConstants.inputFieldConstants.errorMessageColor
        text: _mEscapedErrorString
        visible: showErrorMessage
    }

}
