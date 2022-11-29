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
            accessibleName += "Error. " + _mEscapedErrorString + '. ';

        accessibleName += _mEscapedLabelString + '. ';
        return accessibleName;
    }

    width: parent.width
    onActiveFocusChanged: {
        if (activeFocus){
            nextItemInFocusChain().forceActiveFocus();
        }

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
            _mEscapedPlaceholderString : choiceSet._mEscapedPlaceholderString
            _currentIndex: _comboboxCurrentIndex
            _consumer : choiceSet

            Component.onCompleted : {
                selectionChanged.connect(function() {
                     choiceSet.selectedValues = currentValue ? currentValue : ""
                    if(_isRequired)
                        validate()
                })
                choiceSet.selectedValues = currentValue ? currentValue : ""
            }
        }

    }

    Loader {
        id: radioButtonLoader
        height: item ? item.height : 0
        width: parent.width
        active: _elementType === "RadioButton"

        sourceComponent: Rectangle{
            id: radioButtonRectangle
            height: radioButtonListView.height
            width: parent.width
            color: "transparent"
            activeFocusOnTab: true
            property int focusRadioIndex : 0

            onActiveFocusChanged : {
                if(activeFocus){
                    radioButtonGroup.buttons[focusRadioIndex].forceActiveFocus()
                }
            }

            ButtonGroup{
                id: radioButtonGroup
                buttons:radioButtonListView.contentItem.children
                exclusive:true

                function onSelectionChanged(){
                    choiceSet.selectedValues = AdaptiveCardUtils.onSelectionChanged(radioButtonGroup, false);
                    if(_isRequired)
                        validate()
                }
            }

            ListView{
                id: radioButtonListView
                height: contentItem.height
                width: parent.width
                model: _choiceSetModel

                Keys.onPressed: {
                    if (event.key === Qt.Key_Up) {
                        focusRadioButtons((radioButtonRectangle.focusRadioIndex - 1 + radioButtonListView.count) % radioButtonListView.count)
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Down) {
                        focusRadioButtons((radioButtonRectangle.focusRadioIndex + 1) % radioButtonListView.count)
                        event.accepted = true;
                    }
                }

                function focusRadioButtons(focusIndex){
                    radioButtonRectangle.focusRadioIndex = focusIndex
                    radioButtonGroup.buttons[radioButtonRectangle.focusRadioIndex].checked = true
                    radioButtonGroup.buttons[radioButtonRectangle.focusRadioIndex].forceActiveFocus()
                }

                delegate: CustomRadioButton {
                    _adaptiveCard : choiceSet._adaptiveCard
                    _rbValueOn : valueOn
                    _rbisWrap : isWrap
                    _rbTitle : title 
                    _rbIsChecked : isChecked
                    _consumer : choiceSet

                    Component.onCompleted : {
                        selectionChanged.connect(radioButtonGroup.onSelectionChanged)
                        if(_rbIsChecked) {
                            radioButtonRectangle.focusRadioIndex = index
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
            id: checkBoxRectangle
            height: checkBoxListView.height
            width : parent.width
            color: "transparent"

            ButtonGroup{
                id: checkBoxButtonGroup
                buttons:checkBoxListView.contentItem.children
                exclusive:false

                function onSelectionChanged(){
                    choiceSet.selectedValues = AdaptiveCardUtils.onSelectionChanged(checkBoxButtonGroup, true);
                    if(_isRequired)
                        validate()
                }
            }

            ListView{
                id: checkBoxListView
                height: contentItem.height
                width: parent.width
                model: _choiceSetModel
                keyNavigationEnabled :false

                delegate: CustomCheckBox {
                    _adaptiveCard : choiceSet._adaptiveCard
                    _cbValueOn : valueOn
                    _cbisWrap : isWrap
                    _cbTitle : title
                    _cbIsChecked : isChecked
                    _consumer : choiceSet

                    Component.onCompleted : {
                        selectionChanged.connect(checkBoxButtonGroup.onSelectionChanged)
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
