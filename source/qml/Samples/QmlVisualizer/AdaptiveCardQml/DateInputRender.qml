import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Column {
    id: dateInput

    property var _adaptiveCard
    property bool _isRequired
    property string _mEscapedLabelString
    property string _mEscapedErrorString
    property string _mEscapedPlaceholderString
    property bool showErrorMessage: false
    property var _minDate
    property var _maxDate
    property var _currentDate
    property string _dateInputFormat
    property string _submitVal

    /*function validate() {
        if (showErrorMessage) {
            if (isChecked)
                showErrorMessage = false;

        }
        return !isChecked;
    }*/

    /*function getAccessibleName() {
        let accessibleName = '';
        if (showErrorMessage === true)
            accessibleName += "Error. " + _mEscapedErrorString;

        accessibleName += _mEscapedLabelString;
        return accessibleName;
    }*/

    width: parent.width
    /*onActiveFocusChanged: {
        if (activeFocus)
            customCheckBox.forceActiveFocus();

    }*/

    InputLabel {
        id: inputDateLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label.length
    }

    Rectangle{
        id: dateWrapper
        width:parent.width
        height: CardConstants.inputFieldConstants.height
        radius: CardConstants.inputFieldConstants.borderRadius
        color: CardConstants.inputFieldConstants.backgroundColorNormal
        border.color: showErrorMessage ? CardConstants.inputFieldConstants.borderColorOnError : _date1_dateInput.activeFocus? CardConstants.inputFieldConstants.borderColorOnFocus : CardConstants.inputFieldConstants.borderColorNormal
        border.width: CardConstants.inputFieldConstants.borderWidth

        /*function colorChange(isPressed){
            if (isPressed && !_date1_dateInput.showErrorMessage)
                color = '#4D000000';
            else color = _date1_dateInput.showErrorMessage ? '#FFFFE8EA' : _date1_dateInput.activeFocus ? '#4D000000' : _date1_dateInput.hovered ? '#0A000000' : '#FFFFFFFF'
        }*/

        RowLayout {
            id: dateInputRow
            width: parent.width
            height: parent.height
            spacing: 0

            Button{
                background:Rectangle{
                    color:'transparent'
                }

                width: CardConstants.inputDateConstants.dateIconButtonSize
                height: CardConstants.inputDateConstants.dateIconButtonSize
                horizontalPadding: 0
                verticalPadding: 0
                icon.width: CardConstants.inputDateConstants.dateIconSize
                icon.height: CardConstants.inputDateConstants.dateIconSize
                icon.color: showErrorMessage ? CardConstants.inputDateConstants.dateIconColorOnError : _date1_dateInput.activeFocus ? CardConstants.inputDateConstants.dateIconColorOnFocus : CardConstants.inputDateConstants.dateIconColorNormal
                icon.source: CardConstants.calendarIcon
                Keys.onReturnPressed: onClicked()
                id: dateInputIcon
                Layout.leftMargin: CardConstants.inputDateConstants.dateIconHorizontalPadding
                Layout.alignment: Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                /*onClicked:{ 
                    _date1_dateInput.forceActiveFocus();
                    _date1_dateInput_calendarBox.open();
                }*/
            }

            ComboBox{
                id: dateInputCombobox
                Layout.fillWidth: true
                popup: DateInputPopout{
                    dateInputElement: dateInput
                }
                indicator:Rectangle{}
                focusPolicy:Qt.NoFocus
                Keys.onReturnPressed:{
                    setFocusBackOnClose(dateInputCombobox);
                    this.popup.open();
                }
                //onActiveFocusChanged:_date1_dateInput_wrapper.colorChange(false)
                background: TextField{
                    id: dateInputTextField
                    text: "Hello World"
                }
                Accessible.ignored:true
            }

            Button{
                background:Rectangle{
                    color:'transparent'
                }

                width: CardConstants.inputFieldConstants.clearIconSize
                horizontalPadding:0
                verticalPadding:0
                icon.width: CardConstants.inputFieldConstants.clearIconSize
                icon.height:CardConstants.inputFieldConstants.clearIconSize
                icon.color:activeFocus ? CardConstants.inputFieldConstants.clearIconColorOnFocus : CardConstants.inputFieldConstants.clearIconColorNormal
                icon.source: CardConstants.clearIconImage
                Keys.onReturnPressed:onClicked()
                id:dateInputClearIcon
                Layout.rightMargin:CardConstants.inputFieldConstants.clearIconHorizontalPadding
                //visible:(!_date1_dateInput.focus && _date1_dateInput.text !=="") || (_date1_dateInput.focus && _date1_dateInput.text !== "\/\/")
                /*onClicked: {
                    nextItemInFocusChain().forceActiveFocus();
                    _date1_dateInput.clear();
                }*/
                Accessible.name:"Date Picker clear"
                Accessible.role:Accessible.Button
            }
        }
    }

    InputErrorMessage {
        id: inputDateErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
