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
            if (selectedValues)
                showErrorMessage = false;

        }
        return !selectedValues;
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
            id: comboBox
            _model : _choiceSetModel
            _mEscapedPlaceholderString : _mEscapedPlaceholderString
            _currentIndex: _comboboxCurrentIndex
            onValueChanged : {
                choiceSet.selectedValues = value
            }
        }

    }

    Loader {
        id: radioButtonLoader
        height: item ? item.height : 0
        width: parent.width
        active: _elementType === "RadioButton"

        sourceComponent: Rectangle{
            height: radioButtonColumn.implicitHeight
            width : parent.width

            ButtonGroup{
                id: radioButtonGroup
                buttons:radioButtonColumn.children
                exclusive:true

                function onSelectionChanged(){
                    choiceSet.selectedValues = AdaptiveCardUtils.onSelectionChanged(radioButtonGroup, false);
                }
            }

            Column {
                id: radioButtonColumn
                width: parent.width
                Repeater {
                    model: _choiceSetModel
                    CustomRadioButton {
                        _adaptiveCard : choiceSet._adaptiveCard
                        _rbValueOn : valueOn
                        _rbisWrap : isWrap
                        _rbTitle : title 
                        _rbIsChecked : isChecked

                        Component.onCompleted : {
                            selectionChanged.connect(radioButtonGroup.onSelectionChanged)
                        }
                    }
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
            height: checkBoxColumn.implicitHeight
            width : parent.width

            ButtonGroup{
                id: checkBoxButtonGroup
                buttons:checkBoxColumn.children
                exclusive:false

                function onSelectionChanged(){
                    choiceSet.selectedValues = AdaptiveCardUtils.onSelectionChanged(checkBoxButtonGroup, true);
                }
            }

            Column {
                id: checkBoxColumn
                width: parent.width
                Repeater {
                    model: _choiceSetModel
                    CustomCheckBox {
                        _adaptiveCard : choiceSet._adaptiveCard
                        _cbValueOn : valueOn
                        _cbisWrap : isWrap
                        _cbTitle : title
                        _cbIsChecked : isChecked

                        Component.onCompleted : {
                            selectionChanged.connect(checkBoxButtonGroup.onSelectionChanged)
                        }
                    }
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
