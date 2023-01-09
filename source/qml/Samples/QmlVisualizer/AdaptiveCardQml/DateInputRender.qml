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

    InputLabel {
        id: _inputDateLabel

        _label: _mEscapedLabelString
        _required: _isRequired
        visible: _label.length
    }

    // Date Input Combobox Goes Here
    Rectangle{
        id: dateWrapper
        width:parent.width
        height:32
        radius:8
            color:'#FFFFFFFF'
        border.color: showErrorMessage ? '#FFAB0A15' : _date1_dateInput.activeFocus? '#FF1170CF' : '#80000000'
        border.width:1

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

                width: 18
                horizontalPadding: 0
                verticalPadding: 0
                icon.width: 16
                icon.height: 16
                icon.color: showErrorMessage ? '#FFAB0A15' : _date1_dateInput.activeFocus ? '#FF1170CF' : '#F2000000'
                icon.source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTIiIGhlaWdodD0iMTQiIHZpZXdCb3g9IjAgMCAxMiAxNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTUuOTk5OTkgNS4xMjUwMkM2LjM0NTE3IDUuMTI1MDIgNi42MjQ5OSA0Ljg0NTIgNi42MjQ5OSA0LjUwMDAyQzYuNjI0OTkgNC4xNTQ4NCA2LjM0NTE3IDMuODc1MDIgNS45OTk5OSAzLjg3NTAyQzUuNjU0ODEgMy44NzUwMiA1LjM3NDk5IDQuMTU0ODQgNS4zNzQ5OSA0LjUwMDAyQzUuMzc0OTkgNC44NDUyIDUuNjU0ODEgNS4xMjUwMiA1Ljk5OTk5IDUuMTI1MDJaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik01Ljk5OTk5IDguMTI1MDJDNi4zNDUxNyA4LjEyNTAyIDYuNjI0OTkgNy44NDUyIDYuNjI0OTkgNy41MDAwMkM2LjYyNDk5IDcuMTU0ODQgNi4zNDUxNyA2Ljg3NTAyIDUuOTk5OTkgNi44NzUwMkM1LjY1NDgxIDYuODc1MDIgNS4zNzQ5OSA3LjE1NDg0IDUuMzc0OTkgNy41MDAwMkM1LjM3NDk5IDcuODQ1MiA1LjY1NDgxIDguMTI1MDIgNS45OTk5OSA4LjEyNTAyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNNS45OTk5OSAxMS4xMjVDNi4zNDUxNyAxMS4xMjUgNi42MjQ5OSAxMC44NDUyIDYuNjI0OTkgMTAuNUM2LjYyNDk5IDEwLjE1NDggNi4zNDUxNyA5Ljg3NDk5IDUuOTk5OTkgOS44NzQ5OUM1LjY1NDgxIDkuODc0OTkgNS4zNzQ5OSAxMC4xNTQ4IDUuMzc0OTkgMTAuNUM1LjM3NDk5IDEwLjg0NTIgNS42NTQ4MSAxMS4xMjUgNS45OTk5OSAxMS4xMjVaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik0yLjk5OTk5IDUuMTI1MDJDMy4zNDUxNyA1LjEyNTAyIDMuNjI0OTkgNC44NDUyIDMuNjI0OTkgNC41MDAwMkMzLjYyNDk5IDQuMTU0ODQgMy4zNDUxNyAzLjg3NTAyIDIuOTk5OTkgMy44NzUwMkMyLjY1NDgxIDMuODc1MDIgMi4zNzQ5OSA0LjE1NDg0IDIuMzc0OTkgNC41MDAwMkMyLjM3NDk5IDQuODQ1MiAyLjY1NDgxIDUuMTI1MDIgMi45OTk5OSA1LjEyNTAyWiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNOS41IDEuNDk5NzRWMC41MDAyNDRDOS41IDAuMzY3NjM2IDkuNDQ3MzIgMC4yNDA0NTkgOS4zNTM1NSAwLjE0NjY5MUM5LjI1OTc5IDAuMDUyOTIyNyA5LjEzMjYxIDAuMDAwMjQ0MTQxIDkgMC4wMDAyNDQxNDFDOC44NjczOSAwLjAwMDI0NDE0MSA4Ljc0MDIxIDAuMDUyOTIyNyA4LjY0NjQ1IDAuMTQ2NjkxQzguNTUyNjggMC4yNDA0NTkgOC41IDAuMzY3NjM2IDguNSAwLjUwMDI0NFYxLjQ5OTc0SDMuNVYwLjUwMDI0NEMzLjUgMC4zNjc2MzYgMy40NDczMiAwLjI0MDQ1OSAzLjM1MzU1IDAuMTQ2NjkxQzMuMjU5NzkgMC4wNTI5MjI3IDMuMTMyNjEgMC4wMDAyNDQxNDEgMyAwLjAwMDI0NDE0MUMyLjg2NzM5IDAuMDAwMjQ0MTQxIDIuNzQwMjEgMC4wNTI5MjI3IDIuNjQ2NDUgMC4xNDY2OTFDMi41NTI2OCAwLjI0MDQ1OSAyLjUgMC4zNjc2MzYgMi41IDAuNTAwMjQ0VjEuNDk5NzRDMS44MzcyIDEuNTAwNTIgMS4yMDE3NyAxLjc2NDE3IDAuNzMzMDk0IDIuMjMyODRDMC4yNjQ0MjIgMi43MDE1MSAwLjAwMDc3OTQwNCAzLjMzNjk0IDAgMy45OTk3NFYxMC45OTk3QzAuMDAwNzc5NDA0IDExLjY2MjUgMC4yNjQ0MjIgMTIuMjk4IDAuNzMzMDk0IDEyLjc2NjdDMS4yMDE3NyAxMy4yMzUzIDEuODM3MiAxMy40OTkgMi41IDEzLjQ5OTdIOS41QzEwLjE2MjggMTMuNDk5IDEwLjc5ODIgMTMuMjM1MyAxMS4yNjY5IDEyLjc2NjdDMTEuNzM1NiAxMi4yOTggMTEuOTk5MiAxMS42NjI1IDEyIDEwLjk5OTdWMy45OTk3NEMxMS45OTkyIDMuMzM2OTQgMTEuNzM1NiAyLjcwMTUxIDExLjI2NjkgMi4yMzI4NEMxMC43OTgyIDEuNzY0MTcgMTAuMTYyOCAxLjUwMDUyIDkuNSAxLjQ5OTc0Wk0xMSAxMC45OTk3QzEwLjk5OTYgMTEuMzk3NCAxMC44NDE0IDExLjc3ODcgMTAuNTYwMiAxMi4wNTk5QzEwLjI3OSAxMi4zNDExIDkuODk3NjkgMTIuNDk5MyA5LjUgMTIuNDk5N0gyLjVDMi4xMDIzMSAxMi40OTkzIDEuNzIxMDMgMTIuMzQxMSAxLjQzOTgyIDEyLjA1OTlDMS4xNTg2MSAxMS43Nzg3IDEuMDAwNDMgMTEuMzk3NCAxIDEwLjk5OTdWMy45OTk3NEMxLjAwMDQ0IDMuNjAyMDUgMS4xNTg2MSAzLjIyMDc4IDEuNDM5ODIgMi45Mzk1NkMxLjcyMTAzIDIuNjU4MzUgMi4xMDIzMSAyLjUwMDE4IDIuNSAyLjQ5OTc0SDkuNUM5Ljg5NzY5IDIuNTAwMTggMTAuMjc5IDIuNjU4MzUgMTAuNTYwMiAyLjkzOTU2QzEwLjg0MTQgMy4yMjA3NyAxMC45OTk2IDMuNjAyMDUgMTEgMy45OTk3NFYxMC45OTk3WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNMi45OTk5OSA4LjEyNTAyQzMuMzQ1MTcgOC4xMjUwMiAzLjYyNDk5IDcuODQ1MiAzLjYyNDk5IDcuNTAwMDJDMy42MjQ5OSA3LjE1NDg0IDMuMzQ1MTcgNi44NzUwMiAyLjk5OTk5IDYuODc1MDJDMi42NTQ4MSA2Ljg3NTAyIDIuMzc0OTkgNy4xNTQ4NCAyLjM3NDk5IDcuNTAwMDJDMi4zNzQ5OSA3Ljg0NTIgMi42NTQ4MSA4LjEyNTAyIDIuOTk5OTkgOC4xMjUwMloiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPHBhdGggZD0iTTIuOTk5OTkgMTEuMTI1QzMuMzQ1MTcgMTEuMTI1IDMuNjI0OTkgMTAuODQ1MiAzLjYyNDk5IDEwLjVDMy42MjQ5OSAxMC4xNTQ4IDMuMzQ1MTcgOS44NzQ5OSAyLjk5OTk5IDkuODc0OTlDMi42NTQ4MSA5Ljg3NDk5IDIuMzc0OTkgMTAuMTU0OCAyLjM3NDk5IDEwLjVDMi4zNzQ5OSAxMC44NDUyIDIuNjU0ODEgMTEuMTI1IDIuOTk5OTkgMTEuMTI1WiIgZmlsbD0iYmxhY2siIGZpbGwtb3BhY2l0eT0iMC45NSIvPgo8cGF0aCBkPSJNOC45OTk5OSA1LjEyNTAyQzkuMzQ1MTcgNS4xMjUwMiA5LjYyNDk5IDQuODQ1MiA5LjYyNDk5IDQuNTAwMDJDOS42MjQ5OSA0LjE1NDg0IDkuMzQ1MTcgMy44NzUwMiA4Ljk5OTk5IDMuODc1MDJDOC42NTQ4MSAzLjg3NTAyIDguMzc0OTkgNC4xNTQ4NCA4LjM3NDk5IDQuNTAwMDJDOC4zNzQ5OSA0Ljg0NTIgOC42NTQ4MSA1LjEyNTAyIDguOTk5OTkgNS4xMjUwMloiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPHBhdGggZD0iTTguOTk5OTkgOC4xMjUwMkM5LjM0NTE3IDguMTI1MDIgOS42MjQ5OSA3Ljg0NTIgOS42MjQ5OSA3LjUwMDAyQzkuNjI0OTkgNy4xNTQ4NCA5LjM0NTE3IDYuODc1MDIgOC45OTk5OSA2Ljg3NTAyQzguNjU0ODEgNi44NzUwMiA4LjM3NDk5IDcuMTU0ODQgOC4zNzQ5OSA3LjUwMDAyQzguMzc0OTkgNy44NDUyIDguNjU0ODEgOC4xMjUwMiA4Ljk5OTk5IDguMTI1MDJaIiBmaWxsPSJibGFjayIgZmlsbC1vcGFjaXR5PSIwLjk1Ii8+CjxwYXRoIGQ9Ik04Ljk5OTk5IDExLjEyNUM5LjM0NTE3IDExLjEyNSA5LjYyNDk5IDEwLjg0NTIgOS42MjQ5OSAxMC41QzkuNjI0OTkgMTAuMTU0OCA5LjM0NTE3IDkuODc0OTkgOC45OTk5OSA5Ljg3NDk5QzguNjU0ODEgOS44NzQ5OSA4LjM3NDk5IDEwLjE1NDggOC4zNzQ5OSAxMC41QzguMzc0OTkgMTAuODQ1MiA4LjY1NDgxIDExLjEyNSA4Ljk5OTk5IDExLjEyNVoiIGZpbGw9ImJsYWNrIiBmaWxsLW9wYWNpdHk9IjAuOTUiLz4KPC9zdmc+Cg=="
                Keys.onReturnPressed: onClicked()
                id: dateInputIcon
                Layout.leftMargin: 12
                Layout.alignment: Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                height: 18
                /*onClicked:{ 
                    _date1_dateInput.forceActiveFocus();
                    _date1_dateInput_calendarBox.open();
                }*/
            }

            ComboBox{
                id: dateInputCombobox
                Layout.fillWidth:true
                popup: DateInputPopout{
                    // DateInputPopout Goes Here
                }
                indicator:Rectangle{}
                focusPolicy:Qt.NoFocus
                Keys.onReturnPressed:{
                    setFocusBackOnClose(dateInputCombobox);
                    this.popup.open();
                }
                //onActiveFocusChanged:_date1_dateInput_wrapper.colorChange(false)
                background: DateInputTextField{
                    // DateInput Text Field Goes Here
                }
                Accessible.ignored:true
            }

            Button{
                background:Rectangle{
                    color:'transparent'
                }

                width:16
                horizontalPadding:0
                verticalPadding:0
                icon.width:16
                icon.height:16
                icon.color:activeFocus ? '#FF1170CF' : '#99000000'
                icon.source:"data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTAiIGhlaWdodD0iMTAiIHZpZXdCb3g9IjAgMCAxMCAxMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+Y29tbW9uLWFjdGlvbnMvY2FuY2VsXzEwPC90aXRsZT48cGF0aCBkPSJNNS43MDcyNSA1LjAwMDI1bDIuNjQ2LTIuNjQ2Yy4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDgtLjE5NS0uMTk1LS41MTEtLjE5NS0uNzA3IDBsLTIuNjQ2IDIuNjQ3LTIuNjQ3LTIuNjQ3Yy0uMTk1LS4xOTUtLjUxMS0uMTk1LS43MDcgMC0uMTk1LjE5Ni0uMTk1LjUxMiAwIC43MDhsMi42NDcgMi42NDYtMi42NDcgMi42NDZjLS4xOTUuMTk2LS4xOTUuNTEyIDAgLjcwOC4wOTguMDk3LjIyNi4xNDYuMzU0LjE0Ni4xMjggMCAuMjU2LS4wNDkuMzUzLS4xNDZsMi42NDctMi42NDcgMi42NDYgMi42NDdjLjA5OC4wOTcuMjI2LjE0Ni4zNTQuMTQ2LjEyOCAwIC4yNTYtLjA0OS4zNTMtLjE0Ni4xOTYtLjE5Ni4xOTYtLjUxMiAwLS43MDhsLTIuNjQ2LTIuNjQ2eiIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"
                Keys.onReturnPressed:onClicked()
                id:dateInputClearIcon
                Layout.rightMargin:12
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
        id: _inputDateErrorMessage

        _errorMessage: _mEscapedErrorString
        visible: showErrorMessage && _mEscapedErrorString.length
    }

}
