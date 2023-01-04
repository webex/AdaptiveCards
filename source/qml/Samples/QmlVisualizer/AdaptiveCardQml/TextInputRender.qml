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
    property bool _isInlineShowCardAction
    property string _regex: ""
    property int _maxLength
    property string _submitValue
    property bool _isMultiLineText
    property bool _isheightStreched


    // Button Properties
    property var buttonConfigType
    property bool isIconLeftOfTitle
    property string escapedTitle
    property bool isShowCardButton
    property bool isActionSubmit
    property bool isActionOpenUrl
    property bool isActionToggleVisibility
    property bool hasIconUrl
    property string imgSource: ""
    property var toggleVisibilityTarget
    property var paramStr
    property bool is1_3Enabled
    property var adaptiveCard
    property var selectActionId


    property int minWidth: 200
    spacing: _spacing
    width: parent.width

    property bool _isShowCardButton
    property var _inputtextTextField: !_isMultiLineText ? singlineLoaderElement.item.inputtextTextField : multilineLoaderElement.item.inputtextTextField 

    property bool showErrorMessage: false
    function validate(){
       const regex = new RegExp(String.raw`%s%s`);
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
        visible: text.length && is1_3Enabled
    }

    Row {
        id: _inputtextTextFieldRow
        spacing: 5
        width: parent.width
        height: _isheightStreched ? getStrechHeight() : implicitHeight

       function getStrechHeight() {
            if(_isheightStreched || _isMultiLineText) {
                return  parent.height > 0 ? parent.height : CardConstants.inputTextConstants.multiLineTextHeight
            }
        }
       Loader {
            id: singlineLoaderElement
            height: item ? item.height : 0
            width: (_supportsInterActivity && !_isInlineShowCardAction) ? parent.width - ( buttonLoaderElement.width + _inputtextTextFieldRow.spacing ) : parent.width
            active: !_isMultiLineText
            sourceComponent: SingleLineTextInputRender {
                id: _inputtextTextFieldWrapper
                _showErrorMessage: showErrorMessage
            }
        }

        Loader {
            id: multilineLoaderElement
            height: _isheightStreched ? parent.height : _isMultiLineText ? CardConstants.inputTextConstants.multiLineTextHeight : 0
            width: (_supportsInterActivity && !_isInlineShowCardAction) ? parent.width - ( buttonLoaderElement.width + _inputtextTextFieldRow.spacing ) : parent.width
            active: _isMultiLineText
            sourceComponent: MultiLineTextInputRender {
                id: _inputtextTextFieldWrapper
                _showErrorMessage: showErrorMessage
                height: _isheightStreched ? parent.height : CardConstants.inputTextConstants.multiLineTextHeight
            }
        }     
        
        Loader {
            id: buttonLoaderElement
            active: (_supportsInterActivity && !_isInlineShowCardAction)
            anchors.bottom: _isMultiLineText ? parent.bottom : undefined
            sourceComponent: AdaptiveActionRender {
                id: _inputtextTextFieldWrapper
                _buttonConfigType: buttonConfigType
                _isIconLeftOfTitle: isIconLeftOfTitle
                _escapedTitle: escapedTitle
                _isShowCardButton: isShowCardButton
                _isActionSubmit: isActionSubmit
                _isActionOpenUrl: isActionOpenUrl
                _isActionToggleVisibility: isActionToggleVisibility
                _hasIconUrl: hasIconUrl
                _imgSource: imgSource
                _toggleVisibilityTarget: toggleVisibilityTarget
                _paramStr: paramStr
                _is1_3Enabled: is1_3Enabled
                _adaptiveCard: adaptiveCard
                _selectActionId: selectActionId
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
