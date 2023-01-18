import "AdaptiveCardUtils.js" as AdaptiveCardUtils
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Popup {
    id: dateInputPopout

    property var dateInputElement
    property var dateInputField
    property var inputFieldConstants: CardConstants.inputFieldConstants
    property var inputDateConstants: CardConstants.inputDateConstants

    y: dateInputField.height + 2
    x: (-inputFieldConstants.clearIconSize - inputDateConstants.dateIconHorizontalPadding)
    width: inputDateConstants.calendarWidth
    height: inputDateConstants.calendarHeight
    bottomInset: 0
    topInset: 0
    rightInset: 0
    leftInset: 0
    onOpened: {
        calendarView.forceActiveFocus();
        calendarView.selectedDate = dateInputElement._currentDate ? dateInputElement._currentDate : new Date();
        calendarView.setDate(calendarView.selectedDate);
    }
    onClosed: {
        dateInputField.forceActiveFocus();
    }

    function setGlobalDate() {
        if (calendarView.selectedDate) {
            dateInputElement._currentDate = calendarView.selectedDate;
            dateInputField.setTextFromDate(calendarView.selectedDate);
        }
    }

    Button {
        id: prevMonthButton

        width: icon.width
        anchors.top: parent.top
        anchors.right: nextMonthButton.left
        anchors.margins: 0
        padding: 0
        icon.width: inputDateConstants.arrowIconSize
        icon.height: inputDateConstants.arrowIconSize
        focusPolicy: Qt.NoFocus
        icon.color: inputDateConstants.monthChangeButtonColor
        height: icon.height
        Keys.onReturnPressed: onReleased()
        Accessible.role: Accessible.Button
        icon.source: CardConstants.calendarLeftArrowIcon
        Accessible.name: 'Previous Month'
        onReleased: {
            let tempDate = new Date(calendarView.selectedDate.getFullYear(), calendarView.selectedDate.getMonth() - 1, 1);
            calendarView.setDate(tempDate);
            calendarView.getDateForSR(tempDate);
        }
        KeyNavigation.tab: nextMonthButton
        KeyNavigation.backtab: calendarView

        background: Rectangle {
            color: inputDateConstants.calendarBackgroundColor
            border.width: parent.activeFocus ? 1 : 0
            border.color: inputDateConstants.calendarBorderColor
        }

    }

    Button {
        id: nextMonthButton

        width: icon.width
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 0
        padding: 0
        icon.width: inputDateConstants.arrowIconSize
        icon.height: inputDateConstants.arrowIconSize
        focusPolicy: Qt.NoFocus
        icon.color: inputDateConstants.monthChangeButtonColor
        height: icon.height
        Keys.onReturnPressed: onReleased()
        Accessible.role: Accessible.Button
        icon.source: CardConstants.calendarRightArrowIcon
        Accessible.name: 'Next Month'
        onReleased: {
            let tempDate = new Date(calendarView.selectedDate.getFullYear(), calendarView.selectedDate.getMonth() + 1, 1);
            calendarView.setDate(tempDate);
            calendarView.getDateForSR(tempDate);
        }
        KeyNavigation.tab: calendarView
        KeyNavigation.backtab: prevMonthButton

        background: Rectangle {
            color: inputDateConstants.calendarBackgroundColor
            border.width: parent.activeFocus ? 1 : 0
            border.color: inputDateConstants.calendarBorderColor
        }

    }

    background: Rectangle {
        radius: inputDateConstants.calendarBorderRadius
        border.color: inputDateConstants.calendarBorderColor
        color: inputDateConstants.calendarBackgroundColor
    }

    contentItem: Rectangle {
        radius: inputDateConstants.calendarBorderRadius
        color: inputDateConstants.calendarBackgroundColor

        ListView {
            id: calendarView

            property date selectedDate: dateInputElement._currentDate ? dateInputElement._currentDate : new Date()
            property string accessibilityPrefix: 'Date Picker. The current date is'
            property string dateForSR: ''

            function setDate(clickedDate) {
                selectedDate = clickedDate;
                var curIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();
                currentIndex = curIndex;
                positionViewAtIndex(curIndex, ListView.Center);
                getDateForSR(clickedDate);
            }

            function getDateForSR(clickedDate) {
                var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
                var d = clickedDate.getDate();
                var m = months[clickedDate.getMonth()];
                var y = clickedDate.getFullYear();
                calendarView.dateForSR = m + ' ' + d + ' ' + y;
            }

            anchors.fill: parent
            Component.onCompleted: {
                if (selectedDate < dateInputElement._minDate)
                    selectedDate = dateInputElement._minDate;
                else if (selectedDate > dateInputElement._maxDate)
                    selectedDate = dateInputElement._maxDate;
                setDate(selectedDate);
            }
            snapMode: ListView.SnapOneItem
            orientation: Qt.Horizontal
            clip: true
            model: 36000
            Keys.onPressed: {
                var date = new Date(selectedDate);
                if (event.key === Qt.Key_Right)
                    date.setDate(date.getDate() + 1);
                else if (event.key === Qt.Key_Left)
                    date.setDate(date.getDate() - 1);
                else if (event.key === Qt.Key_Up)
                    date.setDate(date.getDate() - 7);
                else if (event.key === Qt.Key_Down)
                    date.setDate(date.getDate() + 7);
                else if (event.key === Qt.Key_Return) {
                    setGlobalDate();
                    dateInputPopout.close();
                }
                else if (event.key === Qt.Key_Tab)
                    prevMonthButton.forceActiveFocus();
                else if (event.key === Qt.Key_Backtab)
                    nextMonthButton.forceActiveFocus();
                if (date > dateInputElement._minDate && date < dateInputElement._maxDate) {
                    selectedDate = new Date(date);
                    currentIndex = (selectedDate.getFullYear()) * 12 + selectedDate.getMonth();
                }
                calendarView.accessibilityPrefix = '';
                getDateForSR(selectedDate);
                event.accepted = true;
            }

            delegate: Item {
                id: calendarViewDelegate

                property int year: Math.floor(index / 12)
                property int month: index % 12
                property int firstDay: (new Date(year, month, 1).getDay() - 1 < 0 ? 6 : new Date(year, month, 1).getDay() - 1)

                width: calendarView.width
                height: calendarView.height

                Text {
                    id: calendarViewHeader

                    anchors.left: parent.left
                    color: inputFieldConstants.textColor
                    text: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][calendarViewDelegate.month] + ' ' + calendarViewDelegate.year
                    font.pixelSize: inputFieldConstants.pixelSize
                }

                Grid {
                    id: monthView

                    anchors.top: calendarViewHeader.bottom
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.topMargin: inputDateConstants.dateGridTopMargin
                    clip: true
                    columns: 7
                    rows: 7

                    Repeater {
                        model: monthView.columns * monthView.rows

                        delegate: Rectangle {
                            id: monthViewDelegate

                            property bool datePickerFocusCheck: calendarView.activeFocus && new Date(year, month, date).toDateString() === calendarView.selectedDate.toDateString()
                            property int day: index - 7
                            property int date: day - calendarViewDelegate.firstDay + 1
                            property variant dayArray: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                            property date cellDate: new Date(year, month, date)

                            onDatePickerFocusCheckChanged: {
                                if (datePickerFocusCheck)
                                    forceActiveFocus();

                            }
                            Accessible.name: calendarView.accessibilityPrefix + calendarView.dateForSR
                            Accessible.role: Accessible.NoRole
                            Accessible.ignored : !activeFocus
                            width: inputDateConstants.dateElementSize
                            height: inputDateConstants.dateElementSize
                            color: new Date(year, month, date).toDateString() == calendarView.selectedDate.toDateString() && monthViewDelegateMouseArea.enabled ? inputDateConstants.dateElementColorOnFocus : monthViewDelegateMouseArea.containsMouse ? inputDateConstants.dateElementColorOnHover : inputDateConstants.dateElementColorNormal
                            radius: 0.5 * width

                            Rectangle {
                                width: inputDateConstants.dateElementSize
                                height: inputDateConstants.dateElementSize
                                color: 'transparent'
                                border.width: calendarView.activeFocus && new Date(year, month, date).toDateString() == calendarView.selectedDate.toDateString() ? 1 : 0
                                border.color: inputDateConstants.calendarBorderColor
                            }

                            Text {
                                id: monthViewDelegateText

                                anchors.centerIn: parent
                                font.pixelSize: inputDateConstants.calendarDateTextSize
                                color: {
                                    if (monthViewDelegate.cellDate.toDateString() === calendarView.selectedDate.toDateString() && monthViewDelegateMouseArea.enabled)
                                        'white';
                                    else if (monthViewDelegate.cellDate.getMonth() === calendarViewDelegate.month && monthViewDelegateMouseArea.enabled)
                                        inputDateConstants.dateElementTextColorNormal;
                                    else
                                        inputDateConstants.notAvailabledateElementTextColor;
                                }
                                text: {
                                    if (day < 0)
                                        monthViewDelegate.dayArray[index];
                                    else if (new Date(year, month, date).getMonth() == month)
                                        date;
                                    else
                                        cellDate.getDate();
                                }
                            }

                            MouseArea {
                                id: monthViewDelegateMouseArea

                                anchors.fill: parent
                                enabled: monthViewDelegateText.text && day >= 0 && (new Date(year, month, date) > dateInputElement._minDate) && (new Date(year, month, date) < dateInputElement._maxDate)
                                hoverEnabled: true
                                onReleased: {
                                    if(enabled){
                                        calendarView.selectedDate = monthViewDelegate.cellDate;
                                        setGlobalDate();
                                        dateInputPopout.close();
                                    }
                                }
                            }

                        }

                    }

                }

            }

        }

    }

}
