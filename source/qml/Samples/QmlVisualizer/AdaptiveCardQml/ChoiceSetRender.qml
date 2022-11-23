import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: choiceSet

    property var _adaptiveCard
    property bool _isRequired: false
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property var _choiceSetModel
    property bool showErrorMessage: false
    property string _elementType
    property int minWidth: CardConstants.comboBoxConstants.choiceSetMinWidth
    property int _comboboxCurrentIndex
    property string selectedValues : ""

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

    Label {
        id: _choiceSetLabel

        wrapMode: Text.Wrap
        width: parent.width
        color: CardConstants.toggleButtonConstants.textColor
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        text: _isRequired ? _mEscapedLabelString + " " + "<font color='" + CardConstants.inputFieldConstants.errorMessageColor + "'>*</font>" : _mEscapedLabelString
        visible: text.length
    }

    Loader {
        id: comboboxLoader
        height: item ? item.height : 0
        width: parent.width
        active: _elementType === "Combobox"

        sourceComponent: ComboboxRender {
            _model : _choiceSetModel
            _mEscapedPlaceholderString : _mEscapedPlaceholderString
            _currentIndex: _comboboxCurrentIndex
        }

    }

    Loader {
        id: radioButtonLoader
        height: item ? item.height : 0
        width: parent.width
        active: _elementType === "RadioButton"

        sourceComponent: Rectangle{
            height: radioButtonListView.implicitHeight
            width : parent.width

            ButtonGroup{
                buttons: radioButtonListView.children
                exclusive: true
            }

            ListView {
                id: radioButtonListView
                width: parent.width
                implicitHeight: contentHeight
                model : _choiceSetModel
                delegate : CustomRadioButton {
                    _adaptiveCard : choiceSet._adaptiveCard
                    _rbValueOn : value
                    _rbisWrap : isWrap
                    _rbTitle : title 
                    _rbIsChecked : isChecked
                }
            }
        }

    }

    Loader {
        id: checkBoxLoader
        height: item ? item.height : 0
        width: parent.width
        active: _elementType === "CheckBox"

        sourceComponent: Rectangle{
            height: checkBoxListView.implicitHeight
            width : parent.width

            ListView {
                id: checkBoxListView
                width: parent.width
                implicitHeight: contentHeight
                model : _choiceSetModel
                delegate : CustomCheckBox {
                    _adaptiveCard : choiceSet._adaptiveCard
                    _cbValueOn : value
                    _cbisWrap : isWrap
                    _cbTitle : title
                    _cbIsChecked : isChecked
                }
            }
        }
    }

    Label {
        id: _choiceSetErrorMessage

        wrapMode: Text.Wrap
        width: parent.width
        font.pixelSize: CardConstants.inputFieldConstants.labelPixelSize
        Accessible.ignored: true
        color: CardConstants.toggleButtonConstants.errorMessageColor
        text: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
