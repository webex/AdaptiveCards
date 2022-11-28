import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: toggleInput

    property var _adaptiveCard
    property bool _isRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property color _color
    property bool isChecked: customCheckBox.checked
    property bool showErrorMessage: false
    property int minWidth: customCheckBox.implicitWidth
    property alias checkBox : customCheckBox

    function validate() {
        if (showErrorMessage) {
            if (isChecked)
                showErrorMessage = false;

        }
        return !isChecked;
    }

    function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage === true)
            accessibleName += "Error. " + _mEscapedErrorString;

        accessibleName += _mEscapedLabelString;
        return accessibleName;
    }

    width: parent.width
    onActiveFocusChanged: {
        if (activeFocus)
            customCheckBox.forceActiveFocus();

    }
    onIsCheckedChanged: validate()

    Label {
        id: _inputToggleLabel

        wrapMode: Text.Wrap
        width: parent.width
        color: CardConstants.toggleButtonConstants.textColor
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        text: _isRequired ? _mEscapedLabelString + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : _mEscapedLabelString
        visible: text.length
    }

    CustomCheckBox {
        id: customCheckBox
        _adaptiveCard : _adaptiveCard
    }

    Label {
        id: _inputToggleErrorMessage

        wrapMode: Text.Wrap
        width: parent.width
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        color: CardConstants.toggleButtonConstants.errorMessageColor
        text: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
