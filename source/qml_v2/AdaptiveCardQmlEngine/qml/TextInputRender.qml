import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import AdaptiveCardQmlEngine 1.0
import "JSUtils/AdaptiveCardUtils.js" as AdaptiveCardUtils

Column {
    id: inputText

    CardConstants {
        id: cardConst
    }

    property var textInputModel: model.textInputRole
    property bool _isMultiLineText
    property bool isheightStreched
    property string submitValue: !_isMultiLineText ? singlineLoaderElement.item.textValue : multilineLoaderElement.item.textValue
    property bool showErrorMessage: true

    function validate() {
        const regex = new RegExp(textInputModel.regex);
        let isValid = true;

        if (textInputModel.isRequired)
            isValid = (submitValue !== '' && regex.test(submitValue));
        else if (submitValue !== '')
            isValid = regex.test(submitValue);

        if (showErrorMessage && isValid)
            showErrorMessage = false;

        return !isValid;
    } 

    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage === true)
            accessibleName += "Error" + textInputModel.errorMessage;

        accessibleName += textInputModel.label;
        if (submitValue !== '')
            accessibleName += (submitValue + '. ');
        else
            accessibleName += textInputModel.placeholder;

        accessibleName += qsTr(", Type the text");
        return accessibleName;
    }

    visible: textInputModel.isVisible
    spacing: textInputModel.spacing
    width: parent.width
    onActiveFocusChanged: {
        if (activeFocus)
            nextItemInFocusChain().forceActiveFocus();

    }
    onSubmitValueChanged: {
        if (textInputModel.isRequired || textInputModel.regex != "")
            validate();

    }
    onShowErrorMessageChanged: {
        if (isheightStreched && _isMultiLineText) {
            if (showErrorMessage)
                inputtextTextFieldRow.height = inputtextTextFieldRow.height - inputtextErrorMessage.height;
            else
                inputtextTextFieldRow.height = inputtextTextFieldRow.height + inputtextErrorMessage.height;
        }
    }

    InputLabel {
        id: inputTextLabel
        
        required: textInputModel.isRequired
        visible: textInputModel.isVisible
      
    } 

    Row {
        id: inputtextTextFieldRow

        function getStrechHeight() {
            if (textInputModel.heightStreched && _isMultiLineText)
                return parent.height > 0 ? parent.height - y : CardConstants.inputTextConstants.multiLineTextHeight;

        }

        spacing: 5
        width: parent.width
        height: implicitHeight
        
        Loader {
            id: singlineLoaderElement

            height: 30
            width: parent.width
            active: !_isMultiLineText

            sourceComponent: SingleLineTextInputRender {
                id: inputtextTextFieldWrapper

                _showErrorMessage: showErrorMessage
            }
        }
    }

    InputErrorMessage {
        id: inputtextErrorMessage

        errorMessage: textInputModel.errorMessage
        visible: showErrorMessage
    }
}