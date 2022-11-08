import "AdaptiveCardUtils.js" as AdaptiveCardUtils

import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15


/* how is required property will be set for Label */
Column {
    id: toggleInput
    width:parent.width

    property var _adaptiveCard
    property bool _isRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property color _color

    property string _cbValueOn
    property string _cbValueOff
    property string _cbText
    property bool _cbisWrap 
    property string _cbTitle
    property bool _cbIsVisible
    property bool isChecked: _input_toggle_inputToggle.checked
    property bool showErrorMessage:false
    property int minWidth: _input_toggle_inputToggle.implicitWidth
    onActiveFocusChanged: if(activeFocus) {_input_toggle_inputToggle.forceActiveFocus() }
    
    onIsCheckedChanged: validate()
    Label {
        id: _input_toggle_label
        wrapMode: Text.WordWrap
        width: parent.width
        color: _color
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        text: _isRequired ? _mEscapedLabelString + " " + `<font color='#FFAB0A15'>*</font>` : _mEscapedLabelString
        visible: text.length
    }

    CustomCheckBox {
       id: _input_toggle_inputToggle
   
    }


    /* Error Message label
     * Visiblility : 
     * 1.3
     * isRequired property is set
     * Error Message is not Empty 
     */
    Label {
        id: _input_toggle_errorMessage
        wrapMode: Text.Wrap
        width: parent.width
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        color: CardConstants.toggleButtonConstants.errorMessageColor
        text: _mEscapedErrorString
        visible: showErrorMessage
    }
    function validate(){if(showErrorMessage){if(isChecked){showErrorMessage = false}}return !isChecked;}
    function getAccessibleName(){let accessibleName = '';if(showErrorMessage === true){accessibleName += "Error. " + _mEscapedErrorString ;}accessibleName += _mEscapedLabelString;return accessibleName;}
}
