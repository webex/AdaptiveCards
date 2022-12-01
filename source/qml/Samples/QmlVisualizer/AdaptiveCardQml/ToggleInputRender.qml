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
    property alias checkBox: customCheckBox

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

    InputLabel {
        id: _inputToggleLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label.length
    }

    CustomCheckBox {
        id: customCheckBox

        _adaptiveCard: toggleInput._adaptiveCard
        _consumer: toggleInput
    }

    InputErrorMessage {
        id: _inputToggleErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
